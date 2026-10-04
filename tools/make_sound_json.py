"""Write sound.json: how the engine's audio renderer (gbbolt tools/audio.py) drives Pokemon Red's
sound engine, with the list of every song, sound effect and cry - read from the built ROM.

    python tools/make_sound_json.py

The game has three copies of its sound engine, each in its own bank with its own songs and
effects (Audio1_* in bank $02, Audio2_* in bank $08 for battles, Audio3_* in bank $1F). A sound
id is an index into the header table at the start of that bank: 3 bytes per channel, so a
sound that uses three channels takes three ids. PlaySound starts the sound whose id is in A,
in the bank wAudioROMBank names; VBlank then calls that bank's AudioN_UpdateMusic every frame.

A cry is one of the 38 base cries (SFX_Cry00 ...) played with a pitch and a tempo change:
GetCryData reads the Pokemon's 3 bytes of CryData (base cry, wFrequencyModifier,
wTempoModifier), and the engine applies them while the cry plays.
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, '..', 'gbbolt', 'tools'))
os.environ.setdefault('GBBOLT_ROOT', ROOT)
import build  # noqa: E402

BANKS = [(0x02, 1, 'Audio1_UpdateMusic'), (0x08, 2, 'Audio2_UpdateMusic'), (0x1F, 3, 'Audio3_UpdateMusic')]


def spaced(name):
    s = re.sub(r'(?<=[a-z])(?=[A-Z0-9])', ' ', name)
    return re.sub(r'(?<=[A-Z])(?=[A-Z][a-z])', ' ', s).replace('_', ' ').strip()


def main():
    rom = open(build.BUILT, 'rb').read()
    syms = build.read_sym()
    charmap = build.read_charmap()
    rev = {}
    for n, a in syms.items():
        if '.' not in n:
            rev.setdefault(build.linear(build.SYM_BANK.get(n, 0), a), n)

    def lin(name):
        return build.linear(build.SYM_BANK.get(name, 0), syms[name])

    def text(a, n):
        out = ''
        for b in rom[a:a + n]:
            c = charmap.get(b, '?')
            if c == '@':
                break
            out += c
        return out

    kinds, names, pokes = {}, {}, {}
    seen_sfx = set()
    sfx_kinds, drums = {}, []
    playing_music = ['0x{:04X}'.format(syms['wChannelSoundIDs'] + i) for i in range(4)]
    playing_sfx = ['0x{:04X}'.format(syms['wChannelSoundIDs'] + i) for i in range(4, 8)]
    cry_start = None
    for bank, n, update in BANKS:
        music, sfx = [], []
        for sid in range(1, 256):
            a = build.linear(bank, 0x4000 + 3 * sid)
            label = rev.get(a, '')
            if label.startswith('Music_'):
                music.append(sid)
                names['music{} {}'.format(n, sid)] = [spaced(label[6:]), label]
            elif label.startswith('SFX_Cry'):
                if bank == 0x02 and cry_start is None:
                    cry_start = sid
            elif label.startswith('SFX_') and not label.startswith('SFX_Headers') and '_Ch' not in label:
                base = re.sub(r'_\d$', '', label[4:])
                if base in seen_sfx:
                    continue
                seen_sfx.add(base)
                if base.startswith('Noise_Instrument'):      # the drum sounds songs play on the noise channel
                    if bank == 0x02:
                        drums.append(sid)
                        names['drums {}'.format(sid)] = ['Drum ' + base[-2:], label]
                    continue
                sfx.append(sid)
                names['sfx{} {}'.format(n, sid)] = [spaced(base), label]
        common = {'request_call': 'PlaySound', 'bank': bank, 'update': update,
                  'setup': {'wAudioROMBank': bank, 'wAudioSavedROMBank': bank}}
        if music:
            kinds['music{}'.format(n)] = dict(common, label=['Music', 'Battle music', 'More music'][n - 1],
                                              playing=playing_music, playing_mask=255,
                                              ids={'list': music}, loops=True, max_seconds=240)
        if sfx:
            sfx_kinds['sfx{}'.format(n)] = dict(common, label=['Sound effects', 'Battle sound effects',
                                                           'More sound effects'][n - 1],
                                            playing=playing_sfx, playing_mask=255,
                                            ids={'list': sfx}, max_seconds=8)
    kinds.update(sfx_kinds)
    kinds['drums'] = dict(sfx_kinds['sfx1'], label='Drums', ids={'list': drums}, max_seconds=2)
    # cries, by Pokedex number (CryData and the names are indexed by the internal species number)
    cry_data, mon_names, dex = lin('CryData'), lin('MonsterNames'), lin('PokedexOrder')
    requests, ids = {}, []
    for species in range(1, 191):
        no = rom[dex + species - 1]
        if not 1 <= no <= 151:
            continue
        base, pitch, length = rom[cry_data + 3 * (species - 1): cry_data + 3 * species]
        requests[str(no)] = cry_start + 3 * base
        ids.append(no)
        name = text(mon_names + 10 * (species - 1), 10)
        names['cries {}'.format(no)] = ['#{:03d} {}'.format(no, name.title() if name.isupper() else name),
                                        'CryData: base cry {:02X}, pitch {:02X}, length {:02X}'.format(base, pitch, length)]
        pokes['cries {}'.format(no)] = {'wFrequencyModifier': pitch, 'wTempoModifier': length}
    kinds['cries'] = {'label': 'Cries', 'request_call': 'PlaySound', 'bank': 0x02, 'update': 'Audio1_UpdateMusic',
                      'setup': {'wAudioROMBank': 0x02, 'wAudioSavedROMBank': 0x02},
                      'playing': playing_sfx, 'playing_mask': 255, 'ids': {'list': sorted(ids)},
                      'requests': requests, 'max_seconds': 4}
    cfg = {
        '_doc': __doc__.strip().split('\n\n', 1)[1].replace('\n', ' '),
        'init': 'StopAllSounds',
        'update': 'Audio1_UpdateMusic',
        'power_on': [['0xFF26', 128], ['0xFF25', 255], ['0xFF24', 119]],          # NR52, NR51, NR50
        'stack': '0xDFF0',
        '_loop_channels': 'a music channel loops when where it reads, where it returns to and its loop counter repeat',
        'loop_channels': {'count': 4, 'active': 'wChannelSoundIDs',
                          'fields': [['wChannelCommandPointers', 2], ['wChannelReturnAddresses', 2], ['wChannelLoopCounters', 1]]},
        'kinds': kinds,
        'effect_channels': {k: [0, 1, 2, 3] for k in kinds if not k.startswith('music')},
        'owner_current_first': True,
        'names': names,
        'pokes': pokes,
    }
    path = os.path.join(ROOT, 'sound.json')
    json.dump(cfg, open(path, 'w', encoding='utf-8'), indent=1, ensure_ascii=False)
    print(path, {k: len(v['ids']['list']) for k, v in kinds.items()})


if __name__ == '__main__':
    main()
