"""Every compressed picture in the ROM - the Pokemon front and back pictures, the trainers,
the player - decoded from the cartridge bytes the way UncompressSpriteData does it.

A data block counts as a picture when its bytes unpack as one and the picture ends exactly
where the block ends. Whose picture it is comes from the game's own tables: the base stats
(front and back pointers of each Pokemon) and TrainerPicAndMoneyPointers."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import _pk  # noqa: E402

GROUP = 'pokémon pictures'

DOC = ('A compressed picture: the first byte gives its size in tiles (width, height), then a '
       'stream of bits. The two bit planes are stored one after the other, each as alternating '
       'packets: runs of zero pixel pairs (a length coded with a prefix of 1 bits) and literal '
       'pixel pairs (ended by a 00 pair). The pairs fill the picture in 2-pixel-wide strips, top '
       'to bottom, left to right. UncompressSpriteData unpacks it into sSpriteBuffer1 and '
       'sSpriteBuffer2; then each row is turned back from "changes" into pixels (every bit was '
       'stored as whether it differs from the pixel to its left), and depending on the mode the '
       'second plane is XORed with the first.')


def try_pic(rom, start, end):
    b = rom[start]
    w, h = b >> 4, b & 0xF
    if w != h or not 4 <= w <= 7 or end - start < 8:     # the game's pictures are 4 x 4 to 7 x 7 tiles
        return None
    try:
        rows, pw, ph, stop = _pk.decode_pic(rom, start, end)
    except Exception:  # noqa: BLE001 - not a picture
        return None
    return (rows, pw, ph) if stop == end else None


def who(ctx, name):
    """RhydonPicFront -> ('Rhydon', 'front', 'pokémon'), from the label only."""
    for side in ('Front', 'Back'):
        if name.endswith('Pic' + side):
            return _pk.spaced(name[:-len(side) - 3]), side.lower()
    if name.endswith('Pic'):
        return _pk.spaced(name[:-3]), ''
    return _pk.spaced(name), ''


def build(ctx):
    rom = ctx.rom
    rev = _pk.labels_by_address(ctx.project)
    # whose pictures: each Pokemon's base stats hold its front and back pointer (bytes 11-14), in the
    # bank UncompressMonSprite picks for its species number
    import build as engine
    from _pkdata import Game
    from pokedex import card_name
    g = Game(ctx)
    owner = {}
    sgb = g.sgb_palettes()
    for sp in g.species():
        b = g.base_stats(sp['dex'])
        bank = g.pic_bank(sp['internal'])
        for side in ('front', 'back'):
            owner[g.lin(bank, b[side])] = (card_name(sp['dex'], sp['name']), g.nice(sp['name']), side,
                                           g.mon_palette(sp['dex']), sp['dex'])
    out = []
    for u in _pk.data_units(ctx.project):
        got = try_pic(rom, u.start, u.end)
        if not got:
            continue
        rows, w, h = got
        size = u.end - u.start
        name, side = who(ctx, u.name)
        mon = owner.get(u.start)
        if mon:
            name, side = mon[1], mon[2]
        colors = None
        if mon:
            pal = mon[3]
            colors = sgb[pal][1]
            src_pal = ', colours: palette {} at {}'.format(sgb[pal][0], engine.fmt_rom(g.at('SuperPalettes') + 8 * pal))
        out.append({
            'name': u.name, 'unit': u.name, 'type': 'image', 'colors': colors,
            'group': 'pokémon pictures' if mon else 'trainer & other pictures',
            'title': name + (' (' + side + ')' if side else ''),
            'subtitle': '{} x {} tiles, {} bytes'.format(w // 8, h // 8, size),
            'source': '{} bytes at {}, {} x {} tiles{}'.format(size, engine.fmt_rom(u.start), w // 8, h // 8,
                                                                ', the {} picture of {}'.format(side, name) if mon else '') +
                      (src_pal if mon else ''),
            'link': mon[0] if mon else None,
            'width': w, 'height': h, 'pixels': ctx.packed_pixels(rows), 'packed': 'zlib', 'scale': 4,
            'doc': ['{}: a {}{} x {} pixel picture packed into {} bytes ({}% of the {} bytes '
                    'it takes as plain tiles).'.format(u.name, side + ' ' if side else '', w, h, size,
                                                     round(100 * size / (w * h // 4)), w * h // 4), DOC] +
                   (['On a Super Game Boy it is shown in palette {} (MonsterPalettes entry {} gives it; pick "colour" '
                     'above).'.format(sgb[mon[3]][0], mon[4])] if mon else []),
            'users': ['UncompressSpriteData'],
        })
    return out
