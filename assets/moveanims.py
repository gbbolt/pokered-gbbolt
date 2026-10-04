"""The battle animations as frame sheets: every frame an animation shows, side by side, drawn from the game's own
animation data. AttackAnimationPointers gives each move (and the other battle animations after them) a list of
commands: a subanimation with its tileset and frame delay, or a special effect (shaking the screen, flashing a
picture, ...). A subanimation is a list of frame blocks (groups of sprites) placed at base coordinates, with a mode
that says whether the sprites stay for the next block. The frames are as on the player's turn."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import _pk  # noqa: E402
import build as engine  # noqa: E402
from _pkdata import Game  # noqa: E402

GROUP = 'move animations'
FW, FH = 160, 112                    # a frame: the battle screen above the text box
PER_ROW = 6


def F(a):
    return engine.fmt_rom(a)


def anim_name(label):
    """'KarateChopAnim' -> 'Karate Chop'."""
    n = label[:-4] if label.endswith('Anim') else label
    return _pk.spaced(n)


def build(ctx):
    g = Game(ctx)
    rom = g.rom
    consts = ctx.project.parsed.consts
    n_anims = consts.get('NUM_ATTACK_ANIMS', 0xCA)
    n_moves = consts.get('NUM_ATTACKS', 0xA5)
    first_se = consts.get('FIRST_SE_ID', 0xC0)
    se_names = {v: k[3:].replace('_', ' ').lower() for k, v in consts.items() if k.startswith('SE_') and isinstance(v, int)}
    fb_names = {v: k for k, v in consts.items() if k.startswith('FRAMEBLOCKMODE_') and isinstance(v, int)}
    ptrs, bank = g.at('AttackAnimationPointers'), g.bank('AttackAnimationPointers')
    sub_ptrs, sub_bank = g.at('SubanimationPointers'), g.bank('SubanimationPointers')
    fb_ptrs, fb_bank = g.at('FrameBlockPointers'), g.bank('FrameBlockPointers')
    coords = g.at('FrameBlockBaseCoords')
    tset_ptrs = g.at('MoveAnimationTilesPointers')
    tile_bank = g.bank('MoveAnimationTiles0')
    tilesets = []
    for t in range(3):
        n, p = rom[tset_ptrs + 4 * t], g.word(tset_ptrs + 4 * t + 1)
        base = g.lin(tile_bank, p)
        tilesets.append((base, n, [_pk.tile_rows(rom, base + 16 * k) for k in range(n)]))

    def frame_block(num):
        a = g.lin(fb_bank, g.word(fb_ptrs + 2 * num))
        n = rom[a]
        return a, [tuple(rom[a + 1 + 4 * k: a + 5 + 4 * k]) for k in range(n)]

    def draw(frame, sprites, tiles):
        for y, x, t, fl in sprites:
            sy, sx = y - 16, x - 8
            if t - 0x31 < 0 or t - 0x31 >= len(tiles):
                continue
            px = tiles[t - 0x31]
            for ty in range(8):
                yy = sy + ty
                if not 0 <= yy < FH:
                    continue
                r = px[7 - ty] if fl & 0x40 else px[ty]
                for tx in range(8):
                    xx = sx + tx
                    if 0 <= xx < FW:
                        c = r[7 - tx] if fl & 0x20 else r[tx]
                        if c:
                            frame[yy][xx] = c

    out = []
    seen = {}
    move_anim = {}
    for i in range(n_anims):
        a = g.lin(bank, g.word(ptrs + 2 * i))
        label = g.label_at(a) or 'Anim{}'.format(i + 1)
        if i < n_moves:
            move_anim[i + 1] = label
        if a in seen:
            seen[a]['ids'].append(i + 1)
            continue
        info = {'ids': [i + 1]}
        seen[a] = info
        frames, marks, steps = [], [], []
        k = a
        while rom[k] != 0xFF and k < a + 200:
            b = rom[k]
            if b >= first_se:                            # a special effect and its sound
                steps.append('effect: {}'.format(se_names.get(b, '${:02X}'.format(b))))
                marks.append({'x': 0, 'y': 0, 'w': 0, 'h': 0, 'label': 'effect',
                              'text': se_names.get(b, '${:02X}'.format(b))})
                k += 2
                continue
            tset, delay, sub = b >> 6, b & 0x3F, rom[k + 2]
            k += 3
            sa = g.lin(sub_bank, g.word(sub_ptrs + 2 * sub))
            sub_label = g.label_at(sa) or 'subanimation {}'.format(sub)
            head = rom[sa]
            count, kind = head & 0x1F, head >> 5
            transform = 2 if kind == 5 else 0               # the player's turn: an "enemy" one is mirrored
            tiles = tilesets[min(tset, 2)][2]
            steps.append('{} (tileset {}, {} frame{} each)'.format(sub_label, tset, delay, '' if delay == 1 else 's'))
            oam, dest = [], 0
            for e in range(count):
                fbn, bc, mode = rom[sa + 1 + 3 * e: sa + 4 + 3 * e]
                by, bx = rom[coords + 2 * bc], rom[coords + 2 * bc + 1]
                fa, spr = frame_block(fbn)
                placed = []
                for y, x, t, fl in spr:
                    if transform == 2:                       # mirrored left-right and moved down
                        placed.append(((by + y + 40) & 0xFF, (168 - (bx + x)) & 0xFF, t + 0x31 & 0xFF, fl ^ 0x20))
                    else:
                        placed.append(((by + y) & 0xFF, (bx + x) & 0xFF, t + 0x31 & 0xFF, fl))
                oam[dest:dest + len(placed)] = placed
                if mode == 2:                                # no wait: drawn together with the next block
                    dest += len(placed)
                    continue
                frame = [bytearray(FW) for _ in range(FH)]
                draw(frame, oam, tiles)
                n = len(frames)
                frames.append(frame)
                marks.append({'x': (n % PER_ROW) * (FW + 4), 'y': (n // PER_ROW) * (FH + 4), 'w': FW, 'h': FH,
                              'label': 'frame {}'.format(n + 1),
                              'text': '{}: frame block {} ({}) at base {} (x {}, y {}), {}, shown {} frame{}'.format(
                                  sub_label, fbn, g.label_at(fa) or '', bc, bx, by,
                                  fb_names.get(mode, 'mode {}'.format(mode)).replace('FRAMEBLOCKMODE_', 'mode '),
                                  delay, '' if delay == 1 else 's')})
                if mode == 3:
                    dest += len(placed)
                elif mode != 4:
                    oam, dest = [], 0
        if not frames:
            continue
        rows = (len(frames) + PER_ROW - 1) // PER_ROW
        cols = min(PER_ROW, len(frames))
        W, H = cols * (FW + 4) - 4, rows * (FH + 4) - 4
        img = [bytearray([255]) * W for _ in range(H)]
        for fr in frames:                                # where the two Pokemon pictures are, dotted
            for (x0, y0, x1, y1) in ((8, 40, 63, 95), (96, 0, 151, 55)):
                for x in range(x0, x1 + 1, 2):
                    for y in (y0, y1):
                        if not fr[y][x]:
                            fr[y][x] = 1
                for y in range(y0, y1 + 1, 2):
                    for x in (x0, x1):
                        if not fr[y][x]:
                            fr[y][x] = 1
        for n, fr in enumerate(frames):
            ox, oy = (n % PER_ROW) * (FW + 4), (n // PER_ROW) * (FH + 4)
            for y in range(FH):
                img[oy + y][ox:ox + FW] = fr[y]
        info.update({'label': label, 'addr': a, 'img': img, 'W': W, 'H': H, 'marks': marks, 'steps': steps,
                     'frames': len(frames)})
    for a, info in seen.items():
        if 'img' not in info:
            continue
        ids = info['ids']
        moves = [m for m in ids if m <= n_moves]
        title = ' / '.join(g.nice(g.move_name(m)) for m in moves) if moves else anim_name(info['label'])
        out.append({
            'name': 'Anim_' + info['label'], 'unit': info['label'], 'type': 'image', 'title': title,
            'subtitle': '{} frame{}'.format(info['frames'], '' if info['frames'] == 1 else 's'),
            'source': 'animation at {}, subanimations through {}, frame blocks through {}, tiles at {}'.format(
                F(a), F(sub_ptrs), F(fb_ptrs), F(tilesets[0][0])),
            'width': info['W'], 'height': info['H'], 'pixels': ctx.packed_pixels(info['img']), 'packed': 'zlib',
            'scale': 2 if info['W'] <= 700 else 1, 'scroll': True, 'marks': info['marks'], 'listMarks': True,
            'link': None,
            'doc': ['{}: animation {} of AttackAnimationPointers{}. Its commands: {}.'.format(
                        info['label'], ', '.join(str(x) for x in ids),
                        ' (the move{} {})'.format('s' if len(moves) > 1 else '', ', '.join(g.nice(g.move_name(m)) for m in moves))
                        if moves else '', '; '.join(info['steps'])),
                    'Each picture is one frame the animation holds on screen: the sprites of the frame blocks drawn so '
                    'far (mode 2 blocks are drawn together with the next one, mode 3 and 4 blocks stay, the others are '
                    'cleared after their frames). The sprites use the battle animation tiles loaded at tile $31; '
                    'the special effects (screen shakes, flashes, ...) are listed under the frames. The dotted boxes '
                    'are where the player\'s Pokémon (left) and the opponent (right) stand.'],
            'users': ['PlayAnimation', 'PlaySubanimation', 'DrawFrameBlock', 'LoadMoveAnimationTiles'],
        })
    return out
