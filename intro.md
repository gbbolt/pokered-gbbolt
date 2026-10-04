# From power-on to the player's room

What the code does between switching the Game Boy on and the moment the player can first
walk around their bedroom, in the order it happens: the start-up, the shooting star and
the fight between Gengar and Nidorino, the title screen, the main menu, Professor Oak's
speech, and the loading of the first map.

## Power on

The CPU starts at `Start`, at address `$0100`. It has room for two instructions before the
cartridge header begins, so it jumps on to `_Start`. The boot ROM leaves a console ID in
register a, and `_Start` checks it for a Game Boy Color, but it stores FALSE in `wOnCGB`
either way. Then it jumps to `Init`, which builds everything up from nothing:

- interrupts off, and every I/O register that matters set to 0: scrolling, window,
  serial, timer, palettes;
- `DisableLCD` waits for VBlank and switches the screen off, so VRAM can be written freely;
- the stack goes to `wStack`, and all 8 KB of work RAM, all 8 KB of VRAM (`ClearVram`)
  and HRAM are cleared;
- `WriteDMACodeToHRAM` copies the 10-byte `DMARoutine` to HRAM. During a sprite DMA the
  CPU can only reach HRAM, so the routine that starts the DMA and waits for it has to
  live there;
- the window is pushed below the screen (`hWY` = 144), both BG maps are cleared, and the
  VBlank, timer and serial interrupts are switched on. The timer handler, `Timer`, is
  unused: it returns at once;
- `LoadSGB` checks for a Super Game Boy and, if there is one, sends it the border picture
  and the palettes.

Then `Init` calls `PlayIntro`. When the intro is over it clears VRAM once more and goes on
to `PrepareTitleScreen`. `Init` is also where the game goes back to after a soft reset:
holding A + B + SELECT + START sends `_Joypad` to `TrySoftReset`, and `SoftReset` silences
the sound, whites out the palettes, waits half a second and jumps to `Init`.

## Every frame: VBlank

There is no main loop that runs one state per frame. The game is ordinary code that calls
`DelayFrame` whenever it wants to wait for the next frame. `DelayFrame` sets
`hVBlankOccurred` and halts the CPU until the interrupt has cleared it.

Most drawing doesn't go straight to VRAM either. The code draws into `wTileMap`, a 20 x 18
copy of the screen in work RAM, and the sprites into `wShadowOAM`. The `VBlank` interrupt
then does the per-frame work:

- the scroll and window registers from their copies (`hSCX`, `hSCY`, `hWY`);
- the BG map copies: `AutoBgMapTransfer` copies a third of `wTileMap` (six rows) every
  frame, so a whole screen takes three frames. Other routines copy single rows or columns
  while the map scrolls, or tiles queued during the frame;
- the sprite DMA, through the routine in HRAM;
- `PrepareOAMData` builds the next frame's sprites from the map's sprite tables;
- `Random`, the frame counter `hFrameCounter`, the music (one of three sound engines,
  chosen by `wAudioROMBank`), the play time (`TrackPlayTime`) and the joypad
  (`ReadJoypad`).

## ROM banks

The cartridge holds 1 MB, but the CPU only sees 32 KB of ROM at a time. The first 16 KB
(bank 0, the "home" bank, `$0000-$3FFF`) are always there. The other 16 KB window,
`$4000-$7FFF`, shows one of the other 63 banks, picked by writing its number to the
cartridge's bank register.

The game keeps the number of the bank in that window in `hLoadedROMBank`. Code in one bank
calls code in another through the home bank: `Bankswitch` saves `hLoadedROMBank`, switches
to the new bank, calls the function, and switches back. `FarCopyData2` does the same for
copying graphics out of another bank, and `Predef` calls a function by number from the table
`PredefPointers`. Even `VBlank` switches banks freely, to build the sprites and run the
music, and puts the interrupted code's bank back at the end. Each map's data lives in some
bank too; `SwitchToMapRomBank` looks it up in `MapHeaderBanks`.

## Copyright and the shooting star

`PlayIntro` first calls `PlayShootingStar`. That draws the copyright screen
(`LoadCopyrightAndTextBoxTiles`) and simply waits 180 frames, 3 seconds, which no button can
skip.

Then the screen is cleared, `IntroDrawBlackBars` draws black bars 4 rows high at the top
and the bottom, and `LoadIntroGraphics` loads the tiles for the whole intro: Gengar for the
background, the Game Freak logo, and Nidorino as sprites. `AnimateShootingStar` plays the
logo scene:

- a big star of four sprites shoots down and to the left, 4 pixels each way per frame,
  until it leaves the bottom of the screen;
- the logo flashes three times, by rotating its sprite palette `rOBP0`;
- six waves of small stars fall from the logo (`MoveDownSmallStars`), 24 copies of
  `SmallStarsOAM` taking turns.

