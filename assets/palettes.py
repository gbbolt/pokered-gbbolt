"""The Super Game Boy colours: SuperPalettes holds the 37 four-colour palettes the game sends to the Super Game
Boy at power-on (PAL_TRN), and the palette packets (PAL_SET) pick four of them for a screen. Who uses which
palette is read from the game's tables: MonsterPalettes (one per Pokemon), SetPal_Overworld's rule for the maps,
and the PalPacket_ blocks of the other screens."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build as engine  # noqa: E402
from _pkdata import Game, pal_name  # noqa: E402
from pokedex import card_name  # noqa: E402

GROUP = 'sheets'


def build(ctx):
    g = Game(ctx)
    species = g.species()
    sgb = g.sgb_palettes()
    base = g.at('SuperPalettes')
    mons = {}
    for s in species:
        mons.setdefault(g.mon_palette(s['dex']), []).append(s)
    # the palette packets: PAL_SET ($51) and four palette numbers
    packets = {}
    for n in sorted(g.syms):
        if n.startswith('PalPacket_') and '.' not in n:
            a = g.at(n)
            if g.rom[a] == 0x51:
                for k in range(4):
                    p = g.word(a + 1 + 2 * k)
                    if 0 < p < len(sgb) or (p == 0 and n != 'PalPacket_Empty'):
                        packets.setdefault(p, [])
                        if n[10:] not in packets[p]:
                            packets[p].append(n[10:])
    # the maps (as the maps sheet works them out): town maps by number, routes, caves, the grey Pokemon Tower
    towns = {g.const('PAL_PALLET', 1) + m: g.map_name(m) for m in range(g.const('NUM_CITY_MAPS', 11))
             if g.map_label(m).endswith('_h')}
    rows, ids = [], []
    for p, (name, cols) in enumerate(sgb):
        used = []
        if p in towns:
            used.append({'asset': g.map_blocks_label(p - 1), 'text': towns[p]})
        if name == 'PAL_ROUTE':
            used.append('all routes')
        if name == 'PAL_CAVE':
            used.append('caves (CAVERN tileset), Cerulean Cave, Bruno\'s room')
        if name == 'PAL_GRAYMON':
            used.append('the CEMETERY tileset (Pokémon Tower, Agatha\'s room)')
        if name == 'PAL_PALLET':
            used.append('Lorelei\'s room')
        if p in packets:
            used.append('screens: ' + ', '.join(packets[p]))
        used = [x for k, u in enumerate(used) for x in ([u] if k == 0 else [' · ', u])]
        ms = mons.get(p, [])
        if ms:
            used.append(('· ' if used else '') + '{} Pokémon: '.format(len(ms)))
            used += [x for k, m in enumerate(ms) for x in ([] if k == 0 else [', ']) +
                     [{'asset': card_name(m['dex'], m['name']), 'text': g.nice(m['name'])}]]
        swatch = {'image': {'width': 4, 'height': 1, 'pixels': ctx.pixels([[0, 1, 2, 3]]), 'colors': cols,
                            'fixedColors': True, 'scale': 12}}
        rows.append(['${:02X}'.format(p), pal_name(name), swatch, {'text': ' '.join(cols), 'tone': 'muted'}, used])
        ids.append('pal{}'.format(p))
    return [{
        'name': 'PaletteSheet', 'unit': 'SuperPalettes', 'type': 'card', 'title': 'Super Game Boy palettes',
        'subtitle': '{} palettes'.format(len(sgb)), 'summary': 'the colours on a Super Game Boy, and who uses them',
        'source': 'palettes at {} ({} x 8 bytes), Pokémon palettes at {}'.format(
            engine.fmt_rom(base), len(sgb), engine.fmt_rom(g.at('MonsterPalettes'))),
        'sections': [{'columns': ['#', 'palette', 'colours', 'RGB', 'used by'], 'rows': rows, 'ids': ids, 'wide': True}],
        'doc': ['SuperPalettes: four colours of 15 bits each (5 bits red, green, blue) per palette, light to dark - '
                'colour 0 is the background, colour 3 the outlines. On a Super Game Boy these replace the four '
                'grey shades: the game sends all of them once at power-on, then a PAL_SET packet (the PalPacket_ '
                'tables, or one SetPal_Overworld and SetPal_Battle fill in) picks four palettes for the screen and '
                'an ATTR_BLK packet (BlkPacket_) says which part of the screen gets which.',
                'Every Pokémon has its palette in MonsterPalettes (by Pokédex number); a map takes its town\'s '
                'palette, the route palette, or for a building the palette of the place outside.'],
        'users': ['LoadSGB', 'SetPal_Overworld', 'SetPal_Battle', 'SendSGBPackets'],
    }]
