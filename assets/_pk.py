"""Shared decoders for Pokemon Red's data (used by the asset plugins in this folder).

Everything here reads the ROM bytes the build produced, never the source files, so what the
viewer shows is what the cartridge holds.
"""
import re


# ---- the compressed picture format (home/uncompress.asm, UncompressSpriteData)

class _BitReader:
    def __init__(self, data, pos, end=None):
        self.data, self.pos, self.bit = data, pos, 0
        self.end = len(data) if end is None else end

    def get(self):
        if self.pos >= self.end:
            raise ValueError('past the end')
        b = (self.data[self.pos] >> (7 - self.bit)) & 1
        self.bit += 1
        if self.bit == 8:
            self.bit, self.pos = 0, self.pos + 1
        return b

    def num(self, n):
        v = 0
        for _ in range(n):
            v = v << 1 | self.get()
        return v


def _read_plane(r, w, h):
    """One bit plane: alternating packets of zero pairs (run length) and literal pairs,
    filled column of 2-pixel strips by column of 2-pixel strips (top to bottom)."""
    total = w * 8 * h * 8 // 2         # 2-bit pairs
    pairs = []
    rle = r.get() == 0
    while len(pairs) < total:
        if rle:
            k = 1
            while r.get():
                k += 1
                if k > 16:
                    raise ValueError('run too long')
            n = r.num(k) + (1 << k) - 1
            pairs += [0] * n
        else:
            while len(pairs) < total:
                p = r.num(2)
                if not p:
                    break
                pairs.append(p)
        rle = not rle
    pairs = pairs[:total]
    plane = bytearray(w * h * 8)
    i = 0
    for x in range(w):
        for bit in range(0, 8, 2):
            for y in range(h * 8):
                plane[x * h * 8 + y] |= pairs[i] << (6 - bit)
                i += 1
    return plane


def _undelta(plane, w, h):
    """Each bit was stored as the change from the pixel to its left (a row starts from 0)."""
    for y in range(h * 8):
        prev = 0
        for x in range(w):
            j = x * h * 8 + y
            code, out = plane[j], 0
            for b in range(7, -1, -1):
                prev ^= (code >> b) & 1
                out |= prev << b
            plane[j] = out


def decode_pic(rom, start, end=None):
    """A compressed picture at `start` -> (rows of shade indices 0-3, width, height, end)."""
    w, h = rom[start] >> 4, rom[start] & 0xF
    r = _BitReader(rom, start + 1, end)
    order = r.get()
    a = _read_plane(r, w, h)
    mode = 0 if not r.get() else 1 + r.get()
    b = _read_plane(r, w, h)
    _undelta(a, w, h)
    if mode != 1:
        _undelta(b, w, h)
    if mode:
        for i in range(len(b)):
            b[i] ^= a[i]
    lo, hi = (a, b) if order == 0 else (b, a)
    rows = []
    for y in range(h * 8):
        row = []
        for x in range(w * 8):
            j = (x >> 3) * h * 8 + y
            s = 7 - (x & 7)
            row.append(((hi[j] >> s) & 1) << 1 | ((lo[j] >> s) & 1))
        rows.append(row)
    end = r.pos + (1 if r.bit else 0)
    return rows, w * 8, h * 8, end


# ---- plain tiles

def tile_rows(data, off, bpp=2):
    out = []
    for y in range(8):
        lo = data[off + (y if bpp == 1 else 2 * y)]
        hi = lo if bpp == 1 else data[off + 2 * y + 1]
        out.append([((hi >> (7 - x)) & 1) << 1 | ((lo >> (7 - x)) & 1) for x in range(8)])
    return out


def tiles_image(data, cols, bpp=2):
    """Tile data as rows of shades, `cols` tiles per row (row-major tile order)."""
    per = 8 * bpp
    n = len(data) // per
    rows_t = (n + cols - 1) // cols
    rows = [[0] * (cols * 8) for _ in range(rows_t * 8)]
    for t in range(n):
        px = tile_rows(data, t * per, bpp)
        ox, oy = (t % cols) * 8, (t // cols) * 8
        for y in range(8):
            rows[oy + y][ox:ox + 8] = px[y]
    return rows, cols * 8, rows_t * 8


# ---- the disassembly (labels and code only: the bytes always come from the ROM)

COPY_2BPP = {'CopyVideoData', 'FarCopyData', 'FarCopyData2', 'FarCopyData3', 'TrainerInfo_FarCopyData',
             'CopyVideoDataAlternate'}
COPY_1BPP = {'CopyVideoDataDouble', 'FarCopyDataDouble', 'CopyVideoDataDoubleAlternate'}
_LOAD = re.compile(r'ld (hl|de), (\w+)')
_CALL = re.compile(r'(call|jp|farcall|callfar|predef|callba|callab)\s+(?:\w+,\s*)?(\w+)')


def data_units(project):
    return [u for u in project.parsed.units if u.kind == 'data' and u.start is not None and u.end and u.end > u.start]


def tile_loads(project):
    """{data label: bits per pixel} for the data the game's code hands to its tile copy
    routines (1 bpp ones expand each byte into both bit planes on the way to VRAM)."""
    p = project.parsed
    data = {u.name for u in data_units(project)}
    out = {}
    for u in p.units:
        if u.kind != 'code':
            continue
        pend = []
        for i in u.lines:
            t = (p.lines[i].text or '').strip()
            m = _LOAD.match(t)
            if m and m.group(2) in data:
                pend = [x for x in pend if x[1] < 8] + [(m.group(2), 0)]
                continue
            m = _CALL.match(t)
            if m and pend:
                c = m.group(2)
                if c in COPY_1BPP or c in COPY_2BPP:
                    for lab, _ in pend:
                        out.setdefault(lab, 1 if c in COPY_1BPP else 2)
                pend = []
            pend = [(lab, k + 1) for lab, k in pend]
    return out


def labels_by_address(project):
    """linear ROM address -> first global label there."""
    import build as engine
    rev = {}
    for n, a in project.syms.items():
        if '.' not in n:
            rev.setdefault(engine.linear(engine.SYM_BANK.get(n, 0), a), n)
    return rev


def spaced(name):
    s = re.sub(r'(?<=[a-z])(?=[A-Z0-9])', ' ', name)
    return re.sub(r'(?<=[A-Z])(?=[A-Z][a-z])', ' ', s).replace('_', ' ')
