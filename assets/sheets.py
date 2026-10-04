"""Reference sheets read from the game's tables: every move, the type chart, the items and
their prices, the trainer classes with their parties, and the wild Pokemon of each map."""
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pkdata import Game, ENCOUNTER_CHANCE, TYPE_COLOR, trainer_card  # noqa: E402
from pokedex import card_name  # noqa: E402

GROUP = 'sheets'


def effect_text(n, name):
    """POISON_SIDE_EFFECT1 -> 'poison side effect 1'; plain effects lose the word 'effect'."""
    if n == 0:
        return '—'
    m = re.match(r'(\w+)_SIDE_EFFECT([12])$', name)
    if m:
        return '{} side effect {}'.format(m.group(1).lower(), m.group(2))
    return re.sub(r'(^| )effect( |$)', ' ', name.replace('_', ' ').lower()).strip()


def F(a):
    import build as engine
    return engine.fmt_rom(a)


def bcd(bs):
    return int(''.join('{:02X}'.format(b) for b in bs))


def build(ctx):
    g = Game(ctx)
    species = g.species()
    card_of = {s['internal']: card_name(s['dex'], s['name']) for s in species}

    def mon(i):
        s = g.by_internal.get(i)
        return {'asset': card_of[i], 'text': g.nice(s['name'])} if s else 'species ${:02X}'.format(i)

    # move effects: the names of the effect constants
    effects = {}
    for k, v in ctx.project.parsed.consts.items():
        if re.search(r'EFFECT(\d|_[0-9A-F]{2})?$', k) and isinstance(v, int) and v < 0x60:
            effects.setdefault(v, k)
    out = []

    # ---- moves (and who learns them)
    learners = {}
    for s in species:
        b = g.base_stats(s['dex'])
        evos, learn = g.evos_moves(s['internal'])
        for m in b['moves']:
            learners.setdefault(m, set()).add(s['internal'])
        for _, m in learn:
            learners.setdefault(m, set()).add(s['internal'])
    tm_of = {g.tm_move(n): g.tm_label(n) for n in range(1, 56)}

    def effect_cell(n):
        """The effect's name, linked to its handler in MoveEffectPointerTable (effect 1 first; $0000 = none)."""
        text = effect_text(n, effects.get(n, '${:02X}'.format(n)))
        if n == 0:
            return text
        ptr = g.word(g.at('MoveEffectPointerTable') + 2 * (n - 1))
        handler = g.label_at(g.lin(g.bank('MoveEffectPointerTable') if ptr >= 0x4000 else 0, ptr)) if ptr else None
        return {'code': handler, 'text': text} if handler else text

    rows = []
    for m in range(1, 166):
        mv = g.move(m)
        anim, has_frames = g.move_anim(m)
        rows.append([m, g.nice(mv['name']), g.type_cell(mv['type']), mv['power'] or '—', '{}%'.format(mv['acc']),
                     mv['pp'], effect_cell(mv['effect']), tm_of.get(m, ''), len(learners.get(m, ())),
                     {'asset': 'Anim_' + anim, 'text': 'frames'} if anim and has_frames else ''])
    out.append({'name': 'MovesTable', 'unit': 'Moves', 'type': 'card', 'group': 'sheets', 'title': 'Moves',
                'subtitle': '165 moves', 'source': 'moves at {}, names at {}, TM list at {}'.format(F(g.at('Moves')), F(g.at('MoveNames')), F(g.at('TechnicalMachines'))), 'summary': '165 moves: type, power, accuracy, PP, effect',
                'sections': [{'columns': ['#', 'move', 'type', 'power', 'accuracy', 'PP', 'effect', 'TM', 'learned by', 'animation'],
                              'rows': rows, 'wide': True, 'ids': ['m{}'.format(m) for m in range(1, 166)]}],
                'doc': ['Every move from Moves (6 bytes each: animation, effect, power, type, accuracy out of 255, PP) '
                        'with its name from MoveNames. "learned by" counts the Pokémon that learn it by level '
                        '(EvosMovesPointerTable) or know it from the start (base stats).'],
                'users': ['GetMoveName', 'ReadMove']})

    # ---- the type chart: TypeEffects lists (attacker, defender, x10) until $FF
    a = g.at('TypeEffects')
    chart = {}
    while g.rom[a] != 0xFF:
        chart[(g.rom[a], g.rom[a + 1])] = g.rom[a + 2]
        a += 3
    types, seen = [], set()
    for t in range(0x1B):                      # unused type numbers reuse a name: keep the first of each
        n = g.type_name(t)
        if n in TYPE_COLOR and n != 'BIRD' and n not in seen:
            seen.add(n)
            types.append(t)
    tone = {20: ('×2', 'pos'), 5: ('½', 'neg'), 0: ('0', 'zero')}
    rows = []
    for at in types:
        row = [g.type_cell(at)]
        for df in types:
            v = chart.get((at, df))
            row.append({'text': tone[v][0], 'tone': tone[v][1]} if v in tone else '')
        rows.append(row)
    out.append({'name': 'TypeChart', 'unit': 'TypeEffects', 'type': 'card', 'group': 'sheets', 'title': 'Type chart',
                'subtitle': '{} matchups'.format(len(chart)), 'source': 'TypeEffects at {}'.format(F(g.at('TypeEffects'))), 'summary': 'attacking type (rows) against defending type (columns)',
                'sections': [{'title': 'attacker ↓   defender →', 'columns': [''] + [g.type_name(t)[:3] for t in types],
                              'rows': rows, 'wide': True}],
                'doc': ['TypeEffects: a list of (attacking type, defending type, damage x10) entries ended by $FF; '
                        'every pair not listed does normal damage. AdjustDamageForMoveType walks it once per type '
                        'of the defender, so a double weakness multiplies to x4.'],
                'users': ['AdjustDamageForMoveType', 'AIGetTypeEffectiveness']})

    # ---- items and prices (3-byte BCD)
    # where each item lies: item balls (the object data) and hidden items, map by map
    objects = g.map_objects()
    found = {}
    for m in sorted(objects):
        for o in objects[m]:
            if o['kind'] in ('item', 'hidden_item'):
                lst = found.setdefault(o['item'], [])
                cell = {'asset': g.map_blocks_label(m), 'text': g.map_name(m) + (' (hidden)' if o['kind'] == 'hidden_item' else '')}
                if cell['asset'] and cell not in lst:
                    lst.append(cell)

    def found_cell(i):
        lst = found.get(i, [])
        return [x for k, c in enumerate(lst) for x in ([c] if k == 0 else ['·', c])]

    prices = g.at('ItemPrices')
    rows, ids = [], []
    for i in range(1, 0x54):
        name = g.item_name(i)
        p = bcd(g.rom[prices + 3 * (i - 1): prices + 3 * i])
        rows.append(['${:02X}'.format(i), g.nice(name), '₽{}'.format(p) if p else '—', found_cell(i)])
        ids.append('i{}'.format(i))
    for i in list(range(0xC4, 0xC9)) + list(range(0xC9, 0xC9 + 50)):    # HM01-05, TM01-50: named by number
        n = i - 0xC3 if i < 0xC9 else i - 0xC8
        mv = g.tm_move(n if i >= 0xC9 else 50 + n)
        rows.append(['${:02X}'.format(i), [g.item_name(i), {'asset': 'MovesTable@m{}'.format(mv), 'text': g.nice(g.move_name(mv))}],
                     '', found_cell(i)])
        ids.append('i{}'.format(i))
    out.append({'name': 'ItemsTable', 'unit': 'ItemPrices', 'type': 'card', 'group': 'sheets', 'title': 'Items',
                'subtitle': '{} items, {} TMs and HMs'.format(0x53, 55), 'source': 'names at {}, prices at {}'.format(F(g.at('ItemNames')), F(prices)), 'summary': 'names, shop prices and where they lie',
                'sections': [{'columns': ['id', 'item', 'price', 'found on'], 'rows': rows, 'wide': True, 'ids': ids}],
                'doc': ['ItemNames (names ended by "@") and ItemPrices (3 bytes of BCD per item; a mart sells at '
                        'this price and buys back at half). TMs and HMs ($C4 and up) take their names from their number '
                        '(TechnicalMachines gives the move). "found on" lists the maps with an item ball of it (the '
                        "maps' object data) or a hidden one (HiddenEventPointers)."],
                'users': ['GetItemName', 'GetItemPrice']})

    # ---- trainer classes and their parties
    names = g.strings('TrainerNames', 47)
    dp, bank = g.at('TrainerDataPointers'), g.bank('TrainerDataPointers')
    pics = g.at('TrainerPicAndMoneyPointers')
    pic_bank = g.bank('YoungsterPic') if 'YoungsterPic' in g.syms else bank
    starts = [g.lin(bank, g.word(dp + 2 * c)) for c in range(47)]
    fought = {}                                # (class, party) -> the maps where that trainer stands
    for m in sorted(objects):
        for o in objects[m]:
            blocks = g.map_blocks_label(m)
            if o['kind'] == 'trainer' and blocks:
                lst = fought.setdefault((o['cls'], o['party']), [])
                cell = {'asset': blocks, 'text': g.map_name(m)}
                if cell not in lst:
                    lst.append(cell if not lst else ['·', cell])

    for c in range(47):
        a, end = starts[c], min([s for s in starts if s > starts[c]] or [starts[c] + 400])
        parties = []
        while a < end and len(parties) < 64:
            first = g.rom[a]
            a += 1
            team = []
            if first == 0xFF:                      # (level, species) pairs
                while g.rom[a]:
                    team.append((g.rom[a], g.rom[a + 1]))
                    a += 2
            else:                                  # one level for all
                while g.rom[a]:
                    team.append((first, g.rom[a]))
                    a += 1
            a += 1
            parties.append(team)
        pic = g.label_at(g.lin(pic_bank, g.word(pics + 5 * c)))
        money = bcd(g.rom[pics + 5 * c + 2: pics + 5 * c + 5])
        rows = [[k + 1, [[mon(sp), ' Lv{} '.format(lv)] for lv, sp in team], fought.get((c + 1, k + 1), '')]
                for k, team in enumerate(parties)]
        title = g.nice(names[c])
        out.append({'name': trainer_card(c + 1, names[c]), 'type': 'card', 'unit': g.label_at(starts[c]),
                    'group': 'trainers', 'title': title, 'subtitle': '{} part{}'.format(len(parties), 'y' if len(parties) == 1 else 'ies'),
                    'source': 'parties at {}, picture and prize money at {}'.format(F(starts[c]), F(pics + 5 * c)),
                    'images': [pic] if pic else [], 'summary': title,
                    'sections': [{'title': 'Prize money', 'fields': [['base', '₽{} × the level of the last Pokémon'.format(money // 100)]]},
                                 {'title': 'Parties', 'columns': ['#', 'Pokémon and level', 'fought on'], 'rows': rows, 'wide': True,
                                  'ids': ['p{}'.format(k + 1) for k in range(len(rows))]}],
                    'doc': ['Trainer class {} ({}): picture and prize money from TrainerPicAndMoneyPointers, parties '
                            'from TrainerDataPointers - a party is either a level and Pokémon ended by 0, or $FF and '
                            '(level, Pokémon) pairs ended by 0.'.format(c + 1, names[c])],
                    'users': ['ReadTrainer']})

    # ---- wild Pokemon per map
    sections = []
    for m, (got, label) in sorted(g.wild().items()):
        blocks = g.map_blocks_label(m)
        for where, (rate, slots) in got.items():
            rows = [[k + 1, 'Lv {}'.format(lv), mon(sp), '{}%'.format(round(100 * ENCOUNTER_CHANCE[k] / 256, 1))]
                    for k, (lv, sp) in enumerate(slots)]
            sections.append({'title': '{} - {} (rate {})'.format(g.map_name(m), where, rate),
                             'columns': ['slot', 'level', 'Pokémon', 'chance'], 'rows': rows,
                             'ids': ['w{}-{}'.format(m, where)]})      # the map's marks link here
    out.append({'name': 'WildEncounters', 'unit': 'WildDataPointers', 'type': 'card', 'group': 'sheets', 'title': 'Wild Pokémon',
                'subtitle': '{} tables'.format(len(sections)), 'source': 'WildDataPointers at {}'.format(F(g.at('WildDataPointers'))), 'summary': 'the encounter tables of every map',
                'sections': sections,
                'doc': ['WildDataPointers: per map a grass rate (the chance per step of an encounter, out of 256) '
                        'with 10 slots of (level, Pokémon), then the same for water. TryDoWildEncounter picks a '
                        'slot with a random number: the first slots are far more likely (51, 51, 39, 25, 25, 25, '
                        '13, 13, 11 and 3 out of 256).'],
                'users': ['TryDoWildEncounter', 'LoadWildData']})
    return out
