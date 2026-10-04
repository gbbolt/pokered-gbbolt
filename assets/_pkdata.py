"""Pokemon Red's data tables, read from the ROM: species, moves, types, items, evolutions,
learnsets, Pokedex entries, wild encounters, trainers. Shared by the sheet plugins."""
import build as engine

GROWTH = {0: 'medium fast', 1: 'slightly fast', 2: 'slightly slow', 3: 'medium slow', 4: 'fast', 5: 'slow'}
TYPE_COLOR = {'NORMAL': '#9a9a7a', 'FIGHTING': '#b33a2e', 'FLYING': '#8e7fd6', 'POISON': '#9a449a',
              'GROUND': '#c7a24f', 'ROCK': '#a8923a', 'BIRD': '#777', 'BUG': '#93a523', 'GHOST': '#6a5793',
              'FIRE': '#e2742b', 'WATER': '#5a86e0', 'GRASS': '#5fae47', 'ELECTRIC': '#d9b527',
              'PSYCHIC': '#e2557d', 'ICE': '#6cc4c4', 'DRAGON': '#6a3ef0'}
ENCOUNTER_CHANCE = [51, 51, 39, 25, 25, 25, 13, 13, 11, 3]      # out of 256, per slot (the order of the table)


class Game:
    def __init__(self, ctx):
        self.ctx, self.rom, self.syms = ctx, ctx.rom, ctx.syms
        self.charmap = engine.read_charmap()
        self.rev = {}
        for n, a in self.syms.items():
            if '.' not in n:
                self.rev.setdefault(engine.linear(engine.SYM_BANK.get(n, 0), a), n)
        self._move_names = self._item_names = None

    # ---- basics
    def at(self, label):
        return engine.linear(engine.SYM_BANK.get(label, 0), self.syms[label])

    def bank(self, label):
        return engine.SYM_BANK.get(label, 0)

    def word(self, a):
        return self.rom[a] | self.rom[a + 1] << 8

    def lin(self, bank, addr):
        return engine.linear(bank, addr)

    def label_at(self, a):
        return self.rev.get(a)

    def string(self, a, n=None):
        """Characters up to '@' (or n bytes); returns (text, address after the '@')."""
        out = ''
        i = a
        while n is None or i < a + n:
            c = self.charmap.get(self.rom[i], '?')
            i += 1
            if c == '@':
                break
            out += c
        return out, i

    def strings(self, label, count):
        a, out = self.at(label), []
        for _ in range(count):
            s, a = self.string(a)
            out.append(s)
        return out

    @staticmethod
    def nice(s):
        """'BULBASAUR' -> 'Bulbasaur' (keeps the game's own symbols)."""
        return ' '.join(w[:1] + w[1:].lower() if w.isupper() and not any(c.isdigit() for c in w) else w
                        for w in s.split(' '))

    # ---- species
    def species(self):
        """[{internal, dex, name}] for the 151 Pokemon (internal species numbers 1-190 include gaps)."""
        if hasattr(self, '_species'):
            return self._species
        order, names = self.at('PokedexOrder'), self.at('MonsterNames')
        out = []
        for i in range(1, 191):
            dex = self.rom[order + i - 1]
            if 1 <= dex <= 151:
                out.append({'internal': i, 'dex': dex, 'name': self.string(names + 10 * (i - 1), 10)[0]})
        self._species = sorted(out, key=lambda s: s['dex'])
        self.by_internal = {s['internal']: s for s in self._species}
        self.by_dex = {s['dex']: s for s in self._species}
        return self._species

    def base_stats(self, dex):
        a = self.at('MewBaseStats') if dex == 151 else self.at('BaseStats') + 28 * (dex - 1)
        r = self.rom[a:a + 28]
        tm = int.from_bytes(bytes(r[20:27]), 'little')
        return {'addr': a, 'dex': r[0], 'hp': r[1], 'atk': r[2], 'def': r[3], 'spd': r[4], 'spc': r[5],
                'types': [r[6], r[7]], 'catch': r[8], 'exp': r[9], 'size': r[10], 'front': r[11] | r[12] << 8,
                'back': r[13] | r[14] << 8, 'moves': [m for m in r[15:19] if m], 'growth': r[19],
                'tmhm': [i + 1 for i in range(55) if tm >> i & 1]}

    def pic_bank(self, internal):
        """UncompressMonSprite's choice of bank for a species' pictures."""
        mew = self.bank('MewPicFront')
        if self.by_internal.get(internal, {}).get('dex') == 151:
            return mew
        if internal < 0x1F:
            return 0x09
        if internal < 0x4A:
            return 0x0A
        if internal < 0x74:
            return 0x0B
        if internal < 0x99:
            return 0x0C
        return 0x0D

    # ---- types, moves, items
    def type_name(self, t):
        tbl = self.at('TypeNames')
        return self.string(self.lin(self.bank('TypeNames'), self.word(tbl + 2 * t)))[0]

    def type_cell(self, t):
        n = self.type_name(t)
        return {'tag': n, 'color': TYPE_COLOR.get(n, '#888')}

    def move_name(self, m):
        if self._move_names is None:
            self._move_names = self.strings('MoveNames', 165)
        return self._move_names[m - 1] if 1 <= m <= 165 else '?'

    def move(self, m):
        a = self.at('Moves') + 6 * (m - 1)
        r = self.rom[a:a + 6]
        return {'id': m, 'addr': a, 'effect': r[1], 'power': r[2], 'type': r[3],
                'acc': round(r[4] * 100 / 255), 'pp': r[5], 'name': self.move_name(m)}

    def tm_move(self, n):
        return self.rom[self.at('TechnicalMachines') + n - 1]

    def tm_label(self, n):
        return 'TM{:02d}'.format(n) if n <= 50 else 'HM{:02d}'.format(n - 50)

    def move_anim(self, m):
        """(label, has frames) of animation m in AttackAnimationPointers (a move's number is its animation)."""
        a = self.lin(self.bank('AttackAnimationPointers'), self.word(self.at('AttackAnimationPointers') + 2 * (m - 1)))
        k, frames = a, False
        while self.rom[k] != 0xFF and k < a + 200:
            if self.rom[k] >= 0xC0:
                k += 2
            else:
                frames, k = True, k + 3
        return self.rev.get(a), frames

    def item_name(self, i):
        if self._item_names is None:
            self._item_names = self.strings('ItemNames', 0x61)
        if 1 <= i <= len(self._item_names):
            return self._item_names[i - 1]
        if i >= 0xC9:
            return 'TM{:02d}'.format(i - 0xC8)
        if i >= 0xC4:
            return 'HM{:02d}'.format(i - 0xC3)
        return 'item ${:02X}'.format(i)

    # ---- evolutions and learnsets
    def evos_moves(self, internal):
        tbl = self.at('EvosMovesPointerTable')
        bank = self.bank('EvosMovesPointerTable')
        a = self.lin(bank, self.word(tbl + 2 * (internal - 1)))
        evos = []
        while self.rom[a]:
            kind = self.rom[a]
            if kind == 2:
                evos.append({'how': 'item', 'item': self.rom[a + 1], 'level': self.rom[a + 2], 'into': self.rom[a + 3]})
                a += 4
            else:
                evos.append({'how': 'level' if kind == 1 else 'trade', 'level': self.rom[a + 1], 'into': self.rom[a + 2]})
                a += 3
        a += 1
        learn = []
        while self.rom[a]:
            learn.append((self.rom[a], self.rom[a + 1]))
            a += 2
        return evos, learn

    # ---- the Pokedex
    def dex_entry(self, internal):
        tbl = self.at('PokedexEntryPointers')
        bank = self.bank('PokedexEntryPointers')
        a = self.lin(bank, self.word(tbl + 2 * (internal - 1)))
        label, start = self.rev.get(a), a
        kind, a = self.string(a)
        feet, inches = self.rom[a], self.rom[a + 1]
        weight = self.word(a + 2)
        a += 4
        text = ''
        if self.rom[a] == 0x17:                    # text_far: the entry's text in another bank
            t = self.lin(self.rom[a + 3], self.word(a + 1))
            text = self.dex_text(t)
        return {'label': label, 'addr': start, 'kind': kind, 'feet': feet, 'inches': inches, 'weight': weight / 10, 'text': text}

    def dex_text(self, a):
        if self.rom[a] == 0:
            a += 1
        out = ''
        while True:
            c = self.charmap.get(self.rom[a], '?')
            a += 1
            if c in ('@', '<DEXEND>'):
                if c == '<DEXEND>':
                    out += '.'
                break
            if c in ('<NEXT>', '<LINE>', '<PAGE>', '<PARA>', '<CONT>'):
                out += ' '
            elif c.startswith('<') and len(c) > 2:
                out += c
            else:
                out += c
            if len(out) > 400:
                break
        return ' '.join(out.replace('#', 'POKé').split())

    # ---- maps
    def map_label(self, m):
        """The map header label of map id m (e.g. 'PalletTown_h')."""
        ptrs, banks = self.at('MapHeaderPointers'), self.at('MapHeaderBanks')
        return self.rev.get(self.lin(self.rom[banks + m], self.word(ptrs + 2 * m)), '')

    def map_blocks_label(self, m):
        ptrs, banks = self.at('MapHeaderPointers'), self.at('MapHeaderBanks')
        hb = self.rom[banks + m]
        h = self.lin(hb, self.word(ptrs + 2 * m))
        return self.rev.get(self.lin(hb, self.word(h + 3)), '')

    def map_name(self, m):
        import re
        n = self.map_label(m)[:-2]
        s = re.sub(r'(?<=[a-z])(?=[A-Z0-9])', ' ', n)
        s = re.sub(r'(?<=[0-9])(?=[A-Z][a-z])', ' ', s)
        return re.sub(r'(?<=[A-Z])(?=[A-Z][a-z])', ' ', s)

    def map_objects(self):
        """What stands on each map (header shared by several ids counted once), for cross links:
        {map id: [{'kind': 'trainer', 'cls', 'party'} | {'kind': 'item', 'item'} | {'kind': 'mon', 'species', 'level'}
        | {'kind': 'hidden_item', 'item'}]}. Object data: border block, warps (4 bytes), signs (3), then objects of
        6 bytes plus 2 for a trainer (class + 200, party) or a standing Pokemon, or 1 for an item."""
        if hasattr(self, '_map_objects'):
            return self._map_objects
        ptrs, banks = self.at('MapHeaderPointers'), self.at('MapHeaderBanks')
        out, seen = {}, set()
        for m in range(0xF8):
            hb = self.rom[banks + m]
            h = self.lin(hb, self.word(ptrs + 2 * m))
            if not self.rev.get(h, '').endswith('_h') or h in seen:
                continue
            seen.add(h)
            conn = self.rom[h + 9]
            p = h + 10 + 11 * bin(conn & 0xF).count('1')
            q = self.lin(hb, self.word(p)) + 1
            q += 1 + 4 * self.rom[q]
            q += 1 + 3 * self.rom[q]
            n = self.rom[q]
            q += 1
            lst = []
            for _ in range(n):
                tid = self.rom[q + 5]
                q += 6
                if tid & 0x40:
                    c = self.rom[q] - 200
                    lst.append({'kind': 'trainer', 'cls': c, 'party': self.rom[q + 1]} if 1 <= c <= 47 else
                               {'kind': 'mon', 'species': self.rom[q], 'level': self.rom[q + 1]})
                    q += 2
                elif tid & 0x80:
                    lst.append({'kind': 'item', 'item': self.rom[q]})
                    q += 1
            out[m] = lst
        hm, hp, hbank = self.at('HiddenEventMaps'), self.at('HiddenEventPointers'), self.bank('HiddenEventPointers')
        items_fn = self.syms.get('HiddenItems')
        k, done = 0, set()
        while self.rom[hm + k] != 0xFF:
            a = self.lin(hbank, self.word(hp + 2 * k))
            first = self.rom[hm + k] not in done          # the game uses a map's first entry only
            done.add(self.rom[hm + k])
            while first and self.rom[a] != 0xFF:
                if self.word(a + 4) == items_fn and self.rom[hm + k] in out:
                    out[self.rom[hm + k]].append({'kind': 'hidden_item', 'item': self.rom[a + 2]})
                a += 6
            k += 1
        self._map_objects = out
        return out

    def wild(self):
        """{map id: {'grass': (rate, [(level, internal)]), 'water': ...}} from WildDataPointers."""
        tbl, bank = self.at('WildDataPointers'), self.bank('WildDataPointers')
        out = {}
        for m in range(0xF8):
            p = self.word(tbl + 2 * m)
            if p == 0xFFFF:
                break
            a = self.lin(bank, p)
            got = {}
            for where in ('grass', 'water'):
                rate = self.rom[a]
                a += 1
                if rate:
                    got[where] = (rate, [(self.rom[a + 2 * k], self.rom[a + 2 * k + 1]) for k in range(10)])
                    a += 20
            if got:
                out[m] = (got, self.rev.get(self.lin(bank, p)))
        return out


