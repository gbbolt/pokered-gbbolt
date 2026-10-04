"""The Town Map as LoadTownMap draws it: the tile graphics WorldMapTileGraphics go to tiles $60-$6F, then
CompressedMap fills the screen (each byte: tile $60 + its high nibble, repeated as often as its low nibble says,
0 ends it). Every place sits where LoadTownMapEntry puts the cursor: ExternalMapEntries (one per town and route,
by map number) and InternalMapEntries (groups of inside maps, each up to a map number)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import _pk  # noqa: E402
import build as engine  # noqa: E402
from _pkdata import Game  # noqa: E402

GROUP = 'maps'


def place(name):
    """'S.S.ANNE' -> 'S.S.Anne', '#MON TOWER' -> 'Pokémon Tower', "DIGLETT's CAVE" -> "Diglett's Cave"."""
    for k, v in (('<NEXT>', ' '), ('<LINE>', ' '), ('<PKMN>', 'POKéMON'), ('<pkmn>', 'POKéMON'), ('#', 'POKé')):
        name = name.replace(k, v)
    out, up = '', True
    for ch in name:
        out += ch if up else ch.lower()
        up = not ch.isalpha() and ch != "'"
    return out.replace('Hq', 'HQ')


def build(ctx):
    g = Game(ctx)
    rom = g.rom
    tiles = {0x60 + k: _pk.tile_rows(rom, g.at('WorldMapTileGraphics') + 16 * k) for k in range(16)}
    screen = [None] * (20 * 18)
    a, i = g.at('CompressedMap'), 0
    while rom[a] and i < 360:
        n = rom[a] & 0xF or 256
        for _ in range(n):
            if i < 360:
                screen[i] = 0x60 + (rom[a] >> 4)
            i += 1
        a += 1
    end = a
    img = [[0] * 160 for _ in range(144)]
    for k, t in enumerate(screen):
        px = tiles.get(t)
        if px is None:
            continue
        ox, oy = (k % 20) * 8, (k // 20) * 8
        for y in range(8):
            img[oy + y][ox:ox + 8] = px[y]
    # the places: (y << 4 | x) and a name pointer; the cursor sprite (16 x 16) sits at (8x + 12, 8y + 4)
    bank = g.bank('ExternalMapEntries')
    first_in = g.const('FIRST_INDOOR_MAP', 0x25)
    spots = {}                                     # (x, y) -> [names, maps]

    def add(yx, name_ptr, maps):
        name = g.string(g.lin(bank, name_ptr))[0]
        s = spots.setdefault(yx, {'names': [], 'maps': []})
        if name not in s['names']:
            s['names'].append(name)
        s['maps'] += [m for m in maps if m not in s['maps']]
    e = g.at('ExternalMapEntries')
    unused = {v for k, v in ctx.project.parsed.consts.items() if k.startswith('UNUSED_MAP') and isinstance(v, int)}
    for m in range(first_in):
        if m in unused:
            continue
        add(rom[e + 3 * m], g.word(e + 3 * m + 1), [m])
    e, lo = g.at('InternalMapEntries'), first_in
    while rom[e] != 0xFF:
        hi = rom[e]
        add(rom[e + 1], g.word(e + 2), list(range(lo, hi)))
        lo, e = hi, e + 4
    shared = {}
    for m in range(0xF8):
        if m not in unused:
            lab = g.map_blocks_label(m)
            shared[lab] = shared.get(lab, 0) + 1
    marks = []
    for yx, s in spots.items():
        x, y = yx & 0xF, yx >> 4
        links = []
        for m in s['maps']:
            lab = g.map_blocks_label(m) if m < 0xF8 and m not in unused else ''
            if lab and g.map_name(m) and lab not in [l for l, _ in links]:
                links.append((lab, g.map_name(m)))
        links.sort(key=lambda l: shared.get(l[0], 0) > 1)       # a map with blocks of its own first
        names = ' / '.join(place(n) for n in s['names'])
        first = links[0] if links else (None, None)
        mk = {'x': 8 * x + 12, 'y': 8 * y + 4, 'w': 16, 'h': 16, 'label': names,
              'text': 'cursor at ({}, {})'.format(x, y) + (', also: ' + ', '.join(n for _, n in links[1:8]) +
                                                           (' …' if len(links) > 8 else '') if len(links) > 1 else ''),
              'link': first[0], 'linkText': first[1]}
        marks.append(mk)
    marks.sort(key=lambda k: (k['y'], k['x']))
    pal = g.const('PAL_TOWNMAP', 0x0C)
    sgb = g.sgb_palettes()
    return [{
        'name': 'TownMapScreen', 'unit': 'CompressedMap', 'type': 'image', 'title': 'Town Map',
        'subtitle': '{} places'.format(len(marks)),
        'source': 'map at {} ({} bytes), tiles at {}, places at {} and {}, colours: palette {} at {}'.format(
            engine.fmt_rom(g.at('CompressedMap')), end + 1 - g.at('CompressedMap'), engine.fmt_rom(g.at('WorldMapTileGraphics')),
            engine.fmt_rom(g.at('ExternalMapEntries')), engine.fmt_rom(g.at('InternalMapEntries')),
            sgb[pal][0], engine.fmt_rom(g.at('SuperPalettes') + 8 * pal)),
        'width': 160, 'height': 144, 'pixels': ctx.pixels(img), 'scale': 4, 'marks': marks, 'listMarks': True,
        'colors': sgb[pal][1],
        'doc': ['The Town Map, unpacked from CompressedMap the way LoadTownMap does it: a byte gives a tile '
                '($60 plus the high nibble, from WorldMapTileGraphics) and how many times in a row it goes on the '
                'screen (the low nibble, 0 meaning 16); a 0 byte ends the map. {} bytes cover the whole '
                '20 x 18-tile screen.'.format(end + 1 - g.at('CompressedMap')),
                'The marked spots are where the cursor (and the Pokémon nest icons) go: LoadTownMapEntry takes a '
                'town or route straight from ExternalMapEntries (3 bytes per map: y and x in one byte, the name), '
                'an inside map from the first InternalMapEntries group whose upper map number is above it. '
                'TownMapCoordsToOAMCoords turns (x, y) into the sprite position 8x + 24, 8y + 24.'],
        'users': ['LoadTownMap', 'LoadTownMapEntry', 'DisplayTownMap', 'TownMapCoordsToOAMCoords'],
    }]
