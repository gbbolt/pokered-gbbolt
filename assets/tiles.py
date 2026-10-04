"""The plain tile graphics of the ROM, found the way the game uses them: the tileset graphics
of the Tilesets table, the overworld sprites of SpriteSheetPointerTable, and every data block
the code hands to a tile copy routine (CopyVideoData, FarCopyData2, ... for 2 bits per pixel;
CopyVideoDataDouble, FarCopyDataDouble for 1 bit per pixel)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import _pk  # noqa: E402
import build as engine  # noqa: E402  (the engine's build module)

GROUP = 'tiles'


def layout(tiles, cols, frames=False):
    n = len(tiles)
    if frames:                          # 16 x 16 sprite frames side by side
        cols, rt = 2 * ((n + 3) // 4), 2
        pos = [(2 * (t // 4) + (t & 1), (t >> 1) & 1) for t in range(n)]
    else:
        cols = max(1, min(cols, n))
        rt = (n + cols - 1) // cols
        pos = [(t % cols, t // cols) for t in range(n)]
    img = [[0] * (cols * 8) for _ in range(rt * 8)]
    for t, (cx, cy) in enumerate(pos):
        for y in range(8):
            img[cy * 8 + y][cx * 8:cx * 8 + 8] = tiles[t][y]
    return img, cols * 8, rt * 8


def build(ctx):
    rom, syms = ctx.rom, ctx.syms
    lin = engine.linear
    units = {u.start: u for u in _pk.data_units(ctx.project)}
    by_name = {u.name: u for u in units.values()}
    found = {}                           # unit name -> (bpp, group, note, tile count or None)
    uses = {}                            # tileset graphics -> the tilesets using them

    # tilesets: bank, blocks, graphics, collision, ... (12 bytes each)
    ts = engine.sym_linear('Tilesets', syms)
    blocksets = set()
    for t in range(24):
        e = ts + 12 * t
        bank = rom[e]
        blocksets.add(lin(bank, ctx.word(e + 1)))
        u = units.get(lin(bank, ctx.word(e + 3)))
        if u:
            uses.setdefault(u.name, []).append(t)
            found.setdefault(u.name, (2, 'tilesets', 'The graphics of tileset {} (Tilesets entry {}): the 8 x 8 '
                                      'pieces its blockset builds every map block from.'.format(t, t), None))
    # overworld sprites: graphics pointer, size in bytes, bank
    sp = engine.sym_linear('SpriteSheetPointerTable', syms)
    for i in range(72):
        e = sp + 4 * i
        size, bank = rom[e + 2], rom[e + 3]
        u = units.get(lin(bank, ctx.word(e)))
        if u and size and size % 64 == 0:
            found.setdefault(u.name, (2, 'overworld sprites', 'Overworld sprite {} (SpriteSheetPointerTable): '
                                      '{} tiles, {} frames of 16 x 16 pixels; each frame is four tiles (top left, '
                                      'top right, bottom left, bottom right).'.format(i + 1, size // 16, size // 64),
                                      size // 16))
    # whatever the code copies into VRAM
    for name, bpp in _pk.tile_loads(ctx.project).items():
        u = by_name.get(name)
        if u and u.start not in blocksets:
            found.setdefault(name, (bpp, 'fonts & 1 bpp' if bpp == 1 else 'more graphics',
                                    'Copied to VRAM by the code with {}.'.format(
                                        'a 1-bit-per-pixel copy routine, which expands each byte into both bit '
                                        'planes, so the pixels are only white or black' if bpp == 1 else
                                        'a tile copy routine'), None))
    # the rest: graphics the code reaches through tables (emotes, party icons, ...), told by their folder or name
    import re
    pic_like = re.compile(r'(Tiles?\d?|Gfx|GFX|Graphics|Emote|IconFrame\d|Sprite|Icon)$|^(Flower|RedFishing)')
    for u in units.values():
        size = u.end - u.start
        if u.name in found or u.start in blocksets or size % 16 or size > 0x1000:
            continue
        if (u.path or '').startswith('gfx/') or pic_like.search(u.name):
            if u.name.endswith('Pic') or 'Pic' in u.name[-9:]:
                continue
            if u.name.endswith('Sprite') and size % 64 == 0:
                found[u.name] = (2, 'overworld sprites', 'An overworld sprite the code loads on its own: frames of '
                                 '16 x 16 pixels, four tiles each.', size // 16)
            else:
                found[u.name] = (2, 'more graphics', 'Tile data the code reaches through a table.', None)
    out = []
    for name, (bpp, group, note, count) in found.items():
        u = by_name[name]
        per = 8 * bpp
        size = u.end - u.start
        n = count or size // per
        if n == 0 or (not count and size % per):
            continue
        tiles = [_pk.tile_rows(rom, u.start + per * k, bpp) for k in range(n)]
        sprite = group == 'overworld sprites'
        img, w, h = layout(tiles, 16, frames=sprite)
        marks, more = [], []
        if group == 'tilesets' and name in uses:
            from _pkdata import Game
            game = Game(ctx)
            tprops = {}
            for t in uses[name]:
                for tile, lst in game.tileset_props(t).items():
                    for kind, text in lst:
                        line = ('tileset {}: '.format(t) if len(uses[name]) > 1 else '') + text
                        if line not in tprops.setdefault(tile, []):
                            tprops[tile].append(line)
            for tile in sorted(tprops):
                if tile < n:
                    marks.append({'x': (tile % 16) * 8, 'y': (tile // 16) * 8, 'w': 8, 'h': 8,
                                  'label': 'tile ${:02X}'.format(tile), 'text': '; '.join(tprops[tile])})
            more = ['The marked tiles are the ones the tileset\'s tables give a meaning (walkable, door, warp, grass, '
                    'counter, ledge, water, ...); hover one. ' + ', '.join('TilesetProps{:02d}'.format(t) for t in uses[name]) +
                    ' draw{} the whole sheet tinted by it.'.format('s' if len(uses[name]) == 1 else '')]
        out.append({
            'name': name, 'unit': name, 'type': 'image', 'group': group, 'marks': marks,
            'title': _pk.spaced(name),
            'subtitle': '{} tile{}, {} bpp'.format(n, '' if n == 1 else 's', bpp),
            'source': '{} bytes at {}: {} tile{} of {} bit{} per pixel'.format(n * per, engine.fmt_rom(u.start), n,
                                                                         '' if n == 1 else 's', bpp, '' if bpp == 1 else 's'),
            'width': w, 'height': h, 'pixels': ctx.packed_pixels(img), 'packed': 'zlib',
            'scale': 4 if w <= 128 and h <= 128 else (3 if w <= 256 else 2),
            'doc': ['{}: {} tile{} of {} bit{} per pixel ({} bytes).'.format(
                name, n, '' if n == 1 else 's', bpp, '' if bpp == 1 else 's', n * per), note] + more,
        })
    return out
