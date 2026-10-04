# Pokémon Red (Game Boy) - gbbolt disassembly

**Open it: <https://gbbolt.lingora.org/pokered/>**

A complete, matching disassembly of *Pokémon Red* for the Game Boy (Game Freak / Nintendo, 1996),
with pseudo-code written next to every function. It is read with
[gbbolt](https://github.com/AlexanderStebner/gbbolt): code and pseudo-code side by side, each short
piece of Python directly above the few instructions that do it.

## Based on pret/pokered

The assembly and its annotations - labels, RAM and constant names, comments and the
understanding of what the code does - come from the [pret/pokered](https://github.com/pret/pokered)
disassembly by the pret community. This project builds on their work: it was the guide to where
everything is and what it means.

What is new here:

- **Pseudo-code for every function** (2,925 of them), in game terms, following the assembly line by line.
  1,028 are verified by differential testing: the pseudo-code and the original code give identical
  results on random machine states. Most of the others are checked: they wait for VBlank, run
  through a pointer or a script engine, or never return, so they can't run in isolation.
- **One flat, self-contained source.** Every macro is written out, and all graphics, maps and other
  data are in the source as bytes (`db`), not extracted files. What you read is what the ROM contains.
- **Descriptions and folders**: every function has a description and sits in a virtual folder
  (`engine/battle`, `engine/overworld`, `home/text`, `scripts/...`, `audio/...`).
- **A book chapter** on what the game does from power-on to the moment the player can move (`intro.md`).
- **Assets, drawn from the ROM by plugins in `assets/`:**
  - a Pokédex card for each of the 151 Pokémon, with their pictures in Super Game Boy colours;
  - all maps with their objects, warps, signs and trainers, the whole of Kanto stitched together,
    and the Town Map;
  - 13 screens drawn by the game's own code;
  - sheets: moves, items, trainers, wild encounters, the type chart, marts, trades, prizes,
    gift Pokémon, fishing, evolution families, growth curves, the TM/HM grid, badges, the
    character set and the credits;
  - the frames of 158 move animations, tilesets with their tile properties, and the palettes.
- **Sound**: the three copies of the sound engine are annotated; the songs, sound effects and all
  151 cries are rendered from it, with a piano roll and mute / solo per channel.

Some things the code shows:

- Focus Energy halves the chance of a critical hit instead of raising it.
- A Poké Ball thrown at any transformed Pokémon treats it as a Ditto.
- The Card Key reads a byte of program code where it means to read the tile in front of the
  player.
- Walking people can drift down and to the right without limit, but get stuck after five
  steps up.
- One of the in-game trades is never offered by anyone.

## Building

The disassembly rebuilds the original ROM byte for byte. You need
[RGBDS](https://rgbds.gbdev.io) 1.0.1, Python 3.9+ with numpy, and gbbolt next to this folder:

```
git clone https://github.com/AlexanderStebner/gbbolt
git clone https://github.com/AlexanderStebner/pokered-gbbolt
cd pokered-gbbolt
python ../gbbolt/tools/audio.py             # render the music (needs ffmpeg)
python ../gbbolt/tools/gbbolt.py            # build, verify, write out/site/index.html
```

The build is checked against the SHA1 of the original ROM
(`ea9bcae617fdf159b045185467ae58b2e4a48b9a`, *Pokémon - Red Version (USA, Europe)*). No ROM is
needed to build it. If you put your own dump next to `game.json` as `pokered.gb`, it is compared
byte by byte.

## Layout

```
game.json           what gbbolt needs to know about the game
home.asm            bank 0: the code every bank can call
main.asm            the game's engine: overworld, battle, menus, items, Pokémon data
maps.asm            map headers, objects and scripts
text.asm            the game's texts
audio.asm           the three sound engines with their songs, sound effects and cries
ram.asm             RAM variables: names, types, descriptions
gfx/*.asm           Pokémon pictures, sprites and tilesets
constants/          constants
includes.asm        the constants every file includes
layout.link         which section goes in which bank
intro.md            the book chapter
sound.json          how to drive the sound engine
tools/              game helpers for the pseudo-code and the viewer
assets/*.py         asset plugins
```

## Legal

Pokémon and its code, graphics, music and text are the property of their respective owners
(Nintendo, Game Freak, Creatures). This repository contains no ROM. It is a research and
documentation project in the tradition of other community disassemblies; please buy the game.

The labels, names and comments taken from pret/pokered belong to its contributors. The
pseudo-code, descriptions, folders, plugins and configuration written for this project are
available under the MIT license (see [LICENSE](LICENSE)), as far as they are separable from the
game and from pret's work.
