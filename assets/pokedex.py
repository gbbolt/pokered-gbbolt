"""The Pokedex: a sheet per Pokemon with everything the ROM knows about it - its pictures and
cry, base stats, types, catch rate, the Pokedex entry, evolutions, the moves it learns by level
and by TM / HM, and where it lives in the wild. Every value is read from the game's tables."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pkdata import Game, GROWTH, ENCOUNTER_CHANCE, pal_name  # noqa: E402

GROUP = 'pokédex'


PAL_PIXELS = 'AAECAw=='              # a 4 x 1 picture of the colours 0, 1, 2, 3


def card_name(dex, name):
    return 'Dex{:03d}_{}'.format(dex, ''.join(ch for ch in name.title() if ch.isalnum()))


def build(ctx):
    g = Game(ctx)
    species = g.species()
    names = {s['internal']: s for s in species}
    card_of = {s['internal']: card_name(s['dex'], s['name']) for s in species}

    # where each species lives: map id, grass / water, levels, chance
    wild = {}
    for m, (got, label) in g.wild().items():
        for where, (rate, slots) in got.items():
            for k, (lvl, sp) in enumerate(slots):
                w = wild.setdefault(sp, {}).setdefault((m, where), {'levels': set(), 'chance': 0, 'rate': rate, 'label': label})
                w['levels'].add(lvl)
                w['chance'] += ENCOUNTER_CHANCE[k]
    # who evolves into whom (for "evolves from")
    evo_from = {}
    evos_of = {}
    for s in species:
        evos, learn = g.evos_moves(s['internal'])
        evos_of[s['internal']] = (evos, learn)
        for e in evos:
            evo_from.setdefault(e['into'], []).append((s['internal'], e))

    def mon_cell(internal):
        s = names.get(internal)
        return {'asset': card_of[internal], 'text': g.nice(s['name'])} if s else 'species ${:02X}'.format(internal)

    def move_cell(m):
        return {'asset': 'MovesTable@m{}'.format(m), 'text': g.nice(g.move_name(m))}    # its row of the moves sheet

    def evo_text(e):
        if e['how'] == 'item':
            return 'with a {}'.format(g.nice(g.item_name(e['item'])))
        if e['how'] == 'trade':
            return 'when traded'
        return 'at level {}'.format(e['level'])

    out = []
    for s in species:
        i, dex = s['internal'], s['dex']
        b = g.base_stats(dex)
        bank = g.pic_bank(i)
        front, back = g.label_at(g.lin(bank, b['front'])), g.label_at(g.lin(bank, b['back']))
        entry = g.dex_entry(i)
        evos, learn = evos_of[i]
        evo_addr = g.lin(g.bank('EvosMovesPointerTable'), g.word(g.at('EvosMovesPointerTable') + 2 * (i - 1)))
        types = [b['types'][0]] + ([b['types'][1]] if b['types'][1] != b['types'][0] else [])
        name = g.nice(s['name'])
        total = b['hp'] + b['atk'] + b['def'] + b['spd'] + b['spc']
        level_rows = [[lvl, move_cell(m), g.type_cell(g.move(m)['type']), g.move(m)['power'] or '—',
                       '{}%'.format(g.move(m)['acc']), g.move(m)['pp']] for lvl, m in
                      [(1, m) for m in b['moves']] + learn]
        tm_chips = [[g.tm_label(n) + ' ', move_cell(g.tm_move(n))] for n in b['tmhm']]
        evo_rows = [['from', mon_cell(f), evo_text(e)] for f, e in evo_from.get(i, [])]
        evo_rows += [['into', mon_cell(e['into']), evo_text(e)] for e in evos]
        wild_rows = []
        for (m, where), w in sorted(wild.get(i, {}).items()):
            lv = sorted(w['levels'])
            blocks = g.map_blocks_label(m)
            wild_rows.append([{'asset': blocks, 'text': g.map_name(m)} if blocks else g.map_name(m), where,
                              'Lv {}'.format(lv[0] if len(lv) == 1 else '{}–{}'.format(lv[0], lv[-1])),
                              '{}% of encounters'.format(round(100 * w['chance'] / 256))])
        out.append({
            'name': card_name(dex, s['name']), 'type': 'card', 'group': 'pokédex', 'unit': entry['label'],
            'title': '#{:03d} {}'.format(dex, name),
            'subtitle': ' / '.join(g.type_name(t) for t in types),
            'images': [{'asset': x, 'colors': True} for x in (front, back) if x],
            'source': 'base stats at {}, Pokédex entry at {}, cry data at {}, evolutions and moves at {}'.format(
                ctx_fmt(b['addr']), ctx_fmt(entry['addr']), ctx_fmt(g.at('CryData') + 3 * (i - 1)), ctx_fmt(evo_addr)),
            'sound': 'cries {}'.format(dex), 'soundText': 'cry',
            'sections': [
                {'title': 'Pokédex', 'fields': [
                    ['number', '#{:03d} (species ${:02X} inside the game)'.format(dex, i)],
                    ['species', '{} Pokémon'.format(g.nice(entry['kind']))],
                    ['type', [g.type_cell(t) for t in types]],
                    ['height', '{}′{:02d}″'.format(entry['feet'], entry['inches'])],
                    ['weight', '{} lb'.format(entry['weight'])],
                    ['colours', [{'asset': 'PaletteSheet@pal{}'.format(g.mon_palette(dex)),
                                  'text': pal_name(g.sgb_palettes()[g.mon_palette(dex)][0])}] +
                     [{'image': {'width': 4, 'height': 1, 'pixels': PAL_PIXELS, 'scale': 10, 'fixedColors': True,
                                 'colors': g.sgb_palettes()[g.mon_palette(dex)][1]}}]],
                ]},
                {'title': 'Base stats (total {})'.format(total), 'bars': [
                    ['HP', b['hp'], 255], ['Attack', b['atk'], 255], ['Defense', b['def'], 255],
                    ['Speed', b['spd'], 255], ['Special', b['spc'], 255]]},
                {'title': 'Entry', 'text': [entry['text'] or '—']},
                {'title': 'Training', 'fields': [
                    ['catch rate', '{} of 255 (higher is easier)'.format(b['catch'])],
                    ['base experience', b['exp']],
                    ['growth rate', GROWTH.get(b['growth'], b['growth'])],
                ]},
                {'title': 'Evolution', 'columns': ['', 'Pokémon', 'how'], 'rows': evo_rows, 'empty': 'does not evolve'},
                {'title': 'Wild', 'columns': ['map', 'where', 'levels', 'chance'], 'rows': wild_rows,
                 'empty': 'not found in the wild'},
                {'title': 'Moves by level', 'columns': ['Lv', 'move', 'type', 'power', 'accuracy', 'PP'],
                 'rows': level_rows, 'wide': True},
                {'title': 'TM / HM ({})'.format(len(b['tmhm'])), 'chips': tm_chips, 'wide': True},
            ],
            'doc': ['{}: base stats at {} in {}, pictures {} and {} (bank ${:02X}), evolutions and level-up moves '
                    'from EvosMovesPointerTable, the entry from PokedexEntryPointers, the cry from CryData, the '
                    'wild encounters from WildDataPointers.'.format(
                        name, ctx_fmt(b['addr']), 'MewBaseStats' if dex == 151 else 'BaseStats', front, back, bank)],
            'users': ['GetMonHeader', 'UncompressMonSprite', 'GetCryData', 'ShowPokedexDataInternal'],
        })
    return out


def ctx_fmt(a):
    import build as engine
    return engine.fmt_rom(a)