# ---- what a text prints (the text engine's commands, TextCommandProcessor)
TX_NAMES = {'<PLAYER>': 'RED', '<RIVAL>': 'BLUE', '<TARGET>': 'the foe', '<USER>': 'the user', '<PKMN>': 'PKMN',
            '<PC>': 'PC', '<TM>': 'TM', '<TRAINER>': 'TRAINER', '<ROCKET>': 'ROCKET', '#': 'POKé'}
TX_BREAK = {'<NEXT>', '<LINE>', '<CONT>', '<_CONT>', '<SCROLL>', '<PARA>', '<PAGE>'}
TX_SCRIPTS = {0xFF: 'the Pokémon Center nurse', 0xFE: 'a mart', 0xFD: "Bill's PC", 0xFC: "the player's PC",
              0xF9: 'the Pokémon Center PC', 0xF7: 'the Game Corner prize vendor', 0xF6: 'the Cable Club',
              0xF5: 'a vending machine'}


def _text_methods():
    def text(self, a, depth=0, budget=None):
        """(words, how it ends): 'end', 'asm' (code follows at the returned address) or 'bad'."""
        rom = self.rom
        budget = budget if budget is not None else [1500]
        out = []
        while 0 <= a < len(rom) and budget[0] > 0:
            budget[0] -= 1
            op = rom[a]
            a += 1
            if op == 0x00:                                 # text_start: characters up to '@'
                while budget[0] > 0:
                    budget[0] -= 1
                    c = self.charmap.get(rom[a], '?')
                    a += 1
                    if c == '@':
                        break
                    if c in ('<DONE>', '<PROMPT>', '<DEXEND>'):
                        return ' '.join(''.join(out).split()), 'end', a
                    if c in TX_NAMES:
                        out.append(TX_NAMES[c])
                    elif c in TX_BREAK:
                        out.append(' ')
                    elif c.startswith('<') and len(c) > 2:
                        out.append('')
                    else:
                        out.append(c)
            elif op == 0x17:                               # text_far
                t = self.lin(rom[a + 2], self.word(a))
                a += 3
                if depth < 4:
                    s, how, _ = self.text(t, depth + 1, budget)
                    out.append(s + ' ')
                    if how != 'end':
                        return ' '.join(''.join(out).split()), how, a
            elif op == 0x01 or op == 0x05:                 # text_ram, low
                if op == 0x01:
                    out.append('[{}]'.format(self.rev.get(self.word(a), 'RAM')))
                    a += 2
            elif op in (0x02, 0x09):                       # numbers from RAM
                out.append('[number]')
                a += 3
            elif op == 0x03:
                a += 2
            elif op == 0x04:
                a += 4
            elif op in (0x06, 0x07, 0x0A, 0x0D) or 0x0B <= op <= 0x16:
                pass
            elif op == 0x0C:
                a += 1
            elif op == 0x08:                               # text_asm: code follows
                return ' '.join(''.join(out).split()), 'asm', a
            elif op == 0x50:
                return ' '.join(''.join(out).split()), 'end', a
            elif op in TX_SCRIPTS and not out and depth == 0:
                return 'talks to you as ' + TX_SCRIPTS[op], 'end', a
            else:
                return ' '.join(''.join(out).split()), 'bad', a
        return ' '.join(''.join(out).split()), 'end', a

    def is_text(self, a):
        s, how, _ = self.text(a, budget=[300])
        plain = sum(ch.isascii() and (ch.isalnum() or ch in " .,!?'-:/&") for ch in s)
        return how == 'end' and sum(ch.isalpha() for ch in s) >= 3 and plain >= 0.75 * len(s), s

    def script_texts(self, a, limit=4, arg=None):
        """The texts a piece of script code loads (ld hl, Text) before it returns: [(label, words)].
        A trainer header (ld hl, Header + TalkToTrainer) gives the trainer's battle text."""
        from sm83 import decode
        bank = a // 0x4000 if a >= 0x4000 else 0
        mem = BankBytes(self.rom, bank)
        out, pc = [], a if a < 0x4000 else 0x4000 + (a & 0x3FFF)
        predef = self.syms.get('PrintPredefTextID')
        last_a = None
        for _ in range(120):
            ins = decode(mem, pc)
            if ins.op == 0x3E:                    # ld a, n: a TextPredefs number for PrintPredefTextID
                last_a = mem[pc + 1]
            elif ins.op == 0xFA:                  # ld a, [nn]: a hidden event's argument, or unknown
                last_a = arg if ins.imm == self.syms.get('wHiddenEventFunctionArgument') else None
            if ins.kind in ('call', 'jump') and ins.target == predef and last_a:
                t = self.predef_text(last_a)
                if t and all(t[1] != x[1] for x in out):
                    out.append(t)
            if ins.op == 0x21 and ins.imm is not None:
                t = self.lin(bank, ins.imm) if ins.imm >= 0x4000 else ins.imm
                ok, s = self.is_text(t)
                if not ok and 0xD000 <= self.word(t + 2) < 0xE000:     # a trainer header: battle text at +4
                    t2 = self.lin(bank, self.word(t + 4))
                    ok, s = self.is_text(t2)
                    t = t2
                if ok and not s.startswith('talks to you as') and all(s != x[1] for x in out):
                    out.append((self.rev.get(t, ''), s))
                    if len(out) >= limit:
                        break
            if ins.kind in ('ret', 'jphl', 'invalid', 'stop') or (ins.kind == 'jump' and ins.target is not None and
                                                                  not (pc - 0x100 < ins.target < pc + 0x200)):
                break
            pc += ins.length                      # straight on: every branch's text is wanted
        return out

    def predef_text(self, n):
        """Text n of TextPredefs (entries named Label_id): (label, words) or None."""
        e = self.at('TextPredefs') + 2 * (n - 1)
        lab = self.rev.get(e, '')
        name = lab[:-3] if lab.endswith('_id') else ''
        if name not in self.syms:
            return None
        return name, self.say(self.at(name))

    def say(self, a):
        """One line for the text at a: its words, or the words of the texts its script prints."""
        s, how, rest = self.text(a)
        if how == 'asm':
            got = self.script_texts(rest)
            words = ' / '.join(t for _, t in got)
            return ((s + ' ') if s else '') + (words or '(runs a script)')
        return s
    return text, is_text, script_texts, predef_text, say


