"""More reference sheets read from the game's tables and scripts: the marts, the in-game trades, the Game Corner
prizes, the Pokemon you are given or meet standing on a map, fishing, the evolution families, the growth rates,
which Pokemon learn which TM / HM, the badges, the character set and the credits."""
import bisect
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import _pk  # noqa: E402
import build as engine  # noqa: E402
from _pkdata import Game, GROWTH  # noqa: E402
from pokedex import card_name  # noqa: E402

GROUP = 'sheets'


def F(a):
    return engine.fmt_rom(a)


def bcd(bs):
    return int(''.join('{:02X}'.format(b) for b in bs))


def build(ctx):
    g = Game(ctx)
    species = g.species()
    rom = g.rom
    consts = ctx.project.parsed.consts
    out = []

    def mon(i, text=None):
        s = g.by_internal.get(i)
        return {'asset': card_name(s['dex'], s['name']), 'text': text or g.nice(s['name'])} if s else 'species ${:02X}'.format(i)

    def item(i):
        name = g.nice(g.item_name(i))
        return {'asset': 'ItemsTable@i{}'.format(i), 'text': name} if 1 <= i <= 0x53 or i >= 0xC4 else name

    def move(m):
        return {'asset': 'MovesTable@m{}'.format(m), 'text': g.nice(g.move_name(m))}

    # ---- maps by header label, and which map a piece of script belongs to (its folder: scripts/<Map>)
    map_of_label = {}
    for m in range(0xF8):
        lab = g.map_label(m)
        if lab.endswith('_h'):
            map_of_label.setdefault(lab[:-2], m)

    def map_cell(m):
        lab = g.map_blocks_label(m)
        return {'asset': lab, 'text': g.map_name(m)} if lab else g.map_name(m)

    units = sorted((u for u in ctx.project.parsed.units if u.start is not None and u.end), key=lambda u: u.start)
    starts = [u.start for u in units]

    def unit_at(a):
        i = bisect.bisect_right(starts, a) - 1
        return units[i] if i >= 0 and units[i].start <= a < units[i].end else None

    def map_at(a):
        u = unit_at(a)
        if not u:
            return None
        for part in reversed((u.path or '').split('/')):
            if part in map_of_label:
                return map_of_label[part]
        for k in sorted(map_of_label, key=len, reverse=True):         # TextLabels start with the map's name
            if u.name.startswith(k):
                return map_of_label[k]
        return None

    def find(pattern):
        """Every ROM address where the byte pattern occurs (None = any byte)."""
        first = next(b for b in pattern if b is not None)
        k0 = pattern.index(first)
        a = rom.find(bytes([first]))
        while a != -1:
            s = a - k0
            if s >= 0 and all(b is None or rom[s + k] == b for k, b in enumerate(pattern)):
                yield s
            a = rom.find(bytes([first]), a + 1)

    def word16(label):
        v = ctx.addr(label)
        return [v & 0xFF, v >> 8]

    # ======================================================================== marts
    objects_texts = {}                         # text address -> map, for the people and signs of every map
    ptrs, banks = g.at('MapHeaderPointers'), g.at('MapHeaderBanks')
    for m in range(0xF8):
        hb = rom[banks + m]
        h = g.lin(hb, g.word(ptrs + 2 * m))
        if not g.rev.get(h, '').endswith('_h'):
            continue
        tptr = g.lin(hb, g.word(h + 5))
        for t in range(1, 40):
            p = g.word(tptr + 2 * (t - 1))
            if p >= 0x8000:
                break
            objects_texts.setdefault(g.lin(hb, p) if p >= 0x4000 else p, m)
    marts = []
    for a, m in sorted(objects_texts.items(), key=lambda x: x[1]):
        if rom[a] != 0xFE:
            continue
        n = rom[a + 1]
        items = list(rom[a + 2:a + 2 + n])
        if rom[a + 2 + n] != 0xFF:
            continue
        marts.append((m, a, items))
    prices = g.at('ItemPrices')

    def price(i):
        return bcd(rom[prices + 3 * (i - 1): prices + 3 * i]) if 1 <= i <= 0x53 else 0

    def tm_price(i):
        """TechnicalMachinePrices: one nibble per TM (thousands of ₽), two TMs per byte, high nibble first."""
        n = i - 0xC9
        b = rom[g.at('TechnicalMachinePrices') + n // 2]
        return 1000 * ((b >> 4) if n % 2 == 0 else (b & 0xF))
    sections = []
    for m, a, items in marts:
        rows = [[item(i), '₽{}'.format(tm_price(i) if i >= 0xC9 and 'TechnicalMachinePrices' in g.syms else price(i))]
                for i in items]
        same = [x for x in marts if x[0] == m]
        title = g.map_name(m) + (' (clerk {})'.format(same.index((m, a, items)) + 1) if len(same) > 1 else '')
        sections.append({'title': title, 'columns': ['item', 'price'], 'rows': rows,
                         'ids': ['mart{}'.format(m)]})
        sections[-1]['rows'].insert(0, [{'text': 'at', 'tone': 'muted'}, map_cell(m)])
    out.append({'name': 'MartsSheet', 'type': 'card', 'title': 'Marts', 'unit': g.label_at(marts[0][1]) if marts else None,
                'subtitle': '{} marts'.format(len(marts)), 'summary': 'what each Poké Mart sells, and for how much',
                'source': 'the clerks\' texts ({} to {}), prices at {}'.format(
                    F(marts[0][1]), F(marts[-1][1]), F(prices)) if marts else '',
                'sections': sections,
                'doc': ['A mart is a text of its clerk: the byte $FE (the text engine hands it to the mart), the number '
                        'of items, the item numbers and $FF. The clerks were found through the text pointers of '
                        'every map; the prices come from ItemPrices (3 BCD bytes each) and, for TMs, from '
                        'TechnicalMachinePrices (a nibble per TM, in thousands). A mart buys back at half price.'],
                'users': ['DisplayPokemartDialogue', 'GetItemPrice']})

    # ======================================================================== in-game trades
    n_trades = consts.get('NUM_NPC_TRADES', 10)
    dialog = {v: k[len('TRADE_DIALOGSET_'):].lower() for k, v in consts.items()
              if k.startswith('TRADE_DIALOGSET_') and isinstance(v, int)}
    where = {}
    if 'wWhichTrade' in ctx.vars:
        tgt = word16('wWhichTrade')
        for a in find([0xEA] + tgt):           # in a map's script: ld a, trade (or xor a); ld [wWhichTrade], a
            u = unit_at(a)
            if not u or not (u.path or '').startswith('scripts/') or map_at(a) is None:
                continue
            if not (rom[a + 3] == 0x3E and rom[a + 5] == 0xCD or rom[a + 3] == 0x18):
                continue                           # then the trade predef (or a jump to it)
            if rom[a - 2] == 0x3E:
                where.setdefault(rom[a - 1], map_at(a))
            elif rom[a - 1] == 0xAF:
                where.setdefault(0, map_at(a))
    rows = []
    t0 = g.at('TradeMons')
    for k in range(n_trades):
        e = t0 + 14 * k
        give, get, dset = rom[e], rom[e + 1], rom[e + 2]
        nick = g.string(e + 3, 11)[0]
        m = where.get(k)
        rows.append([k + 1, mon(give), '→', mon(get), nick, dialog.get(dset, dset),
                     map_cell(m) if m is not None else {'text': 'nobody offers it', 'tone': 'muted'}])
    out.append({'name': 'TradesSheet', 'type': 'card', 'title': 'In-game trades', 'unit': 'TradeMons',
                'subtitle': '{} trades'.format(n_trades), 'summary': 'the Pokémon people offer in trade',
                'source': 'TradeMons at {} ({} x 14 bytes)'.format(F(t0), n_trades),
                'sections': [{'columns': ['#', 'you give', '', 'you get', 'its nickname', 'dialogue', 'where'],
                              'rows': rows, 'wide': True}],
                'doc': ['TradeMons: per trade the species asked for, the species given, which set of texts the trader '
                        'uses and the nickname of the Pokémon you get (11 bytes). Where: the script that sets '
                        'wWhichTrade before DoInGameTradeDialogue.'],
                'users': ['DoInGameTradeDialogue', 'InGameTrade_DoTrade']})

    # ======================================================================== Game Corner prizes
    sections = []
    pm = g.at('PrizeDifferentMenuPtrs')
    lv = {}
    a = g.at('PrizeMonLevelDictionary')
    while rom[a] and rom[a] != 0xFF and a < g.at('PrizeMonLevelDictionary') + 20:
        lv[rom[a]] = rom[a + 1]
        a += 2
    bank = g.bank('PrizeDifferentMenuPtrs')
    for k, title in enumerate(('Prize window 1', 'Prize window 2', 'Prize window 3')):
        ea, ca = g.lin(bank, g.word(pm + 4 * k)), g.lin(bank, g.word(pm + 4 * k + 2))
        rows = []
        for j in range(3):
            x = rom[ea + j]
            cost = bcd(rom[ca + 2 * j: ca + 2 * j + 2])
            if x >= 0xC4:                      # a TM
                n = x - 0xC8
                rows.append([item(x), move(g.tm_move(n)), '{} coins'.format(cost)])
            else:
                rows.append([mon(x), 'level {}'.format(lv.get(x, '?')), '{} coins'.format(cost)])
        sections.append({'title': title, 'columns': ['prize', '', 'price'], 'rows': rows})
    out.append({'name': 'PrizesSheet', 'type': 'card', 'title': 'Game Corner prizes', 'unit': 'PrizeDifferentMenuPtrs',
                'subtitle': '9 prizes', 'summary': 'what the Celadon prize corner gives for coins',
                'source': 'prize lists at {}, levels at {}'.format(F(pm), F(g.at('PrizeMonLevelDictionary'))),
                'sections': sections,
                'doc': ['The three prize windows of the Celadon Game Corner exchange: PrizeDifferentMenuPtrs points to '
                        'each window\'s three prizes (Pokémon or TM numbers) and their prices (2 BCD bytes, in coins); '
                        'a Pokémon comes at the level PrizeMonLevelDictionary lists for it.'],
                'users': ['CeladonPrizeMenu', 'GetPrizeMenuId']})

    # ======================================================================== gifts and Pokemon standing on maps
    rows = []
    give = word16('GivePokemon')
    for a in find([0x01, None, None, 0xCD] + give):            # ld bc, species << 8 | level; call GivePokemon
        m = map_at(a)
        rows.append([mon(rom[a + 2]), 'level {}'.format(rom[a + 1]), 'given', map_cell(m) if m is not None else '?', F(a)])
    for a in find([0x0E, None, 0xCD] + give):                   # ld c, level (species chosen before)
        if rom[a - 1] == 0x47:                                  # ld b, a
            m = map_at(a)
            choice = ''
            if m is not None:
                kinds = [o for o in g.map_objects().get(m, []) if o['kind'] == 'mon']
            u = unit_at(a)
            what = 'the one you choose' if u and 'Dojo' in (u.path or u.name) else 'the one revived from your fossil' \
                if u and 'Lab' in (u.path or u.name) else 'chosen by the script' + choice
            rows.append([what, 'level {}'.format(rom[a + 1]), 'given', map_cell(m) if m is not None else '?', F(a)])
    if 'wFossilMon' in ctx.vars:                                # the fossils: ld a, species; ld [wFossilMon], a
        for a in find([0x3E, None, 0xEA] + word16('wFossilMon')):
            m = map_at(a)
            rows.append([mon(rom[a + 1]), 'level 30', 'revived from a fossil', map_cell(m) if m is not None else '?', F(a)])
    starters = [consts.get('STARTER{}'.format(k)) for k in (1, 2, 3)]
    for s in starters:
        if isinstance(s, int):
            rows.append([mon(s), 'level 5', 'starter, from Oak', map_cell(map_of_label.get('OaksLab', 0)), ''])
    for m, objs in sorted(g.map_objects().items()):
        for o in objs:
            if o['kind'] == 'mon':
                rows.append([mon(o['species']), 'level {}'.format(o['level']), 'standing on the map, to battle',
                             map_cell(m), ''])
    out.append({'name': 'GiftsSheet', 'type': 'card', 'title': 'Gift and standing Pokémon', 'unit': 'GivePokemon',
                'subtitle': '{} Pokémon'.format(len(rows)), 'summary': 'Pokémon you are given, revive, or meet on a map',
                'source': 'the scripts calling GivePokemon at {} and the maps\' object data'.format(F(g.at('GivePokemon'))),
                'sections': [{'columns': ['Pokémon', 'level', 'how', 'where', 'script at'], 'rows': rows, 'wide': True}],
                'doc': ['Found in the code: every "ld bc, species and level" followed by a call to GivePokemon (the '
                        'Eevee, the Magikarp salesman, the Lapras in Silph Co., ...), the two gifts whose species is '
                        'picked first (the Fighting Dojo\'s Hitmonlee or Hitmonchan, the Cinnabar Lab fossils, which '
                        'set wFossilMon), the three starters (STARTER1-3) and the Pokémon that stand on maps as objects '
                        'with a level (Snorlax, the Power Plant Voltorbs and Electrode, the legendary birds, Mewtwo).'],
                'users': ['GivePokemon', '_GivePokemon']})

    # ======================================================================== fishing
    a = g.at('ItemUseOldRod')
    old = next(((rom[k + 2], rom[k + 1]) for k in range(a, a + 16) if rom[k] == 0x01), None)   # ld bc, level << 8 | species
    good = [(rom[g.at('GoodRodMons') + 2 * k], rom[g.at('GoodRodMons') + 2 * k + 1]) for k in range(2)]
    rows = []
    if old:
        rows.append(['Old Rod', 'anywhere with water', [mon(old[1]), ' level {}'.format(old[0])], 'always bites'])
    rows.append(['Good Rod', 'anywhere with water', [x for lvl, sp in good for x in (mon(sp), ' level {} '.format(lvl))],
                 'half the time; one of the two'])
    sd, sb = g.at('SuperRodData'), g.bank('SuperRodData')
    k = 0
    while rom[sd + 3 * k] != 0xFF and k < 60:
        m = rom[sd + 3 * k]
        grp = g.lin(sb, g.word(sd + 3 * k + 1))
        n = rom[grp]
        fish = [(rom[grp + 1 + 2 * j], rom[grp + 2 + 2 * j]) for j in range(n)]
        rows.append(['Super Rod', map_cell(m), [x for lvl, sp in fish for x in (mon(sp), ' L{} '.format(lvl))],
                     'half the time; group at {}'.format(F(grp))])
        k += 1
    out.append({'name': 'FishingSheet', 'type': 'card', 'title': 'Fishing', 'unit': 'SuperRodData',
                'subtitle': '{} Super Rod maps'.format(k), 'summary': 'what bites on the Old, Good and Super Rod',
                'source': 'Old Rod in ItemUseOldRod at {}, Good Rod at {}, Super Rod table at {}'.format(
                    F(a), F(g.at('GoodRodMons')), F(sd)),
                'sections': [{'columns': ['rod', 'where', 'Pokémon', 'chance'], 'rows': rows, 'wide': True}],
                'doc': ['The Old Rod always hooks the same Pokémon (ItemUseOldRod loads it straight into bc). The Good '
                        'Rod gets a bite half the time and then picks one of GoodRodMons. The Super Rod looks the map '
                        'up in SuperRodData (map number, pointer to a group: a count and level / species pairs); half '
                        'the time something bites, picked at random from the group. Maps not listed have no Super Rod '
                        'fish.'],
                'users': ['ItemUseOldRod', 'ItemUseGoodRod', 'ItemUseSuperRod', 'ReadSuperRodData']})

    # ======================================================================== evolution families as trees
    evos = {s['internal']: g.evos_moves(s['internal'])[0] for s in species}
    parents = {}
    for i, lst in evos.items():
        for e in lst:
            parents.setdefault(e['into'], []).append(i)

    def how(e):
        if e['how'] == 'item':
            return [item(e['item'])]
        if e['how'] == 'trade':
            return 'trade'
        return 'level {}'.format(e['level'])
    sections = []
    for s in species:
        i = s['internal']
        if i in parents or not evos[i]:
            continue
        lines = []

        def walk(x, depth, via):
            lines.append([{'text': '│   ' * max(0, depth - 1) + ('└─ ' if depth else ''), 'tone': 'muted'},
                          mon(x), via if depth else ''])
            for e in evos.get(x, []):
                walk(e['into'], depth + 1, how(e))
        walk(i, 0, None)
        sections.append({'title': g.nice(s['name']) + ' family', 'columns': ['', 'Pokémon', 'evolves by'], 'rows': lines})
    out.append({'name': 'EvolutionSheet', 'type': 'card', 'title': 'Evolution families', 'unit': 'EvosMovesPointerTable',
                'subtitle': '{} families'.format(len(sections)), 'summary': 'who evolves into whom, and how',
                'source': 'evolution data through EvosMovesPointerTable at {}'.format(F(g.at('EvosMovesPointerTable'))),
                'sections': sections,
                'doc': ['Every Pokémon\'s entry in EvosMovesPointerTable starts with its evolutions: EVOLVE_LEVEL '
                        '(level, species), EVOLVE_ITEM (stone, level, species) or EVOLVE_TRADE (level, species), ended '
                        'by 0. Each tree starts at a Pokémon nothing evolves into; Eevee branches three ways.'],
                'users': ['EvolutionAfterBattle', 'TryEvolvingMon']})

    # ======================================================================== growth rates
    gr = g.at('GrowthRateTable')
    series, rows = [], []
    for k in range(6):
        e = gr + 4 * k
        num, den = rom[e] >> 4, rom[e] & 0xF
        c = rom[e + 1]
        c = -(c & 0x7F) if c & 0x80 else c
        d, sub = rom[e + 2], rom[e + 3]

        def xp(n):
            return max(0, num * n ** 3 // den + c * n * n + d * n - sub)
        series.append({'name': GROWTH.get(k, str(k)), 'points': [[n, xp(n)] for n in range(1, 101)],
                       'color': ['#2a6fdb', '#e08a2a', '#9b59b6', '#2a9d8f', '#d33b3b', '#6b8e23'][k]})
        formula = ('n³' if num == den else '{}/{}·n³'.format(num, den)) +             (' {} {}n²'.format('−' if c < 0 else '+', abs(c)) if c else '') +             (' + {}n'.format(d) if d else '') + (' − {}'.format(sub) if sub else '')
        users = sum(1 for s in species if g.base_stats(s['dex'])['growth'] == k)
        rows.append([GROWTH.get(k, k), formula, xp(50), xp(100), users])
    out.append({'name': 'GrowthChart', 'type': 'chart', 'kind': 'line', 'title': 'Growth rates', 'unit': 'GrowthRateTable',
                'subtitle': 'experience needed per level', 'x': 'level', 'y': 'experience points',
                'source': 'GrowthRateTable at {} (6 x 4 bytes)'.format(F(gr)), 'series': series,
                'xticks': [[n, n] for n in range(0, 101, 10)],
                'doc': ['The experience a Pokémon needs for level n, from GrowthRateTable: per growth rate a fraction a/b '
                        '(a byte of two nibbles), c (the high bit is its sign), d and e, for (a/b)·n³ + c·n² + d·n − e. '
                        'CalcExperience works it out; the base stats say which rate a Pokémon has.'] +
                       ['{}: {} — level 50 at {:,} points, level 100 at {:,} ({} Pokémon).'.format(*r) for r in rows],
                'users': ['CalcExperience', 'CalcLevelFromExperience']})

    # ======================================================================== TM / HM compatibility
    cols = [g.tm_label(n) for n in range(1, 56)]
    rows, ids = [], []
    for s in species:
        b = g.base_stats(s['dex'])
        have = set(b['tmhm'])
        rows.append([{'text': '{:03d}'.format(s['dex']), 'tone': 'muted'}, mon(s['internal'])] +
                    [{'text': '●', 'tone': 'pos'} if n in have else '' for n in range(1, 56)] + [len(have)])
        ids.append('d{}'.format(s['dex']))
    head = [[g.tm_label(n), move(g.tm_move(n))] for n in range(1, 56)]
    out.append({'name': 'TMGrid', 'type': 'card', 'title': 'TM / HM compatibility', 'unit': 'TechnicalMachines',
                'subtitle': '151 Pokémon × 55 machines', 'summary': 'which Pokémon can learn which TM and HM',
                'source': 'TM list at {}, each Pokémon\'s 7 bytes of TM / HM bits in its base stats at {}'.format(
                    F(g.at('TechnicalMachines')), F(g.at('BaseStats'))),
                'sections': [{'title': 'The machines', 'chips': head, 'wide': True},
                             {'title': 'Pokémon ↓   machine →', 'columns': ['#', 'Pokémon'] + [c[:2] + c[2:] for c in cols] + ['Σ'],
                              'rows': rows, 'ids': ids, 'wide': True}],
                'doc': ['Bytes 20-26 of each Pokémon\'s base stats are 56 bits, one per machine: TM01-TM50, then '
                        'HM01-HM05 (bit 0 of the first byte is TM01). CanLearnTM tests the bit; TechnicalMachines gives '
                        'the move of each machine.'],
                'users': ['CanLearnTM', 'TMToMove']})

    # ======================================================================== badges
    tiles = g.at('GymLeaderFaceAndBadgeTileGraphics')

    def pic2x2(t0):
        img = [[0] * 16 for _ in range(16)]
        for k in range(4):
            px = _pk.tile_rows(rom, tiles + 16 * (t0 + k))
            for y in range(8):
                img[(k >> 1) * 8 + y][(k & 1) * 8:(k & 1) * 8 + 8] = px[y]
        return {'width': 16, 'height': 16, 'pixels': ctx.pixels(img), 'scale': 3}
    bit_names = {v: k[4:] for k, v in consts.items() if re.match(r'BIT_[A-Z]+BADGE$', k) and isinstance(v, int)}
    # obedience: CheckForDisobedience tests the badges from the highest down, each followed by ld a, level
    obey = {}
    a = g.at('CheckForDisobedience')
    for k in range(a, a + 0x80):
        if rom[k] == 0xCB and rom[k + 1] & 0xC7 == 0x46 and rom[k + 2] == 0x3E:
            obey[(rom[k + 1] >> 3) & 7] = rom[k + 3]
    # the field moves: StartMenu_Pokemon loads the badges once, then each move's branch (.fly, .cut, ...) tests one
    field = {}
    u = next((x for x in ctx.project.parsed.units if x.name == 'StartMenu_Pokemon'), None)
    locs = sorted((g.at(k), k.split('.')[1]) for k in g.syms if k.startswith('StartMenu_Pokemon.'))
    if u:
        for k in range(u.start, u.end - 1):
            if rom[k] == 0xCB and rom[k + 1] & 0xC7 == 0x47:
                lab = [n for a2, n in locs if a2 <= k]
                if lab:
                    field[(rom[k + 1] >> 3) & 7] = lab[-1].upper()
    # the gyms: MapBadgeFlags (gym map, badge bit)
    gym = {}
    a = g.at('MapBadgeFlags')
    for k in range(8):
        b = rom[a + 2 * k + 1]
        if b:
            gym[b.bit_length() - 1] = rom[a + 2 * k]
    sections = []
    for n in range(consts.get('NUM_BADGES', 8)):
        name = bit_names.get(n, 'BADGE{}'.format(n))
        word = name[:-5].capitalize()
        title = word + ' Badge'
        said = []
        for lab in sorted(g.syms):
            if lab.startswith('_') and lab.endswith('{}BadgeInfoText'.format(word)):
                said.append(['the leader says', '“{}”'.format(g.text(g.at(lab))[0])])
        house = '_CeruleanBadgeHouse{}BadgeText'.format(word)
        if house in g.syms:
            said.append(['the badge house', '“{}”'.format(g.text(g.at(house))[0])])
        fields = [['badge', [{'image': pic2x2(8 * n + 4)}, ' its leader: ', {'image': pic2x2(8 * n)}]]]
        if n in gym:
            fields.append(['won at', map_cell(gym[n])])
        fields.append(['bit', 'wObtainedBadges bit {}'.format(n)])
        if n in obey:
            fields.append(['obedience', 'Pokémon up to level {} obey'.format(obey[n]) if obey[n] <= 100 else 'every Pokémon obeys'])
        if n in field:
            fields.append(['field move', '{} outside of battle'.format(field[n])])
        sections.append({'title': title, 'fields': fields + said})
    out.append({'name': 'BadgesSheet', 'type': 'card', 'title': 'Badges', 'unit': 'GymLeaderFaceAndBadgeTileGraphics',
                'subtitle': '8 badges', 'summary': 'the eight badges and what each one unlocks',
                'source': 'faces and badges at {}, gyms at {}, obedience levels in CheckForDisobedience at {}'.format(
                    F(tiles), F(g.at('MapBadgeFlags')), F(g.at('CheckForDisobedience'))),
                'sections': sections,
                'doc': ['The badges are the bits of wObtainedBadges. What they do is spread over the code: '
                        'CheckForDisobedience reads the highest badges for the level up to which traded Pokémon obey, '
                        'ApplyBadgeStatBoosts raises a stat for four of them, and the field moves (Cut, Fly, Surf, '
                        'Strength, Flash) each test their badge. The texts are what the gym leaders and the man in '
                        'Cerulean City\'s badge house say about each badge.'],
                'users': ['DrawBadges', 'CheckForDisobedience', 'ApplyBadgeStatBoosts', 'StartMenu_Pokemon']})

    # ======================================================================== the character set
    font = g.at('FontGraphics')
    cmap = g.charmap
    img = [[0] * (16 * 10) for _ in range(8 * 10)]
    marks = []
    for k in range(128):
        code = 0x80 + k
        px = _pk.tile_rows(rom, font + 8 * k, 1)
        ox, oy = (k % 16) * 10 + 1, (k // 16) * 10 + 1
        for y in range(8):
            img[oy + y][ox:ox + 8] = [3 if v else 0 for v in px[y]]
        ch = cmap.get(code, '')
        marks.append({'x': ox - 1, 'y': oy - 1, 'w': 10, 'h': 10, 'label': '${:02X}'.format(code),
                      'text': ch if ch else '(no character)'})
    special = sorted((c, s) for c, s in cmap.items() if c < 0x80 and s)
    out.append({'name': 'CharacterSet', 'type': 'image', 'title': 'Character set', 'unit': 'FontGraphics',
                'subtitle': 'codes $80-$FF', 'source': 'font at {} (128 tiles of 1 bit per pixel)'.format(F(font)),
                'width': 160, 'height': 80, 'pixels': ctx.pixels(img), 'scale': 4, 'marks': marks, 'listMarks': False,
                'doc': ['The font: FontGraphics holds the glyphs of character codes $80-$FF (A-Z, a-z, accents, '
                        'digits, punctuation, ...) as 1-bit tiles, copied to tiles $80-$FF of VRAM by '
                        'LoadFontTilePatterns, so a character code is simply the tile it is drawn with. Hover a glyph '
                        'for its code.',
                        'Codes below $80 are commands of the text engine or other tiles: ' +
                        ', '.join('${:02X} {}'.format(c, s) for c, s in special[:60]) + '.'],
                'users': ['LoadFontTilePatterns', 'PlaceString']})

    # ======================================================================== the credits
    co, cp = g.at('CreditsOrder'), g.at('CreditsTextPointers')
    cbank = g.bank('CreditsTextPointers')
    names = {0xFF: 'fade in, with a Pokémon', 0xFE: 'with a Pokémon', 0xFD: 'fade in', 0xFC: 'next',
             0xFB: 'copyright', 0xFA: 'THE END'}
    sections, page, k = [], [], 0
    a = co
    while a < co + 400:
        c = rom[a]
        a += 1
        if c in names:
            sections.append({'title': 'Screen {} ({})'.format(len(sections) + 1, names[c]),
                             'text': page or ['(the copyright lines)' if c == 0xFB else '—']})
            page = []
            if c == 0xFA:
                break
            continue
        t = g.lin(cbank, g.word(cp + 2 * c))
        page.append(g.string(t + 1)[0].replace('<PK><MN>', 'POKéMON').replace('#', 'POKé'))
    out.append({'name': 'CreditsSheet', 'type': 'card', 'title': 'Credits', 'unit': 'CreditsOrder',
                'subtitle': '{} screens'.format(len(sections)), 'summary': 'the staff roll in order',
                'source': 'CreditsOrder at {}, texts through CreditsTextPointers at {}'.format(F(co), F(cp)),
                'sections': sections,
                'doc': ['CreditsOrder: text numbers (each a line, through CreditsTextPointers: an x offset and the '
                        'text) and commands that end a screen - fade the text in, show a Pokémon running past, the '
                        'copyright, and finally THE END.'],
                'users': ['Credits']})
    return out
