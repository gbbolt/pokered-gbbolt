"""Every map of the game as one picture, drawn the way the game builds it: the map header
(MapHeaderPointers / MapHeaderBanks) names the tileset, the size and the block data; each
block byte picks a 4 x 4-tile block from the tileset's blockset, and the blockset's tile
numbers pick 8 x 8 tiles from the tileset graphics. The people, items and signs of the
map's object data stand on top, each drawn with the first frame of its overworld sprite."""
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import _pk  # noqa: E402
import build as engine  # noqa: E402

GROUP = 'maps'
OBP0 = [None, 0, 1, 3]             # FadePal4's rOBP0 (3,1,0,0): colour 0 is see-through
FACING = {0xD0: 0, 0xD1: 1, 0xD2: 2, 0xD3: 3}      # DOWN, UP, LEFT, RIGHT -> frame (right = left mirrored)


def spaced(name):
    s = re.sub(r'(?<=[a-z])(?=[A-Z0-9])', ' ', name)
    return re.sub(r'(?<=[A-Z])(?=[A-Z][a-z])', ' ', s).replace('_', ' ')


def build(ctx):
    rom, syms = ctx.rom, ctx.syms
    bank_of = engine.SYM_BANK
    lin = engine.linear
    rev = {}
    for n, a in syms.items():
        if '.' not in n:
            rev.setdefault(lin(bank_of.get(n, 0), a), n)

    def sym(n):
        return lin(bank_of.get(n, 0), syms[n])

    def word(a):
        return rom[a] | rom[a + 1] << 8

    ptrs, banks, tsets = sym('MapHeaderPointers'), sym('MapHeaderBanks'), sym('Tilesets')
    sheet_table = sym('SpriteSheetPointerTable')
    n_maps = (banks - sym('MapHeaderBanks')) or 0
    n_maps = 0xF8                                       # map ids $00-$F7 (NUM_MAPS)
    tile_cache = {}

    def tileset(t):
        e = tsets + 12 * t
        bank = rom[e]
        blocks, gfx = lin(bank, word(e + 1)), lin(bank, word(e + 3))
        return bank, blocks, gfx, e

    def tiles_of(gfx):
        if gfx not in tile_cache:
            tile_cache[gfx] = [_pk.tile_rows(rom, gfx + 16 * i) for i in range(0x60)]
        return tile_cache[gfx]

    sprite_cache = {}

    def sprite_frame(pic, frame):
        """16 x 16 shade rows (None = see-through) of a sprite's frame."""
        key = (pic, frame)
        if key in sprite_cache:
            return sprite_cache[key]
        e = sheet_table + 4 * (pic - 1)
        addr, size, bank = word(e), rom[e + 2], rom[e + 3]
        src = lin(bank, addr)
        frames = size // 64
        mirror = frame == 3
        f = min(2 if frame == 3 else frame, frames - 1) if frames else 0
        rows = [[None] * 16 for _ in range(16)]
        for k in range(4):
            tr = _pk.tile_rows(rom, src + 64 * f + 16 * k)
            ox, oy = (k & 1) * 8, (k >> 1) * 8
            for y in range(8):
                for x in range(8):
                    rows[oy + y][ox + x] = OBP0[tr[y][x]]
        if mirror:
            rows = [r[::-1] for r in rows]
        sprite_cache[key] = (rows, rev.get(src, 'sprite {}'.format(pic)))
        return sprite_cache[key]

    from _pkdata import Game, trainer_card
    from pokedex import card_name
    game = Game(ctx)
    game.species()
    wild = {m: got for m, (got, _) in game.wild().items()}
    trainer_names = game.strings('TrainerNames', 47)
    # hidden events: HiddenEventMaps (map ids up to $FF), HiddenEventPointers (a list per map:
    # y, x, argument, bank and address of the routine; $FF ends it)
    hidden = {}
    hm, hp, hbank = game.at('HiddenEventMaps'), game.at('HiddenEventPointers'), game.bank('HiddenEventPointers')
    k = 0
    while rom[hm + k] != 0xFF:
        a = lin(hbank, word(hp + 2 * k))
        lst = []
        while rom[a] != 0xFF:
            y, x, arg, fb = rom[a:a + 4]
            f = lin(fb, word(a + 4))
            lst.append((y, x, arg, f, rev.get(f, '')))
            a += 6
        hidden.setdefault(rom[hm + k], lst)
        k += 1
    # ---- a first pass over the headers: size, connections and warps of every map (for the colours and Kanto)
    info = {}
    for m in range(n_maps):
        hb = rom[banks + m]
        h_addr = lin(hb, word(ptrs + 2 * m))
        if not rev.get(h_addr, '').endswith('_h'):
            continue
        conn, p, cl = rom[h_addr + 9], h_addr + 10, []
        for bit, d in ((8, 'north'), (4, 'south'), (2, 'west'), (1, 'east')):
            if conn & bit:
                cl.append((d, rom[p], word(p + 1), word(p + 3)))
                p += 11
        q = lin(hb, word(p)) + 1
        warps = [rom[q + 1 + 4 * i + 3] for i in range(rom[q])]
        info[m] = {'h': h_addr, 'tset': rom[h_addr], 'H': rom[h_addr + 1], 'W': rom[h_addr + 2],
                   'blk': word(h_addr + 3), 'conns': cl, 'warps': warps}
    outside_set = {game.const('OVERWORLD', 0), game.const('PLATEAU', 0x17)}
    # inside maps take the colours of the town or route they are entered from (wLastMap): follow the warps
    outside = {}
    todo = [m for m in sorted(info) if info[m]['tset'] in outside_set]
    for m in todo:
        outside[m] = m
    while todo:
        nxt = []
        for m in todo:
            for d in info[m]['warps']:
                if d in info and d not in outside:
                    outside[d] = outside[m]
                    nxt.append(d)
        todo = nxt
    sgb = game.sgb_palettes()

    def map_colors(m):
        p = game.map_palette(m, info[m]['tset'], outside.get(m))
        return (p, sgb[p][1]) if p is not None and p < len(sgb) else (None, None)

    region_imgs = {}
    seen = {}
    out = []
    for m in range(n_maps):
        hb = rom[banks + m]
        h_addr = lin(hb, word(ptrs + 2 * m))
        h_label = rev.get(h_addr, '')
        if not h_label.endswith('_h'):
            continue
        if h_addr in seen:
            continue
        seen[h_addr] = m
        tset, height, width = rom[h_addr], rom[h_addr + 1], rom[h_addr + 2]
        blk = lin(hb, word(h_addr + 3))
        conn = rom[h_addr + 9]
        p = h_addr + 10
        conns = []
        strips = []                     # (direction, map, first block along the edge, length in blocks)
        for bit, d in ((8, 'north'), (4, 'south'), (2, 'west'), (1, 'east')):
            if conn & bit:
                conns.append((d, rom[p]))
                # connection: map, strip source, strip destination in wOverworldMap (rows of width + 6
                # blocks: a 3-block border around the map), strip length, ...
                off = word(p + 3) - syms['wOverworldMap']
                row, col = divmod(off, width + 6)
                strips.append((d, rom[p], (col if d in ('north', 'south') else row) - 3, rom[p + 5]))
                p += 11
        obj = lin(hb, word(p))
        b_label = rev.get(blk, '')
        if not b_label or width * height == 0:
            continue
        _, blocks, gfx, t_entry = tileset(tset)
        tiles = tiles_of(gfx)
        blank = [[0] * 8 for _ in range(8)]
        W, H = width * 32, height * 32
        img = [[0] * W for _ in range(H)]
        for by in range(height):
            for bx in range(width):
                b = rom[blk + by * width + bx]
                for k in range(16):
                    t = rom[blocks + 16 * b + k]
                    px = tiles[t] if t < 0x60 else blank
                    ox, oy = bx * 32 + (k & 3) * 8, by * 32 + (k >> 2) * 8
                    for y in range(8):
                        img[oy + y][ox:ox + 8] = px[y]
        # the object data: border block, warps, signs, people / items - and what each one says or does
        tptr = lin(hb, word(h_addr + 5))
        n_texts = 64

        def says(tid):
            if not 1 <= tid <= n_texts:
                return ''
            a = lin(hb, word(tptr + 2 * (tid - 1)))
            return game.say(a)

        marks = []
        q = obj + 1
        n = rom[q]
        q += 1
        for i in range(n):
            y, x, warp_id, dest = rom[q:q + 4]
            q += 4
            if dest == 0xFF:
                marks.append({'x': 16 * x, 'y': 16 * y, 'w': 16, 'h': 16, 'label': 'Warp {}'.format(i + 1),
                              'text': 'back outside, to the map you came from (warp {})'.format(warp_id + 1)})
                continue
            dblocks = game.map_blocks_label(dest) if dest < n_maps else ''
            marks.append({'x': 16 * x, 'y': 16 * y, 'w': 16, 'h': 16, 'label': 'Warp {}'.format(i + 1),
                          'text': 'to warp {} of {}'.format(warp_id + 1, game.map_name(dest)),
                          'link': dblocks or None, 'linkText': game.map_name(dest)})
        # the exits at the map's edges: the connected maps (8 pixels wide strips along the edge)
        for d, dest, start, length in strips:
            along = W if d in ('north', 'south') else H
            a0 = max(0, min(32 * start, along))
            a1 = max(a0, min(32 * (start + length), along))
            if a1 - a0 < 16:                         # odd data: mark the whole edge
                a0, a1 = 0, along
            box = {'north': (a0, 0, a1 - a0, 8), 'south': (a0, H - 8, a1 - a0, 8),
                   'west': (0, a0, 8, a1 - a0), 'east': (W - 8, a0, 8, a1 - a0)}[d]
            marks.append({'x': box[0], 'y': box[1], 'w': box[2], 'h': box[3],
                          'label': '{} exit'.format(d.capitalize()),
                          'text': 'the map continues {} into {}'.format(d, game.map_name(dest)),
                          'link': game.map_blocks_label(dest) or None, 'linkText': game.map_name(dest)})
        n = rom[q]
        q += 1
        for i in range(n):
            y, x, text_id = rom[q:q + 3]
            q += 3
            marks.append({'x': 16 * x, 'y': 16 * y, 'w': 16, 'h': 16, 'label': 'Sign',
                          'text': '' if says(text_id) else 'text {}'.format(text_id), 'say': says(text_id)})
        n = rom[q]
        q += 1
        people = 0
        for i in range(n):
            pic, y, x, move, facing, tid = rom[q:q + 6]
            q += 6
            mk = {'text': '' if says(tid & 0x3F) else 'text {}'.format(tid & 0x3F), 'say': says(tid & 0x3F)}
            if tid & 0x40:                       # TRAINER: class, party number
                cls, party = rom[q] - 200, rom[q + 1]      # OPP_ ids: 200 + trainer class
                if 1 <= cls <= 47:
                    mk['text'] = '{} (party {})'.format(game.nice(trainer_names[cls - 1]), party)
                    mk['link'] = '{}@p{}'.format(trainer_card(cls, trainer_names[cls - 1]), party)
                    mk['linkText'] = 'the party'
                else:                            # a Pokemon standing on the map (Snorlax, the legendary birds)
                    sp = game.by_internal.get(rom[q])
                    mk['text'] = 'a wild {} at level {}'.format(game.nice(sp['name']) if sp else '?', party)
                    if sp:
                        mk['link'], mk['linkText'] = card_name(sp['dex'], sp['name']), 'Pokédex'
                q += 2
            elif tid & 0x80:                     # ITEM
                mk = {'text': 'item: {}'.format(game.nice(game.item_name(rom[q]))),
                      'link': 'ItemsTable@i{}'.format(rom[q]) if 1 <= rom[q] <= 0x53 or rom[q] >= 0xC4 else None,
                      'linkText': 'items sheet'}
                q += 1
            x, y = x - 4, y - 4
            rows, sname = sprite_frame(pic, FACING.get(facing, 0))
            ox, oy = 16 * x, 16 * y - 4
            for yy in range(16):
                for xx in range(16):
                    v = rows[yy][xx]
                    if v is not None and 0 <= oy + yy < H and 0 <= ox + xx < W:
                        img[oy + yy][ox + xx] = v
            people += 1
            mk['text'] = ' · '.join(t for t in ('walks around' if move == 0xFE else '', mk['text']) if t)
            marks.append(dict(mk, x=ox, y=max(0, oy), w=16, h=16, label=sname.replace('Sprite', '') or sname))
        for y, x, arg, func, flabel in hidden.get(m, []):
            link = None
            if flabel == 'HiddenItems':
                what, more = 'a hidden item: {}'.format(game.nice(game.item_name(arg))), ''
                link = 'ItemsTable@i{}'.format(arg) if 1 <= arg <= 0x53 or arg >= 0xC4 else None
            elif flabel == 'HiddenCoins':
                what, more = 'hidden coins', ''
            else:
                said = ' / '.join(t for _, t in game.script_texts(func, limit=1, arg=arg))   # the texts its routine prints
                what, more = flabel or 'a script', said
            marks.append({'x': 16 * x, 'y': 16 * y, 'w': 16, 'h': 16, 'label': 'Hidden', 'text': what, 'say': more,
                          'link': link, 'linkText': 'items sheet' if link else None})
        name = h_label[:-2]
        title = spaced(name)
        scale = 2 if W <= 640 else 1
        pal, colors = map_colors(m)
        if tset in outside_set:
            region_imgs[m] = (img, pal, b_label, title)
        out.append({
            'name': b_label, 'unit': b_label, 'type': 'image', 'title': title,
            'subtitle': '{} x {} blocks, {}'.format(width, height, rev.get(gfx, 'tileset {}'.format(tset)).replace('_GFX', '')),
            'source': 'map ${:02X}: header at {}, blocks at {}, objects at {}, tileset {} (graphics at {}, blocks at {})'.format(
                m, engine.fmt_rom(h_addr), engine.fmt_rom(blk), engine.fmt_rom(obj), rev.get(gfx, str(tset)).replace('_GFX', ''),
                engine.fmt_rom(gfx), engine.fmt_rom(blocks)),
            'listMarks': True, 'colors': colors,
            'width': W, 'height': H, 'pixels': ctx.packed_pixels(img), 'packed': 'zlib',
            'scale': scale, 'scroll': True, 'marks': marks,
            'doc': ['{}: map ${:02X}, {} x {} blocks of 32 x 32 pixels. Header {} picks tileset {} '
                    '(blocks {}, tiles {}); the block numbers come from {}.'.format(
                        title, m, width, height, h_label, tset, rev.get(blocks, '?'), rev.get(gfx, '?'), b_label),
                    'On top: {} warp{}, {} sign{} and {} person / item sprite{} from {}, and the hidden events of '
                    'HiddenEventPointers. Hover or click a mark; the list below the map has them all.'.format(
                        sum(1 for k in marks if k['label'].startswith('Warp')), '' if sum(1 for k in marks if k['label'].startswith('Warp')) == 1 else 's',
                        sum(1 for k in marks if k['label'] == 'Sign'), '' if sum(1 for k in marks if k['label'] == 'Sign') == 1 else 's',
                        people, '' if people == 1 else 's', rev.get(obj, 'the object data')) +
                    (' It joins {}.'.format(', '.join('{} to map ${:02X} ({})'.format(
                        d, t, rev.get(lin(rom[banks + t], word(ptrs + 2 * t)), '?')[:-2]) for d, t in conns)) if conns else '')],
            'users': ['LoadMapHeader', 'LoadCurrentMapView'],
            'wild': wild.get(m), 'map_id': m,
        })
        if pal is not None:
            why = ('its own palette' if m < game.const('NUM_CITY_MAPS', 11) else 'the route palette') if tset in outside_set \
                else 'the palette of {}, the map outside'.format(game.map_name(outside[m])) if m in outside and outside[m] != m \
                and game.map_palette(m, tset, None) is None else 'a palette of its own kind'
            out[-1]['source'] += ', colours: palette {} at {}'.format(sgb[pal][0], engine.fmt_rom(game.at('SuperPalettes') + 8 * pal))
            out[-1]['doc'].append('On a Super Game Boy SetPal_Overworld colours it with {} ({} of SuperPalettes; pick '
                                  '"colour" above to see it).'.format(why, sgb[pal][0]))
    region = kanto(ctx, game, info, region_imgs, sgb, syms['wOverworldMap'])
    for a in out:
        got = a.pop('wild', None)
        m = a.pop('map_id')
        for where, (rate, slots) in (got or {}).items():
            # not a spot on the map: a mark without a size, listed under the picture with its link
            a['marks'].append({'x': 0, 'y': 0, 'w': 0, 'h': 0, 'label': 'Wild ({})'.format(where),
                               'text': 'encounter rate {} of 256 per step'.format(rate),
                               'link': 'WildEncounters@w{}-{}'.format(m, where), 'linkText': 'the encounter table'})
            mons = []
            for lvl, sp in slots:
                n = game.nice(game.by_internal[sp]['name']) if sp in game.by_internal else '?'
                if n not in mons:
                    mons.append(n)
            a['doc'].append('Wild Pokémon in the {} (encounter rate {} of 256 per step; WildEncounters lists the '
                            'slots): {}.'.format('grass' if where == 'grass' else 'water', rate, ', '.join(mons)))
    return out + region