class BankBytes:
    """The CPU's view of the ROM with one bank switched in (for decoding code)."""
    def __init__(self, rom, bank):
        self.rom, self.base = rom, max(bank, 1) * 0x4000 - 0x4000

    def __getitem__(self, a):
        return self.rom[a] if a < 0x4000 else self.rom[self.base + a] if a < 0x8000 else 0


Game.text, Game.is_text, Game.script_texts, Game.predef_text, Game.say = _text_methods()


def _sgb_methods():
    def const(self, name, default=None):
        v = self.ctx.project.parsed.consts.get(name, default)
        return v if isinstance(v, int) else default

    def sgb_palettes(self):
        """SuperPalettes: [(name, ['#rrggbb' x 4])], the Super Game Boy's palettes (4 colours of 15 bits each)."""
        if hasattr(self, '_sgb'):
            return self._sgb
        names = {}
        for k, v in self.ctx.project.parsed.consts.items():
            if k.startswith('PAL_') and isinstance(v, int) and k not in ('PAL_COLORS', 'PAL_SIZE'):
                names.setdefault(v, k)
        n = self.const('NUM_SGB_PALS', 0x25)
        a, out = self.at('SuperPalettes'), []
        for p in range(n):
            cols = []
            for c in range(4):
                w = self.word(a + 8 * p + 2 * c)
                r, g, b = w & 31, w >> 5 & 31, w >> 10 & 31
                cols.append('#{:02x}{:02x}{:02x}'.format(*(v << 3 | v >> 2 for v in (r, g, b))))
            out.append((names.get(p, 'PAL_{:02X}'.format(p)), cols))
        self._sgb = out
        return out

    def mon_palette(self, dex):
        """The palette number MonsterPalettes gives a Pokemon (by Pokedex number)."""
        return self.rom[self.at('MonsterPalettes') + dex]

    def map_palette(self, m, tileset, outside=None):
        """SetPal_Overworld's palette for map m: CEMETERY tileset grey, CAVERN tileset cave colours; a town its
        own palette (map + 1), a route the route palette; Cerulean Cave and Bruno's room cave colours, Lorelei's
        room Pallet Town's; any other inside map the palette of the town or route outside (wLastMap)."""
        if tileset == self.const('CEMETERY'):
            return self.const('PAL_GRAYMON')
        if tileset == self.const('CAVERN'):
            return self.const('PAL_CAVE')
        first_in, cities = self.const('FIRST_INDOOR_MAP', 0x25), self.const('NUM_CITY_MAPS', 0x0B)
        if m >= first_in:
            if self.const('CERULEAN_CAVE_2F', 0x100) <= m <= self.const('CERULEAN_CAVE_1F', -1):
                return self.const('PAL_CAVE')
            if m == self.const('LORELEIS_ROOM'):
                return self.const('PAL_PALLET')
            if m == self.const('BRUNOS_ROOM'):
                return self.const('PAL_CAVE')
            if outside is None:
                return None
            m = outside
        return m + 1 if m < cities else self.const('PAL_ROUTE', 0)
    return const, sgb_palettes, mon_palette, map_palette


