"""Screens as the game draws them: the game's own drawing routine runs once from a plain start (the power-on
setup of Init, no save file), and the picture is what it leaves in VRAM and in the sprite buffer at the moment
it starts to wait for a button."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build as engine  # noqa: E402
from _pkdata import Game, pal_name  # noqa: E402
from _pkrun import Runner, StepLimit  # noqa: E402

GROUP = 'screens'
PAD_START = 0x08
STEPS = 4000000


def F(g, label):
    return engine.fmt_rom(g.at(label))


def build(ctx):
    g = Game(ctx)
    g.species()
    r = Runner(ctx)
    r.call('Init', stop=['PlayIntro'], max_steps=5000000)       # the power-on setup, up to the intro movie
    for f in ('LoadFontTilePatterns', 'LoadTextBoxTilePatterns'):   # the font, as the title screen leaves it
        r.call(f)
    r.set('hDisableJoypadPolling', 0)
    r.set('wOnSGB', 1)                            # a Super Game Boy: the screens send their colour packets
    boot = r.snapshot()
    out = []
    sgb = g.sgb_palettes()

    def coloured(img):
        """The screen with the Super Game Boy's colours: pixel = 4 x palette (0-3, by the ATTR_BLK areas) +
        shade; colour 0 of palette 0 is the background of all four."""
        attr, pals = r.sgb_screen()
        if not pals or any(p >= len(sgb) for p in pals):
            return img, None
        cols = []
        for k, p in enumerate(pals):
            c = list(sgb[p][1])
            c[0] = sgb[pals[0]][1][0]
            cols += c
        return [bytearray(4 * attr[y >> 3][x >> 3] + v for x, v in enumerate(row)) for y, row in enumerate(img)], cols

    def shot(name, title, routine, source, doc, users, how='wTileMap', setup=None, stop=None, frames=None,
             after=None, cond=None):
        import time
        t0 = time.time()
        r.restore(boot)
        try:
            if setup:
                setup()
            got = r.call(routine, stop=stop, frames=frames, max_steps=STEPS)
            while got and cond and not cond():
                r.cpu.step()
                got = r.resume(stop=stop, max_steps=STEPS)
        except StepLimit as e:
            if os.environ.get('K2DEV'):
                print(name, 'step limit', e)
        if os.environ.get('K2DEV'):
            print(name, round(time.time() - t0, 1), 's', r.frames, 'frames')
        if after:
            after()
        if not r.mem[0xFF47]:                      # still faded to white: show it with GBPalNormal's palettes
            r.mem[0xFF47], r.mem[0xFF48], r.mem[0xFF49] = 0xE4, 0xD0, 0xE0
        frame = r.screen(how)
        if name == 'ScreenTitle':
            ctx.poster(frame, 'title')          # gen/screens_title.png: the hub's thumbnail
        img, colors = coloured(frame)
        out.append({'name': name, 'type': 'image', 'title': title, 'subtitle': 'drawn by ' + routine,
                    'source': source, 'width': 160, 'height': 144, 'pixels': ctx.pixels(img), 'scale': 3,
                    'doc': doc + (['On a Super Game Boy the screen is coloured with {} (pick "colour" above).'.format(
                        ', '.join(sorted({pal_name(sgb[p][0]) for p in r.sgb_screen()[1]})))] if colors else []),
                    'users': users, 'unit': routine, 'colors': colors})

    # ---- the copyright screen: the first thing PlayIntro shows, for three seconds
    shot('ScreenCopyright', 'Copyright screen', 'PlayIntro',
         'text at {}, tiles at {}'.format(F(g, 'CopyrightTextString'), F(g, 'NintendoCopyrightLogoGraphics')),
         ['The copyright screen, the first screen after power-on: PlayShootingStar calls LoadCopyrightAndTextBoxTiles, '
          'which loads the © and logo tiles (NintendoCopyrightLogoGraphics, GameFreakLogoGraphics) and prints '
          'CopyrightTextString, then waits 180 frames.'],
         ['PlayShootingStar', 'LoadCopyrightAndTextBoxTiles', 'LoadCopyrightTiles'], stop=['DelayFrames'],
         cond=lambda: r.cpu.c == 180)

    # ---- the title screen, once the logo has bounced and the version has slid in
    shot('ScreenTitle', 'Title screen', 'PrepareTitleScreen',
         'logo tiles at {}, version tiles at {}, title Pokémon list at {}'.format(
             F(g, 'PokemonLogoGraphics'), F(g, 'Version_GFX'), F(g, 'TitleMons')),
         ['The title screen as DisplayTitleScreen leaves it when it starts waiting for a button: the Pokémon logo '
          '(PokemonLogoGraphics, placed tile by tile), "Red Version" (Version_GFX), the player holding a Poké Ball '
          '(sprites from DrawPlayerCharacter), the copyright line and the first title Pokémon, Charmander. '
          'Every few seconds TitleScreenPickNewMon scrolls in another one from TitleMons.'],
         ['DisplayTitleScreen', 'DrawPlayerCharacter', 'LoadTitleMonSprite', 'TitleScreenPickNewMon'],
         how='bg', stop=['DisplayTitleScreen.awaitUserInterruptionLoop'])

    # ---- the main menu without a save file
    shot('ScreenMainMenu', 'Main menu', 'MainMenu',
         'text at {}'.format(F(g, 'NewGameText')),
         ['The main menu as it is with no save file: CheckForPlayerNameInSRAM finds no name, so MainMenu draws the '
          'two-line box with NEW GAME and OPTION (NewGameText). With a save file the box has CONTINUE on top.'],
         ['MainMenu', 'HandleMenuInput'], stop=['HandleMenuInput_.loop1', 'HandleMenuInput'], after=lambda: r.resume(frames=3))

    # ---- the naming screen's keyboard
    def naming():
        r.set('wNamingScreenType', 0)
        r.cpu.setp('hl', r.addr('wPlayerName'))
    shot('ScreenNaming', 'Naming screen', 'DisplayNamingScreen',
         'upper case letters at {}, lower case at {}'.format(F(g, 'UpperCaseAlphabet'), F(g, 'LowerCaseAlphabet')),
         ['The naming screen for the player\'s name: a box with the alphabet (UpperCaseAlphabet; "lower case" '
          'switches to LowerCaseAlphabet), "YOUR NAME?" from PrintNamingText, the name so far with underscores, and '
          'the cursor on A.'],
         ['DisplayNamingScreen', 'PrintAlphabet', 'PrintNamingText', 'PrintNicknameAndUnderscores'],
         setup=naming, stop=['DisplayNamingScreen.inputLoop'])

    # ---- the plain new-game state the menus below read: the player's name, ₽3000, the Pokédex
    def player(pokedex=True, badges=0):
        r.fill('wPlayerName', r.char_codes('RED'))
        r.fill('wRivalName', r.char_codes('BLUE'))
        r.fill('wPlayerMoney', bytes([0x00, 0x30, 0x00]))
        r.set('wObtainedBadges', badges)
        if pokedex:
            ev = g.const('EVENT_GOT_POKEDEX', 0x25)
            r.set('wEventFlags', r.get('wEventFlags', ev // 8) | 1 << (ev % 8), ev // 8)

    def starter():
        player()
        r.set('wCurPartySpecies', g.by_dex[4]['internal'])
        r.set('wCurEnemyLevel', 5)
        r.set('wMonDataLocation', 0x10)          # the player's party, without the nickname question
        r.call('AddPartyMon')
        sp = g.by_dex[4]['internal']
        name = g.at('MonsterNames') + 10 * (sp - 1)
        r.fill('wPartyMonNicks', bytes(g.rom[name:name + 10]) + b'P')   # the species name, as when not naming it

    shot('ScreenStartMenu', 'Start menu', 'DisplayStartMenu',
         'menu texts at {}'.format(F(g, 'StartMenuPokedexText')),
         ['The START menu once the player has the Pokédex (DrawStartMenu leaves POKéDEX out before that): POKéDEX, '
          'POKéMON, ITEM, the player\'s name, SAVE, OPTION and EXIT in a box on the right. In the game it opens over '
          'the map.'],
         ['DisplayStartMenu', 'DrawStartMenu', 'PrintStartMenuItem'], setup=player,
         stop=['HandleMenuInput'], after=lambda: r.resume(frames=3))

    shot('ScreenPartyMenu', 'Party menu', 'DisplayPartyMenu',
         'party icons: which icon each Pokémon has at {}, icon tiles from {}'.format(F(g, 'MonPartyData'), F(g, 'MonPartySpritePointers')),
         ['The party menu with the Pokémon the player starts with: Charmander at level 5, the party AddPartyMon '
          'builds when it is picked in Oak\'s lab. Each line has the Pokémon\'s little icon (an animated sprite; '
          'MonPartyData picks one of the icon kinds for every species), its name, level, HP bar and HP.'],
         ['DisplayPartyMenu', 'DrawPartyMenu', 'LoadMonPartySpriteGfx', 'WriteMonPartySpriteOAMBySpecies'],
         setup=starter, stop=['HandlePartyMenuInput'], after=lambda: r.resume(frames=2))

    for badges, nm, ttl, extra in ((0, 'ScreenTrainerCard', 'Trainer card', 'with no badges yet: the eight gym '
                                    'leaders\' faces wait in the badge case'),
                                   (0xFF, 'ScreenTrainerCardBadges', 'Trainer card (all badges)',
                                    'as it looks once all eight badges are won (wObtainedBadges = $FF): each won '
                                    'badge replaces its leader\'s face')):
        shot(nm, ttl, 'StartMenu_TrainerInfo',
             'card tiles at {}, leader faces at {}, badge tiles at {}'.format(
                 F(g, 'TrainerInfoTextBoxTileGraphics'), F(g, 'BlankLeaderNames'), F(g, 'BadgeNumbersTileGraphics')),
             ['The trainer card from the START menu: the player\'s picture (RedPicFront), NAME, MONEY (₽3000, what a '
              'new game starts with) and TIME, and the badge case drawn by DrawBadges - {}.'.format(extra)],
             ['StartMenu_TrainerInfo', 'DrawTrainerInfo', 'DrawBadges'], setup=lambda b=badges: player(badges=b),
             stop=['WaitForTextScrollButtonPress'])

    def dex_entry():
        player()
        r.set('wPokedexNum', g.by_dex[1]['internal'])
        r.set('wPokedexOwned', 1)
        r.set('wPokedexSeen', 1)
    shot('ScreenPokedexEntry', 'Pokédex entry', 'ShowPokedexData',
         'Pokédex tiles at {}, Bulbasaur\'s entry at {}'.format(F(g, 'PokedexTileGraphics'), engine.fmt_rom(g.dex_entry(g.by_dex[1]['internal'])['addr'])),
         ['A Pokédex entry: Bulbasaur, as it shows up once it is owned. ShowPokedexDataInternal frames the screen '
          'with the Pokédex tiles, puts the picture top left, the name, the species and No. 001, height and weight, '
          'and the entry text underneath; a Pokémon only seen gets the name and number alone.'],
         ['ShowPokedexData', 'ShowPokedexDataInternal'], setup=dex_entry, stop=['WaitForTextScrollButtonPress'])

    shot('ScreenPokedexList', 'Pokédex list', 'ShowPokedexMenu',
         'menu text at {}'.format(F(g, 'PokedexMenuItemsText')),
         ['The Pokédex list at the start of the game, with nothing seen yet: numbers with dashes in place of the '
          'names, SEEN and OWN counts, and the DATA / CRY / AREA / QUIT side menu that works on the chosen Pokémon.'],
         ['ShowPokedexMenu', 'HandlePokedexListMenu'], setup=player, stop=['HandleMenuInput'],
         after=lambda: r.resume(frames=2))

    def slots():
        player()
        r.call('LoadSlotMachineTiles')
        r.call('LoadFontTilePatterns')
        r.call('GBPalNormal')
        r.mem[0xFF48] = 0xE4
    shot('ScreenSlots', 'Slot machine', 'MainSlotMachineLoop',
         'tiles at {} and {}'.format(F(g, 'SlotMachineTiles1'), F(g, 'SlotMachineTiles2')),
         ['The Game Corner slot machine, the moment it asks for a bet: LoadSlotMachineTiles draws the cabinet with '
          'the three wheels (their symbols are sprites), MainSlotMachineLoop prints the coin counters and the '
          '"Bet how many coins?" box with 3, 2 and 1. A new game has no coins, so the credit reads 0.'],
         ['PromptUserToPlaySlots', 'LoadSlotMachineTiles', 'MainSlotMachineLoop'], setup=slots,
         stop=['HandleMenuInput'], after=lambda: r.resume(frames=2))

    # ---- a battle: the starter against a wild Pidgey (level 3, as on Route 1), at the battle menu
    def battle():
        starter()
        r.set('wCurOpponent', g.by_dex[16]['internal'])
        r.set('wCurEnemyLevel', 3)
        r.tap = 0x01                              # A now and then: page through "Wild PIDGEY appeared!" and "Go!"

    def battle_menu():
        r.tap = 0
        r.resume(frames=6)
    shot('ScreenBattle', 'Battle screen', 'InitBattle',
         'HUD tiles at {}, battle menu text at {}'.format(F(g, 'BattleHudTiles1'), F(g, 'BattleMenuText')),
         ['The battle screen with its HUD: the wild Pokémon\'s picture top right, its name, level and HP bar top '
          'left (DrawEnemyHUDAndHPBar); the player\'s Pokémon from behind bottom left, its name, level, HP bar and '
          'HP on the right (DrawPlayerHUDAndHPBar); and the FIGHT / PKMN / ITEM / RUN menu. Set up as the first wild battle of a '
          'game: the starter (Charmander, level 5) against a level 3 Pidgey; the texts before the menu were paged '
          'through with A.'],
         ['InitBattle', 'InitWildBattle', 'DrawPlayerHUDAndHPBar', 'DrawEnemyHUDAndHPBar', 'DisplayBattleMenu'],
         setup=battle, stop=['DisplayBattleMenu'], after=battle_menu)

    # ---- "The End": the last credits screen. The Hall of Fame scene before it is skipped; the credits start at
    # their last command, CRED_THE_END
    order, end = g.at('CreditsOrder'), g.at('CreditsOrder')
    while g.rom[end] != 0xFA and end < order + 400:
        end += 1

    def the_end():
        r.skip('AnimateHallOfFame')
    def to_end():
        r.cpu.push(g.lin(0, 0) + (g.syms['CreditsOrder'] + end - order))
        r.cpu.pc = r.addr('Credits.nextCreditsScreen')
    shot_end = dict(name='ScreenTheEnd', title='The End', routine='HallOfFamePC',
                    source='"THE END" tiles at {}, text at {}, credits list at {}'.format(
                        F(g, 'TheEndGfx'), F(g, 'TheEndTextString'), F(g, 'CreditsOrder')),
                    doc=['The very last screen: after the Hall of Fame and the credits, CRED_THE_END in CreditsOrder '
                         'loads the big letters of TheEndGfx and prints TheEndTextString with them, between the black '
                         'bars the credits run in.'],
                    users=['HallOfFamePC', 'Credits'])
    r.restore(boot)
    the_end()
    try:
        r.call('HallOfFamePC', stop=['Credits'], max_steps=20000000)
        to_end()
        r.resume(stop=['DelayFrames'], max_steps=STEPS)      # after FillMiddleOfScreenWithWhite: 16 frames first
        r.resume(frames=150, max_steps=STEPS)                # the letters, then FadeInCredits
    except StepLimit:
        pass
    if not r.mem[0xFF47]:
        r.mem[0xFF47] = 0xE4
    img, cols = coloured(r.screen('wTileMap'))
    out.append({'name': shot_end['name'], 'type': 'image', 'title': shot_end['title'], 'colors': cols,
                'subtitle': 'drawn by Credits', 'source': shot_end['source'], 'width': 160, 'height': 144,
                'pixels': ctx.pixels(img), 'scale': 3, 'doc': shot_end['doc'],
                'users': shot_end['users'], 'unit': 'Credits'})
    r.hooks.pop(r.addr('AnimateHallOfFame'), None)
    return out