def kanto(ctx, game, info, imgs, sgb, overworld_buf):
    """The outdoor maps put together through their connections, starting at Pallet Town. A connection
    copies a strip of the neighbour's blocks into the border of wOverworldMap (rows of width + 6 blocks): the
    strip's source address in the neighbour's blocks and its destination in that buffer fix how the two maps
    line up."""
    if 0 not in imgs:
        return []
    pos = {0: (0, 0)}
    todo, clashes = [0], []
    while todo:
        m = todo.pop(0)
        x, y = pos[m]
        a = info[m]
        for d, c, src, dst in a['conns']:
            if c not in imgs or c not in info:
                continue
            b = info[c]
            so, do = src - b['blk'], dst - overworld_buf
            if d in ('north', 'south'):
                dx = do % (a['W'] + 6) - 3 - so % b['W']
                p = (x + dx, y - b['H'] if d == 'north' else y + a['H'])
            else:
                dy = do // (a['W'] + 6) - 3 - so // b['W']
                p = (x - b['W'] if d == 'west' else x + a['W'], y + dy)
            if c in pos:
                if pos[c] != p:
                    clashes.append((m, c))
                continue
            pos[c] = p
            todo.append(c)
    x0 = min(x for x, _ in pos.values())
    y0 = min(y for _, y in pos.values())
    x1 = max(x + info[m]['W'] for m, (x, _) in pos.items())
    y1 = max(y + info[m]['H'] for m, (_, y) in pos.items())
    W, H = 32 * (x1 - x0), 32 * (y1 - y0)
    canvas = [bytearray([255]) * W for _ in range(H)]
    pals = []                                    # the palettes in the picture, in order of first use
    marks = []
    for m in sorted(pos, key=lambda k: (pos[k][1], pos[k][0])):
        img, pal, label, title = imgs[m]
        if pal not in pals:
            pals.append(pal)
        base = 4 * pals.index(pal)
        ox, oy = 32 * (pos[m][0] - x0), 32 * (pos[m][1] - y0)
        for yy, row in enumerate(img):
            canvas[oy + yy][ox:ox + len(row)] = bytes(v + base for v in row)
        marks.append({'x': ox, 'y': oy, 'w': len(img[0]), 'h': len(img), 'label': title,
                      'text': 'map ${:02X}, {} x {} blocks'.format(m, info[m]['W'], info[m]['H']),
                      'link': label, 'linkText': 'the map'})
    colors = [c for p in pals for c in sgb[p][1]]
    import build as engine
    return [{
        'name': 'Kanto', 'type': 'image', 'group': 'maps', 'title': 'Kanto',
        'subtitle': '{} outdoor maps put together, {} x {} pixels'.format(len(pos), W, H),
        'source': 'map headers from {} (pointers) and {} (banks), each map\'s connections in its header'.format(
            engine.fmt_rom(game.at('MapHeaderPointers')), engine.fmt_rom(game.at('MapHeaderBanks'))),
        'width': W, 'height': H, 'pixels': ctx.packed_pixels(canvas), 'packed': 'zlib', 'scale': 0.5, 'scroll': True,
        'marks': marks, 'listMarks': True, 'colors': colors,
        'doc': ['The whole region in one picture: every town and route (the maps with the outdoor tilesets) joined '
                'the way the game joins them while you walk. Each map header lists up to four connections (north, '
                'south, west, east); a connection copies a 3-block strip of the neighbour into the border around the '
                'current map in wOverworldMap, and where that strip comes from and goes to says how the neighbour '
                'is shifted along the edge. Starting at Pallet Town and following them all gives every outdoor map '
                'its place. Click a map to open it.',
                'Places reached only through a gate house, a cave or by Surf across a gap without a connection stand '
                'where their own connections put them; the colours are each map\'s Super Game Boy palette (pick '
                '"colour").' + (' {} connection pair{} disagree{} with the placement.'.format(
                    len(clashes), '' if len(clashes) == 1 else 's', 's' if len(clashes) == 1 else '') if clashes else '')],
        'users': ['LoadMapHeader', 'LoadTileBlockMapData'],
    }]
