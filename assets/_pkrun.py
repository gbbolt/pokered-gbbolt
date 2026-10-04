"""Running Pokemon Red's own drawing code to see a screen as the game builds it.

The game's code runs in the SM83 interpreter over a memory image with the cartridge's bank switching. There is
no LCD and no interrupts, so this stands in for them: whenever the code waits for the next frame (`halt` in
DelayFrame) the game's own VBlank handler runs once - it copies the tile buffer and the queued tiles to VRAM and
the sprite buffer to OAM - and ReadJoypad reports the buttons we hold (none, unless asked)."""
import build as engine
from sm83 import CPU, MBC, StepLimit

__all__ = ['Runner', 'StepLimit']


class Runner:
    FRAME_STEPS = 5000                            # about a frame's worth of instructions (70224 cycles)
    def __init__(self, ctx):
        self.ctx = ctx
        self.rom = ctx.rom
        self.syms = ctx.syms
        self.vars = ctx.vars
        self.mem = bytearray(0x10000)
        self.mem[0:0x8000] = self.rom[0:0x8000]
        self.mbc = MBC(self.rom, self.mem)
        self.cpu = CPU(self.mem, self.mbc)
        self.buttons = 0
        self.tap = 0
        self.frames = 0
        self.mem[0xFF44] = 0x91
        self.mem[0xFF40] = 0xE3
        self.hooks = {self.addr('ReadJoypad'): self._joypad}
        self.sgb_log = []                         # the Super Game Boy packets the game sent, in order
        if 'SendSGBPacket' in self.syms:
            self.hooks[self.addr('SendSGBPacket')] = self._sgb_packet
        dma, hdma = self.syms.get('DMARoutine'), self.addr('hDMARoutine')
        if dma is not None:                       # what WriteDMACodeToHRAM does at power on
            end = self.syms.get('DMARoutineEnd', dma + 10)
            self.mem[hdma:hdma + end - dma] = self.rom[dma:end]
        self.set('hLoadedROMBank', 1)
        if 'Wait7000' in self.syms:
            self.skip('Wait7000')

    def addr(self, name):
        if isinstance(name, int):
            return name
        if name in self.vars:
            return self.vars[name]
        return self.syms[name]

    def bank(self, name):
        return engine.SYM_BANK.get(name, 0)

    def set(self, name, v, off=0):
        self.mem[self.addr(name) + off] = v & 0xFF

    def get(self, name, off=0):
        return self.mem[self.addr(name) + off]

    def fill(self, name, data):
        a = self.addr(name)
        self.mem[a:a + len(data)] = bytes(data)

    def skip(self, label):
        """Return straight away whenever `label` is called (a scene we do not need)."""
        b = self.bank(label)
        self.hooks[self.addr(label)] = lambda: self.addr(label) < 0x4000 or self.mbc.rom_bank == b

    def char_codes(self, text):
        """Text in the game's character codes, ended by '@'."""
        inv = {}
        for code, ch in engine.read_charmap().items():
            inv.setdefault(ch, code)
        return bytes(inv[c] for c in text) + bytes([inv['@']])

    # ---- the stand-ins for the hardware
    def _joypad(self):
        self.joy_reads = getattr(self, 'joy_reads', 0) + 1
        b = self.buttons
        if self.tap and self.joy_reads % 8 < 2:     # tap a button now and then (to page through texts)
            b |= self.tap
        self.set('hJoyInput', b)
        return True                               # skip the routine: return to the caller

    def _sgb_packet(self):
        """SendSGBPacket(hl): note the packet (and the ones after it: the low 3 bits of the first byte count
        them) instead of clocking it out bit by bit through the joypad port."""
        a = self.cpu.getp('hl')
        n = (self.mem[a] & 7) or 1
        self.sgb_log.append(bytes(self.mem[a:a + 16 * n]))
        return True

    def sgb_screen(self):
        """What the Super Game Boy makes of the packets so far: (20 x 18 palette numbers 0-3, the four palettes as
        SuperPalettes numbers) from the last PAL_SET and the ATTR_BLK packets since the last PAL_SET."""
        attr = [[0] * 20 for _ in range(18)]
        pals = None
        for pk in self.sgb_log:
            cmd = pk[0] >> 3
            if cmd == 0x0A:                       # PAL_SET: four palettes by number
                pals = [pk[1 + 2 * k] | (pk[2 + 2 * k] & 1) << 8 for k in range(4)]
            elif cmd == 0x04:                     # ATTR_BLK: data sets of 6 bytes
                data = pk[1:]
                for k in range(min(data[0], (len(data) - 1) // 6)):
                    ctl, pp, x1, y1, x2, y2 = data[1 + 6 * k: 7 + 6 * k]
                    for y in range(18):
                        for x in range(20):
                            inside = x1 < x < x2 and y1 < y < y2
                            border = x1 <= x <= x2 and y1 <= y <= y2 and not inside
                            outside = not (x1 <= x <= x2 and y1 <= y <= y2)
                            if inside and ctl & 1:
                                attr[y][x] = pp & 3
                            elif border and ctl & 2:
                                attr[y][x] = pp >> 2 & 3
                            elif outside and ctl & 4:
                                attr[y][x] = pp >> 4 & 3
                            elif border and ctl & 1 and not ctl & 2:      # inside only: the border goes with it
                                attr[y][x] = pp & 3
                            elif border and ctl & 4 and not ctl & 2:      # outside only: the border goes with it
                                attr[y][x] = pp >> 4 & 3
        return attr, pals

    def vblank(self, after_halt=False):
        """The VBlank interrupt: the game's handler runs once (it saves and restores the registers itself)."""
        cpu = self.cpu
        self.frames += 1
        ret = cpu.pc + (1 if after_halt else 0)
        saved_sp = cpu.sp
        cpu.push(ret)
        cpu.push(0xFEA0)
        cpu.pc = self.addr('VBlank')
        cpu.ime = False
        self._loop(0xFEA0, 400000, vblank=False)
        cpu.ime = True
        cpu.pc = cpu.pop()
        cpu.sp = saved_sp

    def _loop(self, until, max_steps, vblank=True, stop=None, frames=None):
        cpu, mem, hooks = self.cpu, self.mem, self.hooks
        end_frame = self.frames + frames if frames else None
        steps = since = 0
        ly = 0
        while cpu.pc != until:
            pc = cpu.pc
            if stop and pc in stop and (pc < 0x4000 or stop[pc][1] in (0, self.mbc.rom_bank)):
                return pc
            if end_frame and self.frames >= end_frame:
                return -1
            h = hooks.get(pc)
            if h and h():
                cpu.pc = cpu.pop()
                continue
            if mem[pc] == 0x76:                   # halt: wait for the VBlank interrupt
                if not vblank:
                    raise StepLimit('halt inside VBlank')
                self.vblank(after_halt=True)
                since = 0
                continue
            if vblank and since > self.FRAME_STEPS and cpu.ime and mem[0xFFFF] & 1:
                self.vblank()                     # a frame has gone by: the interrupt comes
                since = 0
                continue
            cpu.step()
            steps += 1
            since += 1
            ly = (ly + 1) % 154
            mem[0xFF44] = ly                      # the LCD's line counter keeps moving (some loops wait for a line)
            if steps > max_steps:
                raise StepLimit('no return after {} steps (pc=${:04x})'.format(steps, cpu.pc))
        return None

    def resume(self, frames=None, stop=None, max_steps=3000000):
        """Go on from where the last call stopped (for `frames` more frames, or to a `stop` address)."""
        stops = {}
        for s in stop or ():
            stops[self.addr(s)] = (s, self.bank(s) if isinstance(s, str) else 0)
        got = self._loop(0xFEA0, max_steps, stop=stops, frames=frames)
        return stops[got][0] if got and got > 0 else got

    def snapshot(self):
        c = self.cpu
        return (bytes(self.mem), self.mbc.rom_bank, dict(self.mbc.saved_ram), self.mbc.ram_bank,
                (c.a, c.f, c.b, c.c, c.d, c.e, c.h, c.l, c.sp, c.pc, c.ime), self.frames)

    def restore(self, snap):
        mem, bank, saved, ram_bank, regs, frames = snap
        self.mem[:] = mem
        self.mbc.rom_bank, self.mbc.saved_ram, self.mbc.ram_bank = bank, dict(saved), ram_bank
        c = self.cpu
        c.a, c.f, c.b, c.c, c.d, c.e, c.h, c.l, c.sp, c.pc, c.ime = regs
        self.frames = frames
        self.sgb_log = []

    def call(self, name, max_steps=3000000, stop=None, frames=None, **regs):
        """Run a routine (switching to its bank) until it returns, or until it reaches one of the addresses
        in `stop` (labels or numbers; returns the label reached)."""
        cpu = self.cpu
        a = self.addr(name)
        b = self.bank(name) if isinstance(name, str) else 0
        if b:
            self.mbc.map(b)
            self.set('hLoadedROMBank', b)
        for r, v in regs.items():
            if len(r) == 2:
                cpu.setp(r, v)
            else:
                setattr(cpu, r, v & 0xFF)
        cpu.sp = 0xDFFF - 0x10
        cpu.reads, cpu.writes = set(), set()
        stops = {}
        for s in stop or ():
            stops[self.addr(s)] = (s, self.bank(s) if isinstance(s, str) else 0)
        cpu.push(0xFEA0)
        cpu.pc = a
        got = self._loop(0xFEA0, max_steps, stop=stops, frames=frames)
        cpu.reads, cpu.writes = set(), set()
        return stops[got][0] if got and got > 0 else got

    # ---- what is on the screen
    def tile(self, t, signed=True):
        """The 8 x 8 pixels of BG tile t (raw colour numbers)."""
        m = self.mem
        base = (0x9000 + 16 * t if t < 128 else 0x8800 + 16 * (t - 128)) if signed else 0x8000 + 16 * t
        return [[((m[base + 2 * y + 1] >> (7 - x)) & 1) << 1 | ((m[base + 2 * y] >> (7 - x)) & 1) for x in range(8)]
                for y in range(8)]

    def screen(self, source='wTileMap', sprites='wShadowOAM', bgp=None, obp0=None, obp1=None):
        """160 x 144 shades: the 20 x 18 tile buffer (or 'bg' for the BG map as the LCD shows it, with the window)
        drawn with the VRAM tiles, the sprites of the sprite buffer on top."""
        m = self.mem
        bgp = m[0xFF47] if bgp is None else bgp
        pal = [(bgp >> (2 * c)) & 3 for c in range(4)]
        img = [bytearray(160) for _ in range(144)]
        raw = [bytearray(160) for _ in range(144)]
        signed = not m[0xFF40] & 0x10
        cache = {}
        if source == 'bg':
            lcdc = m[0xFF40]
            scx, scy, wx, wy = m[0xFF43], m[0xFF42], m[0xFF4B] - 7, m[0xFF4A]
            bgmap = 0x9C00 if lcdc & 0x08 else 0x9800
            winmap = 0x9C00 if lcdc & 0x40 else 0x9800
            win = lcdc & 0x20 and wy < 144
            for y in range(144):
                for x in range(160):
                    if win and y >= wy and x >= wx:
                        mx, my, base = x - wx, y - wy, winmap
                    else:
                        mx, my, base = (x + scx) & 0xFF, (y + scy) & 0xFF, bgmap
                    t = m[base + (my >> 3) * 32 + (mx >> 3)]
                    px = cache.get(t) or cache.setdefault(t, self.tile(t, signed))
                    c = px[my & 7][mx & 7]
                    raw[y][x], img[y][x] = c, pal[c]
        else:
            a = self.addr(source)
            for k in range(360):
                t = m[a + k]
                px = cache.get(t) or cache.setdefault(t, self.tile(t, signed))
                ox, oy = (k % 20) * 8, (k // 20) * 8
                for y in range(8):
                    for x in range(8):
                        c = px[y][x]
                        raw[oy + y][ox + x], img[oy + y][ox + x] = c, pal[c]
        if sprites:
            obp = (m[0xFF48] if obp0 is None else obp0, m[0xFF49] if obp1 is None else obp1)
            oam = self.addr(sprites)
            tall = m[0xFF40] & 0x04
            for i in range(39, -1, -1):
                sy, sx, t, attr = m[oam + 4 * i: oam + 4 * i + 4]
                sy -= 16
                sx -= 8
                h = 16 if tall else 8
                for ty in range(h):
                    y = sy + ty
                    if not 0 <= y < 144:
                        continue
                    r = (h - 1 - ty) if attr & 0x40 else ty
                    base = 0x8000 + (t & (0xFE if tall else 0xFF)) * 16 + 2 * r
                    lo, hi = m[base], m[base + 1]
                    for tx in range(8):
                        x = sx + tx
                        if not 0 <= x < 160:
                            continue
                        b = tx if attr & 0x20 else 7 - tx
                        c = ((hi >> b) & 1) << 1 | ((lo >> b) & 1)
                        if not c or (attr & 0x80 and raw[y][x]):
                            continue
                        img[y][x] = (obp[(attr >> 4) & 1] >> (2 * c)) & 3
        return img