Game.const, Game.sgb_palettes, Game.mon_palette, Game.map_palette = _sgb_methods()


def _tileset_methods():
    def tileset_names(self):
        names = {}
        for k, v in self.ctx.project.parsed.consts.items():
            if isinstance(v, int) and k.isupper() and k in ('OVERWORLD', 'REDS_HOUSE_1', 'MART', 'FOREST', 'REDS_HOUSE_2',
                                                            'DOJO', 'POKECENTER', 'GYM', 'HOUSE', 'FOREST_GATE', 'MUSEUM',
                                                            'UNDERGROUND', 'GATE', 'SHIP', 'SHIP_PORT', 'CEMETERY',
                                                            'INTERIOR', 'CAVERN', 'LOBBY', 'MANSION', 'LAB', 'CLUB',
                                                            'FACILITY', 'PLATEAU'):
                names[v] = k
        return names

    def tileset_props(self, t):
        """What the game's tables say about the tiles of tileset t: {tile: [(kind, text)]}, kind one of 'walk',
        'door', 'warp', 'grass', 'counter', 'ledge', 'water', 'shelf', 'pair'."""
        rom = self.rom
        e = self.at('Tilesets') + 12 * t
        props = {}

        def add(tile, kind, text):
            props.setdefault(tile, []).append((kind, text))
        coll = self.word(e + 5)
        a = coll if coll < 0x4000 else self.lin(rom[e], coll)
        while rom[a] != 0xFF and a < coll + 128:
            add(rom[a], 'walk', 'walkable ({})'.format(self.rev.get(coll if coll < 0x4000 else a, 'collision list')))
            a += 1
        for k in range(3):
            if rom[e + 7 + k] != 0xFF:
                add(rom[e + 7 + k], 'counter', 'a counter: you can talk across it')
        if rom[e + 10] != 0xFF:
            add(rom[e + 10], 'grass', 'grass: wild Pokémon, and drawn over the lower half of sprites')
        d, db = self.at('DoorTileIDPointers'), self.bank('DoorTileIDPointers')
        k = 0
        while rom[d + 3 * k] != 0xFF and k < 40:
            if rom[d + 3 * k] == t:
                a = self.lin(db, self.word(d + 3 * k + 1))
                while rom[a]:
                    add(rom[a], 'door', 'a door: stepping on it from outside walks you through (DoorTileIDPointers)')
                    a += 1
                break
            k += 1
        w, wb = self.at('WarpTileIDPointers'), self.bank('WarpTileIDPointers')
        a = self.lin(wb, self.word(w + 2 * t))
        while rom[a] != 0xFF:
            add(rom[a], 'warp', 'a warp tile: a warp of the map here takes you on (WarpTileIDPointers)')
            a += 1
        if t == self.const('OVERWORLD', 0):
            a = self.at('LedgeTiles')
            while rom[a] != 0xFF:
                add(rom[a + 2], 'ledge', 'a ledge: you jump down it from tile ${:02X}'.format(rom[a + 1]))
                a += 4
        wt = self.at('WaterTilesets')
        k = 0
        while rom[wt + k] != 0xFF and k < 30:
            if rom[wt + k] == t:
                a = self.at('IsNextTileShoreOrWater')
                cps = [rom[i + 1] for i in range(a, a + 0x30) if rom[i] == 0xFE]
                for c in cps[1:] if len(cps) > 1 else cps:
                    add(c, 'water', 'water or shore: Surf works from here (IsNextTileShoreOrWater)')
                break
            k += 1
        b = self.at('BookshelfTileIDs')
        while rom[b] != 0xFF:
            if rom[b] == t:
                n = self.predef_text(rom[b + 2])
                add(rom[b + 1], 'shelf', 'something to read: {}'.format(n[0] if n else 'text {}'.format(rom[b + 2])))
            b += 3
        for lab in ('TilePairCollisionsLand', 'TilePairCollisionsWater'):
            a = self.at(lab)
            while rom[a] != 0xFF:
                if rom[a] == t:
                    for x, y in ((rom[a + 1], rom[a + 2]), (rom[a + 2], rom[a + 1])):
                        add(x, 'pair', 'no step between it and tile ${:02X} ({}; different heights)'.format(y, lab))
                a += 3
        return props
    return tileset_names, tileset_props


Game.tileset_names, Game.tileset_props = _tileset_methods()


def pal_name(name):
    """'PAL_GREENMON' -> 'green mon'."""
    s = name[4:] if name.startswith('PAL_') else name
    s = s.lower()
    if s.endswith('mon') and len(s) > 3:
        s = s[:-3] + ' mon'
    for c in ('green', 'yellow', 'red'):
        if s == c + 'bar':
            s = c + ' bar'
    return s


def trainer_card(c, name):
    """The trainer-class card's name (class number c, 1-based)."""
    import re
    return 'Trainer{:02d}_{}'.format(c, re.sub(r'\W', '', Game.nice(name)))
