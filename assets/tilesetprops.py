"""What the tiles of each tileset do, from the game's tables: which tiles the player can walk on (the tileset's
collision list), doors, warp tiles, grass, counters, ledges, water, things to read, and the tile pairs that block
a step between two heights. Each tileset's tiles are drawn tinted by what they are."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import _pk  # noqa: E402
import build as engine  # noqa: E402
from _pkdata import Game  # noqa: E402

GROUP = 'tilesets'
# light to dark per kind (the tile's own shade picks one of the four)
KINDS = [
    ('solid', 'not walkable', ['#f2e3e3', '#cf9a9a', '#8c5656', '#3b1d1d']),
    ('walk', 'walkable', ['#eef6ea', '#a9cf9a', '#55834b', '#1d3519']),
    ('water', 'water / shore (Surf)', ['#e3f0fb', '#8fbfe8', '#3f78b4', '#14304f']),
    ('grass', 'grass (wild Pokémon)', ['#eaf9d4', '#9ee05a', '#4c9a1c', '#1c3d08']),
    ('ledge', 'ledge (jump down)', ['#f7ecdc', '#dcb27a', '#93642a', '#3d270c']),
    ('counter', 'counter (talk across)', ['#fbf6d6', '#e7d35c', '#a28d14', '#433906']),
    ('shelf', 'something to read', ['#e0f7f5', '#7fd3c9', '#2b8a7f', '#0c3a35']),
    ('warp', 'warp tile', ['#f0e6fa', '#bf9ae6', '#7445a8', '#2c1545']),
    ('door', 'door', ['#fde9dc', '#f2a46e', '#bd5a17', '#4d2006']),
]
WORDS = ['dull red', 'green', 'blue', 'bright green', 'brown', 'yellow', 'teal', 'purple', 'orange']
ORDER = ['door', 'warp', 'ledge', 'counter', 'shelf', 'grass', 'water', 'walk']


def build(ctx):
    g = Game(ctx)
    rom = g.rom
    names = g.tileset_names()
    kind_index = {k: i for i, (k, _, _) in enumerate(KINDS)}
    colors = [c for _, _, cs in KINDS for c in cs]
    out = []
    n = g.const('NUM_TILESETS', 24)
    for t in range(n):
        e = g.at('Tilesets') + 12 * t
        bank, gfx = rom[e], g.lin(rom[e], g.word(e + 3))
        props = g.tileset_props(t)
        img = [[0] * (16 * 9) for _ in range(6 * 9)]
        marks = []
        counts = {}
        for tile in range(0x60):
            px = _pk.tile_rows(rom, gfx + 16 * tile)
            have = {k for k, _ in props.get(tile, [])}
            kind = next((k for k in ORDER if k in have), 'solid')
            counts[kind] = counts.get(kind, 0) + 1
            base = 4 * kind_index[kind]
            ox, oy = (tile % 16) * 9, (tile // 16) * 9
            for y in range(8):
                img[oy + y][ox:ox + 8] = [base + v for v in px[y]]
            texts = [txt for k, txt in props.get(tile, []) if k != 'walk']
            walk = 'walkable' if 'walk' in have else 'not walkable'
            marks.append({'x': ox, 'y': oy, 'w': 8, 'h': 8, 'label': 'tile ${:02X}'.format(tile),
                          'text': '; '.join([walk] + texts)})
        for y in range(len(img)):                  # the 1-pixel gaps: background
            for x in range(len(img[0])):
                if x % 9 == 8 or y % 9 == 8:
                    img[y][x] = 255
        name = names.get(t, 'tileset {}'.format(t))
        gfx_label = g.label_at(gfx) or '?'
        legend = ', '.join('{} {}'.format(counts[k], text) for k, text, _ in KINDS if counts.get(k))
        out.append({
            'name': 'TilesetProps{:02d}'.format(t), 'type': 'image', 'unit': gfx_label,
            'title': 'Tileset {} ({}): what the tiles do'.format(t, name.replace('_', ' ').lower()),
            'subtitle': legend,
            'source': 'tileset entry at {}, graphics at {}, walkable list at {}'.format(
                engine.fmt_rom(e), engine.fmt_rom(gfx), engine.fmt_rom(g.word(e + 5))),
            'width': len(img[0]), 'height': len(img), 'pixels': ctx.pixels(img), 'scale': 4,
            'colors': colors, 'fixedColors': True, 'marks': marks, 'listMarks': False,
            'doc': ['The 96 tiles of tileset {} ({}, graphics {}) tinted by what the game\'s tables make of them: '.format(
                        t, name, gfx_label) + '; '.join('{}: {}'.format(w, text) for (k, text, cs), w in zip(KINDS, WORDS)) + '.',
                    'Walkable tiles are the tileset\'s collision list (Tilesets bytes 5-6); counters and grass are bytes '
                    '7-10 of its Tilesets entry; doors come from DoorTileIDPointers, warp tiles from WarpTileIDPointers, '
                    'ledges from LedgeTiles (outdoors only), water from WaterTilesets and IsNextTileShoreOrWater, things '
                    'to read from BookshelfTileIDs, and TilePairCollisionsLand / Water list tile pairs you cannot step '
                    'between. The game tests the tile under the lower left quarter of each 16 x 16 step. Hover a tile '
                    'for all it does.'],
            'users': ['CollisionCheckOnLand', 'IsPlayerStandingOnDoorTile', 'CheckForJumpingAndTilePairCollisions',
                      'IsNextTileShoreOrWater'],
        })
    return out