Any time during the logo, START or A cuts the scene short (`CheckForUserInterruption`). Then
the intro music starts and the middle of the screen is cleared for the fight.

## Gengar and Nidorino

`PlayIntroScene` is the fight between the bars. The two Pokémon are made in two different
ways: Gengar is drawn in the background, three tile maps switched with `IntroCopyTiles`,
while Nidorino is 6 x 6 = 36 sprites. Both move by scrolling: Gengar with `hSCX`, Nidorino by
updating its sprites (`IntroMoveMon`, `AnimateIntroNidorino`, a list of steps 5 frames
apart).

- Nidorino walks in from the left and hops twice, with a sound for each hop.
- Gengar raises its arm and slashes; Nidorino is knocked back.
- Nidorino hops again and lunges at Gengar.

Each pause between moves is a `CheckForUserInterruption`, so START or A ends the fight at any
point. `PlayIntro` fades to white and returns to `Init`.

## The title screen

`PrepareTitleScreen` puts default names into `wPlayerName` and `wRivalName` (they are
replaced later anyway), clears some story flags and selects the bank of the title music.
Then `DisplayTitleScreen` builds the screen with the LCD off:

- the font, the Nintendo and Game Freak copyright tiles, the Pokémon logo and the "Red
  Version" tiles are copied to VRAM;
- the logo is written into `wTileMap` as 6 rows of 16 tiles plus one more row;
- `DrawPlayerCharacter` places the player on the right as 7 rows of 5 sprites, and one more
  sprite puts a Poké Ball in his hand;
- the copyright line goes on the bottom row.

The first Pokémon shown, in `wTitleMonSpecies`, is Charmander (`LoadTitleMonSprite`). Then
the show begins. The screen starts scrolled down, and `hSCY` steps through a table of
(pixels, frames) pairs, so the logo drops in and bounces, with a crash sound at the first
bounce. After a pause the "Red Version" text slides in from the right with a whoosh
(`PrintGameVersionOnTitleScreen`, `ScrollTitleScreenGameVersion`), and the title music starts.

From then on the loop waits 200 frames for a button, then `TitleScreenPickNewMon` picks
another Pokémon at random from the 16 in `TitleMons` (never the one already shown), scrolls
the old one out and the new one in from the right (`TitleScreenScrollInMon`).
The list holds the three starters, Weedle, Nidoran♂, Scyther, Pikachu, Clefairy, Rhydon, Abra,
Gastly, Ditto, Pidgeotto, Onix, Ponyta and Magikarp.

START or A ends the loop. The Pokémon on screen cries (`PlayCry`), the screen fades to white,
and the game goes on to `MainMenu`. Holding Up + SELECT + B instead leads to
`DoClearSaveDialogue`: "Clear all saved data?" with NO and YES. YES wipes the cartridge RAM;
either way the game restarts at `Init`. (In a development build, SELECT here opened a debug
menu. In this game `DebugMenu` only returns.)

## The main menu

`MainMenu` sets the default options (`InitOptions`: medium text speed, battle animations
on, battle style shift) and then looks for a save file:

- `CheckForPlayerNameInSRAM` opens the cartridge RAM and checks whether the player's name
  saved there, `sPlayerName`, has its end mark. If not, there is no save at all.
- If there is a name, `TryLoadSaveFile` loads the save and checks its checksums. A bad one
  shows "The file data is destroyed!" for 100 frames.

`wSaveFileStatus` ends up 1 (no save, or a damaged one) or 2 (a good one). With a save the
menu box offers CONTINUE, NEW GAME and OPTION, otherwise only NEW GAME and OPTION.
`HandleMenuInput` moves the cursor; B goes back to the title screen.

- OPTION opens `DisplayOptionMenu` and comes back to this menu.
- CONTINUE shows a summary of the save (`DisplayContinueGameInfo`): the player's name, the
  number of badges, the Pokédex count and the play time. A starts the game on the saved map
  through `SpecialEnterMap`; B goes back to the menu.
- NEW GAME calls `StartNewGame`.

## Professor Oak

`StartNewGame` clears the debug flag and calls `OakSpeech`, which starts the music and wipes
the slate for a new game:

- `PrepareOakSpeech` clears the player's entire save data in RAM, from `wPlayerName` to the
  end of the box data, but keeps the options;
- `InitPlayerData2` rolls a random trainer ID into `wPlayerID`, empties the party, the box,
  the bag and the PC, gives 3000 money, no badges and no coins;
- a Potion goes into the PC;
- `PrepareForSpecialWarp` already loads the destination of the first warp, the player's
  room (more on that below).

Then the speech itself. Each picture is decompressed into VRAM and placed on the screen by
`IntroDisplayPicCenteredOrUpperRight`, and comes in either by fading in through six palettes
(`FadeInIntroPic`) or by sliding in from the right, 8 pixels a frame (`MovePicLeft`).

