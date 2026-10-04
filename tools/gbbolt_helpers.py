"""Pseudo-code helpers for Pokemon Red's own idioms (game.json "helpers")."""

SCREEN_WIDTH = 20
BG_MAP_WIDTH = 32


_SOUNDS = {}


def _sounds(addr):
    """Music and sound effect IDs (constants/music_constants.asm): (header - SFX_Headers_1) / 3. They are
    defined as text, so the assembler's constant dump does not have them as numbers. Read once."""
    if _SOUNDS:
        return _SOUNDS
    import os
    import re
    path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'constants', 'music_constants.asm')
    try:
        base = addr('SFX_Headers_1')
        for line in open(path, encoding='utf-8'):
            m = (re.match(r'^\s*music_const\s+(\w+),\s*(\w+)', line) or
                 re.match(r'^\s*DEF\s+(\w+)\s+EQUS\s+"\(\((\w+)\s*-\s*SFX_Headers_1\)\s*/\s*3\)"', line))
            if m:
                _SOUNDS[m.group(1)] = ((addr(m.group(2)) - base) // 3, 'sound ID ({})'.format(m.group(2)))
    except (OSError, KeyError):
        pass
    return _SOUNDS


def helpers(mem, addr):
    def coord(x, y):
        """Address of tile (x, y) in the screen buffer wTileMap (the hlcoord / decoord macros)"""
        return addr('wTileMap') + y * SCREEN_WIDTH + x

    def bgcoord(x, y, base=None):
        """Address of tile (x, y) in a 32 x 32 BG map, vBGMap0 unless given (the hlbgcoord macros)"""
        return (addr('vBGMap0') if base is None else base) + y * BG_MAP_WIDTH + x

    def event(e):
        """Whether event flag e is set (CheckEvent): bit e % 8 of wEventFlags[e / 8]"""
        return bool(mem[addr('wEventFlags') + e // 8] >> (e % 8) & 1)

    def set_event(e):
        """Set event flag e (SetEvent)"""
        a = addr('wEventFlags') + e // 8
        mem[a] = mem[a] | 1 << (e % 8)

    def reset_event(e):
        """Clear event flag e (ResetEvent)"""
        a = addr('wEventFlags') + e // 8
        mem[a] = mem[a] & ~(1 << (e % 8)) & 0xFF

    def open_sram(bank):
        """Enable the cartridge RAM and switch SRAM bank `bank` in at $A000 (rRAMG, rBMODE, rRAMB)"""
        mem[0x0000] = 0x0A
        mem[0x6000] = 1
        mem[0x4000] = bank

    def close_sram():
        """Back to simple banking mode and disable the cartridge RAM again"""
        mem[0x6000] = 0
        mem[0x0000] = 0

    def call(address):
        """Call the function at an address taken from a table or a register (jp hl): not modelled, so code
        that does this is checked rather than verified"""
        from pseudo import NotModeled
        if getattr(address, 'pyfunc', None) is not None or (callable(address) and not isinstance(address, int)):
            return address()                     # a function that has pseudo-code: run it
        raise NotModeled('calls the function at ${:04X} through a pointer'.format(int(address) & 0xFFFF))

    def charmap(text):
        """The bytes the game's character map gives a string: letters, digits, space, '@' (the end mark)"""
        out = []
        for ch in text:
            if 'A' <= ch <= 'Z':
                out.append(0x80 + ord(ch) - ord('A'))
            elif 'a' <= ch <= 'z':
                out.append(0xA0 + ord(ch) - ord('a'))
            elif '0' <= ch <= '9':
                out.append(0xF6 + ord(ch) - ord('0'))
            else:
                out.append({' ': 0x7F, '@': 0x50, '(': 0x9A, ')': 0x9B, ':': 0x9C, 'é': 0xBA, "'": 0xE0,
                            '-': 0xE3, '?': 0xE6, '!': 0xE7, '.': 0xE8, '♂': 0xEF, '×': 0xF1, '/': 0xF3,
                            ',': 0xF4, '♀': 0xF5}[ch])
        return out

    def label(name):
        """The address of a label given by its full name, for local labels the code uses as data:
        label('StartMenu_Pokemon.newBadgeRequiredText')"""
        return addr(name)

    def farcall(fn, *args):
        """A far call (farcall / callfar / Bankswitch): switch fn's ROM bank in (and into hLoadedROMBank), call
        fn(*args), then switch back to the bank hLoadedROMBank held before. Returns what fn returns."""
        import build
        name = getattr(fn, 'label', None) or getattr(fn, '__name__', None)
        bank = build.SYM_BANK.get(name)
        if bank is None:
            from pseudo import NotModeled
            raise NotModeled('farcall of something that is not a label')
        h = addr('hLoadedROMBank')
        saved = mem[h]
        mem[h] = bank
        mem[0x2000] = bank
        result = fn(*args)
        mem[h] = saved
        mem[0x2000] = saved
        return result

    def predef(fn, hl=0, de=0, bc=0):
        """A predef call (predef / predef_jump): what Predef does for predefined function fn - keep hl, de and
        bc big-endian in wPredefHL/DE/BC (where fn reads them back with GetPredefRegisters), note fn's table
        entry in wPredefID and the caller's bank in wPredefParentBank, run fn in its own bank, then switch
        back. Returns what fn returns."""
        import build
        name = getattr(fn, 'label', None) or getattr(fn, '__name__', None)
        bank = build.SYM_BANK.get(name)
        if bank is None:
            from pseudo import NotModeled
            raise NotModeled('predef of something that is not a label')
        target = int(fn) & 0xFFFF if isinstance(fn, int) else addr(name)
        table = addr('PredefPointers')
        mem[0x2000] = build.SYM_BANK.get('PredefPointers', 0)   # Predef reads the table in its own bank
        for i in range(128):                       # entries: bank, address (little-endian)
            e = table + 3 * i
            if mem[e] == bank and (mem[e + 1] | mem[e + 2] << 8) == target:
                mem[addr('wPredefID')] = i
                break
        for var, v in (('wPredefHL', hl), ('wPredefDE', de), ('wPredefBC', bc)):
            a = addr(var)
            mem[a], mem[a + 1] = v >> 8 & 0xFF, v & 0xFF
        h = addr('hLoadedROMBank')
        saved = mem[h]
        mem[addr('wPredefParentBank')] = saved
        mem[addr('wPredefBank')] = bank
        mem[h] = bank
        mem[0x2000] = bank
        result = fn()
        mem[h] = saved
        mem[0x2000] = saved
        return result

    sounds = _sounds(addr)

    return dict(sounds, **{
        'call': (call, call.__doc__),
        'farcall': (farcall, farcall.__doc__),
        'label': (label, label.__doc__),
        'predef': (predef, predef.__doc__),
        'charmap': (charmap, charmap.__doc__),
        'open_sram': (open_sram, open_sram.__doc__),
        'close_sram': (close_sram, close_sram.__doc__),
        'coord': (coord, coord.__doc__),
        'bgcoord': (bgcoord, bgcoord.__doc__),
        'event': (event, event.__doc__),
        'set_event': (set_event, set_event.__doc__),
        'reset_event': (reset_event, reset_event.__doc__),
    })
