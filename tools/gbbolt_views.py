"""What Pokemon Red's text blocks print, decoded for the viewer (game.json "views").

A text block is a little program for the text engine (TextCommandProcessor): commands
like TX_RAM (print a name from RAM) or TX_FAR (continue at text in another bank), and
TX_START, which prints characters until '@'. Inside the characters, control codes break
lines, start paragraphs, wait for a button or name the player.
"""

TX = {0x00: 'start', 0x01: 'ram', 0x02: 'bcd', 0x03: 'move', 0x04: 'box', 0x05: 'low', 0x06: 'wait',
      0x07: 'scroll', 0x08: 'asm', 0x09: 'num', 0x0A: 'pause', 0x0C: 'dots', 0x0D: 'waitbutton',
      0x17: 'far', 0x50: 'end'}
SOUNDS = {0x0B: 'get item / level up jingle', 0x0E: 'Pokédex rating jingle', 0x0F: 'get item jingle',
          0x10: 'get item jingle 2', 0x11: 'get key item jingle', 0x12: 'caught Pokémon jingle',
          0x13: 'Pokédex page added', 0x14: "Nidorina's cry", 0x15: "Pidgeot's cry", 0x16: "Dewgong's cry"}
SCRIPTS = {0xFF: 'Pokémon Center nurse', 0xFE: 'mart', 0xFD: "Bill's PC", 0xFC: "player's PC",
           0xF9: 'Pokémon Center PC', 0xF7: 'Game Corner prize vendor', 0xF6: 'Cable Club receptionist',
           0xF5: 'vending machine'}
NAMES = {'<PLAYER>': 'player', '<RIVAL>': 'rival', '<TARGET>': 'target', '<USER>': 'user', '<PKMN>': 'PKMN',
         '<PC>': 'PC', '<TM>': 'TM', '<TRAINER>': 'TRAINER', '<ROCKET>': 'ROCKET', '#': 'POKé'}
BREAKS = {'<NEXT>': 'br', '<LINE>': 'br', '<CONT>': 'br', '<_CONT>': 'br', '<SCROLL>': 'br',
          '<PARA>': 'para', '<PAGE>': 'para'}
FIRST = {'text', 'text_far', 'text_ram', 'text_start', 'text_decimal', 'text_bcd', 'text_asm', 'text_box',
         'text_move', 'text_low', 'text_promptbutton', 'text_pause', 'text_dots', 'text_waitbutton',
         'text_scroll', 'sound_get_item_1', 'sound_get_key_item', 'sound_caught_mon', 'sound_level_up'}


def views(ctx):
    rom, charmap = ctx.rom, ctx.charmap
    out = {}

    def ram_name(addr):
        return ctx.label(0, addr) or '${:04X}'.format(addr)

    def decode(lin, toks, depth=0, budget=None):
        """Text commands at lin; returns False when a box ends (done/prompt) or code follows."""
        budget = budget if budget is not None else [3000]
        while 0 <= lin < len(rom) and budget[0] > 0:
            budget[0] -= 1
            op = rom[lin]
            lin += 1
            kind = TX.get(op)
            if op in SOUNDS:
                toks.append(['sound', SOUNDS[op]])
            elif kind == 'start':
                buf = ''
                while lin < len(rom) and budget[0] > 0:
                    budget[0] -= 1
                    c = rom[lin]
                    lin += 1
                    s = charmap.get(c, '?')
                    if s == '@':
                        break
                    if s in NAMES or s in BREAKS or s in ('<DONE>', '<PROMPT>', '<DEXEND>'):
                        if buf:
                            toks.append(buf)
                            buf = ''
                        if s in NAMES:
                            toks.append(['name', NAMES[s]])
                        elif s in BREAKS:
                            toks.append([BREAKS[s]])
                        else:
                            if s == '<DEXEND>':
                                toks.append('.')
                            toks.append(['prompt' if s == '<PROMPT>' else 'done'])
                            return False
                    elif s.startswith('<') and s.endswith('>') and len(s) > 2:
                        buf += s[1:-1].lower() if s.startswith('<BOLD_') else s
                    else:
                        buf += s
                if buf:
                    toks.append(buf)
            elif kind == 'ram':
                toks.append(['ram', ram_name(rom[lin] | rom[lin + 1] << 8)])
                lin += 2
            elif kind == 'bcd':
                toks.append(['num', ram_name(rom[lin] | rom[lin + 1] << 8), 'BCD'])
                lin += 3
            elif kind == 'num':
                toks.append(['num', ram_name(rom[lin] | rom[lin + 1] << 8), '{} digits'.format(rom[lin + 2] & 0xF)])
                lin += 3
            elif kind == 'move':
                lin += 2
            elif kind == 'box':
                lin += 4
            elif kind in ('wait', 'waitbutton'):
                toks.append(['wait'])
            elif kind == 'scroll':
                toks.append(['br'])
            elif kind == 'pause':
                toks.append(['pause'])
            elif kind == 'dots':
                toks.append(['dots', rom[lin]])
                lin += 1
            elif kind == 'low':
                pass
            elif kind == 'far':
                addr, bank = rom[lin] | rom[lin + 1] << 8, rom[lin + 2]
                lin += 3
                target = ctx.linear(bank, addr)
                label = ctx.label(bank, addr) or ctx.fmt_rom(target)
                toks.append(['far', label, target])
                if depth < 4 and not decode(target, toks, depth + 1, budget):
                    toks.append(['farend'])
                    return False
                toks.append(['farend'])
            elif kind == 'asm':
                toks.append(['asm'])
                return False
            elif kind == 'end':
                return True
            elif op in SCRIPTS and depth == 0 and not toks:
                toks.append(['script', SCRIPTS[op]])
                return False
            else:
                toks.append(['?', '${:02X}'.format(op)])
                return False
        return True

    import re
    for u in ctx.units:
        # a text block starts with a text command: `db TX_START, "..."`, `db TX_FAR`, `db TX_SOUND_...`
        if not u.lines or not (u.lines[0][0] in FIRST or re.match(r'^\s*db\s+TX_\w+', u.lines[0][1], re.I)):
            continue
        toks = []
        decode(u.start, toks)
        if toks:
            out[u.name] = {'kind': 'text', 't': toks}
    return out