- Professor Oak fades in: "Hello there! Welcome to the world of POKéMON!"
- A Nidorino slides in, mirrored, while he explains what Pokémon are. The cry that plays
  during his words is Nidorina's, not Nidorino's.
- The player slides in: "First, what is your name?"

`ChoosePlayerName` slides the picture to the right and shows a list next to it: NEW NAME,
RED, ASH and JACK. Picking one of the names slides the picture back. NEW NAME opens the
naming screen, `DisplayNamingScreen`:

- a letter grid in a box, with ED at the end and a switch between upper and lower case;
- the D-pad moves the cursor and wraps around the edges, A types a letter, B deletes the
  last one, SELECT switches the case, START or ED finishes;
- the player's name can have up to 7 letters, and an empty name is asked for again.

The same happens for the rival in `ChooseRivalName`, whose picture fades in: "This is my
grandson. He's been your rival since you were a baby." The defaults are BLUE, GARY and JOHN.

At the end the player stands in the middle of the screen again, and Oak says "Your very
own POKéMON legend is about to unfold!" A shrinking sound plays, and the big picture is
replaced by two smaller ones (`ShrinkPic1`, then `ShrinkPic2`), 4 frames apart, until only
the player's walking sprite is left, its tiles copied from `RedSprite`. The music fades out,
the screen fades to white, and `StartNewGame` hands over to `SpecialEnterMap`, which starts
the play time clock and calls `EnterMap`.

## Where the game begins

A new game doesn't use a warp tile to get into the first map. `LoadSpecialWarpData` (called
from `PrepareForSpecialWarp` during the speech) copies a fixed 8-byte entry, `NewGameWarp`,
into `wCurMap` and the bytes after it:

- the map: the second floor of the player's house, their room;
- the position of the view in the block map and the player's coordinates: 3 steps from the
  left, 6 from the top;
- the tileset, in `wCurMapTileset`.

Pallet Town is stored as the map to return to (`wLastMap`): walking out of the house leads
there.

## Loading the room

`EnterMap` ignores all buttons while it works (`wJoyIgnore`) and calls `LoadMapData`, which
turns the LCD off and builds the map:

- `LoadMapHeader` switches to the map's bank and copies the header pointed to by
  `MapHeaderPointers`. The room's header, `RedsHouse2F_h`, says: the house tileset,
  4 x 4 blocks, the blocks in `RedsHouse2F_Blocks`, the script `RedsHouse2F_Script`, and no
  connections to other maps.
- The object data, `RedsHouse2F_Object`, comes next: the block that fills the space around
  the map, one warp (the stairs in the top right corner, down to the ground floor,
  `RedsHouse1F_h`), no signs and no people. The header loader also reads the wild Pokémon (none here) and the map's
  music from `MapSongBanks`: the Pallet Town theme.
- `InitMapSprites` loads the graphics for the people on the map. In the player's room
  there are none.
- `LoadTileBlockMap` builds `wOverworldMap`: the map's 16 blocks with a border of 3 blocks on
  every side. A block is 4 x 4 tiles, and the player walks in steps of half a block.
- `LoadTilesetTilePatternData` copies the tileset's 96 tiles to VRAM.
- `LoadCurrentMapView` draws the 6 x 5 blocks around the player into `wSurroundingTiles`
  and copies the 20 x 18 tiles of the screen out of it into `wTileMap`, which goes straight
  to the BG map while the LCD is still off.

Then the LCD goes back on with the overworld palette, `LoadPlayerSpriteGraphics` loads the
player's walking sprite, and `PlayDefaultMusicFadeOutCurrent` starts the map's music.

There are things in the room that are not in the object data. The PC in the top left corner
and the game console on the floor are hidden events (`HiddenEventsFor_REDS_HOUSE_2F`): they
have no sprite and are checked only when the player presses A in front of them
(`OpenRedsPC`, `PrintRedSNESText`).

## The overworld loop

`EnterMap` updates the sprites, clears `wJoyIgnore` and jumps to `OverworldLoop`, which it
never leaves. Each round, `OverworldLoop` waits for the next frame and runs
`OverworldLoopLessDelay`:

- While a step is in progress (`wWalkCounter` not 0), it goes on with the step.
- Otherwise `JoypadOverworld` first runs the map's script (`RunMapScript`) and then reads the
  joypad (`Joypad`). The very first time, the room's script, `RedsHouse2FDefaultScript`,
  turns the player to face up and moves on to `RedsHouse2FNoopScript`, which does nothing,
  for the rest of the game.
- START opens the start menu, and A talks to whoever stands in front of the player or
  checks the hidden events.
- A direction held turns the player and sets the step vector. If `CollisionCheckOnLand`
  finds the way free, `wWalkCounter` is set to 8 and `AdvancePlayerSprite` moves the map 2
  pixels per frame: a step of 16 pixels takes 8 frames.

From this frame on, the player is in control: standing in the bedroom, facing up, with the
stairs down in the corner.
