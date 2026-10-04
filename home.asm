SECTION "NULL", ROM0
;@ path: home
NULL::

; rst vectors (unused)

SECTION "rst0", ROM0[$0000]
	rst $38

	ds $08 - @, 0 ; unused

SECTION "rst8", ROM0[$0008]
	rst $38

	ds $10 - @, 0 ; unused

SECTION "rst10", ROM0[$0010]
	rst $38

	ds $18 - @, 0 ; unused

SECTION "rst18", ROM0[$0018]
	rst $38

	ds $20 - @, 0 ; unused

SECTION "rst20", ROM0[$0020]
	rst $38

	ds $28 - @, 0 ; unused

SECTION "rst28", ROM0[$0028]
	rst $38

	ds $30 - @, 0 ; unused

SECTION "rst30", ROM0[$0030]
	rst $38

	ds $38 - @, 0 ; unused

SECTION "rst38", ROM0[$0038]
	rst $38

	ds $40 - @, 0 ; unused


; Game Boy hardware interrupts

SECTION "vblank", ROM0[$0040]
	jp VBlank

	ds $48 - @, 0 ; unused

SECTION "lcd", ROM0[$0048]
	rst $38

	ds $50 - @, 0 ; unused

SECTION "timer", ROM0[$0050]
	jp Timer

	ds $58 - @, 0 ; unused

SECTION "serial", ROM0[$0058]
	jp Serial

	ds $60 - @, 0 ; unused

SECTION "joypad", ROM0[$0060]
	reti


SECTION "Header", ROM0[$0100]

;@ path: home/header
;@ def Start(bootup: a)
;@ Where the CPU starts after the boot ROM: on to _Start, past the cartridge header.
;@ test: skip goes on into the game's startup and never returns
Start::
; Nintendo requires all Game Boy ROMs to begin with a nop ($00) and a jp ($C3)
; to the starting address.
;> _Start(bootup)
	nop
	jp _Start

; The Game Boy cartridge header data is patched over by rgbfix.
; This makes sure it doesn't get used for anything else.

	ds $0150 - @

ENDSECTION


SECTION "High Home", ROM0

;@ path: home/lcd
;@ def DisableLCD()
;@ Switch the LCD off. That is only safe during VBlank, so it waits for line LY_VBLANK + 1 with the VBlank
;@ interrupt masked, then clears the enable bit of rLCDC.
;@ test: skip waits for the LCD to reach VBlank
DisableLCD::
;> rIF = 0
	xor a
	ldh [rIF], a
;> enabled = rIE
	ldh a, [rIE]
	ld b, a
;> rIE = enabled & ~(1 << B_IE_VBLANK) # no VBlank interrupt meanwhile
	res B_IE_VBLANK, a
	ldh [rIE], a

.wait
;> wait_ly(LY_VBLANK + 1)              # the LCD may only be switched off in VBlank
	ldh a, [rLY]
	cp LY_VBLANK + 1
	jr nz, .wait

;> rLCDC = rLCDC & ~LCDC_ON
	ldh a, [rLCDC]
	and ~LCDC_ON
	ldh [rLCDC], a
;> rIE = enabled
	ld a, b
	ldh [rIE], a
	ret

;@ path: home/lcd
;@ def EnableLCD()
;@ Switch the LCD back on.
EnableLCD::
;> rLCDC = rLCDC | 1 << B_LCDC_ENABLE
	ldh a, [rLCDC]
	set B_LCDC_ENABLE, a
	ldh [rLCDC], a
	ret
;@ path: home/clear_sprites
;@ def ClearSprites()
;@ Zero the whole shadow OAM, so every sprite sits off screen at (0, 0).
ClearSprites::
;> fill(wShadowOAM, 0, OAM_COUNT * OBJ_SIZE)
	xor a
	ld hl, wShadowOAM
	ld b, wShadowOAMEnd - wShadowOAM
.loop
	ld [hli], a
	dec b
	jr nz, .loop
;> return
	ret

;@ path: home/clear_sprites
;@ def HideSprites()
;@ Move all 40 sprites below the bottom of the screen without touching their tiles and attributes.
HideSprites::
;>@each for i in range(OAM_COUNT):
	ld a, SCREEN_HEIGHT_PX + OAM_Y_OFS
	ld hl, wShadowOAMSprite00YCoord
	ld de, OBJ_SIZE
	ld b, OAM_COUNT
;>     mem[addr(wShadowOAMSprite00YCoord) + i * OBJ_SIZE] = SCREEN_HEIGHT_PX + OAM_Y_OFS   # below the screen
.loop
	ld [hl], a
	add hl, de
;=@each
	dec b
	jr nz, .loop
	ret
;@ def FarCopyData(bank: a, src: hl, dest: de, count: bc)
;@ Copy count bytes from src in ROM bank `bank` to dest, then switch the bank that was in back in.
;@ path: lib/memory
;@ test: bank = rand(1, 0x2C); count = rand(1, 64); src = rand(0x4000, 0x7FB0); dest = rand_ram(64)
FarCopyData::
; Copy bc bytes from a:hl to de.
;> wBuffer[0] = bank
	ld [wBuffer], a
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
	ld a, [wBuffer]
;> hLoadedROMBank = bank
;> set_rom_bank(bank)
	ldh [hLoadedROMBank], a
	ld [rROMB], a
;> CopyData(src, dest, count)
	call CopyData
;> hLoadedROMBank = saved
;> set_rom_bank(saved)
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret

;@ def CopyData(src: hl, dest: de, count: bc) -> (hl, de)
;@ Copy count bytes from src to dest, one at a time and upwards. Returns both pointers just past the copy.
;@ path: lib/memory
;@ test: count = rand(1, 200); src = rand_ram(200); dest = rand_ram(200)
CopyData::
; Copy bc bytes from hl to de.
;>@loop for i in range(count):
;>     mem[dest + i] = mem[src + i]
	ld a, [hli]
	ld [de], a
	inc de
;=@loop
	dec bc
	ld a, c
	or b
	jr nz, CopyData
;> return (src + count, dest + count)
	ret


SECTION "Home", ROM0

;@ path: home/start
;@ def _Start(bootup: a)
;@ The boot ROM leaves a console ID in a; the game checks for a Game Boy Color but stores FALSE in wOnCGB
;@ either way, then initializes everything.
;@ test: skip goes on into Init and never returns
_Start::
;> wOnCGB = 0    # FALSE on every console
	cp BOOTUP_A_CGB
	jr z, .cgb
	xor a
	jr .ok
.cgb
	ld a, FALSE
.ok
	ld [wOnCGB], a
;> Init()
	jp Init
;@ path: home/joypad
;@ def ReadJoypad()
;@ Read all eight buttons into hJoyInput, a set bit for a pressed button: the direction keys in the high
;@ nybble, A, B, Select and Start in the low one. Each group is read several times to let the lines settle.
ReadJoypad::
; Poll joypad input.
; Unlike the hardware register, button
; presses are indicated by a set bit.

;> rJOYP = 1 << 5                      # select the direction keys
	ld a, 1 << 5 ; select direction keys
	ld c, 0

	ldh [rJOYP], a
;> keys = rJOYP                        # read six times: the last read counts, once the lines have settled
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
;> dpad = ~keys & 0xF                  # the hardware clears a bit for a pressed key
	cpl
	and %1111
;> high = dpad << 4                    # the direction keys go in the high nybble
	swap a
	ld b, a

;> rJOYP = 1 << 4                      # select A, B, Select and Start
	ld a, 1 << 4 ; select button keys
	ldh [rJOYP], a
;>@read for _ in range(10):            # read ten times (written out)
;>     keys = rJOYP
	ldh a, [rJOYP]
;=@read
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
;=@read
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
;> buttons = ~keys & 0xF
	cpl
	and %1111
;> hJoyInput = high | buttons
	or b

	ldh [hJoyInput], a

;> rJOYP = 1 << 4 | 1 << 5             # deselect both groups
	ld a, 1 << 4 + 1 << 5 ; deselect keys
	ldh [rJOYP], a
	ret

;@ path: home/joypad
;@ def Joypad()
;@ Update hJoyHeld, hJoyPressed and hJoyReleased from the last joypad read (_Joypad, in its own bank).
Joypad::
; Update the joypad state variables:
; [hJoyReleased]  keys released since last time
; [hJoyPressed]   keys pressed since last time
; [hJoyHeld] currently pressed keys
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(_Joypad)
	ld a, BANK(_Joypad)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(_Joypad))
	ld [rROMB], a
;> _Joypad()
	call _Joypad
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret

; see also MapHeaderBanks
;@ path: data/maps/map_header_pointers
MapHeaderPointers::
	dw PalletTown_h
	dw ViridianCity_h
	dw PewterCity_h
	dw CeruleanCity_h
	dw LavenderTown_h
	dw VermilionCity_h
	dw CeladonCity_h
	dw FuchsiaCity_h
	dw CinnabarIsland_h
	dw IndigoPlateau_h
	dw SaffronCity_h
	dw SaffronCity_h ; UNUSED_MAP_0B
	dw Route1_h
	dw Route2_h
	dw Route3_h
	dw Route4_h
	dw Route5_h
	dw Route6_h
	dw Route7_h
	dw Route8_h
	dw Route9_h
	dw Route10_h
	dw Route11_h
	dw Route12_h
	dw Route13_h
	dw Route14_h
	dw Route15_h
	dw Route16_h
	dw Route17_h
	dw Route18_h
	dw Route19_h
	dw Route20_h
	dw Route21_h
	dw Route22_h
	dw Route23_h
	dw Route24_h
	dw Route25_h
	dw RedsHouse1F_h
	dw RedsHouse2F_h
	dw BluesHouse_h
	dw OaksLab_h
	dw ViridianPokecenter_h
	dw ViridianMart_h
	dw ViridianSchoolHouse_h
	dw ViridianNicknameHouse_h
	dw ViridianGym_h
	dw DiglettsCaveRoute2_h
	dw ViridianForestNorthGate_h
	dw Route2TradeHouse_h
	dw Route2Gate_h
	dw ViridianForestSouthGate_h
	dw ViridianForest_h
	dw Museum1F_h
	dw Museum2F_h
	dw PewterGym_h
	dw PewterNidoranHouse_h
	dw PewterMart_h
	dw PewterSpeechHouse_h
	dw PewterPokecenter_h
	dw MtMoon1F_h
	dw MtMoonB1F_h
	dw MtMoonB2F_h
	dw CeruleanTrashedHouse_h
	dw CeruleanTradeHouse_h
	dw CeruleanPokecenter_h
	dw CeruleanGym_h
	dw BikeShop_h
	dw CeruleanMart_h
	dw MtMoonPokecenter_h
	dw CeruleanTrashedHouse_h ; CERULEAN_TRASHED_HOUSE_COPY
	dw Route5Gate_h
	dw UndergroundPathRoute5_h
	dw Daycare_h
	dw Route6Gate_h
	dw UndergroundPathRoute6_h
	dw UndergroundPathRoute6_h ; UNDERGROUND_PATH_ROUTE_6_COPY
	dw Route7Gate_h
	dw UndergroundPathRoute7_h
	dw UndergroundPathRoute7Copy_h
	dw Route8Gate_h
	dw UndergroundPathRoute8_h
	dw RockTunnelPokecenter_h
	dw RockTunnel1F_h
	dw PowerPlant_h
	dw Route11Gate1F_h
	dw DiglettsCaveRoute11_h
	dw Route11Gate2F_h
	dw Route12Gate1F_h
	dw BillsHouse_h
	dw VermilionPokecenter_h
	dw PokemonFanClub_h
	dw VermilionMart_h
	dw VermilionGym_h
	dw VermilionPidgeyHouse_h
	dw VermilionDock_h
	dw SSAnne1F_h
	dw SSAnne2F_h
	dw SSAnne3F_h
	dw SSAnneB1F_h
	dw SSAnneBow_h
	dw SSAnneKitchen_h
	dw SSAnneCaptainsRoom_h
	dw SSAnne1FRooms_h
	dw SSAnne2FRooms_h
	dw SSAnneB1FRooms_h
	dw LancesRoom_h ; UNUSED_MAP_69
	dw LancesRoom_h ; UNUSED_MAP_6A
	dw LancesRoom_h ; UNUSED_MAP_6B
	dw VictoryRoad1F_h
	dw LancesRoom_h ; UNUSED_MAP_6D
	dw LancesRoom_h ; UNUSED_MAP_6E
	dw LancesRoom_h ; UNUSED_MAP_6F
	dw LancesRoom_h ; UNUSED_MAP_70
	dw LancesRoom_h
	dw LancesRoom_h ; UNUSED_MAP_72
	dw LancesRoom_h ; UNUSED_MAP_73
	dw LancesRoom_h ; UNUSED_MAP_74
	dw LancesRoom_h ; UNUSED_MAP_75
	dw HallOfFame_h
	dw UndergroundPathNorthSouth_h
	dw ChampionsRoom_h
	dw UndergroundPathWestEast_h
	dw CeladonMart1F_h
	dw CeladonMart2F_h
	dw CeladonMart3F_h
	dw CeladonMart4F_h
	dw CeladonMartRoof_h
	dw CeladonMartElevator_h
	dw CeladonMansion1F_h
	dw CeladonMansion2F_h
	dw CeladonMansion3F_h
	dw CeladonMansionRoof_h
	dw CeladonMansionRoofHouse_h
	dw CeladonPokecenter_h
	dw CeladonGym_h
	dw GameCorner_h
	dw CeladonMart5F_h
	dw GameCornerPrizeRoom_h
	dw CeladonDiner_h
	dw CeladonChiefHouse_h
	dw CeladonHotel_h
	dw LavenderPokecenter_h
	dw PokemonTower1F_h
	dw PokemonTower2F_h
	dw PokemonTower3F_h
	dw PokemonTower4F_h
	dw PokemonTower5F_h
	dw PokemonTower6F_h
	dw PokemonTower7F_h
	dw MrFujisHouse_h
	dw LavenderMart_h
	dw LavenderCuboneHouse_h
	dw FuchsiaMart_h
	dw FuchsiaBillsGrandpasHouse_h
	dw FuchsiaPokecenter_h
	dw WardensHouse_h
	dw SafariZoneGate_h
	dw FuchsiaGym_h
	dw FuchsiaMeetingRoom_h
	dw SeafoamIslandsB1F_h
	dw SeafoamIslandsB2F_h
	dw SeafoamIslandsB3F_h
	dw SeafoamIslandsB4F_h
	dw VermilionOldRodHouse_h
	dw FuchsiaGoodRodHouse_h
	dw PokemonMansion1F_h
	dw CinnabarGym_h
	dw CinnabarLab_h
	dw CinnabarLabTradeRoom_h
	dw CinnabarLabMetronomeRoom_h
	dw CinnabarLabFossilRoom_h
	dw CinnabarPokecenter_h
	dw CinnabarMart_h
	dw CinnabarMart_h ; CINNABAR_MART_COPY
	dw IndigoPlateauLobby_h
	dw CopycatsHouse1F_h
	dw CopycatsHouse2F_h
	dw FightingDojo_h
	dw SaffronGym_h
	dw SaffronPidgeyHouse_h
	dw SaffronMart_h
	dw SilphCo1F_h
	dw SaffronPokecenter_h
	dw MrPsychicsHouse_h
	dw Route15Gate1F_h
	dw Route15Gate2F_h
	dw Route16Gate1F_h
	dw Route16Gate2F_h
	dw Route16FlyHouse_h
	dw Route12SuperRodHouse_h
	dw Route18Gate1F_h
	dw Route18Gate2F_h
	dw SeafoamIslands1F_h
	dw Route22Gate_h
	dw VictoryRoad2F_h
	dw Route12Gate2F_h
	dw VermilionTradeHouse_h
	dw DiglettsCave_h
	dw VictoryRoad3F_h
	dw RocketHideoutB1F_h
	dw RocketHideoutB2F_h
	dw RocketHideoutB3F_h
	dw RocketHideoutB4F_h
	dw RocketHideoutElevator_h
	dw RocketHideoutElevator_h ; UNUSED_MAP_CC
	dw RocketHideoutElevator_h ; UNUSED_MAP_CD
	dw RocketHideoutElevator_h ; UNUSED_MAP_CE
	dw SilphCo2F_h
	dw SilphCo3F_h
	dw SilphCo4F_h
	dw SilphCo5F_h
	dw SilphCo6F_h
	dw SilphCo7F_h
	dw SilphCo8F_h
	dw PokemonMansion2F_h
	dw PokemonMansion3F_h
	dw PokemonMansionB1F_h
	dw SafariZoneEast_h
	dw SafariZoneNorth_h
	dw SafariZoneWest_h
	dw SafariZoneCenter_h
	dw SafariZoneCenterRestHouse_h
	dw SafariZoneSecretHouse_h
	dw SafariZoneWestRestHouse_h
	dw SafariZoneEastRestHouse_h
	dw SafariZoneNorthRestHouse_h
	dw CeruleanCave2F_h
	dw CeruleanCaveB1F_h
	dw CeruleanCave1F_h
	dw NameRatersHouse_h
	dw CeruleanBadgeHouse_h
	dw Route16Gate1F_h ; UNUSED_MAP_E7
	dw RockTunnelB1F_h
	dw SilphCo9F_h
	dw SilphCo10F_h
	dw SilphCo11F_h
	dw SilphCoElevator_h
	dw SilphCo2F_h ; UNUSED_MAP_ED
	dw SilphCo2F_h ; UNUSED_MAP_EE
	dw TradeCenter_h
	dw Colosseum_h
	dw SilphCo2F_h ; UNUSED_MAP_F1
	dw SilphCo2F_h ; UNUSED_MAP_F2
	dw SilphCo2F_h ; UNUSED_MAP_F3
	dw SilphCo2F_h ; UNUSED_MAP_F4
	dw LoreleisRoom_h
	dw BrunosRoom_h
	dw AgathasRoom_h

;@ path: home/overworld
;@ def HandleMidJump()
;@ One frame of the player's jump down a ledge (in another bank).
;@ test: skip runs the jump animation in another bank
HandleMidJump::
; Handle the player jumping down
; a ledge in the overworld.
;> return _HandleMidJump()
	ld b, BANK(_HandleMidJump)
	ld hl, _HandleMidJump
	jp Bankswitch

;@ path: home/overworld
;@ def EnterMap()
;@ Arrive on a map (wCurMap): load it, give three steps without wild battles after a battle (when the cooldown
;@ flag is set), play the arrival animation after Fly or a dungeon warp, apply forced biking or currents, then
;@ hand over to the overworld loop. Never returns.
;@ test: skip never returns: goes on into the overworld loop
EnterMap::
; Load a new map.
;> wJoyIgnore = PAD_BUTTONS | PAD_CTRL_PAD   # no input while the map loads
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
;> LoadMapData()
	call LoadMapData
;> ClearVariablesOnEnterMap()
	ld b, BANK(ClearVariablesOnEnterMap)
	ld hl, ClearVariablesOnEnterMap
	call Bankswitch
;> if wStatusFlags2 >> BIT_WILD_ENCOUNTER_COOLDOWN & 1:
	ld hl, wStatusFlags2
	bit BIT_WILD_ENCOUNTER_COOLDOWN, [hl]
	jr z, .skipGivingThreeStepsOfNoRandomBattles
;>     wNumberOfNoRandomBattleStepsLeft = 3   # three steps without wild battles
	ld a, 3 ; minimum number of steps between battles
	ld [wNumberOfNoRandomBattleStepsLeft], a
.skipGivingThreeStepsOfNoRandomBattles
;> after_battle = wStatusFlags4 >> BIT_BATTLE_OVER_OR_BLACKOUT & 1
	ld hl, wStatusFlags4
	bit BIT_BATTLE_OVER_OR_BLACKOUT, [hl]
;> wStatusFlags4 &= ~(1 << BIT_BATTLE_OVER_OR_BLACKOUT) & 0xFF
	res BIT_BATTLE_OVER_OR_BLACKOUT, [hl]
;> if not after_battle:
;>     ResetUsingStrengthOutOfBattleBit()
	call z, ResetUsingStrengthOutOfBattleBit
;> else:
;>     MapEntryAfterBattle()
	call nz, MapEntryAfterBattle
;> if wStatusFlags6 & (1 << BIT_FLY_WARP | 1 << BIT_DUNGEON_WARP):   # arriving by Fly or a dungeon warp
	ld hl, wStatusFlags6
	ld a, [hl]
	and (1 << BIT_FLY_WARP) | (1 << BIT_DUNGEON_WARP)
	jr z, .didNotEnterUsingFlyWarpOrDungeonWarp
;>     wStatusFlags6 &= ~(1 << BIT_FLY_WARP) & 0xFF
	res BIT_FLY_WARP, [hl]
;>     EnterMapAnim()
	ld b, BANK(EnterMapAnim)
	ld hl, EnterMapAnim
	call Bankswitch
;>     UpdateSprites()
	call UpdateSprites
.didNotEnterUsingFlyWarpOrDungeonWarp
;> CheckForceBikeOrSurf()              # currents at the Seafoam Islands, the bike on Cycling Road
	; handle currents in SF islands and forced bike riding in cycling road
	ld b, BANK(CheckForceBikeOrSurf)
	ld hl, CheckForceBikeOrSurf
	call Bankswitch
;> wStatusFlags3 &= ~(1 << BIT_NO_NPC_FACE_PLAYER) & 0xFF
	ld hl, wStatusFlags3
	res BIT_NO_NPC_FACE_PLAYER, [hl]
;> UpdateSprites()
	call UpdateSprites
;> wCurrentMapScriptFlags |= 1 << BIT_CUR_MAP_LOADED_1 | 1 << BIT_CUR_MAP_LOADED_2
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	set BIT_CUR_MAP_LOADED_2, [hl]
;> wJoyIgnore = 0
	xor a
	ld [wJoyIgnore], a
;> OverworldLoop()                     # it follows right below

;@ path: home/overworld
;@ def OverworldLoop()
;@ The overworld's main loop, one frame later: walking around, talking, menus, warps, battles. Never returns;
;@ it goes round by jumping back here.
;@ test: skip never returns: the overworld loop
OverworldLoop::
;> DelayFrame()
;> OverworldLoopLessDelay()
	call DelayFrame
;@ path: home/overworld
;@ def OverworldLoopLessDelay()
;@ One round of the overworld: go on with a step in progress, or read the joypad (perhaps simulated by a
;@ script) and act on it: START opens the start menu, A talks to whoever or reads whatever is in front, a
;@ direction turns or walks, unless something is in the way. After each finished step: count it, Safari Zone
;@ steps, poison damage, a wild or trainer battle, warps and map connections. After a battle the map is
;@ entered again (or the player blacks out). Never returns.
;@ test: skip never returns: the overworld loop
OverworldLoopLessDelay::
;>@init walk, battled = True, False    # a step goes on, no battle yet (unless found otherwise below)
;> DelayFrame()
	call DelayFrame
;> LoadGBPal()
	call LoadGBPal
;> if wMovementFlags >> BIT_LEDGE_OR_FISHING & 1:
;>     HandleMidJump()                 # in the middle of a jump down a ledge
	ld a, [wMovementFlags]
	bit BIT_LEDGE_OR_FISHING, a
	call nz, HandleMidJump
;> if not wWalkCounter:                # no step in progress: read the buttons (else: further down)
	ld a, [wWalkCounter]
	and a
	jp nz, .moveAhead ; if the player sprite has not yet completed the walking animation
;>     JoypadOverworld()               # the buttons (a script may simulate them)
	call JoypadOverworld ; get joypad state (which is possibly simulated)
;>     SafariZoneCheck()
	ld b, BANK(SafariZoneCheck)
	ld hl, SafariZoneCheck
	call Bankswitch
;>     if wSafariZoneGameOver:         # the Safari Game is over: back to the gate
;>         return WarpFound2()
	ld a, [wSafariZoneGameOver]
	and a
	jp nz, WarpFound2
;>     warp = wStatusFlags3 >> BIT_WARP_FROM_CUR_SCRIPT & 1   # a map script asked for a warp
	ld hl, wStatusFlags3
	bit BIT_WARP_FROM_CUR_SCRIPT, [hl]
;>     wStatusFlags3 &= ~(1 << BIT_WARP_FROM_CUR_SCRIPT) & 0xFF
	res BIT_WARP_FROM_CUR_SCRIPT, [hl]
;>     if warp:
;>         return WarpFound2()
	jp nz, WarpFound2
;>     if wStatusFlags6 & (1 << BIT_FLY_WARP | 1 << BIT_DUNGEON_WARP):
;>         return HandleFlyWarpOrDungeonWarp()
	ld a, [wStatusFlags6]
	and (1 << BIT_FLY_WARP) | (1 << BIT_DUNGEON_WARP)
	jp nz, HandleFlyWarpOrDungeonWarp
;>     walk = not wCurOpponent         # a trainer who has seen the player: straight on to the battle
;>     if walk:
	ld a, [wCurOpponent]
	and a
	jp nz, .newBattle
;>@init2         talk = stand = False
;>         if wStatusFlags5 >> BIT_SCRIPTED_MOVEMENT_STATE & 1:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_MOVEMENT_STATE, a
	jr z, .notSimulating
;>             keys = hJoyHeld         # simulated buttons count while they are held
	ldh a, [hJoyHeld]
	jr .checkIfStartIsPressed
.notSimulating
;>         else:
;>             keys = hJoyPressed      # the player's own only when newly pressed
	ldh a, [hJoyPressed]
.checkIfStartIsPressed
;>         if keys & PAD_START:
	bit B_PAD_START, a
	jr z, .startButtonNotPressed
; if START is pressed
;>             hTextID = TEXT_START_MENU
	xor a ; TEXT_START_MENU
	ldh [hTextID], a
;>             talk = True
	jp .displayDialogue
.startButtonNotPressed
;>         elif keys & PAD_A:
	bit B_PAD_A, a
	jp z, .checkIfDownButtonIsPressed
; if A is pressed
;>             if wStatusFlags5 >> BIT_UNKNOWN_5_2 & 1:   # A is ignored for now
;>                 stand = True
	ld a, [wStatusFlags5]
	bit BIT_UNKNOWN_5_2, a
	jp nz, .noDirectionButtonsPressed
;>             elif IsPlayerCharacterBeingControlledByGame():   # not while a script moves the player
	call IsPlayerCharacterBeingControlledByGame
	jr nz, .checkForOpponent
;>                 CheckForHiddenEventOrBookshelfOrCardKeyDoor()
	call CheckForHiddenEventOrBookshelfOrCardKeyDoor
;>                 if not hItemAlreadyFound:   # a hidden event or a bookshelf was handled (a card key door goes on)
;>                     return OverworldLoop()
	ldh a, [hItemAlreadyFound]
	and a
	jp z, OverworldLoop ; jump if a hidden event or bookshelf was found, but not if a card key door was found
;>                 IsSpriteOrSignInFrontOfPlayer()   # hTextID: the sign's or the person's text
	call IsSpriteOrSignInFrontOfPlayer
;>                 talk = hTextID != 0  # somebody or something to read
	ldh a, [hTextID]
	and a
;>                 if not talk:
;>                     return OverworldLoop()
	jp z, OverworldLoop
.displayDialogue
;>@talk         if talk:                    # show the start menu or the text
;>             GetTileAndCoordsInFrontOfPlayer()
	ld a, (GetTileAndCoordsInFrontOfPlayerPredef - PredefPointers) / 3
	call Predef
;>             UpdateSprites()
	call UpdateSprites
;>             if not wMiscFlags & (1 << BIT_TURNING | 1 << BIT_SEEN_BY_TRAINER):   # not while turning, or when a trainer comes
	ld a, [wMiscFlags]
	bit BIT_TURNING, a
	jr nz, .checkForOpponent
	bit BIT_SEEN_BY_TRAINER, a
	jr nz, .checkForOpponent
;>                 wTilePlayerStandingOn = mem[coord(8, 9)]   # Surf checks it for forbidden tile pairs
	ld a, [(9) * SCREEN_WIDTH + (8) + wTileMap]
	ld [wTilePlayerStandingOn], a ; checked when using Surf for forbidden tile pairs
;>                 DisplayTextID()     # the start menu, or the person's or sign's text
	call DisplayTextID ; display either the start menu or the NPC/sign text
;>                 if wEnteringCableClub:   # set when the player sits down at the link cable club
	ld a, [wEnteringCableClub]
	and a
	jr z, .checkForOpponent
;>                     entering = wEnteringCableClub
	dec a
;>                     wEnteringCableClub = 0
	ld a, 0
	ld [wEnteringCableClub], a
;>                     if entering != 1:   # never so, it seems
	jr z, .changeMap
; XXX can this code be reached?
;>                         TryLoadSaveFile()
	ld a, (TryLoadSaveFilePredef - PredefPointers) / 3
	call Predef
;>                         wDestinationMap = wCurMap   # warp back into the same map
	ld a, [wCurMap]
	ld [wDestinationMap], a
;>                         PrepareForSpecialWarp()
	call PrepareForSpecialWarp
;>                         SwitchToMapRomBank(wCurMap)
	ld a, [wCurMap]
	call SwitchToMapRomBank
;>                         wCurMapTileset |= 1 << BIT_NO_PREVIOUS_MAP
	ld hl, wCurMapTileset
	set BIT_NO_PREVIOUS_MAP, [hl]
.changeMap
;>                     return EnterMap()
	jp EnterMap
.checkForOpponent
;>@after         if keys & (PAD_START | PAD_A) and not stand:   # after A or START a trainer may have seen the player
;>@nowalk             walk = False
;>             if not wCurOpponent:
;>                 return OverworldLoop()
	ld a, [wCurOpponent]
	and a
	jp nz, .newBattle
	jp OverworldLoop
.noDirectionButtonsPressed
;>@stand         elif stand or not hJoyHeld & PAD_CTRL_PAD:   # A ignored, or no direction held: stand still
;>             wMiscFlags &= ~(1 << BIT_TURNING) & 0xFF
	ld hl, wMiscFlags
	res BIT_TURNING, [hl]
;>             UpdateSprites()
	call UpdateSprites
;>             wCheckFor180DegreeTurn = 1   # the next direction pressed may first turn the player on the spot
	ld a, 1
	ld [wCheckFor180DegreeTurn], a
;>             if not wPlayerMovingDirection:   # the direction pressed last time
;>                 return OverworldLoop()
	ld a, [wPlayerMovingDirection] ; the direction that was pressed last time
	and a
	jp z, OverworldLoop
; if a direction was pressed last time
;>             wPlayerLastStopDirection = wPlayerMovingDirection   # remember which way the player stopped
	ld [wPlayerLastStopDirection], a ; save the last direction
;>             wPlayerMovingDirection = 0
	xor a
	ld [wPlayerMovingDirection], a ; zero the direction
;>             return OverworldLoop()
	jp OverworldLoop

.checkIfDownButtonIsPressed
;>         else:                       # a direction is held: turn or walk that way
;>             held = hJoyHeld
	ldh a, [hJoyHeld] ; current joypad state
;>             if held & PAD_DOWN:
	bit B_PAD_DOWN, a
	jr z, .checkIfUpButtonIsPressed
;>                 wSpritePlayerStateData1YStepVector = 1
	ld a, 1
	ld [wSpritePlayerStateData1YStepVector], a
;>                 direction = PLAYER_DIR_DOWN
	ld a, PLAYER_DIR_DOWN
	jr .handleDirectionButtonPress

.checkIfUpButtonIsPressed
;>             elif held & PAD_UP:
	bit B_PAD_UP, a
	jr z, .checkIfLeftButtonIsPressed
;>                 wSpritePlayerStateData1YStepVector = 0xFF   # -1
	ld a, -1
	ld [wSpritePlayerStateData1YStepVector], a
;>                 direction = PLAYER_DIR_UP
	ld a, PLAYER_DIR_UP
	jr .handleDirectionButtonPress

.checkIfLeftButtonIsPressed
;>             elif held & PAD_LEFT:
	bit B_PAD_LEFT, a
	jr z, .checkIfRightButtonIsPressed
;>                 wSpritePlayerStateData1XStepVector = 0xFF   # -1
	ld a, -1
	ld [wSpritePlayerStateData1XStepVector], a
;>                 direction = PLAYER_DIR_LEFT
	ld a, PLAYER_DIR_LEFT
	jr .handleDirectionButtonPress

.checkIfRightButtonIsPressed
;=@stand
	bit B_PAD_RIGHT, a
	jr z, .noDirectionButtonsPressed
;>             else:                   # right
;>                 wSpritePlayerStateData1XStepVector = 1
;>                 direction = PLAYER_DIR_RIGHT   # the 1 just written
	ld a, 1
	ld [wSpritePlayerStateData1XStepVector], a


.handleDirectionButtonPress
;>             wPlayerDirection = direction
	ld [wPlayerDirection], a ; new direction
;>             turning = not wStatusFlags5 >> BIT_SCRIPTED_MOVEMENT_STATE & 1   # not while a script walks the player
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_MOVEMENT_STATE, a
	jr nz, .noDirectionChange ; ignore direction changes if we are
;>             turning = turning and wCheckFor180DegreeTurn != 0   # only right after standing still
	ld a, [wCheckFor180DegreeTurn]
	and a
	jr z, .noDirectionChange
;>             if turning and wPlayerDirection != wPlayerLastStopDirection:   # facing a new way: turn on the spot
	ld a, [wPlayerDirection] ; new direction
	ld b, a
	ld a, [wPlayerLastStopDirection] ; old direction
	cp b
	jr z, .noDirectionChange
; Check whether the player did a 180-degree turn.
; It appears that this code was supposed to show the player rotate by having
; the player's sprite face an intermediate direction before facing the opposite
; direction (instead of doing an instantaneous about-face), but the intermediate
; direction is only set for a short period of time. It is unlikely for it to
; ever be visible because DelayFrame is called at the start of OverworldLoop and
; normally not enough cycles would be executed between then and the time the
; direction is set for V-blank to occur while the direction is still set.
;>                 turn = swap(wPlayerLastStopDirection) | wPlayerDirection   # old direction above, new below
	swap a ; put old direction in upper half
	or b ; put new direction in lower half
;>                 if turn == PLAYER_DIR_DOWN << 4 | PLAYER_DIR_UP:   # a turn round: face a direction in between
	cp (PLAYER_DIR_DOWN << 4) | PLAYER_DIR_UP ; change dir from down to up
	jr nz, .notDownToUp
;>                     wPlayerMovingDirection = PLAYER_DIR_LEFT
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	jr .holdIntermediateDirectionLoop
.notDownToUp
;>                 elif turn == PLAYER_DIR_UP << 4 | PLAYER_DIR_DOWN:
	cp (PLAYER_DIR_UP << 4) | PLAYER_DIR_DOWN ; change dir from up to down
	jr nz, .notUpToDown
;>                     wPlayerMovingDirection = PLAYER_DIR_RIGHT
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	jr .holdIntermediateDirectionLoop
.notUpToDown
;>                 elif turn == PLAYER_DIR_RIGHT << 4 | PLAYER_DIR_LEFT:
	cp (PLAYER_DIR_RIGHT << 4) | PLAYER_DIR_LEFT ; change dir from right to left
	jr nz, .notRightToLeft
;>                     wPlayerMovingDirection = PLAYER_DIR_DOWN
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	jr .holdIntermediateDirectionLoop
.notRightToLeft
;>                 elif turn == PLAYER_DIR_LEFT << 4 | PLAYER_DIR_RIGHT:
	cp (PLAYER_DIR_LEFT << 4) | PLAYER_DIR_RIGHT ; change dir from left to right
	jr nz, .holdIntermediateDirectionLoop
;>                     wPlayerMovingDirection = PLAYER_DIR_UP
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
.holdIntermediateDirectionLoop
;>                 wMiscFlags |= 1 << BIT_TURNING   # this round only turns, without a step
	ld hl, wMiscFlags
	set BIT_TURNING, [hl]
;>                 wCheckFor180DegreeTurn = 0      # counted down to 0
	ld hl, wCheckFor180DegreeTurn
	dec [hl]
	jr nz, .holdIntermediateDirectionLoop
;>                 wPlayerMovingDirection = wPlayerDirection   # the in-between direction is gone already
	ld a, [wPlayerDirection]
	ld [wPlayerMovingDirection], a
;>                 battled = NewBattle()
	call NewBattle
;>@nowalk2                 walk = False
;>                 if not battled:
;>                     return OverworldLoop()
	jp c, .battleOccurred
	jp OverworldLoop

.noDirectionChange
;>             else:                   # walk a step that way
;>                 wPlayerMovingDirection = wPlayerDirection
	ld a, [wPlayerDirection] ; current direction
	ld [wPlayerMovingDirection], a ; save direction
;>                 UpdateSprites()
	call UpdateSprites
;>                 if wWalkBikeSurfState != 2:   # walking or on the bike
	ld a, [wWalkBikeSurfState]
	cp $02 ; surfing
	jr z, .surfing
; not surfing
;>                     if CollisionCheckOnLand():   # something in the way
	call CollisionCheckOnLand
	jr nc, .noCollision
; collision occurred
;>                         if not wMovementFlags >> BIT_STANDING_ON_WARP & 1:
;>                             return OverworldLoop()
	push hl
	ld hl, wMovementFlags
	bit BIT_STANDING_ON_WARP, [hl]
	pop hl
	jp z, OverworldLoop
; collision occurred while standing on a warp
;>                         if ExtraWarpCheck():   # a warp at the edge of the map: walking against it warps
;>                             return CheckWarpsCollision()
	push hl
	call ExtraWarpCheck ; sets carry if there is a potential to warp
	pop hl
	jp c, CheckWarpsCollision
;>                         return OverworldLoop()
	jp OverworldLoop

.surfing
;>                 elif CollisionCheckOnWater():   # surfing
;>                     return OverworldLoop()
	call CollisionCheckOnWater
	jp c, OverworldLoop

.noCollision
;>                 wWalkCounter = 8    # a new step: 8 moves of 2 pixels
	ld a, $08
	ld [wWalkCounter], a
	jr .moveAhead2

.moveAhead
;> else:                               # a step in progress goes on
;>     if wMovementFlags >> BIT_SPINNING & 1:   # on spinner tiles
	ld a, [wMovementFlags]
	bit BIT_SPINNING, a
	jr z, .noSpinning
;>         LoadSpinnerArrowTiles()
	ld b, BANK(LoadSpinnerArrowTiles)
	ld hl, LoadSpinnerArrowTiles
	call Bankswitch
.noSpinning
;>     UpdateSprites()
	call UpdateSprites

.moveAhead2
;> if walk:                            # move the player
;>     wMiscFlags &= ~(1 << BIT_TURNING) & 0xFF
	ld hl, wMiscFlags
	res BIT_TURNING, [hl]
;>     if wWalkBikeSurfState == 1 and not wMovementFlags >> BIT_LEDGE_OR_FISHING & 1:   # on the bike, not jumping
	ld a, [wWalkBikeSurfState]
	dec a ; riding a bike?
	jr nz, .normalPlayerSpriteAdvancement
	ld a, [wMovementFlags]
	bit BIT_LEDGE_OR_FISHING, a
	jr nz, .normalPlayerSpriteAdvancement
;>         DoBikeSpeedup()             # a second move per frame
	call DoBikeSpeedup
.normalPlayerSpriteAdvancement
;>     AdvancePlayerSprite()
	call AdvancePlayerSprite
;>     if wWalkCounter:                # the step is not finished yet
;>         return CheckMapConnections()
	ld a, [wWalkCounter]
	and a
	jp nz, CheckMapConnections ; it seems like this check will never succeed (the other place where CheckMapConnections is run works)
; walking animation finished
;>     if not wStatusFlags5 >> BIT_SCRIPTED_MOVEMENT_STATE & 1:   # the step is finished: count the player's own
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_MOVEMENT_STATE, a
	jr nz, .doneStepCounting ; if button presses are being simulated, don't count steps
; step counting
;>         wStepCounter = u8(wStepCounter - 1)
	ld hl, wStepCounter
	dec [hl]
;>         if wStatusFlags2 >> BIT_WILD_ENCOUNTER_COOLDOWN & 1:   # no wild battles for some steps
	ld a, [wStatusFlags2]
	bit BIT_WILD_ENCOUNTER_COOLDOWN, a
	jr z, .doneStepCounting
;>             wNumberOfNoRandomBattleStepsLeft = u8(wNumberOfNoRandomBattleStepsLeft - 1)
	ld hl, wNumberOfNoRandomBattleStepsLeft
	dec [hl]
;>             if wNumberOfNoRandomBattleStepsLeft == 0:
	jr nz, .doneStepCounting
;>                 wStatusFlags2 &= ~(1 << BIT_WILD_ENCOUNTER_COOLDOWN) & 0xFF
	ld hl, wStatusFlags2
	res BIT_WILD_ENCOUNTER_COOLDOWN, [hl]
.doneStepCounting
;>     if event(EVENT_IN_SAFARI_ZONE):
	ld a, [wEventFlags + $49]
	bit (EVENT_IN_SAFARI_ZONE) % 8, a
	jr z, .notSafariZone
;>         SafariZoneCheckSteps()
	ld b, BANK(SafariZoneCheckSteps)
	ld hl, SafariZoneCheckSteps
	call Bankswitch
;>         if wSafariZoneGameOver:     # out of steps
;>             return WarpFound2()
	ld a, [wSafariZoneGameOver]
	and a
	jp nz, WarpFound2
.notSafariZone
;>     if wIsInBattle:
;>         return CheckWarpsNoCollision()
	ld a, [wIsInBattle]
	and a
	jp nz, CheckWarpsNoCollision
;>     ApplyOutOfBattlePoisonDamage()  # also gives the day care Pokémon experience
	; also increment daycare mon exp
	ld a, (ApplyOutOfBattlePoisonDamagePredef - PredefPointers) / 3
	call Predef
;>     if wOutOfBattleBlackout:        # the whole party fainted from poison
;>         return HandleBlackOut()
	ld a, [wOutOfBattleBlackout]
	and a
	jp nz, HandleBlackOut ; if all pokemon fainted
.newBattle
;> if not battled:                     # a trainer or wild battle may start
;>     battled = NewBattle()
	call NewBattle
;>     wMovementFlags &= ~(1 << BIT_STANDING_ON_WARP) & 0xFF
	ld hl, wMovementFlags
	res BIT_STANDING_ON_WARP, [hl]
;>     if not battled:
;>         return CheckWarpsNoCollision()
	jp nc, CheckWarpsNoCollision ; check for warps if there was no battle
.battleOccurred
;> wStatusFlags3 &= ~(1 << BIT_TALKED_TO_TRAINER) & 0xFF   # back from a battle
	ld hl, wStatusFlags3
	res BIT_TALKED_TO_TRAINER, [hl]
;> wStatusFlags7 &= ~(1 << BIT_TRAINER_BATTLE) & 0xFF
	ld hl, wStatusFlags7
	res BIT_TRAINER_BATTLE, [hl]
;> wCurrentMapScriptFlags |= 1 << BIT_CUR_MAP_LOADED_1 | 1 << BIT_CUR_MAP_LOADED_2   # the map is set up again
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	set BIT_CUR_MAP_LOADED_2, [hl]
;> hJoyHeld = 0
	xor a
	ldh [hJoyHeld], a
;> if wCurMap == CINNABAR_GYM:
	ld a, [wCurMap]
	cp CINNABAR_GYM
	jr nz, .notCinnabarGym
;>     set_event(EVENT_2A7)
	ld hl, wEventFlags + $54
	set (EVENT_2A7) % 8, [hl]
.notCinnabarGym
;> wStatusFlags4 |= 1 << BIT_BATTLE_OVER_OR_BLACKOUT
	ld hl, wStatusFlags4
	set BIT_BATTLE_OVER_OR_BLACKOUT, [hl]
;>@alive alive = True
;> if wCurMap != OAKS_LAB:             # losing to the rival in Oak's lab is no black out
	ld a, [wCurMap]
	cp OAKS_LAB
	jp z, .noFaintCheck ; no blacking out if the player lost to the rival in Oak's lab
;>     _, alive = AnyPartyAlive()
	ld hl, AnyPartyAlive
	ld b, BANK(AnyPartyAlive)
	call Bankswitch
;> if alive:
	ld a, d
	and a
	jr z, .allPokemonFainted
.noFaintCheck
;>     DelayFrames(10)
	ld c, 10
	call DelayFrames
;>     return EnterMap()
	jp EnterMap
.allPokemonFainted
;> wIsInBattle = LOST_BATTLE           # the player blacks out
	ld a, LOST_BATTLE
	ld [wIsInBattle], a
;> RunMapScript()
	call RunMapScript
;> return HandleBlackOut()
	jp HandleBlackOut

; function to determine if there will be a battle and execute it (either a trainer battle or wild battle)
; sets carry if a battle occurred and unsets carry if not
;@ path: home/overworld
;@ def NewBattle() -> carry
;@ Start a battle if one is due (a trainer who saw the player, or a wild Pokémon in grass, cave or water):
;@ carry if a battle took place. None while the game moves the player, after a dungeon warp, or while battles
;@ are switched off.
;@ test: skip runs whole battles
NewBattle::
;> if wStatusFlags3 >> BIT_ON_DUNGEON_WARP & 1:
;>     return False
	ld a, [wStatusFlags3]
	bit BIT_ON_DUNGEON_WARP, a
	jr nz, .noBattle
;> if not IsPlayerCharacterBeingControlledByGame():  # zero: the player is in control
;>     return False
	call IsPlayerCharacterBeingControlledByGame
	jr nz, .noBattle ; no battle if the player character is under the game's control
;> if wStatusFlags4 >> BIT_NO_BATTLES & 1:
;>     return False
	ld a, [wStatusFlags4]
	bit BIT_NO_BATTLES, a
	jr nz, .noBattle
;> return InitBattle()
	ld b, BANK(InitBattle)
	ld hl, InitBattle
	jp Bankswitch
.noBattle
	and a
	ret

; function to make bikes twice as fast as walking
;@ path: home/overworld
;@ def DoBikeSpeedup()
;@ On the bike the player moves twice per frame: one more AdvancePlayerSprite. Not during a scripted walk, and
;@ on Cycling Road only when riding downhill (no Up, Left or Right held).
;@ test: skip AdvancePlayerSprite needs a loaded map
DoBikeSpeedup::
;> if wNPCMovementScriptPointerTableNum:   # a scripted walk
;>     return
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret nz
;> if wCurMap == ROUTE_17:             # Cycling Road: faster only riding downhill
	ld a, [wCurMap]
	cp ROUTE_17 ; Cycling Road
	jr nz, .goFaster
;>     if hJoyHeld & (PAD_UP | PAD_LEFT | PAD_RIGHT):
;>         return
	ldh a, [hJoyHeld]
	and PAD_UP | PAD_LEFT | PAD_RIGHT
	ret nz
.goFaster
;> return AdvancePlayerSprite()
	jp AdvancePlayerSprite

; check if the player has stepped onto a warp after having not collided
;@ path: home/overworld
;@ def CheckWarpsNoCollision()
;@ After a step that did not bump into anything: look for a warp at the player's position among the map's
;@ warps (4 bytes each: y, x, destination warp, destination map); none means checking the map's edges
;@ (CheckMapConnections). Never returns.
;@ test: skip never returns: goes on in the overworld loop
CheckWarpsNoCollision::
;> if not wNumberOfWarps:              # no warps: look at the map's edges
;>     return CheckMapConnections()
	ld a, [wNumberOfWarps]
	and a
	jp z, CheckMapConnections
;> left = wNumberOfWarps               # the warps still to test
	ld a, [wNumberOfWarps]
	ld b, 0
	ld c, a
;> y, x = wYCoord, wXCoord
	ld a, [wYCoord]
	ld d, a
	ld a, [wXCoord]
	ld e, a
;> return CheckWarpsNoCollisionLoop(addr(wWarpEntries), 0, left, y, x)   # it follows right below
	ld hl, wWarpEntries
;@ path: home/overworld
;@ def CheckWarpsNoCollisionLoop(warp: hl, n: b, left: c, y: d, x: e)
;@ Test one warp entry against the player's position y, x (n counts the warps tested, left the ones still to
;@ test). On a match the warp is taken if the player stands on a door or warp tile, or (at the map's edge,
;@ ExtraWarpCheck) if the warp is forced or a direction is held.
;@ test: skip never returns: goes on in the overworld loop
CheckWarpsNoCollisionLoop::
;> if mem[warp] != y:
;>     return CheckWarpsNoCollisionRetry1(warp + 1, n, left, y, x)
	ld a, [hli] ; check if the warp's Y position matches
	cp d
	jr nz, CheckWarpsNoCollisionRetry1
;> if mem[warp + 1] != x:
;>     return CheckWarpsNoCollisionRetry2(warp + 2, n, left, y, x)
	ld a, [hli] ; check if the warp's X position matches
	cp e
	jr nz, CheckWarpsNoCollisionRetry2
; if a match was found
;> wMovementFlags |= 1 << BIT_STANDING_ON_WARP
	push hl
	push bc
	ld hl, wMovementFlags
	set BIT_STANDING_ON_WARP, [hl]
;> on_door = IsPlayerStandingOnDoorTileOrWarpTile()
	ld b, BANK(IsPlayerStandingOnDoorTileOrWarpTile)
	ld hl, IsPlayerStandingOnDoorTileOrWarpTile
	call Bankswitch
	pop bc
	pop hl
;> if on_door:
;>     return WarpFound1(warp + 2, left)
	jr c, WarpFound1 ; jump if standing on door or warp
;> may_warp = ExtraWarpCheck()         # at the map's edge, for instance
	push hl
	push bc
	call ExtraWarpCheck
	pop bc
	pop hl
;> if not may_warp:
;>     return CheckWarpsNoCollisionRetry2(warp + 2, n, left, y, x)
	jr nc, CheckWarpsNoCollisionRetry2
; if the extra check passed
;> if wStatusFlags7 >> BIT_FORCED_WARP & 1:
;>     return WarpFound1(warp + 2, left)
	ld a, [wStatusFlags7]
	bit BIT_FORCED_WARP, a
	jr nz, WarpFound1
;> Joypad()
	push de
	push bc
	call Joypad
	pop bc
	pop de
;> if not hJoyHeld & PAD_CTRL_PAD:     # no direction held: do not go through
;>     return CheckWarpsNoCollisionRetry2(warp + 2, n, left, y, x)
	ldh a, [hJoyHeld]
	and PAD_CTRL_PAD
	jr z, CheckWarpsNoCollisionRetry2 ; if directional buttons aren't being pressed, do not pass through the warp
;> return WarpFound1(warp + 2, left)
	jr WarpFound1

; check if the player has stepped onto a warp after having collided
;@ path: home/overworld
;@ def CheckWarpsCollision()
;@ After bumping into something while standing on a warp (ExtraWarpCheck said it may lead somewhere): take
;@ the warp at the player's position, if there is one; otherwise back to the overworld loop. Never returns.
;@ test: skip never returns: goes on in the overworld loop
CheckWarpsCollision::
;>@each for k in range(wNumberOfWarps or 256):
;>     warp = addr(wWarpEntries) + 4 * k
	ld a, [wNumberOfWarps]
	ld c, a
	ld hl, wWarpEntries
.loop
;>     if mem[warp] != wYCoord:
	ld a, [hli] ; Y coordinate of warp
	ld b, a
	ld a, [wYCoord]
	cp b
	jr nz, .retry1
;>@r1         continue
;>     if mem[warp + 1] != wXCoord:
	ld a, [hli] ; X coordinate of warp
	ld b, a
	ld a, [wXCoord]
	cp b
	jr nz, .retry2
;>@r2         continue
;>     wDestinationWarpID = mem[warp + 2]
	ld a, [hli]
	ld [wDestinationWarpID], a
;>     hWarpDestinationMap = mem[warp + 3]
	ld a, [hl]
	ldh [hWarpDestinationMap], a
;>     return WarpFound2(u8(wNumberOfWarps - k))
	jr WarpFound2
.retry1
;=@r1
	inc hl
.retry2
;=@r2
	inc hl
	inc hl
;=@each
	dec c
	jr nz, .loop
;> return OverworldLoop()
	jp OverworldLoop

;@ path: home/overworld
;@ def CheckWarpsNoCollisionRetry1(warp: hl, n: b, left: c, y: d, x: e)
;@ The warp's y did not match: skip the rest of the entry.
;@ test: skip never returns: goes on in the overworld loop
CheckWarpsNoCollisionRetry1::
;> return CheckWarpsNoCollisionRetry2(warp + 1, n, left, y, x)
	inc hl
;@ path: home/overworld
;@ def CheckWarpsNoCollisionRetry2(warp: hl, n: b, left: c, y: d, x: e)
;@ Skip the destination bytes of the warp entry and go on with the next warp.
;@ test: skip never returns: goes on in the overworld loop
CheckWarpsNoCollisionRetry2::
;> return ContinueCheckWarpsNoCollisionLoop(warp + 2, n, left, y, x)
	inc hl
	inc hl
	jp ContinueCheckWarpsNoCollisionLoop

;@ path: home/overworld
;@ def WarpFound1(dest: hl, left: c)
;@ Take the warp: dest points at its destination warp and map.
;@ test: skip never returns: enters the new map
WarpFound1::
;> wDestinationWarpID = mem[dest]
	ld a, [hli]
	ld [wDestinationWarpID], a
;> hWarpDestinationMap = mem[dest + 1]
	ld a, [hli]
	ldh [hWarpDestinationMap], a
;> return WarpFound2(left)             # it follows right below

;@ path: home/overworld
;@ def WarpFound2(left: c)
;@ Go through a warp to hWarpDestinationMap (left tells which warp it was): remember where the player came
;@ from. From an outside map the current map becomes the "last map"; a warp to LAST_MAP leads back out to it.
;@ A warp pad starts the teleport animation instead of the door sound. Then the new map is entered with the
;@ player stepping out of the door.
;@ test: skip never returns: enters the new map
WarpFound2::
;> wWarpedFromWhichWarp = u8(wNumberOfWarps - left)   # the number of the warp taken
	ld a, [wNumberOfWarps]
	sub c
	ld [wWarpedFromWhichWarp], a ; save ID of used warp
;> wWarpedFromWhichMap = wCurMap
	ld a, [wCurMap]
	ld [wWarpedFromWhichMap], a
;> if CheckIfInOutsideMap():
	call CheckIfInOutsideMap
	jr nz, .indoorMaps
; this is for handling "outside" maps that can't have the 0xFF destination map
;>     wLastMap = wCurMap              # an outside map: the place a LAST_MAP warp leads back to
	ld a, [wCurMap]
	ld [wLastMap], a
;>     wUnusedLastMapWidth = wCurMapWidth
	ld a, [wCurMapWidth]
	ld [wUnusedLastMapWidth], a
;>     wCurMap = hWarpDestinationMap
	ldh a, [hWarpDestinationMap]
	ld [wCurMap], a
;>     if wCurMap == ROCK_TUNNEL_1F:
	cp ROCK_TUNNEL_1F
	jr nz, .notRockTunnel
;>         wMapPalOffset = 6           # dark
	ld a, $06
	ld [wMapPalOffset], a
;>         GBFadeOutToBlack()
	call GBFadeOutToBlack
.notRockTunnel
;>     PlayMapChangeSound()
	call PlayMapChangeSound
	jr .done

; for maps that can have the 0xFF destination map, which means to return to the outside map
; not all these maps are necessarily indoors, though
.indoorMaps
;> elif hWarpDestinationMap != LAST_MAP:   # an inside map, and a warp further in
	ldh a, [hWarpDestinationMap]
	cp LAST_MAP
	jr z, .goBackOutside
; if not going back to the previous map
;>     wCurMap = hWarpDestinationMap
	ld [wCurMap], a
;>     IsPlayerStandingOnWarpPadOrHole()
	ld b, BANK(IsPlayerStandingOnWarpPadOrHole)
	ld hl, IsPlayerStandingOnWarpPadOrHole
	call Bankswitch
;>     if wStandingOnWarpPadOrHole == 1:   # a warp pad: teleport
	ld a, [wStandingOnWarpPadOrHole]
	dec a ; is the player on a warp pad?
	jr nz, .notWarpPad
; if the player is on a warp pad
;>         wStatusFlags6 |= 1 << BIT_FLY_WARP
	ld hl, wStatusFlags6
	set BIT_FLY_WARP, [hl]
;>         LeaveMapAnim()
	call LeaveMapAnim
	jr .skipMapChangeSound
.notWarpPad
;>     else:
;>         PlayMapChangeSound()
	call PlayMapChangeSound
.skipMapChangeSound
;>     wMovementFlags &= ~(1 << BIT_STANDING_ON_DOOR | 1 << BIT_EXITING_DOOR) & 0xFF
	ld hl, wMovementFlags
	res BIT_STANDING_ON_DOOR, [hl]
	res BIT_EXITING_DOOR, [hl]
	jr .done
.goBackOutside
;> else:                               # back out to the last outside map
;>     wCurMap = wLastMap
	ld a, [wLastMap]
	ld [wCurMap], a
;>     PlayMapChangeSound()
	call PlayMapChangeSound
;>     wMapPalOffset = 0
	xor a
	ld [wMapPalOffset], a
.done
;> wMovementFlags |= 1 << BIT_STANDING_ON_DOOR   # step out of the door (if there is one)
	ld hl, wMovementFlags
	set BIT_STANDING_ON_DOOR, [hl] ; have the player's sprite step out from the door (if there is one)
;> IgnoreInputForHalfSecond()
	call IgnoreInputForHalfSecond
;> return EnterMap()
	jp EnterMap

;@ path: home/overworld
;@ def ContinueCheckWarpsNoCollisionLoop(warp: hl, n: b, left: c, y: d, x: e)
;@ On to the next warp entry; after the last one, check the map's edges.
;@ test: skip never returns: goes on in the overworld loop
ContinueCheckWarpsNoCollisionLoop::
;> n = u8(n + 1)
	inc b ; increment warp number
;> left = u8(left - 1)
	dec c ; decrement number of warps
;> if left:
;>     return CheckWarpsNoCollisionLoop(warp, n, left, y, x)
	jp nz, CheckWarpsNoCollisionLoop
;> return CheckMapConnections()        # it follows right below

; if no matching warp was found
;@ path: home/overworld
;@ def CheckMapConnections()
;@ Did the step lead off the map's edge? Then enter the map connected on that side: its number, the player's
;@ new coordinates (the connection's alignment) and the view pointer into the new map's block map, then load it
;@ without a fade (header, music, palette, sprites, blocks) and go on walking. Otherwise back to the overworld
;@ loop. Never returns.
;@ test: skip never returns: goes on in the overworld loop
CheckMapConnections::
; check west map
;> if wXCoord == 0xFF:                 # off the west edge
	ld a, [wXCoord]
	cp $ff
	jr nz, .checkEastMap
;>     wCurMap = wWestConnectedMap
	ld a, [wWestConnectedMap]
	ld [wCurMap], a
;>     wXCoord = wWestConnectedMapXAlignment   # the column where the player comes in
	ld a, [wWestConnectedMapXAlignment] ; new X coordinate upon entering west map
	ld [wXCoord], a
;>     wYCoord = u8(wYCoord + wWestConnectedMapYAlignment)
	ld a, [wYCoord]
	ld c, a
	ld a, [wWestConnectedMapYAlignment] ; Y adjustment upon entering west map
	add c
	ld c, a
	ld [wYCoord], a
;>     view = mem16[addr(wWestConnectedMapViewPointer)]   # the new map's view for its top row
	ld a, [wWestConnectedMapViewPointer] ; pointer to upper left corner of map without adjustment for Y position
	ld l, a
	ld a, [wWestConnectedMapViewPointer + 1]
	ld h, a
;>@rows1     for _ in range(wYCoord >> 1):   # one block row down per two steps
	srl c
	jr z, .savePointer1
;>         view += u8(wWestConnectedMapWidth + MAP_BORDER * 2)
.pointerAdjustmentLoop1
	ld a, [wWestConnectedMapWidth]
	add MAP_BORDER * 2
	ld e, a
	ld d, 0
	ld b, 0
	add hl, de
;=@rows1
	dec c
	jr nz, .pointerAdjustmentLoop1
.savePointer1
;>     wCurrentTileBlockMapViewPointer[0] = lo(view)
	ld a, l
	ld [wCurrentTileBlockMapViewPointer], a ; pointer to upper left corner of current tile block map section
;>     wCurrentTileBlockMapViewPointer[1] = hi(view)
	ld a, h
	ld [wCurrentTileBlockMapViewPointer + 1], a
	jp .loadNewMap

.checkEastMap
;> elif wXCoord == wCurrentMapWidth2:  # off the east edge
	ld b, a
	ld a, [wCurrentMapWidth2]
	cp b
	jr nz, .checkNorthMap
;>     wCurMap = wEastConnectedMap
	ld a, [wEastConnectedMap]
	ld [wCurMap], a
;>     wXCoord = wEastConnectedMapXAlignment
	ld a, [wEastConnectedMapXAlignment] ; new X coordinate upon entering east map
	ld [wXCoord], a
;>     wYCoord = u8(wYCoord + wEastConnectedMapYAlignment)
	ld a, [wYCoord]
	ld c, a
	ld a, [wEastConnectedMapYAlignment] ; Y adjustment upon entering east map
	add c
	ld c, a
	ld [wYCoord], a
;>     view = mem16[addr(wEastConnectedMapViewPointer)]
	ld a, [wEastConnectedMapViewPointer] ; pointer to upper left corner of map without adjustment for Y position
	ld l, a
	ld a, [wEastConnectedMapViewPointer + 1]
	ld h, a
;>@rows2     for _ in range(wYCoord >> 1):
	srl c
	jr z, .savePointer2
;>         view += u8(wEastConnectedMapWidth + MAP_BORDER * 2)
.pointerAdjustmentLoop2
	ld a, [wEastConnectedMapWidth]
	add MAP_BORDER * 2
	ld e, a
	ld d, 0
	ld b, 0
	add hl, de
;=@rows2
	dec c
	jr nz, .pointerAdjustmentLoop2
.savePointer2
;>     wCurrentTileBlockMapViewPointer[0] = lo(view)
	ld a, l
	ld [wCurrentTileBlockMapViewPointer], a ; pointer to upper left corner of current tile block map section
;>     wCurrentTileBlockMapViewPointer[1] = hi(view)
	ld a, h
	ld [wCurrentTileBlockMapViewPointer + 1], a
	jp .loadNewMap

.checkNorthMap
;> elif wYCoord == 0xFF:               # off the north edge
	ld a, [wYCoord]
	cp $ff
	jr nz, .checkSouthMap
;>     wCurMap = wNorthConnectedMap
	ld a, [wNorthConnectedMap]
	ld [wCurMap], a
;>     wYCoord = wNorthConnectedMapYAlignment   # the row where the player comes in
	ld a, [wNorthConnectedMapYAlignment] ; new Y coordinate upon entering north map
	ld [wYCoord], a
;>     wXCoord = u8(wXCoord + wNorthConnectedMapXAlignment)
	ld a, [wXCoord]
	ld c, a
	ld a, [wNorthConnectedMapXAlignment] ; X adjustment upon entering north map
	add c
	ld c, a
	ld [wXCoord], a
;>     view = mem16[addr(wNorthConnectedMapViewPointer)]
	ld a, [wNorthConnectedMapViewPointer] ; pointer to upper left corner of map without adjustment for X position
	ld l, a
	ld a, [wNorthConnectedMapViewPointer + 1]
	ld h, a
;>     view += wXCoord >> 1            # one block right per two steps
	ld b, 0
	srl c
	add hl, bc
;>     wCurrentTileBlockMapViewPointer[0] = lo(view)
	ld a, l
	ld [wCurrentTileBlockMapViewPointer], a ; pointer to upper left corner of current tile block map section
;>     wCurrentTileBlockMapViewPointer[1] = hi(view)
	ld a, h
	ld [wCurrentTileBlockMapViewPointer + 1], a
	jp .loadNewMap

.checkSouthMap
;> elif wYCoord == wCurrentMapHeight2: # off the south edge
	ld b, a
	ld a, [wCurrentMapHeight2]
	cp b
	jr nz, .didNotEnterConnectedMap
;>     wCurMap = wSouthConnectedMap
	ld a, [wSouthConnectedMap]
	ld [wCurMap], a
;>     wYCoord = wSouthConnectedMapYAlignment
	ld a, [wSouthConnectedMapYAlignment] ; new Y coordinate upon entering south map
	ld [wYCoord], a
;>     wXCoord = u8(wXCoord + wSouthConnectedMapXAlignment)
	ld a, [wXCoord]
	ld c, a
	ld a, [wSouthConnectedMapXAlignment] ; X adjustment upon entering south map
	add c
	ld c, a
	ld [wXCoord], a
;>     view = mem16[addr(wSouthConnectedMapViewPointer)]
	ld a, [wSouthConnectedMapViewPointer] ; pointer to upper left corner of map without adjustment for X position
	ld l, a
	ld a, [wSouthConnectedMapViewPointer + 1]
	ld h, a
;>     view += wXCoord >> 1
	ld b, 0
	srl c
	add hl, bc
;>     wCurrentTileBlockMapViewPointer[0] = lo(view)
	ld a, l
	ld [wCurrentTileBlockMapViewPointer], a ; pointer to upper left corner of current tile block map section
;>     wCurrentTileBlockMapViewPointer[1] = hi(view)
	ld a, h
	ld [wCurrentTileBlockMapViewPointer + 1], a
.loadNewMap ; load the connected map that was entered
;>@stay else:                          # still on this map
;>@back     return OverworldLoop()
;> LoadMapHeader()                     # load the connected map, without a fade
	call LoadMapHeader
;> PlayDefaultMusicFadeOutCurrent()
	call PlayDefaultMusicFadeOutCurrent
;> RunPaletteCommand(SET_PAL_OVERWORLD)
	ld b, SET_PAL_OVERWORLD
	call RunPaletteCommand
; Since the sprite set shouldn't change, this will just update VRAM slots at
; x#SPRITESTATEDATA2_IMAGEBASEOFFSET without loading any tile patterns.
;> InitMapSprites()                    # the sprite set stays: only the VRAM slots are updated
	ld b, BANK(InitMapSprites)
	ld hl, InitMapSprites
	call Bankswitch
;> LoadTileBlockMap()
	call LoadTileBlockMap
;> return OverworldLoopLessDelay()
	jp OverworldLoopLessDelay

.didNotEnterConnectedMap
;=@stay
;=@back
	jp OverworldLoop

; function to play a sound when changing maps
;@ path: home/overworld
;@ def PlayMapChangeSound()
;@ The sound of going through a warp: in through a door (a door tile at the player's position) or out.
;@ Then fade out to black, unless the new map is dark (wMapPalOffset).
;@ test: wMapPalOffset = rand(1, 255)
PlayMapChangeSound::
;> if mem[coord(8, 8)] == 0x0B:  # the door tile of the overworld tileset
	; upper left tile of the 4x4 square the player's sprite is standing on
	ld a, [(8) * SCREEN_WIDTH + (8) + wTileMap]
	cp $0b ; door tile in tileset 0
	jr nz, .didNotGoThroughDoor
;>     PlaySound(0xAD)  # SFX_GO_INSIDE
	ld a, SFX_GO_INSIDE
	jr .playSound
.didNotGoThroughDoor
;> else:
;>     PlaySound(0xB5)  # SFX_GO_OUTSIDE
	ld a, SFX_GO_OUTSIDE
.playSound
	call PlaySound
;> if wMapPalOffset:
;>     return
	ld a, [wMapPalOffset]
	and a
	ret nz
;> return GBFadeOutToBlack()
	jp GBFadeOutToBlack

;@ path: home/overworld
;@ def CheckIfInOutsideMap() -> zero
;@ Zero for an outside map (a town or route): the overworld tileset or the Indigo Plateau's.
CheckIfInOutsideMap::
; If the player is in an outside map (a town or route), set the z flag
;> return wCurMapTileset == OVERWORLD or wCurMapTileset == PLATEAU
	ld a, [wCurMapTileset]
	and a ; most towns/routes have tileset 0 (OVERWORLD)
	ret z
	cp PLATEAU ; Route 23 / Indigo Plateau
	ret

; this function is an extra check that sometimes has to pass in order to warp, beyond just standing on a warp
; the "sometimes" qualification is necessary because of CheckWarpsNoCollision's behavior
; depending on the map, either "function 1" or "function 2" is used for the check
; "function 1" passes when the player is at the edge of the map and is facing towards the outside of the map
; "function 2" passes when the the tile in front of the player is among a certain set
; sets carry if the check passes, otherwise clears carry
;@ path: home/overworld
;@ def ExtraWarpCheck() -> carry
;@ The check a warp needs beyond standing on it (carry: it may be taken). In most buildings: the player faces
;@ the map's edge. Outside, on the ships, the port, the plateau, in Rocket Hideout B1F, B2F, B4F and Rock
;@ Tunnel 1F: the tile in front is a warp tile. S.S. Anne 3F uses the edge check.
;@ test: skip the checks in the other bank wait for frames on the way
ExtraWarpCheck::
;> edge = wCurMap == SS_ANNE_3F        # S.S. Anne 3F: the edge check
	ld a, [wCurMap]
	cp SS_ANNE_3F
	jr z, .useFunction1
;>@maps if not edge and wCurMap not in (ROCKET_HIDEOUT_B1F, ROCKET_HIDEOUT_B2F, ROCKET_HIDEOUT_B4F, ROCK_TUNNEL_1F):
	cp ROCKET_HIDEOUT_B1F
	jr z, .useFunction2
	cp ROCKET_HIDEOUT_B2F
	jr z, .useFunction2
;=@maps
	cp ROCKET_HIDEOUT_B4F
	jr z, .useFunction2
	cp ROCK_TUNNEL_1F
	jr z, .useFunction2
;>     tileset = wCurMapTileset
	ld a, [wCurMapTileset]
;>@tilesets     edge = tileset not in (OVERWORLD, SHIP, SHIP_PORT, PLATEAU)   # not outside, a ship, the port, the plateau
	and a ; outside tileset (OVERWORLD)
	jr z, .useFunction2
	cp SHIP ; S.S. Anne tileset
	jr z, .useFunction2
;=@tilesets
	cp SHIP_PORT ; Vermilion Port tileset
	jr z, .useFunction2
	cp PLATEAU ; Indigo Plateau tileset
	jr z, .useFunction2
.useFunction1
;> if edge:                            # does the player face the map's edge?
;>     return IsPlayerFacingEdgeOfMap()
	ld hl, IsPlayerFacingEdgeOfMap
	jr .doBankswitch
.useFunction2
;> return IsWarpTileInFrontOfPlayer()  # is the tile in front a warp tile? (both in the same bank)
	ld hl, IsWarpTileInFrontOfPlayer
.doBankswitch
	ld b, BANK(IsWarpTileInFrontOfPlayer)
	jp Bankswitch

;@ path: home/overworld
;@ def MapEntryAfterBattle()
;@ Back on the map after a battle: note whether the player stands on a warp (so bumping into a wall there can
;@ still warp), then fade the map in (or just set the palette on a dark map).
;@ test: skip the fade waits for frames
MapEntryAfterBattle::
;> IsPlayerStandingOnWarp()            # so bumping into a wall there can still warp
	; for enabling warp testing after collisions
	ld b, BANK(IsPlayerStandingOnWarp)
	ld hl, IsPlayerStandingOnWarp
	call Bankswitch
;> if not wMapPalOffset:
;>     return GBFadeInFromWhite()
	ld a, [wMapPalOffset]
	and a
	jp z, GBFadeInFromWhite
;> return LoadGBPal()                  # a dark map: just the palette
	jp LoadGBPal

;@ path: home/overworld
;@ def HandleBlackOut()
;@ The whole party fainted: fade out, stop the music, heal and halve the money, and warp to the last Pokémon
;@ Center (the "blacked out" text comes elsewhere). Never returns.
;@ test: skip never returns: enters the map
HandleBlackOut::
; For when all the player's pokemon faint.
; Does not print the "blacked out" message.
;> GBFadeOutToBlack()
	call GBFadeOutToBlack
;> StopMusic(8)
	ld a, $08
	call StopMusic
;> wStatusFlags4 &= ~(1 << BIT_BATTLE_OVER_OR_BLACKOUT) & 0xFF
	ld hl, wStatusFlags4
	res BIT_BATTLE_OVER_OR_BLACKOUT, [hl]
;> hLoadedROMBank = BANK(ResetStatusAndHalveMoneyOnBlackout)
	ld a, BANK(ResetStatusAndHalveMoneyOnBlackout) ; also BANK(PrepareForSpecialWarp) and BANK(SpecialEnterMap)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(ResetStatusAndHalveMoneyOnBlackout))
	ld [rROMB], a
;> ResetStatusAndHalveMoneyOnBlackout()
	call ResetStatusAndHalveMoneyOnBlackout
;> PrepareForSpecialWarp()
	call PrepareForSpecialWarp
;> PlayDefaultMusicFadeOutCurrent()
	call PlayDefaultMusicFadeOutCurrent
;> return SpecialEnterMap()
	jp SpecialEnterMap

;@ path: home/overworld
;@ def StopMusic(fade: a)
;@ Fade the music out (fade sets the speed), wait until it is silent, then stop all sounds.
;@ test: skip waits for the sound engine (run by VBlank) to finish the fade
StopMusic::
;> wAudioFadeOutControl = fade
	ld [wAudioFadeOutControl], a
;> wNewSoundID = 0xFF  # SFX_STOP_ALL_MUSIC
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
;> PlaySound(0xFF)
	call PlaySound
;> while wAudioFadeOutControl:
;>     wait_vblank_flag()    # the audio engine runs in the VBlank interrupt
.wait
	ld a, [wAudioFadeOutControl]
	and a
	jr nz, .wait
;> return StopAllSounds()
	jp StopAllSounds

;@ path: home/overworld
;@ def HandleFlyWarpOrDungeonWarp()
;@ Leave the map by Fly, Teleport, Dig, an Escape Rope or a dungeon warp: off the bike or water, the leaving
;@ animation, then warp. Never returns.
;@ test: skip never returns: enters the map
HandleFlyWarpOrDungeonWarp::
;> UpdateSprites()
	call UpdateSprites
;> Delay3()
	call Delay3
;> wBattleResult = 0
	xor a
	ld [wBattleResult], a
;> wWalkBikeSurfState = 0
	ld [wWalkBikeSurfState], a
;> wIsInBattle = 0
	ld [wIsInBattle], a
;> wMapPalOffset = 0
	ld [wMapPalOffset], a
;> wStatusFlags6 |= 1 << BIT_FLY_OR_DUNGEON_WARP
	ld hl, wStatusFlags6
	set BIT_FLY_OR_DUNGEON_WARP, [hl]
;> wStatusFlags6 &= ~(1 << BIT_ALWAYS_ON_BIKE) & 0xFF
	res BIT_ALWAYS_ON_BIKE, [hl]
;> LeaveMapAnim()
	call LeaveMapAnim
;> hLoadedROMBank = BANK(PrepareForSpecialWarp)
	ld a, BANK(PrepareForSpecialWarp)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(PrepareForSpecialWarp))
	ld [rROMB], a
;> PrepareForSpecialWarp()
	call PrepareForSpecialWarp
;> return SpecialEnterMap()
	jp SpecialEnterMap

;@ path: home/overworld
;@ def LeaveMapAnim()
;@ The player leaving the map (spinning away, flying off, falling into a hole), in another bank.
;@ test: skip animates over many frames
LeaveMapAnim::
;> return _LeaveMapAnim()
	ld b, BANK(_LeaveMapAnim)
	ld hl, _LeaveMapAnim
	jp Bankswitch

;@ path: home/overworld
;@ def LoadPlayerSpriteGraphics()
;@ Load the player's sprite for walking, biking or surfing (wWalkBikeSurfState). Where the bike is not
;@ allowed the player gets off and walks; on a map without water animation (hTileAnimations 0) surfing turns
;@ into walking too.
;@ test: skip copies the graphics to VRAM, waiting for VBlank
LoadPlayerSpriteGraphics::
; Load sprite graphics based on whether the player is standing, biking, or surfing.

	; 0: standing
	; 1: biking
	; 2: surfing

;> if wWalkBikeSurfState != 1:         # walking or surfing
	ld a, [wWalkBikeSurfState]
	dec a
	jr z, .ridingBike

;>     ok = hTileAnimations != 0       # surfing needs a map with water (animated tiles)
	ldh a, [hTileAnimations]
	and a
	jr nz, .determineGraphics
	jr .startWalking

.ridingBike
;> else:
;>     ok = IsBikeRidingAllowed()
	; If the bike can't be used,
	; start walking instead.
	call IsBikeRidingAllowed
	jr c, .determineGraphics

.startWalking
;> if not ok:                          # get off and walk
;>     wWalkBikeSurfState = wWalkBikeSurfStateCopy = 0
	xor a
	ld [wWalkBikeSurfState], a
	ld [wWalkBikeSurfStateCopy], a
;>     return LoadWalkingPlayerSpriteGraphics()
	jp LoadWalkingPlayerSpriteGraphics

.determineGraphics
;> if wWalkBikeSurfState == 0:
;>     return LoadWalkingPlayerSpriteGraphics()
	ld a, [wWalkBikeSurfState]
	and a
	jp z, LoadWalkingPlayerSpriteGraphics
;> if wWalkBikeSurfState == 1:
;>     return LoadBikePlayerSpriteGraphics()
	dec a
	jp z, LoadBikePlayerSpriteGraphics
;> if wWalkBikeSurfState == 2:
;>     return LoadSurfingPlayerSpriteGraphics()
	dec a
	jp z, LoadSurfingPlayerSpriteGraphics
;> return LoadWalkingPlayerSpriteGraphics()
	jp LoadWalkingPlayerSpriteGraphics

;@ path: home/overworld
;@ def IsBikeRidingAllowed() -> carry
;@ Carry if the bike can be ridden here: on Route 23, at the Indigo Plateau, or on a map whose tileset is in
;@ BikeRidingTilesets.
IsBikeRidingAllowed::
; The bike can be used on Route 23 and Indigo Plateau,
; or maps with tilesets in BikeRidingTilesets.
; Return carry if biking is allowed.

;> if wCurMap == ROUTE_23 or wCurMap == INDIGO_PLATEAU:
;>@yes1     return True
	ld a, [wCurMap]
	cp ROUTE_23
	jr z, .allowed
	cp INDIGO_PLATEAU
	jr z, .allowed

;> tileset = wCurMapTileset
	ld a, [wCurMapTileset]
	ld b, a
;> i = 0
	ld hl, BikeRidingTilesets
;> while True:
;>     t = mem[BikeRidingTilesets + i]
.loop
	ld a, [hli]
;>     if t == tileset:
;>@yes2         return True
	cp b
	jr z, .allowed
;>     if t == 0xFF:                   # the end of the list
	inc a
	jr nz, .loop
;>         return False
	and a
	ret
;>@next     i += 1

.allowed
;=@yes1
;=@yes2
	scf
	ret

;@ path: home/overworld
BikeRidingTilesets::
	db OVERWORLD
	db FOREST
	db UNDERGROUND
	db SHIP_PORT
	db CAVERN
	db -1 ; end

; load the tile pattern data of the current tileset into VRAM
;@ path: home/overworld
;@ def LoadTilesetTilePatternData()
;@ Copy the current tileset's 96 tiles to VRAM (the LCD must be off).
LoadTilesetTilePatternData::
;> src = wTilesetGfxPtr[0] | wTilesetGfxPtr[1] << 8
	ld a, [wTilesetGfxPtr]
	ld l, a
	ld a, [wTilesetGfxPtr + 1]
	ld h, a
;> return FarCopyData2(wTilesetBank, src, addr(vTileset), MAP_TILESET_SIZE * 16)
	ld de, vTileset
	ld bc, MAP_TILESET_SIZE * TILE_SIZE
	ld a, [wTilesetBank]
	jp FarCopyData2

; this loads the current map's complete tile map (which references blocks, not individual tiles) to wOverworldMap
; it can also load partial tile maps of connected maps into a border of length 3 around the current map
;@ path: home/overworld
;@ def LoadTileBlockMap()
;@ Build the block map of the current map in wOverworldMap: fill it with the background block, copy the map's
;@ blocks in with a border of 3 blocks on every side, then fill the borders with strips of the connected maps
;@ (where there are connections).
;@ test: wCurMapWidth = rand(1, 30); wCurMapHeight = rand(1, 1300 // (wCurMapWidth + 6) - 6); [mem.__setitem__(a, 0xFF) for a in (0xD371, 0xD37C, 0xD387, 0xD392)]  # no connections
LoadTileBlockMap::
; fill wOverworldMap-wOverworldMapEnd with the background tile
;>@fill fill(addr(wOverworldMap), wMapBackgroundTile, addr(wOverworldMapEnd) - addr(wOverworldMap))
	ld hl, wOverworldMap
	ld a, [wMapBackgroundTile]
	ld d, a
	ld bc, wOverworldMapEnd - wOverworldMap
.backgroundTileLoop
;=@fill
	ld a, d
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .backgroundTileLoop
; load tile map of current map (made of tile block IDs)
; a 3-byte border at the edges of the map is kept so that there is space for map connections
;> hMapWidth = wCurMapWidth
	ld hl, wOverworldMap
	ld a, [wCurMapWidth]
	ldh [hMapWidth], a
;> hMapStride = u8(wCurMapWidth + MAP_BORDER * 2)   # a row with its west and east borders
	add MAP_BORDER * 2 ; east and west
	ldh [hMapStride], a ; map width + border
;> dest = addr(wOverworldMap) + hMapStride * 3   # past the north border
	ld b, 0
	ld c, a
; make space for north border (next 3 lines)
	add hl, bc
	add hl, bc
	add hl, bc
;> dest += MAP_BORDER                  # and the west one
	ld c, MAP_BORDER
	add hl, bc ; this puts us past the (west) border
;> src = mem16[addr(wCurMapDataPtr)]         # the map's blocks
	ld a, [wCurMapDataPtr] ; tile map pointer
	ld e, a
	ld a, [wCurMapDataPtr + 1]
	ld d, a ; de = tile map pointer
;>@rows for _ in range(wCurMapHeight or 256):
	ld a, [wCurMapHeight]
	ld b, a
;>@copy     copy(dest, src, hMapWidth or 256)   # one row
;>@src     src += hMapWidth or 256
.rowLoop ; copy one row each iteration
	push hl
	ldh a, [hMapWidth] ; map width (without border)
	ld c, a
.rowInnerLoop
;=@copy
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .rowInnerLoop
; add the map width plus the border to the base address of the current row to get the next row's address
;>     dest += hMapStride
	pop hl
	ldh a, [hMapStride] ; map width + border
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
;=@rows
	dec b
	jr nz, .rowLoop
; north connection
;> if wNorthConnectedMap != 0xFF:
	ld a, [wNorthConnectedMap]
	cp $ff
	jr z, .southConnection
;>     SwitchToMapRomBank(wNorthConnectedMap)
	call SwitchToMapRomBank
;>     src = mem16[addr(wNorthConnectionStripSrc)]
	ld a, [wNorthConnectionStripSrc]
	ld l, a
	ld a, [wNorthConnectionStripSrc + 1]
	ld h, a
;>     dest = mem16[addr(wNorthConnectionStripDest)]
	ld a, [wNorthConnectionStripDest]
	ld e, a
	ld a, [wNorthConnectionStripDest + 1]
	ld d, a
;>     hNorthSouthConnectionStripWidth = wNorthConnectionStripLength
	ld a, [wNorthConnectionStripLength]
	ldh [hNorthSouthConnectionStripWidth], a
;>     hNorthSouthConnectedMapWidth = wNorthConnectedMapWidth
	ld a, [wNorthConnectedMapWidth]
	ldh [hNorthSouthConnectedMapWidth], a
;>     LoadNorthSouthConnectionsTileMap(src, dest)
	call LoadNorthSouthConnectionsTileMap
.southConnection
;> if wSouthConnectedMap != 0xFF:
	ld a, [wSouthConnectedMap]
	cp $ff
	jr z, .westConnection
;>     SwitchToMapRomBank(wSouthConnectedMap)
	call SwitchToMapRomBank
;>     src = mem16[addr(wSouthConnectionStripSrc)]
	ld a, [wSouthConnectionStripSrc]
	ld l, a
	ld a, [wSouthConnectionStripSrc + 1]
	ld h, a
;>     dest = mem16[addr(wSouthConnectionStripDest)]
	ld a, [wSouthConnectionStripDest]
	ld e, a
	ld a, [wSouthConnectionStripDest + 1]
	ld d, a
;>     hNorthSouthConnectionStripWidth = wSouthConnectionStripLength
	ld a, [wSouthConnectionStripLength]
	ldh [hNorthSouthConnectionStripWidth], a
;>     hNorthSouthConnectedMapWidth = wSouthConnectedMapWidth
	ld a, [wSouthConnectedMapWidth]
	ldh [hNorthSouthConnectedMapWidth], a
;>     LoadNorthSouthConnectionsTileMap(src, dest)
	call LoadNorthSouthConnectionsTileMap
.westConnection
;> if wWestConnectedMap != 0xFF:
	ld a, [wWestConnectedMap]
	cp $ff
	jr z, .eastConnection
;>     SwitchToMapRomBank(wWestConnectedMap)
	call SwitchToMapRomBank
;>     src = mem16[addr(wWestConnectionStripSrc)]
	ld a, [wWestConnectionStripSrc]
	ld l, a
	ld a, [wWestConnectionStripSrc + 1]
	ld h, a
;>     dest = mem16[addr(wWestConnectionStripDest)]
	ld a, [wWestConnectionStripDest]
	ld e, a
	ld a, [wWestConnectionStripDest + 1]
	ld d, a
;>     rows = wWestConnectionStripLength
	ld a, [wWestConnectionStripLength]
	ld b, a
;>     hEastWestConnectedMapWidth = wWestConnectedMapWidth
	ld a, [wWestConnectedMapWidth]
	ldh [hEastWestConnectedMapWidth], a
;>     LoadEastWestConnectionsTileMap(src, dest, rows)
	call LoadEastWestConnectionsTileMap
.eastConnection
;> if wEastConnectedMap != 0xFF:
	ld a, [wEastConnectedMap]
	cp $ff
	jr z, .done
;>     SwitchToMapRomBank(wEastConnectedMap)
	call SwitchToMapRomBank
;>     src = mem16[addr(wEastConnectionStripSrc)]
	ld a, [wEastConnectionStripSrc]
	ld l, a
	ld a, [wEastConnectionStripSrc + 1]
	ld h, a
;>     dest = mem16[addr(wEastConnectionStripDest)]
	ld a, [wEastConnectionStripDest]
	ld e, a
	ld a, [wEastConnectionStripDest + 1]
	ld d, a
;>     rows = wEastConnectionStripLength
	ld a, [wEastConnectionStripLength]
	ld b, a
;>     hEastWestConnectedMapWidth = wEastConnectedMapWidth
	ld a, [wEastConnectedMapWidth]
	ldh [hEastWestConnectedMapWidth], a
;>     LoadEastWestConnectionsTileMap(src, dest, rows)
	call LoadEastWestConnectionsTileMap
.done
	ret

;@ path: home/overworld
;@ def LoadNorthSouthConnectionsTileMap(src: hl, dest: de)
;@ Copy a strip of a map connected to the north or south into the 3 border rows of the block map: 3 rows of
;@ hNorthSouthConnectionStripWidth blocks from src (rows hNorthSouthConnectedMapWidth apart).
;@ test: src = rand_ram(200); dest = wOverworldMap + rand(0, 400); hNorthSouthConnectionStripWidth = rand(1, 30); hNorthSouthConnectedMapWidth = rand(1, 40); wCurMapWidth = rand(1, 30)
LoadNorthSouthConnectionsTileMap::
;>@rows for _ in range(MAP_BORDER):
	ld c, MAP_BORDER
.loop
	push de
	push hl
;>@copy     copy(dest, src, hNorthSouthConnectionStripWidth or 256)
	ldh a, [hNorthSouthConnectionStripWidth]
	ld b, a
.innerLoop
;=@copy
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .innerLoop
;=@copy
	pop hl
	pop de
;>     src += hNorthSouthConnectedMapWidth   # the next row of the connected map
	ldh a, [hNorthSouthConnectedMapWidth]
	add l
	ld l, a
	jr nc, .noCarry1
	inc h
.noCarry1
;>     dest += u8(wCurMapWidth + MAP_BORDER * 2)   # the next row of the block map
	ld a, [wCurMapWidth]
	add MAP_BORDER * 2
	add e
	ld e, a
	jr nc, .noCarry2
	inc d
.noCarry2
;=@rows
	dec c
	jr nz, .loop
	ret

;@ path: home/overworld
;@ def LoadEastWestConnectionsTileMap(src: hl, dest: de, rows: b)
;@ Copy a strip of a map connected to the east or west into the 3 border columns of the block map: `rows`
;@ rows of 3 blocks from src (rows hEastWestConnectedMapWidth apart).
;@ test: src = rand_ram(200); dest = wOverworldMap + rand(0, 400); rows = rand(1, 25); hEastWestConnectedMapWidth = rand(1, 40); wCurMapWidth = rand(1, 30)
LoadEastWestConnectionsTileMap::
;>@rows for _ in range(rows or 256):
;>@copy     copy(dest, src, MAP_BORDER)
	push hl
	push de
	ld c, MAP_BORDER
.innerLoop
;=@copy
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .innerLoop
;=@copy
	pop de
	pop hl
;>     src += hEastWestConnectedMapWidth   # the next row of the connected map
	ldh a, [hEastWestConnectedMapWidth]
	add l
	ld l, a
	jr nc, .noCarry1
	inc h
.noCarry1
;>     dest += u8(wCurMapWidth + MAP_BORDER * 2)   # the next row of the block map
	ld a, [wCurMapWidth]
	add MAP_BORDER * 2
	add e
	ld e, a
	jr nc, .noCarry2
	inc d
.noCarry2
;=@rows
	dec b
	jr nz, LoadEastWestConnectionsTileMap
	ret

; function to check if there is a sign or sprite in front of the player
; if so, it is stored in [hTextID]
; if not, [hTextID] is set to 0
;@ path: home/overworld
;@ def IsSpriteOrSignInFrontOfPlayer()
;@ What did the player press A at? hTextID gets the text of the sign in front of the player, else of the person
;@ in front (the person's number). Across a counter (wTilesetTalkingOverTiles) people can be talked to from
;@ two steps away. hTextID stays 0 if there is nobody.
;@ test: skip the predef call keeps the incoming hl, de and bc in wPredefHL..., which the pseudo-code has no names for
IsSpriteOrSignInFrontOfPlayer::
;> hTextID = 0
	xor a
	ldh [hTextID], a
;> if wNumSigns:
	ld a, [wNumSigns]
	and a
	jr z, .extendRangeOverCounter
; if there are signs
;>     _, y, x = GetTileAndCoordsInFrontOfPlayer()
	; get the coordinates in front of the player in de
	ld a, (GetTileAndCoordsInFrontOfPlayerPredef - PredefPointers) / 3
	call Predef
;>@signs     for i in range(wNumSigns):
	ld hl, wSignCoords
	ld a, [wNumSigns]
	ld b, a
	ld c, 0
;>         if wSignCoords[2 * i] != y:
.signLoop
	inc c
	ld a, [hli] ; sign Y
	cp d
	jr z, .yCoordMatched
;>             continue
	inc hl
	jr .retry
.yCoordMatched
;>         if wSignCoords[2 * i + 1] != x:
;>             continue
	ld a, [hli] ; sign X
	cp e
	jr nz, .retry
; X coord matched: found sign
;>         p = addr(wSignTextIDs) + i
	push hl
	push bc
	ld hl, wSignTextIDs
	ld b, 0
	dec c
	add hl, bc
;>         hTextID = mem[p]            # the sign's text
	ld a, [hl]
	ldh [hTextID], a ; store sign text ID
;>         return
	pop bc
	pop hl
	ret
.retry
;=@signs
	dec b
	jr nz, .signLoop
; check if the player is front of a counter in a pokemon center, pokemart, etc. and if so, extend the range at which he can talk to the NPC
.extendRangeOverCounter
;> tile, _, _ = GetTileAndCoordsInFrontOfPlayer()
	; get the tile in front of the player in c
	ld a, (GetTileAndCoordsInFrontOfPlayerPredef - PredefPointers) / 3
	call Predef
;>@tiles for i in range(3):
	ld hl, wTilesetTalkingOverTiles ; list of tiles that extend talking range (counter tiles)
	ld b, 3
	ld d, $20 ; talking range in pixels (long range)
;>     if wTilesetTalkingOverTiles[i] == tile:   # a counter: talk over it, from two steps away
;>         return IsSpriteInFrontOfPlayer2(0x20)
.counterTilesLoop
	ld a, [hli]
	cp c
	jr z, IsSpriteInFrontOfPlayer2 ; jumps if the tile in front of the player is a counter tile
;=@tiles
	dec b
	jr nz, .counterTilesLoop
;> IsSpriteInFrontOfPlayer()           # it follows: the normal range

; part of the above function, but sometimes its called on its own, when signs are irrelevant
; the caller must zero [hTextID]
;@ path: home/overworld
;@ def IsSpriteInFrontOfPlayer()
;@ Look for a person right in front of the player (16 pixels away); the caller clears hTextID first.
IsSpriteInFrontOfPlayer::
;> IsSpriteInFrontOfPlayer2(0x10)
	ld d, $10 ; talking range in pixels (normal range)
;@ path: home/overworld
;@ def IsSpriteInFrontOfPlayer2(distance: d)
;@ Look for a visible person `distance` pixels in front of the player (whose sprite is at y $3C, x $40 on the
;@ screen). If there is one, it turns to face the player and hTextID gets its number. Also sets
;@ wPlayerDirection from the way the player faces.
IsSpriteInFrontOfPlayer2::
;> y, x = 0x3C, 0x40                   # the player's sprite on the screen
	; Y and X position of player sprite
	ld bc, (($3c) & $ff) << 8 + (($40) & $ff)
;> facing = wSpritePlayerStateData1FacingDirection
	ld a, [wSpritePlayerStateData1FacingDirection]
; check if player facing up
;> if facing == SPRITE_FACING_UP:
	cp SPRITE_FACING_UP
	jr nz, .checkIfPlayerFacingDown
; facing up
;>     y = u8(y - distance)
	ld a, b
	sub d
	ld b, a
;>     direction = PLAYER_DIR_UP
	ld a, PLAYER_DIR_UP
	jr .doneCheckingDirection

.checkIfPlayerFacingDown
;> elif facing == SPRITE_FACING_DOWN:
	cp SPRITE_FACING_DOWN
	jr nz, .checkIfPlayerFacingRight
; facing down
;>     y = u8(y + distance)
	ld a, b
	add d
	ld b, a
;>     direction = PLAYER_DIR_DOWN
	ld a, PLAYER_DIR_DOWN
	jr .doneCheckingDirection

.checkIfPlayerFacingRight
;> elif facing == SPRITE_FACING_RIGHT:
	cp SPRITE_FACING_RIGHT
	jr nz, .playerFacingLeft
; facing right
;>     x = u8(x + distance)
	ld a, c
	add d
	ld c, a
;>     direction = PLAYER_DIR_RIGHT
	ld a, PLAYER_DIR_RIGHT
	jr .doneCheckingDirection

.playerFacingLeft
;> else:
; facing left
;>     x = u8(x - distance)
	ld a, c
	sub d
	ld c, a
;>     direction = PLAYER_DIR_LEFT
	ld a, PLAYER_DIR_LEFT
.doneCheckingDirection
;> wPlayerDirection = direction
	ld [wPlayerDirection], a
;> if not wNumSprites:
;>     return
	ld a, [wNumSprites]
	and a
	ret z
; if there are sprites
;>@each for n in range(1, wNumSprites + 1):
;>     sprite = (addr(wSprite01StateData1) & 0xFF00) | u8(addr(wSprite01StateData1) + (n - 1) * SPRITESTATEDATA1_LENGTH)
	ld hl, wSprite01StateData1
	ld d, a
	ld e, $01
.spriteLoop
;>     if mem[sprite] == 0:            # no sprite
;>         continue
	push hl
	ld a, [hli] ; image (0 if no sprite)
	and a
	jr z, .nextSprite
;>     if mem[sprite + 2] == 0xFF:     # hidden
;>         continue
	inc l
	ld a, [hli] ; sprite visibility
	inc a
	jr z, .nextSprite
;>     if mem[sprite + 4] != y:        # its place on the screen
;>         continue
	inc l
	ld a, [hli] ; Y location
	cp b
	jr nz, .nextSprite
;>     if mem[sprite + 6] == x:
;>@face         mem[sprite + 1] |= 1 << BIT_FACE_PLAYER   # it turns to the player (movement status)
;>@id         hTextID = n
;>@ret         return
	inc l
	ld a, [hl] ; X location
	cp c
	jr z, .foundSpriteInFrontOfPlayer
.nextSprite
;=@each
	pop hl
	ld a, l
	add SPRITESTATEDATA1_LENGTH
	ld l, a
	inc e
	dec d
;=@each
	jr nz, .spriteLoop
	ret
.foundSpriteInFrontOfPlayer
;=@face
	pop hl
	ld a, l
	and $f0
	inc a
	ld l, a ; hl = x#SPRITESTATEDATA1_MOVEMENTSTATUS
	set BIT_FACE_PLAYER, [hl]
;=@id
	ld a, e
	ldh [hTextID], a
;=@ret
	ret

; function to check if the player will jump down a ledge and check if the tile ahead is passable (when not surfing)
; sets the carry flag if there is a collision, and unsets it if there isn't a collision
;@ path: home/overworld
;@ def CollisionCheckOnLand() -> carry
;@ Can the player walk the step in wPlayerDirection? Carry (with the bump sound, unless it is already playing)
;@ if a person is in the way, a tile pair forbids it (or a ledge is jumped), or the tile is not walkable. No
;@ collisions while jumping a ledge or while the game moves the player.
CollisionCheckOnLand::
;> if wMovementFlags >> BIT_LEDGE_OR_FISHING & 1:   # jumping down a ledge
;>@no1     return False
	ld a, [wMovementFlags]
	bit BIT_LEDGE_OR_FISHING, a
	jr nz, .noCollision
; if not jumping a ledge
;> if wSimulatedJoypadStatesIndex:     # the game moves the player
;>@no2     return False
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	jr nz, .noCollision ; no collisions when the player's movements are being controlled by the game
;> blocked = wSpritePlayerStateData1CollisionData & wPlayerDirection   # a person that way
;> if not blocked:
	ld a, [wPlayerDirection] ; the direction that the player is trying to go in
	ld d, a
	ld a, [wSpritePlayerStateData1CollisionData]
	and d ; check if a sprite is in the direction the player is trying to go
	jr nz, .collision
;>     hTextID = 0
;>     IsSpriteInFrontOfPlayer()       # look again for a person in front
	xor a
	ldh [hTextID], a
	call IsSpriteInFrontOfPlayer ; check for sprite collisions again? when does the above check fail to detect a sprite collision?
;>     blocked = hTextID
	ldh a, [hTextID]
	and a ; was there a sprite collision?
	jr nz, .collision
; if no sprite collision
;> if not blocked:
;>     blocked = CheckForJumpingAndTilePairCollisions(TilePairCollisionsLand)
	ld hl, TilePairCollisionsLand
	call CheckForJumpingAndTilePairCollisions
	jr c, .collision
;> if not blocked:
;>     blocked = CheckTilePassable()
	call CheckTilePassable
;> if not blocked:
;>@no3     return False
	jr nc, .noCollision
.collision
;> if wChannelSoundIDs[CHAN5] != 0xB4: # SFX_COLLISION, unless it is already playing
;>     PlaySound(0xB4)
	ld a, [wChannelSoundIDs + CHAN5]
	cp SFX_COLLISION ; check if collision sound is already playing
	jr z, .setCarry
	ld a, SFX_COLLISION
	call PlaySound ; play collision sound (if it's not already playing)
.setCarry
;> return True
	scf
	ret
.noCollision
;=@no1
;=@no2
;=@no3
	and a
	ret

; function that checks if the tile in front of the player is passable
; clears carry if it is, sets carry if not
;@ path: home/overworld
;@ def CheckTilePassable() -> carry
;@ Carry if the tile in front of the player is not in the tileset's list of walkable tiles.
;@ test: skip the predef call keeps the incoming hl, de and bc in wPredefHL..., which the pseudo-code has no names for
CheckTilePassable::
;> GetTileAndCoordsInFrontOfPlayer()
	ld a, (GetTileAndCoordsInFrontOfPlayerPredef - PredefPointers) / 3
	call Predef
;> tile = wTileInFrontOfPlayer
	ld a, [wTileInFrontOfPlayer]
	ld c, a
;> tiles = wTilesetCollisionPtr[0] | wTilesetCollisionPtr[1] << 8   # the walkable tiles
	ld hl, wTilesetCollisionPtr ; pointer to list of passable tiles
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl now points to passable tiles
;>@loop while True:
;>     t = mem[tiles]
;>     tiles += 1
.loop
	ld a, [hli]
;>     if t == 0xFF:                   # not in the list
;>@no         return True
	cp $ff
	jr z, .tileNotPassable
;>     if t == tile:
;>         return False
	cp c
	ret z
;=@loop
	jr .loop
.tileNotPassable
;=@no
	scf
	ret

; check if the player is going to jump down a small ledge
; and check for collisions that only occur between certain pairs of tiles
; Input: hl - address of directional collision data
; sets carry if there is a collision and unsets carry if not
;@ path: home/overworld
;@ def CheckForJumpingAndTilePairCollisions(pairs: hl) -> carry
;@ Start a ledge jump if the player walks off a ledge (no collision then); otherwise check the tile pairs.
;@ test: skip the predef call keeps the incoming hl, de and bc in wPredefHL..., which the pseudo-code has no names for
CheckForJumpingAndTilePairCollisions::
;> GetTileAndCoordsInFrontOfPlayer()
	push hl
	ld a, (GetTileAndCoordsInFrontOfPlayerPredef - PredefPointers) / 3
	call Predef
;> HandleLedges()                      # may start a jump down a ledge
	push de
	push bc
	; check if the player is trying to jump a ledge
	ld b, BANK(HandleLedges)
	ld hl, HandleLedges
	call Bankswitch
;> # (bc and de keep the tile and coordinates in front of the player)
	pop bc
	pop de
	pop hl
;> if wMovementFlags >> BIT_LEDGE_OR_FISHING & 1:   # jumping: no collision
;>     return False
	and a
	ld a, [wMovementFlags]
	bit BIT_LEDGE_OR_FISHING, a
	ret nz
; if not jumping
;> return CheckForTilePairCollisions2(pairs)   # it follows right below

;@ path: home/overworld
;@ def CheckForTilePairCollisions2(pairs: hl) -> carry
;@ CheckForTilePairCollisions with the tile under the player read from the screen first.
CheckForTilePairCollisions2::
;> wTilePlayerStandingOn = mem[coord(8, 9)]
;> return CheckForTilePairCollisions(pairs)
	; tile the player is on
	ld a, [(9) * SCREEN_WIDTH + (8) + wTileMap]
	ld [wTilePlayerStandingOn], a

;@ path: home/overworld
;@ def CheckForTilePairCollisions(pairs: hl) -> carry
;@ Carry if the step goes between two tiles that the list at pairs keeps apart in this tileset (entries:
;@ tileset, tile 1, tile 2; $FF ends it): mostly heights, like the edge of a raised floor in a cave. After a
;@ near match (first tile matches, second not) the search goes on one byte off.
CheckForTilePairCollisions::
;> front = wTileInFrontOfPlayer
	ld a, [wTileInFrontOfPlayer]
	ld c, a
;>@scan while True:
;>     tileset = mem[pairs]
;>     pairs += 1
.tilePairCollisionLoop
	ld a, [wCurMapTileset]
	ld b, a
	ld a, [hli]
;>     if tileset == 0xFF:             # the end of the list
;>@none         return False
	cp $ff
	jr z, .noMatch
;>     if tileset != wCurMapTileset:   # an entry for another tileset
;>@skip         pairs += 2
;>@next         continue
	cp b
	jr z, .tilesetMatches
	inc hl
.retry
;=@skip
	inc hl
;=@next
	jr .tilePairCollisionLoop
.tilesetMatches
;>     standing = wTilePlayerStandingOn
;>     if mem[pairs] == standing:      # standing on the pair's first tile
	ld a, [wTilePlayerStandingOn]
	ld b, a
	ld a, [hl]
	cp b
	jr z, .currentTileMatchesFirstInPair
;>@f1         pairs += 1
;>@f2         if mem[pairs] == front: return True   # and stepping onto its second
;>@f3         continue                # (it goes on at the second tile, read as a tileset)
;>     if mem[pairs + 1] != standing:  # not on the second tile either
	inc hl
	ld a, [hl]
	cp b
	jr z, .currentTileMatchesSecondInPair
;>         pairs += 2
;>         continue
	jr .retry
.currentTileMatchesFirstInPair
;=@f1
	inc hl
;=@f2
	ld a, [hl]
	cp c
	jr z, .foundMatch
;=@f3
	jr .tilePairCollisionLoop
.currentTileMatchesSecondInPair
;>     first = mem[pairs]              # standing on the second tile: is the first one in front?
	dec hl
	ld a, [hli]
;>     if first != front:
	cp c
;>         pairs += 2
	inc hl
;>         continue
	jr nz, .tilePairCollisionLoop
.foundMatch
;>     return True
	scf
	ret
.noMatch
;=@none
	and a
	ret

; FORMAT: tileset number, tile 1, tile 2
; terminated by -1
; these entries indicate that the player may not cross between tile 1 and tile 2
; it's mainly used to simulate differences in elevation

;@ path: home/overworld
TilePairCollisionsLand::
	db CAVERN, $20, $05
	db CAVERN, $41, $05
	db FOREST, $30, $2E
	db CAVERN, $2A, $05
	db CAVERN, $05, $21
	db FOREST, $52, $2E
	db FOREST, $55, $2E
	db FOREST, $56, $2E
	db FOREST, $20, $2E
	db FOREST, $5E, $2E
	db FOREST, $5F, $2E
	db -1 ; end

;@ path: home/overworld
TilePairCollisionsWater::
	db FOREST, $14, $2E
	db FOREST, $48, $2E
	db CAVERN, $14, $05
	db -1 ; end

; this builds a tile map from the tile block map based on the current X/Y coordinates of the player's character
;@ path: home/overworld
;@ def LoadCurrentMapView()
;@ Draw the map around the player: the 6x5 blocks from the block map at wCurrentTileBlockMapViewPointer go
;@ into wSurroundingTiles as tiles (from the tileset's blocks, in its bank), then the 20x18 tiles of the screen
;@ are copied from there to the screen buffer, half a block further right or down when the player stands in
;@ the right or bottom half of a block.
LoadCurrentMapView::
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = wTilesetBank       # the tileset's blocks are in its bank
;> set_rom_bank(wTilesetBank)
	ld a, [wTilesetBank]
	ldh [hLoadedROMBank], a
	ld [rROMB], a
;> view = wCurrentTileBlockMapViewPointer[0] | wCurrentTileBlockMapViewPointer[1] << 8   # the top left block
	ld a, [wCurrentTileBlockMapViewPointer] ; address of upper left corner of current map view
	ld e, a
	ld a, [wCurrentTileBlockMapViewPointer + 1]
	ld d, a
;> dest = addr(wSurroundingTiles)
	ld hl, wSurroundingTiles
;>@rows for _ in range(SCREEN_BLOCK_HEIGHT):
	ld b, SCREEN_BLOCK_HEIGHT
.rowLoop ; each loop iteration fills in one row of tile blocks
	push hl
	push de
;>@cols     for c in range(SCREEN_BLOCK_WIDTH):
	ld c, SCREEN_BLOCK_WIDTH
;>@draw         DrawTileBlock(mem[view + c], dest + c * BLOCK_WIDTH)
.rowInnerLoop ; loop to draw each tile block of the current row
	push bc
	push de
	push hl
	ld a, [de]
	ld c, a ; tile block number
	call DrawTileBlock
;=@draw
	pop hl
	pop de
	pop bc
;=@cols
	inc hl
	inc hl
	inc hl
	inc hl
	inc de
;=@cols
	dec c
	jr nz, .rowInnerLoop
; update tile block map pointer to next row's address
;>     # (view and dest come back off the stack)
	pop de
;>     view += u8(wCurMapWidth + MAP_BORDER * 2)   # the next row of the block map
	ld a, [wCurMapWidth]
	add MAP_BORDER * 2
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
; update tile map pointer to next row's address
;>     dest += SURROUNDING_WIDTH * BLOCK_HEIGHT
	pop hl
	ld a, SURROUNDING_WIDTH * BLOCK_HEIGHT
	add l
	ld l, a
	jr nc, .noCarry2
	inc h
.noCarry2
;=@rows
	dec b
	jr nz, .rowLoop
;> src = addr(wSurroundingTiles)
	ld hl, wSurroundingTiles
	ld bc, 0
; adjust for Y coord within tile block
;> if wYBlockCoord:                    # in the bottom half of a block: two tile rows further down
;>     src += SURROUNDING_WIDTH * 2
	ld a, [wYBlockCoord]
	and a
	jr z, .adjustForXCoordWithinTileBlock
	ld bc, SURROUNDING_WIDTH * 2
	add hl, bc
.adjustForXCoordWithinTileBlock
;> if wXBlockCoord:                    # in the right half: two tiles further right
;>     src += BLOCK_WIDTH // 2
	ld a, [wXBlockCoord]
	and a
	jr z, .copyToVisibleAreaBuffer
	ld bc, BLOCK_WIDTH / 2
	add hl, bc
.copyToVisibleAreaBuffer
;>@rows2 for row in range(SCREEN_HEIGHT):
	; base address for the tiles that are directly transferred to VRAM during V-blank
	ld de, (0) * SCREEN_WIDTH + (0) + wTileMap
	ld b, SCREEN_HEIGHT
;>     copy(coord(0, row), src + row * SURROUNDING_WIDTH, SCREEN_WIDTH)
.rowLoop2
	ld c, SCREEN_WIDTH
.rowInnerLoop2
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .rowInnerLoop2
;=@rows2
	ld a, SURROUNDING_WIDTH - SCREEN_WIDTH
	add l
	ld l, a
	jr nc, .noCarry3
	inc h
.noCarry3
;=@rows2
	dec b
	jr nz, .rowLoop2
;> hLoadedROMBank = saved
;> set_rom_bank(saved)
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret

;@ path: home/overworld
;@ def AdvancePlayerSprite()
;@ One frame of the player's step (wWalkCounter counts 8 frames down): the map coordinates change on the last
;@ frame. On the first frame the player moves on half a block: the VRAM view pointer moves, and on entering
;@ a new block the block map pointer too, the map view is redrawn and the row or column coming into view is
;@ scheduled for VBlank. Every frame the background scrolls 2 pixels and all other sprites shift the other way,
;@ so the player stays in the middle.
AdvancePlayerSprite::
;> dy = wSpritePlayerStateData1YStepVector
;> dx = wSpritePlayerStateData1XStepVector
	ld a, [wSpritePlayerStateData1YStepVector]
	ld b, a
	ld a, [wSpritePlayerStateData1XStepVector]
	ld c, a
;> wWalkCounter = u8(wWalkCounter - 1)
;> if wWalkCounter == 0:               # the last frame: the player arrives
	ld hl, wWalkCounter
	dec [hl]
	jr nz, .afterUpdateMapCoords
; if it's the end of the animation, update the player's map coordinates
;>     wYCoord = u8(wYCoord + dy)
	ld a, [wYCoord]
	add b
	ld [wYCoord], a
;>     wXCoord = u8(wXCoord + dx)
	ld a, [wXCoord]
	add c
	ld [wXCoord], a
.afterUpdateMapCoords
;> if wWalkCounter == 7:               # the first frame of the step
	ld a, [wWalkCounter]
	cp $07
	jp nz, .scrollBackgroundAndSprites
; if this is the first iteration of the animation
;>     v = wMapViewVRAMPointer[0]
;>     if dx == 1:
	ld a, c
	cp $01
	jr nz, .checkIfMovingWest
; moving east
;>         row = v & 0xE0              # east: 2 tiles right, round the 32-tile row
	ld a, [wMapViewVRAMPointer]
	ld e, a
	and $e0
	ld d, a
;>         wMapViewVRAMPointer[0] = row | ((v + 2) & 0x1F)
	ld a, e
	add $02
	and $1f
	or d
	ld [wMapViewVRAMPointer], a
	jr .adjustXCoordWithinBlock
.checkIfMovingWest
;>     elif dx == 0xFF:
	cp $ff
	jr nz, .checkIfMovingSouth
; moving west
;>         row = v & 0xE0              # west
	ld a, [wMapViewVRAMPointer]
	ld e, a
	and $e0
	ld d, a
;>         wMapViewVRAMPointer[0] = row | ((v - 2) & 0x1F)
	ld a, e
	sub $02
	and $1f
	or d
	ld [wMapViewVRAMPointer], a
	jr .adjustXCoordWithinBlock
.checkIfMovingSouth
;>     elif dy == 1:
	ld a, b
	cp $01
	jr nz, .checkIfMovingNorth
; moving south
;>         wMapViewVRAMPointer[0] = u8(v + 0x40)   # south: 2 tile rows down
	ld a, [wMapViewVRAMPointer]
	add $40
	ld [wMapViewVRAMPointer], a
;>         if v + 0x40 > 0xFF:          # round the BG map at $9800
	jr nc, .adjustXCoordWithinBlock
;>             wMapViewVRAMPointer[1] = ((wMapViewVRAMPointer[1] + 1) & 3) | 0x98
	ld a, [wMapViewVRAMPointer + 1]
	inc a
	and $03
	or $98
	ld [wMapViewVRAMPointer + 1], a
	jr .adjustXCoordWithinBlock
.checkIfMovingNorth
;>     elif dy == 0xFF:
	cp $ff
	jr nz, .adjustXCoordWithinBlock
; moving north
;>         wMapViewVRAMPointer[0] = u8(v - 0x40)   # north
	ld a, [wMapViewVRAMPointer]
	sub $40
	ld [wMapViewVRAMPointer], a
;>         if v < 0x40:
	jr nc, .adjustXCoordWithinBlock
;>             wMapViewVRAMPointer[1] = ((wMapViewVRAMPointer[1] - 1) & 3) | 0x98
	ld a, [wMapViewVRAMPointer + 1]
	dec a
	and $03
	or $98
	ld [wMapViewVRAMPointer + 1], a
.adjustXCoordWithinBlock
;>     # (dx is tested here without effect: the jump goes to the next line)
	ld a, c
	and a
	jr z, .pointlessJump ; mistake?
.pointlessJump
;>     wXBlockCoord = u8(wXBlockCoord + dx)   # half a block on
	ld hl, wXBlockCoord
	ld a, [hl]
	add c
	ld [hl], a
;>     if wXBlockCoord == 2:           # into the block to the east
	cp $02
	jr nz, .checkForMoveToWestBlock
; moved into the tile block to the east
;>         wXBlockCoord = 0
;>         wXOffsetSinceLastSpecialWarp = u8(wXOffsetSinceLastSpecialWarp + 1)
	xor a
	ld [hl], a
	ld hl, wXOffsetSinceLastSpecialWarp
	inc [hl]
;>         MoveTileBlockMapPointerEast(addr(wCurrentTileBlockMapViewPointer))
	ld de, wCurrentTileBlockMapViewPointer
	call MoveTileBlockMapPointerEast
	jr .updateMapView
.checkForMoveToWestBlock
;>     elif wXBlockCoord == 0xFF:      # into the block to the west
	cp $ff
	jr nz, .adjustYCoordWithinBlock
; moved into the tile block to the west
;>         wXBlockCoord = 1
;>         wXOffsetSinceLastSpecialWarp = u8(wXOffsetSinceLastSpecialWarp - 1)
	ld a, $01
	ld [hl], a
	ld hl, wXOffsetSinceLastSpecialWarp
	dec [hl]
;>         MoveTileBlockMapPointerWest(addr(wCurrentTileBlockMapViewPointer))
	ld de, wCurrentTileBlockMapViewPointer
	call MoveTileBlockMapPointerWest
	jr .updateMapView
.adjustYCoordWithinBlock
;>     else:
;>         wYBlockCoord = u8(wYBlockCoord + dy)
	ld hl, wYBlockCoord
	ld a, [hl]
	add b
	ld [hl], a
;>         if wYBlockCoord == 2:       # into the block to the south
	cp $02
	jr nz, .checkForMoveToNorthBlock
; moved into the tile block to the south
;>             wYBlockCoord = 0
;>             wYOffsetSinceLastSpecialWarp = u8(wYOffsetSinceLastSpecialWarp + 1)
	xor a
	ld [hl], a
	ld hl, wYOffsetSinceLastSpecialWarp
	inc [hl]
;>             MoveTileBlockMapPointerSouth(wCurMapWidth, addr(wCurrentTileBlockMapViewPointer))
	ld de, wCurrentTileBlockMapViewPointer
	ld a, [wCurMapWidth]
	call MoveTileBlockMapPointerSouth
	jr .updateMapView
.checkForMoveToNorthBlock
;>         elif wYBlockCoord == 0xFF:  # into the block to the north
	cp $ff
	jr nz, .updateMapView
; moved into the tile block to the north
;>             wYBlockCoord = 1
;>             wYOffsetSinceLastSpecialWarp = u8(wYOffsetSinceLastSpecialWarp - 1)
	ld a, $01
	ld [hl], a
	ld hl, wYOffsetSinceLastSpecialWarp
	dec [hl]
;>             MoveTileBlockMapPointerNorth(wCurMapWidth, addr(wCurrentTileBlockMapViewPointer))
	ld de, wCurrentTileBlockMapViewPointer
	ld a, [wCurMapWidth]
	call MoveTileBlockMapPointerNorth
.updateMapView
;>     LoadCurrentMapView()
	call LoadCurrentMapView
;>     if wSpritePlayerStateData1YStepVector == 1:   # the row or column coming into view
;>         ScheduleSouthRowRedraw()
	ld a, [wSpritePlayerStateData1YStepVector]
	cp $01
	jr nz, .checkIfMovingNorth2
; if moving south
	call ScheduleSouthRowRedraw
	jr .scrollBackgroundAndSprites
.checkIfMovingNorth2
;>     elif wSpritePlayerStateData1YStepVector == 0xFF:
;>         ScheduleNorthRowRedraw()
	cp $ff
	jr nz, .checkIfMovingEast2
; if moving north
	call ScheduleNorthRowRedraw
	jr .scrollBackgroundAndSprites
.checkIfMovingEast2
;>     elif wSpritePlayerStateData1XStepVector == 1:
;>         ScheduleEastColumnRedraw()
	ld a, [wSpritePlayerStateData1XStepVector]
	cp $01
	jr nz, .checkIfMovingWest2
; if moving east
	call ScheduleEastColumnRedraw
	jr .scrollBackgroundAndSprites
.checkIfMovingWest2
;>     elif wSpritePlayerStateData1XStepVector == 0xFF:
;>         ScheduleWestColumnRedraw()
	cp $ff
	jr nz, .scrollBackgroundAndSprites
; if moving west
	call ScheduleWestColumnRedraw
.scrollBackgroundAndSprites
;> dy = u8(wSpritePlayerStateData1YStepVector * 2)   # 2 pixels a frame
;> dx = u8(wSpritePlayerStateData1XStepVector * 2)
	ld a, [wSpritePlayerStateData1YStepVector]
	ld b, a
	ld a, [wSpritePlayerStateData1XStepVector]
	ld c, a
	sla b
	sla c
;> hSCY = u8(hSCY + dy)
	ldh a, [hSCY]
	add b
	ldh [hSCY], a ; update background scroll Y
;> hSCX = u8(hSCX + dx)
	ldh a, [hSCX]
	add c
	ldh [hSCX], a ; update background scroll X
; shift all the sprites in the direction opposite of the player's motion
; so that the player appears to move relative to them
;> page = addr(wSprite01StateData1YPixels) & 0xFF00
;>@spr for k in range(wNumSprites):     # the other sprites move the other way
	ld hl, wSprite01StateData1YPixels
	ld a, [wNumSprites]
	and a ; are there any sprites?
	jr z, .done
	ld e, a
.spriteShiftLoop
;>     y = page | u8(addr(wSprite01StateData1YPixels) + k * SPRITESTATEDATA1_LENGTH)
;>     mem[y] = u8(mem[y] - dy)
	ld a, [hl]
	sub b
	ld [hli], a
;>     mem[y + 2] = u8(mem[y + 2] - dx)   # its x pixels
	inc l
	ld a, [hl]
	sub c
	ld [hl], a
;=@spr
	ld a, $0e
	add l
	ld l, a
	dec e
	jr nz, .spriteShiftLoop
.done
	ret

; the following four functions are used to move the pointer to the upper left
; corner of the tile block map in the direction of motion

;@ path: home/overworld
;@ def MoveTileBlockMapPointerEast(ptr: de)
;@ Add 1 to the 16-bit pointer at ptr (the block map view pointer): one block east.
;@ test: ptr = rand_ram(2)
MoveTileBlockMapPointerEast::
;> low = mem[ptr] + 1
	ld a, [de]
	add $01
;> mem[ptr] = u8(low)
	ld [de], a
;> if low <= 0xFF:
;>     return
	ret nc
;> mem[ptr + 1] = u8(mem[ptr + 1] + 1) # the carry into the high byte
	inc de
	ld a, [de]
	inc a
	ld [de], a
	ret

;@ path: home/overworld
;@ def MoveTileBlockMapPointerWest(ptr: de)
;@ Subtract 1 from the 16-bit pointer at ptr: one block west.
;@ test: ptr = rand_ram(2)
MoveTileBlockMapPointerWest::
;> low = mem[ptr] - 1
	ld a, [de]
	sub $01
;> mem[ptr] = u8(low)
	ld [de], a
;> if low >= 0:
;>     return
	ret nc
;> mem[ptr + 1] = u8(mem[ptr + 1] - 1) # the borrow from the high byte
	inc de
	ld a, [de]
	dec a
	ld [de], a
	ret

;@ path: home/overworld
;@ def MoveTileBlockMapPointerSouth(width: a, ptr: de)
;@ Add a block map row (the map's width plus the borders) to the 16-bit pointer at ptr: one block south.
;@ test: ptr = rand_ram(2)
MoveTileBlockMapPointerSouth::
;> low = mem[ptr] + u8(width + MAP_BORDER * 2)
	add MAP_BORDER * 2
	ld b, a
	ld a, [de]
	add b
;> mem[ptr] = u8(low)
	ld [de], a
;> if low <= 0xFF:
;>     return
	ret nc
;> mem[ptr + 1] = u8(mem[ptr + 1] + 1) # the carry into the high byte
	inc de
	ld a, [de]
	inc a
	ld [de], a
	ret

;@ path: home/overworld
;@ def MoveTileBlockMapPointerNorth(width: a, ptr: de)
;@ Subtract a block map row from the 16-bit pointer at ptr: one block north.
;@ test: ptr = rand_ram(2)
MoveTileBlockMapPointerNorth::
;> low = mem[ptr] - u8(width + MAP_BORDER * 2)
	add MAP_BORDER * 2
	ld b, a
	ld a, [de]
	sub b
;> mem[ptr] = u8(low)
	ld [de], a
;> if low >= 0:
;>     return
	ret nc
;> mem[ptr + 1] = u8(mem[ptr + 1] - 1) # the borrow from the high byte
	inc de
	ld a, [de]
	dec a
	ld [de], a
	ret

; the following 6 functions are used to tell the V-blank handler to redraw
; the portion of the map that was newly exposed due to the player's movement

;@ path: home/overworld
;@ def ScheduleNorthRowRedraw()
;@ Have VBlank draw the top two tile rows of the screen (just come into view walking north) at the top of the
;@ view in the VRAM BG map.
ScheduleNorthRowRedraw::
;> CopyToRedrawRowOrColumnSrcTiles(coord(0, 0))   # the top two tile rows
	ld hl, (0) * SCREEN_WIDTH + (0) + wTileMap
	call CopyToRedrawRowOrColumnSrcTiles
;> hRedrawRowOrColumnDest[0] = wMapViewVRAMPointer[0]   # at the view's top
	ld a, [wMapViewVRAMPointer]
	ldh [hRedrawRowOrColumnDest], a
;> hRedrawRowOrColumnDest[1] = wMapViewVRAMPointer[1]
	ld a, [wMapViewVRAMPointer + 1]
	ldh [hRedrawRowOrColumnDest + 1], a
;> hRedrawRowOrColumnMode = REDRAW_ROW
	ld a, REDRAW_ROW
	ldh [hRedrawRowOrColumnMode], a
	ret

;@ path: home/overworld
;@ def CopyToRedrawRowOrColumnSrcTiles(src: hl)
;@ Copy two screen rows of tiles from src to wRedrawRowOrColumnSrcTiles, for VBlank to draw.
CopyToRedrawRowOrColumnSrcTiles::
;>@copy copy(addr(wRedrawRowOrColumnSrcTiles), src, 2 * SCREEN_WIDTH)
	ld de, wRedrawRowOrColumnSrcTiles
	ld c, 2 * SCREEN_WIDTH
.loop
;=@copy
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
;> return
	ret

;@ path: home/overworld
;@ def ScheduleSouthRowRedraw()
;@ Have VBlank draw the bottom two tile rows of the screen (walking south) 16 rows below the view's top in the
;@ BG map, wrapping round its 32 rows.
ScheduleSouthRowRedraw::
;> CopyToRedrawRowOrColumnSrcTiles(coord(0, 16))   # the bottom two tile rows
	ld hl, (16) * SCREEN_WIDTH + (0) + wTileMap
	call CopyToRedrawRowOrColumnSrcTiles
;> dest = (wMapViewVRAMPointer[0] | wMapViewVRAMPointer[1] << 8) + 0x200   # 16 tile rows below the view's top
	ld a, [wMapViewVRAMPointer]
	ld l, a
	ld a, [wMapViewVRAMPointer + 1]
	ld h, a
	ld bc, $200
	add hl, bc
;> hRedrawRowOrColumnDest[1] = (hi(dest) & 3) | 0x98   # round the BG map at $9800
	ld a, h
	and $03
	or $98
	ldh [hRedrawRowOrColumnDest + 1], a
;> hRedrawRowOrColumnDest[0] = lo(dest)
	ld a, l
	ldh [hRedrawRowOrColumnDest], a
;> hRedrawRowOrColumnMode = REDRAW_ROW
	ld a, REDRAW_ROW
	ldh [hRedrawRowOrColumnMode], a
	ret

;@ path: home/overworld
;@ def ScheduleEastColumnRedraw()
;@ Have VBlank draw the right two tile columns of the screen (walking east) 18 tiles right of the view's left
;@ edge in the BG map, wrapping round its 32 columns.
ScheduleEastColumnRedraw::
;> ScheduleColumnRedrawHelper(coord(18, 0))   # the right two tile columns
	ld hl, (0) * SCREEN_WIDTH + (18) + wTileMap
	call ScheduleColumnRedrawHelper
;> v = wMapViewVRAMPointer[0]
	ld a, [wMapViewVRAMPointer]
	ld c, a
;> row = v & 0xE0
	and $e0
	ld b, a
;> hRedrawRowOrColumnDest[0] = row | ((v + 18) & 0x1F)   # 18 tiles right, round the 32-tile row
	ld a, c
	add 18
	and $1f
	or b
	ldh [hRedrawRowOrColumnDest], a
;> hRedrawRowOrColumnDest[1] = wMapViewVRAMPointer[1]
	ld a, [wMapViewVRAMPointer + 1]
	ldh [hRedrawRowOrColumnDest + 1], a
;> hRedrawRowOrColumnMode = REDRAW_COL
	ld a, REDRAW_COL
	ldh [hRedrawRowOrColumnMode], a
	ret

;@ path: home/overworld
;@ def ScheduleColumnRedrawHelper(src: hl)
;@ Copy two screen columns of tiles from src (2 tiles from each of the 18 rows) to wRedrawRowOrColumnSrcTiles.
ScheduleColumnRedrawHelper::
;>@rows for row in range(SCREEN_HEIGHT):
	ld de, wRedrawRowOrColumnSrcTiles
	ld c, SCREEN_HEIGHT
;>     wRedrawRowOrColumnSrcTiles[2 * row] = mem[src + row * SCREEN_WIDTH]
.loop
	ld a, [hli]
	ld [de], a
	inc de
;>     wRedrawRowOrColumnSrcTiles[2 * row + 1] = mem[src + row * SCREEN_WIDTH + 1]
	ld a, [hl]
	ld [de], a
	inc de
;=@rows
	ld a, SCREEN_WIDTH - 1
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
;=@rows
	dec c
	jr nz, .loop
	ret

;@ path: home/overworld
;@ def ScheduleWestColumnRedraw()
;@ Have VBlank draw the left two tile columns of the screen (walking west) at the view's left edge in the BG
;@ map.
ScheduleWestColumnRedraw::
;> ScheduleColumnRedrawHelper(coord(0, 0))   # the left two tile columns
	ld hl, (0) * SCREEN_WIDTH + (0) + wTileMap
	call ScheduleColumnRedrawHelper
;> hRedrawRowOrColumnDest[0] = wMapViewVRAMPointer[0]   # at the view's left edge
	ld a, [wMapViewVRAMPointer]
	ldh [hRedrawRowOrColumnDest], a
;> hRedrawRowOrColumnDest[1] = wMapViewVRAMPointer[1]
	ld a, [wMapViewVRAMPointer + 1]
	ldh [hRedrawRowOrColumnDest + 1], a
;> hRedrawRowOrColumnMode = REDRAW_COL
	ld a, REDRAW_COL
	ldh [hRedrawRowOrColumnMode], a
	ret

; function to write the tiles that make up a tile block to memory
; Input: c = tile block ID, hl = destination address
;@ path: home/overworld
;@ def DrawTileBlock(block: c, dest: hl)
;@ Write the 4x4 tiles of a block (16 bytes in the tileset's block data) to dest in wSurroundingTiles, whose
;@ rows are 24 tiles wide.
;@ test: dest = wSurroundingTiles + rand(0, 380)
DrawTileBlock::
;> base = wTilesetBlocksPtr[0] | wTilesetBlocksPtr[1] << 8   # the tileset's blocks, 16 tiles each
	push hl
	ld a, [wTilesetBlocksPtr] ; pointer to tiles
	ld l, a
	ld a, [wTilesetBlocksPtr + 1]
	ld h, a
;> hi_lo = swap(block)
	ld a, c
	swap a
	ld b, a
;> offset = (hi_lo & 0xF0) | (hi_lo & 0x0F) << 8   # block * 16
	and $f0
	ld c, a
	ld a, b
	and $0f
	ld b, a ; bc = tile block ID * 0x10
;> tiles = base + offset
	add hl, bc
	ld d, h
	ld e, l ; de = address of the tile block's tiles
	pop hl
;>@rows for row in range(BLOCK_HEIGHT):
	ld c, BLOCK_HEIGHT ; 4 loop iterations
.loop ; each loop iteration, write 4 tile numbers
	push bc
;>     d, t = dest + row * SURROUNDING_WIDTH, tiles + row * BLOCK_WIDTH
;>     mem[d], mem[d + 1] = mem[t], mem[t + 1]
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
;>     mem[d + 2], mem[d + 3] = mem[t + 2], mem[t + 3]
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	inc de
;=@rows
	ld bc, SURROUNDING_WIDTH - (BLOCK_WIDTH - 1)
	add hl, bc
	pop bc
	dec c
	jr nz, .loop
	ret

; function to update joypad state and simulate button presses
;@ path: home/overworld
;@ def JoypadOverworld()
;@ Read the joypad for the overworld, after running the map's script. On Cycling Road the player rolls down by
;@ itself when no button is held (not during a trainer battle's approach). While a script walks the player,
;@ the held keys come from the list of simulated joypad states, read backwards from wSimulatedJoypadStatesEnd;
;@ at its end the scripted walk stops.
;@ test: skip runs the map's script
JoypadOverworld::
;> wSpritePlayerStateData1YStepVector = 0
	xor a
	ld [wSpritePlayerStateData1YStepVector], a
;> wSpritePlayerStateData1XStepVector = 0
	ld [wSpritePlayerStateData1XStepVector], a
;> RunMapScript()
	call RunMapScript
;> Joypad()
	call Joypad
;> if not wStatusFlags7 >> BIT_TRAINER_BATTLE & 1:   # no trainer coming
	ld a, [wStatusFlags7]
	bit BIT_TRAINER_BATTLE, a
	jr nz, .notForcedDownwards
;>     if wCurMap == ROUTE_17:         # Cycling Road
	ld a, [wCurMap]
	cp ROUTE_17 ; Cycling Road
	jr nz, .notForcedDownwards
;>         if not hJoyHeld & (PAD_CTRL_PAD | PAD_B | PAD_A):
	ldh a, [hJoyHeld]
	and PAD_CTRL_PAD | PAD_B | PAD_A
	jr nz, .notForcedDownwards
;>             hJoyHeld = PAD_DOWN     # nothing held: roll down the slope
	ld a, PAD_DOWN
	ldh [hJoyHeld], a ; on the cycling road, if there isn't a trainer and the player isn't pressing buttons, simulate a down press
.notForcedDownwards
;> if not wStatusFlags5 >> BIT_SCRIPTED_MOVEMENT_STATE & 1:   # no scripted walk
;>     return
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_MOVEMENT_STATE, a
	ret z
; if simulating button presses
;> if hJoyHeld & wOverrideSimulatedJoypadStatesMask:   # real keys that win over the simulated ones
;>     return
	ldh a, [hJoyHeld]
	ld b, a
	ld a, [wOverrideSimulatedJoypadStatesMask] ; bit mask for button presses that override simulated ones
	and b
	ret nz ; return if the simulated button presses are overridden
;> wSimulatedJoypadStatesIndex = u8(wSimulatedJoypadStatesIndex - 1)
	ld hl, wSimulatedJoypadStatesIndex
	dec [hl]
;> if wSimulatedJoypadStatesIndex != 0xFF:
	ld a, [hl]
	cp $ff
	jr z, .doneSimulating ; if the end of the simulated button presses has been reached
;>     entry = addr(wSimulatedJoypadStatesEnd) + wSimulatedJoypadStatesIndex   # the list is read backwards
	ld hl, wSimulatedJoypadStatesEnd
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
;>     hJoyHeld = mem[entry]
	ld a, [hl]
	ldh [hJoyHeld], a ; store simulated button press in joypad state
;>     if hJoyHeld:
;>         return
	and a
	ret nz
;>     hJoyPressed = 0                 # an empty entry: nothing pressed
	ldh [hJoyPressed], a
;>     hJoyReleased = 0
	ldh [hJoyReleased], a
;>     return
	ret

; if done simulating button presses
.doneSimulating
;> else:                               # the end of the list: the scripted walk is over
;>     wUnusedOverrideSimulatedJoypadStatesIndex = 0
	xor a
	ld [wUnusedOverrideSimulatedJoypadStatesIndex], a
;>     wSimulatedJoypadStatesIndex = 0
	ld [wSimulatedJoypadStatesIndex], a
;>     wSimulatedJoypadStatesEnd = 0
	ld [wSimulatedJoypadStatesEnd], a
;>     wJoyIgnore = 0
	ld [wJoyIgnore], a
;>     hJoyHeld = 0
	ldh [hJoyHeld], a
;>     wMovementFlags &= 1 << BIT_SPINNING | 1 << BIT_LEDGE_OR_FISHING | 1 << 5 | 1 << 4 | 1 << 3
	ld hl, wMovementFlags
	ld a, [hl]
	and (1 << BIT_SPINNING) | (1 << BIT_LEDGE_OR_FISHING) | (1 << 5) | (1 << 4) | (1 << 3)
	ld [hl], a
;>     wStatusFlags5 &= ~(1 << BIT_SCRIPTED_MOVEMENT_STATE) & 0xFF
	ld hl, wStatusFlags5
	res BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ret

; function to check the tile ahead to determine if the character should get on land or keep surfing
; sets carry if there is a collision and clears carry otherwise
; It seems that this function has a bug in it, but due to luck, it doesn't
; show up. After detecting a sprite collision, it jumps to the code that
; checks if the next tile is passable instead of just directly jumping to the
; "collision detected" code. However, it doesn't store the next tile in c,
; so the old value of c is used. 2429 is always called before this function,
; and 2429 always sets c to 0xF0. There is no 0xF0 background tile, so it
; is considered impassable and it is detected as a collision.
;@ path: home/overworld
;@ def CollisionCheckOnWater(old: c) -> carry
;@ Can the surfing player go on in wPlayerDirection? Water (and the Safari Zone's coast tile) keeps surfing;
;@ a walkable land tile, or the S.S. Anne's boarding platform at Vermilion's dock, ends surfing (back to
;@ walking, with the map's music). Carry (with the bump sound) for anything else, a tile pair rule or a person
;@ in the way. For a person the check uses the old c as the tile, which never is walkable, so it still counts
;@ as a collision.
;@ test: skip the predef call keeps the incoming hl, de and bc in wPredefHL..., which the pseudo-code has no names for
CollisionCheckOnWater::
;> if wStatusFlags5 >> BIT_SCRIPTED_MOVEMENT_STATE & 1:   # a scripted walk
;>@nc1     return False
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_MOVEMENT_STATE, a
	jp nz, .noCollision ; return and clear carry if button presses are being simulated
;>@tile tile = old                     # stays the old c when a person is in the way: never walkable
;>@flags blocked = walkable = False
;> person = wSpritePlayerStateData1CollisionData & wPlayerDirection   # a person that way
	ld a, [wPlayerDirection] ; the direction that the player is trying to go in
	ld d, a
	ld a, [wSpritePlayerStateData1CollisionData]
	and d ; check if a sprite is in the direction the player is trying to go
;> if not person:
	jr nz, .checkIfNextTileIsPassable ; bug?
;>     blocked = CheckForJumpingAndTilePairCollisions(TilePairCollisionsWater)
	ld hl, TilePairCollisionsWater
	call CheckForJumpingAndTilePairCollisions
;>     if not blocked:
	jr c, .collision
;>         tile, _, _ = GetTileAndCoordsInFrontOfPlayer()
	; get tile in front of player (puts it in c and [wTileInFrontOfPlayer])
	ld a, (GetTileAndCoordsInFrontOfPlayerPredef - PredefPointers) / 3
	call Predef
;>         if wTileInFrontOfPlayer == 0x14:   # water: keep surfing
;>@nc2             return False
	ld a, [wTileInFrontOfPlayer]
	cp $14 ; water tile
	jr z, .noCollision ; keep surfing if it's a water tile
;>         if wTileInFrontOfPlayer == 0x32:   # the boarding platform at Vermilion's dock; elsewhere a coast tile
	cp $32 ; either the left tile of the S.S. Anne boarding platform or the tile on eastern coastlines (depending on the current tileset)
	jr z, .checkIfVermilionDockTileset
;>@d1             walkable = wCurMapTileset == SHIP_PORT
;>@d2             if not walkable:    # a coast tile: keep surfing
;>@d3                 return False
;>         elif wTileInFrontOfPlayer == 0x48:   # the Safari Zone's coast: keep surfing
;>             return False
	cp $48 ; tile on right on coast lines in Safari Zone
	jr z, .noCollision ; keep surfing
; check if the [land] tile in front of the player is passable
.checkIfNextTileIsPassable
;>@land if not blocked and not walkable:   # is the land tile in front walkable?
;>     tiles = wTilesetCollisionPtr[0] | wTilesetCollisionPtr[1] << 8   # the tileset's walkable tiles
	ld hl, wTilesetCollisionPtr ; pointer to list of passable tiles
	ld a, [hli]
	ld h, [hl]
	ld l, a
;>@lp     while True:
;>         t = mem[tiles]
;>         tiles += 1
.loop
	ld a, [hli]
;>         if t == 0xFF:               # the end of the list: not walkable
;>@bl             blocked = True
;>             break
	cp $ff
	jr z, .collision
;>         if t == tile:               # walkable land: get off the water
;>@wk             walkable = True
;>             break
	cp c
	jr z, .stopSurfing ; stop surfing if the tile is passable
;=@lp
	jr .loop
.collision
;>@bump if blocked:
;>     if wChannelSoundIDs[CHAN5] != 0xB4:  # SFX_COLLISION, unless it is already playing
	ld a, [wChannelSoundIDs + CHAN5]
	cp SFX_COLLISION ; check if collision sound is already playing
	jr z, .setCarry
;>         PlaySound(0xB4)
	ld a, SFX_COLLISION
	call PlaySound ; play collision sound (if it's not already playing)
.setCarry
;>     return True
	scf
	jr .done
;>@w1 if walkable:                     # back to walking, with the map's music
;>@w2     wWalkBikeSurfState = 0
;>@w3     LoadPlayerSpriteGraphics()
;>@w4     PlayDefaultMusic()
;> return False
.noCollision
	and a
.done
	ret
.stopSurfing
;=@w2
	xor a
	ld [wWalkBikeSurfState], a
;=@w3
	call LoadPlayerSpriteGraphics
;=@w4
	call PlayDefaultMusic
	jr .noCollision
.checkIfVermilionDockTileset
;=@d1
	ld a, [wCurMapTileset]
	cp SHIP_PORT
;=@d3
	jr nz, .noCollision ; keep surfing if it's not the boarding platform tile
;=@w1
	jr .stopSurfing ; if it is the boarding platform tile, stop surfing

;@ path: home/overworld
;@ def RunMapScript()
;@ Run the overworld's scripts for this frame: boulder pushing (with its dust), a scripted walk of a person,
;@ then the current map's script (in the map's bank).
;@ test: skip runs the map's script
RunMapScript::
;> TryPushingBoulder()
	push hl
	push de
	push bc
	ld b, BANK(TryPushingBoulder)
	ld hl, TryPushingBoulder
	call Bankswitch
;> if wMiscFlags >> BIT_BOULDER_DUST & 1:
	ld a, [wMiscFlags]
	bit BIT_BOULDER_DUST, a
	jr z, .afterBoulderEffect
;>     DoBoulderDustAnimation()
	ld b, BANK(DoBoulderDustAnimation)
	ld hl, DoBoulderDustAnimation
	call Bankswitch
.afterBoulderEffect
;> RunNPCMovementScript()
	pop bc
	pop de
	pop hl
	call RunNPCMovementScript
;> SwitchToMapRomBank(wCurMap)
	ld a, [wCurMap]
	call SwitchToMapRomBank
;> script = wCurMapScriptPtr[0] | wCurMapScriptPtr[1] << 8
	ld hl, wCurMapScriptPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
;> call(script)
	ld de, .return
	push de
	jp hl
.return
	ret

;@ path: home/overworld
;@ def LoadWalkingPlayerSpriteGraphics()
;@ Load the player's walking sprite.
;@ test: skip copies to VRAM, waiting for VBlank
LoadWalkingPlayerSpriteGraphics::
;> return LoadPlayerSpriteGraphicsCommon(RedSprite, addr(vNPCSprites))
	ld de, RedSprite
	ld hl, vNPCSprites
	jr LoadPlayerSpriteGraphicsCommon

;@ path: home/overworld
;@ def LoadSurfingPlayerSpriteGraphics()
;@ Load the surfing sprite (the player riding a Seel).
;@ test: skip copies to VRAM, waiting for VBlank
LoadSurfingPlayerSpriteGraphics::
;> return LoadPlayerSpriteGraphicsCommon(SeelSprite, addr(vNPCSprites))
	ld de, SeelSprite
	ld hl, vNPCSprites
	jr LoadPlayerSpriteGraphicsCommon

;@ path: home/overworld
;@ def LoadBikePlayerSpriteGraphics()
;@ Load the player's bike sprite.
;@ test: skip copies to VRAM, waiting for VBlank
LoadBikePlayerSpriteGraphics::
;> LoadPlayerSpriteGraphicsCommon(RedBikeSprite, addr(vNPCSprites))
	ld de, RedBikeSprite
	ld hl, vNPCSprites

;@ path: home/overworld
;@ def LoadPlayerSpriteGraphicsCommon(src: de, dest: hl)
;@ Copy a player sprite to the first sprite slot in VRAM: the standing frames (12 tiles) at dest, the walking
;@ frames (the next 12 tiles) $800 bytes further.
;@ test: skip copies to VRAM, waiting for VBlank
LoadPlayerSpriteGraphicsCommon::
;> CopyVideoData(dest, src, BANK(RedSprite), 12)   # the standing frames
	push de
	push hl
	ld bc, ((BANK(RedSprite)) & $ff) << 8 + (($0c) & $ff)
	call CopyVideoData
	pop hl
	pop de
;> src += 0xC0                         # the next 12 tiles
	ld a, $c0
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
;> return CopyVideoData(dest | 0x800, src, BANK(RedSprite), 12)   # the walking frames, $800 further
	set 3, h ; add $800 ($80 tiles) to hl (1 << 3 == $8)
	ld bc, ((BANK(RedSprite)) & $ff) << 8 + (($0c) & $ff)
	jp CopyVideoData

; function to load data from the map header
;@ path: home/overworld
;@ def LoadMapHeader()
;@ Load the current map's header from its bank: the fixed part (tileset, size, pointers to blocks, texts and
;@ script, connections), the connection headers, then the object data: background block, warps, signs and the
;@ people (picture, position, movement, text, and the trainer or item they stand for). After a battle the
;@ people stay as they are. Then the tileset header, the wild Pokémon, the size in 2x2 steps and the map's
;@ music. Nothing of this happens when the map is flagged as already loaded (BIT_NO_PREVIOUS_MAP in
;@ wCurMapTileset).
;@ test: skip loads through predefs and far calls
LoadMapHeader::
;> MarkTownVisitedAndLoadToggleableObjects()
	ld b, BANK(MarkTownVisitedAndLoadToggleableObjects)
	ld hl, MarkTownVisitedAndLoadToggleableObjects
	call Bankswitch
;> wUnusedCurMapTilesetCopy = wCurMapTileset
	ld a, [wCurMapTileset]
	ld [wUnusedCurMapTilesetCopy], a
;> SwitchToMapRomBank(wCurMap)
	ld a, [wCurMap]
	call SwitchToMapRomBank
;> loaded = wCurMapTileset >> BIT_NO_PREVIOUS_MAP & 1   # flagged as loaded already
	ld a, [wCurMapTileset]
	ld b, a
;> wCurMapTileset &= ~(1 << BIT_NO_PREVIOUS_MAP) & 0xFF
	res BIT_NO_PREVIOUS_MAP, a
	ld [wCurMapTileset], a
;> hPreviousTileset = wCurMapTileset
	ldh [hPreviousTileset], a
;> if loaded:
;>     return
	bit BIT_NO_PREVIOUS_MAP, b
	ret nz
;>@ptr ptr = MapHeaderPointers + wCurMap * 2
	ld hl, MapHeaderPointers
	ld a, [wCurMap]
	sla a
	jr nc, .noCarry1
	inc h
.noCarry1
;=@ptr
	add l
	ld l, a
	jr nc, .noCarry2
	inc h
.noCarry2
;> src = mem16[ptr]                    # the map's header
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = base of map header
;>@cp copy(addr(wCurMapHeader), src, wCurMapHeaderEnd - wCurMapHeader)   # the fixed part
	ld de, wCurMapHeader
	ld c, wCurMapHeaderEnd - wCurMapHeader
.copyFixedHeaderLoop
;=@cp
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copyFixedHeaderLoop
; initialize all the connected maps to disabled at first, before loading the actual values
;>@src src += wCurMapHeaderEnd - wCurMapHeader
;> wNorthConnectedMap = 0xFF      # no connections until the header says so
	ld a, $ff
	ld [wNorthConnectedMap], a
;> wSouthConnectedMap = 0xFF
	ld [wSouthConnectedMap], a
;> wWestConnectedMap = 0xFF
	ld [wWestConnectedMap], a
;> wEastConnectedMap = 0xFF
	ld [wEastConnectedMap], a
; copy connection data (if any) to WRAM
;> connections = wCurMapConnections
	ld a, [wCurMapConnections]
	ld b, a
; check north
;> if connections >> NORTH_F & 1:
	bit NORTH_F, b
	jr z, .checkSouth
;>     src = CopyMapConnectionHeader(src, addr(wNorthConnectionHeader))
	ld de, wNorthConnectionHeader
	call CopyMapConnectionHeader
.checkSouth
;> if connections >> SOUTH_F & 1:
	bit SOUTH_F, b
	jr z, .checkWest
;>     src = CopyMapConnectionHeader(src, addr(wSouthConnectionHeader))
	ld de, wSouthConnectionHeader
	call CopyMapConnectionHeader
.checkWest
;> if connections >> WEST_F & 1:
	bit WEST_F, b
	jr z, .checkEast
;>     src = CopyMapConnectionHeader(src, addr(wWestConnectionHeader))
	ld de, wWestConnectionHeader
	call CopyMapConnectionHeader
.checkEast
;> if connections >> EAST_F & 1:
	bit EAST_F, b
	jr z, .getObjectDataPointer
;>     src = CopyMapConnectionHeader(src, addr(wEastConnectionHeader))
	ld de, wEastConnectionHeader
	call CopyMapConnectionHeader
.getObjectDataPointer
;> wObjectDataPointerTemp[0] = mem[src]   # the pointer to the object data
	ld a, [hli]
	ld [wObjectDataPointerTemp], a
;> wObjectDataPointerTemp[1] = mem[src + 1]
	ld a, [hli]
	ld [wObjectDataPointerTemp + 1], a
;> obj = wObjectDataPointerTemp[0] | wObjectDataPointerTemp[1] << 8
	push hl
	ld a, [wObjectDataPointerTemp]
	ld l, a
	ld a, [wObjectDataPointerTemp + 1]
	ld h, a ; hl = base of object data
;> wMapBackgroundTile = mem[obj]
	ld de, wMapBackgroundTile
	ld a, [hli]
	ld [de], a
; load warp data
;> wNumberOfWarps = mem[obj + 1]
;> obj += 2
	ld a, [hli]
	ld [wNumberOfWarps], a
;> if wNumberOfWarps:
	and a
	jr z, .loadSignData
;>     dest = addr(wWarpEntries)
;>@warps     for _ in range(wNumberOfWarps):
	ld c, a
	ld de, wWarpEntries
.warpLoop ; one warp per loop iteration
;>@cw         copy(dest, obj, 4)          # y, x, destination warp, destination map
	ld b, 4
.warpInnerLoop
;=@cw
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .warpInnerLoop
;>@o4         obj += 4
;>@d4         dest += 4
;=@warps
	dec c
	jr nz, .warpLoop
.loadSignData
;> wNumSigns = mem[obj]
;> obj += 1
	ld a, [hli] ; number of signs
	ld [wNumSigns], a
;> if wNumSigns:
	and a ; are there any signs?
	jr z, .loadSpriteData ; if not, skip this
;>     hSignCoordPointer[0] = hi(addr(wSignTextIDs))   # where the next text id goes (high byte first)
	ld c, a
	ld de, wSignTextIDs
	ld a, d
	ldh [hSignCoordPointer], a
;>     hSignCoordPointer[1] = lo(addr(wSignTextIDs))
	ld a, e
	ldh [hSignCoordPointer + 1], a
;>@signs     for i in range(wNumSigns):  # y, x, text id each
	ld de, wSignCoords
;>         wSignCoords[2 * i] = mem[obj]
.signLoop
	ld a, [hli]
	ld [de], a
	inc de
;>         wSignCoords[2 * i + 1] = mem[obj + 1]
	ld a, [hli]
	ld [de], a
	inc de
;>         ids = hSignCoordPointer[0] << 8 | hSignCoordPointer[1]
	push de
	ldh a, [hSignCoordPointer]
	ld d, a
	ldh a, [hSignCoordPointer + 1]
	ld e, a
;>         mem[ids] = mem[obj + 2]     # wSignTextIDs[i]
;>         obj += 3
	ld a, [hli]
	ld [de], a
	inc de
;>         hSignCoordPointer[0], hSignCoordPointer[1] = hi(ids + 1), lo(ids + 1)
	ld a, d
	ldh [hSignCoordPointer], a
	ld a, e
	ldh [hSignCoordPointer + 1], a
	pop de
;=@signs
	dec c
	jr nz, .signLoop
.loadSpriteData
;> if not wStatusFlags4 >> BIT_BATTLE_OVER_OR_BLACKOUT & 1:   # after a battle the people stay as they are
	ld a, [wStatusFlags4]
	bit BIT_BATTLE_OVER_OR_BLACKOUT, a
	jp nz, .finishUp ; if so, skip this because battles don't destroy this data
;>     wNumSprites = mem[obj]
;>     obj += 1
	ld a, [hli]
	ld [wNumSprites], a ; save the number of sprites
	push hl
; zero out sprite state data for sprites 01-15
;>@z1     fill(wSprite01StateData1, 0, 0xF0)
;>@z2     fill(wSprite01StateData2, 0, 0xF0)
	ld hl, wSprite01StateData1
	ld de, wSprite01StateData2
	xor a
	ld b, $f0
.zeroSpriteDataLoop
;=@z1
	ld [hli], a
	ld [de], a
	inc e
	dec b
	jr nz, .zeroSpriteDataLoop
; disable SPRITESTATEDATA1_IMAGEINDEX (set to $ff) for sprites 01-15
;>@dis     for i in range(NUM_SPRITESTATEDATA_STRUCTS - 1):
	ld hl, wSprite01StateData1ImageIndex
	ld de, SPRITESTATEDATA1_LENGTH
	ld c, NUM_SPRITESTATEDATA_STRUCTS - 1
;>         mem[wSprite01StateData1ImageIndex + i * SPRITESTATEDATA1_LENGTH] = 0xFF   # not shown yet
.disableSpriteEntriesLoop
	ld [hl], $ff
;=@dis
	add hl, de
	dec c
	jr nz, .disableSpriteEntriesLoop
;>     # (obj comes back off the stack)
	pop hl
;>     if wNumSprites:
	ld de, wSprite01StateData1
	ld a, [wNumSprites] ; number of sprites
	and a ; are there any sprites?
	jp z, .finishUp ; if there are no sprites, skip the rest
;>@each         for n in range(wNumSprites):
;>             data1 = wSprite01StateData1 + n * SPRITESTATEDATA1_LENGTH
;>             data2 = data1 + 0x100   # the person's second state data block
	ld b, a
	ld c, $00
.loadSpriteLoop
;>             mem[data1] = mem[obj]   # picture
	ld a, [hli]
	ld [de], a ; x#SPRITESTATEDATA1_PICTUREID
;>             mem[data2 + 4] = mem[obj + 1]   # map y
	inc d
	ld a, $04
	add e
	ld e, a
	ld a, [hli]
	ld [de], a ; x#SPRITESTATEDATA2_MAPY
;>             mem[data2 + 5] = mem[obj + 2]   # map x
	inc e
	ld a, [hli]
	ld [de], a ; x#SPRITESTATEDATA2_MAPX
;>             mem[data2 + 6] = mem[obj + 3]   # movement byte 1
	inc e
	ld a, [hli]
	ld [de], a ; x#SPRITESTATEDATA2_MOVEMENTBYTE1
;>             movement2 = mem[obj + 4]
	ld a, [hli]
	ldh [hLoadSpriteTemp1], a ; save movement byte 2
;>             flags = mem[obj + 5]    # text id and flags
	ld a, [hli]
	ldh [hLoadSpriteTemp2], a ; save text ID and flags byte
;>             # (n and obj kept on the stack)
	push bc
	push hl
;>             wMapSpriteData[2 * n] = movement2
	ld b, $00
	ld hl, wMapSpriteData
	add hl, bc
	ldh a, [hLoadSpriteTemp1]
	ld [hli], a ; store movement byte 2 in byte 0 of sprite entry
;>             wMapSpriteData[2 * n + 1] = flags   # overwritten straight away
	ldh a, [hLoadSpriteTemp2]
	ld [hl], a ; this appears pointless, since the value is overwritten immediately after
;>             wMapSpriteData[2 * n + 1] = flags & 0x3F   # the text id
	ldh a, [hLoadSpriteTemp2]
	ldh [hLoadSpriteTemp1], a
	and $3f
	ld [hl], a ; store text ID in byte 1 of sprite entry
;>             obj += 6
	pop hl
	ldh a, [hLoadSpriteTemp1]
;>             if flags >> BIT_TRAINER & 1:
	bit BIT_TRAINER, a
	jr nz, .trainerSprite
;>@t1                 cls = mem[obj]      # trainer class
;>@t2                 num = mem[obj + 1]  # trainer number within the class
;>@t3                 obj += 2
;>@t4                 wMapSpriteExtraData[2 * n] = cls
;>@t5                 wMapSpriteExtraData[2 * n + 1] = num
;>             elif flags >> BIT_ITEM & 1:
	bit BIT_ITEM, a
	jr nz, .itemBallSprite
;>@i1                 wMapSpriteExtraData[2 * n], wMapSpriteExtraData[2 * n + 1], obj = mem[obj], 0, obj + 1   # the item
;>             else:                   # a regular person doesn't use the two bytes
;>@r1                 wMapSpriteExtraData[2 * n] = wMapSpriteExtraData[2 * n + 1] = 0
	jr .regularSprite
.trainerSprite
;=@t1
	ld a, [hli]
	ldh [hLoadSpriteTemp1], a ; save trainer class
;=@t2
	ld a, [hli]
	ldh [hLoadSpriteTemp2], a ; save trainer number (within class)
;=@t4
	push hl
	ld hl, wMapSpriteExtraData
	add hl, bc
	ldh a, [hLoadSpriteTemp1]
	ld [hli], a ; store trainer class in byte 0 of the entry
;=@t5
	ldh a, [hLoadSpriteTemp2]
	ld [hl], a ; store trainer number in byte 1 of the entry
	pop hl
	jr .nextSprite
.itemBallSprite
;=@i1
	ld a, [hli]
	ldh [hLoadSpriteTemp1], a ; save item number
;=@i1
	push hl
	ld hl, wMapSpriteExtraData
	add hl, bc
	ldh a, [hLoadSpriteTemp1]
	ld [hli], a ; store item number in byte 0 of the entry
;=@i1
	xor a
	ld [hl], a ; zero byte 1, since it is not used
	pop hl
	jr .nextSprite
.regularSprite
;=@r1
	push hl
	ld hl, wMapSpriteExtraData
	add hl, bc
; zero both bytes, since regular sprites don't use this extra space
	xor a
	ld [hli], a
;=@r1
	ld [hl], a
	pop hl
.nextSprite
;=@each
	pop bc
	dec d
	ld a, $0a
	add e
	ld e, a
;=@each
	inc c
	inc c
	dec b
	jp nz, .loadSpriteLoop
.finishUp
;> LoadTilesetHeader()
	ld a, (LoadTilesetHeaderPredef - PredefPointers) / 3
	call Predef
;> LoadWildData()
	ld hl, LoadWildData
	ld b, BANK(LoadWildData)
	call Bankswitch
;> # (the header pointer pushed before the object data comes back off the stack, unused)
	pop hl ; restore hl from before going to the warp/sign/sprite data (this value was saved for seemingly no purpose)
;> wCurrentMapHeight2 = u8(wCurMapHeight * 2)   # the size in steps (2x2 tiles)
	ld a, [wCurMapHeight] ; map height in 4x4 tile blocks
	add a ; double it
	ld [wCurrentMapHeight2], a ; store map height in 2x2 tile blocks
;> wCurrentMapWidth2 = u8(wCurMapWidth * 2)
	ld a, [wCurMapWidth] ; map width in 4x4 tile blocks
	add a ; double it
	ld [wCurrentMapWidth2], a ; map width in 2x2 tile blocks
;> m = wCurMap
	ld a, [wCurMap]
	ld c, a
	ld b, $00
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(MapSongBanks)
	ld a, BANK(MapSongBanks)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(MapSongBanks))
	ld [rROMB], a
;> wMapMusicSoundID = mem[MapSongBanks + m * 2]   # the map's music
	ld hl, MapSongBanks
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wMapMusicSoundID], a ; music 1
;> wMapMusicROMBank = mem[MapSongBanks + m * 2 + 1]
	ld a, [hl]
	ld [wMapMusicROMBank], a ; music 2
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret

; function to copy map connection data from ROM to WRAM
; Input: hl = source, de = destination
;@ path: home/overworld
;@ def CopyMapConnectionHeader(src: hl, dest: de) -> hl
;@ Copy a connection header (11 bytes) from a map header to dest; returns src past it.
;@ test: dest = rand_ram(11)
CopyMapConnectionHeader::
;>@cp copy(dest, src, 11)
	ld c, $0b
.loop
;=@cp
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
;> return src + 11
	ret

; function to load map data
;@ path: home/overworld
;@ def LoadMapData()
;@ Load the current map completely, with the LCD off: reset the view and scrolling, load the text box tiles,
;@ the map header, the sprites, the block map, the tileset and the map view, copy the screen to the BG map,
;@ then turn the LCD on with the overworld palette and the player's sprite, and start the map's music (not
;@ after Fly or a dungeon warp, nor when the map's music is off).
;@ test: skip turns the LCD off and on
LoadMapData::
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> DisableLCD()
	call DisableLCD
;> wMapViewVRAMPointer[1] = hi(addr(vBGMap0))   # the view starts at the BG map's top left
	ld a, HIGH(vBGMap0)
	ld [wMapViewVRAMPointer + 1], a
;> wMapViewVRAMPointer[0] = 0
	xor a
	ld [wMapViewVRAMPointer], a
;> hSCY = hSCX = 0
	ldh [hSCY], a
	ldh [hSCX], a
;> wWalkCounter = 0
	ld [wWalkCounter], a
;> wUnusedCurMapTilesetCopy = 0
	ld [wUnusedCurMapTilesetCopy], a
;> wWalkBikeSurfStateCopy = 0
	ld [wWalkBikeSurfStateCopy], a
;> wSpriteSetID = 0
	ld [wSpriteSetID], a
;> LoadTextBoxTilePatterns()
	call LoadTextBoxTilePatterns
;> LoadMapHeader()
	call LoadMapHeader
;> InitMapSprites()                    # the sprites' tile patterns
	; load tile pattern data for sprites
	ld b, BANK(InitMapSprites)
	ld hl, InitMapSprites
	call Bankswitch
;> LoadTileBlockMap()
	call LoadTileBlockMap
;> LoadTilesetTilePatternData()
	call LoadTilesetTilePatternData
;> LoadCurrentMapView()
	call LoadCurrentMapView
; copy current map view to VRAM
;>@rows for row in range(SCREEN_HEIGHT):   # the screen into the BG map
	ld hl, (0) * SCREEN_WIDTH + (0) + wTileMap
	ld de, vBGMap0
	ld b, SCREEN_HEIGHT
;>     copy(addr(vBGMap0) + row * TILEMAP_WIDTH, coord(0, row), SCREEN_WIDTH)
.vramCopyLoop
	ld c, SCREEN_WIDTH
.vramCopyInnerLoop
	ld a, [hli]
	ld [de], a
	inc e
	dec c
	jr nz, .vramCopyInnerLoop
;=@rows
	ld a, TILEMAP_WIDTH - SCREEN_WIDTH
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
;=@rows
	dec b
	jr nz, .vramCopyLoop
;> wUpdateSpritesEnabled = 1
	ld a, $01
	ld [wUpdateSpritesEnabled], a
;> EnableLCD()
	call EnableLCD
;> RunPaletteCommand(SET_PAL_OVERWORLD)
	ld b, SET_PAL_OVERWORLD
	call RunPaletteCommand
;> LoadPlayerSpriteGraphics()
	call LoadPlayerSpriteGraphics
;> if not wStatusFlags6 & (1 << BIT_FLY_WARP | 1 << BIT_DUNGEON_WARP):   # not after Fly or a dungeon warp
	ld a, [wStatusFlags6]
	and (1 << BIT_FLY_WARP) | (1 << BIT_DUNGEON_WARP)
	jr nz, .restoreRomBank
;>     if not wStatusFlags7 >> BIT_NO_MAP_MUSIC & 1:
	ld a, [wStatusFlags7]
	bit BIT_NO_MAP_MUSIC, a
	jr nz, .restoreRomBank
;>         UpdateMusic6Times()
	call UpdateMusic6Times
;>         PlayDefaultMusicFadeOutCurrent()
	call PlayDefaultMusicFadeOutCurrent
.restoreRomBank
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret

; function to switch to the ROM bank that a map is stored in
; Input: a = map number
;@ path: home/overworld
;@ def SwitchToMapRomBank(map: a)
;@ Switch in the ROM bank of a map's data (looked up in MapHeaderBanks), keeping hl and bc.
;@ test: wBankswitchHomeSavedROMBank = rand(1, 0x2C)
SwitchToMapRomBank::
;> BankswitchHome(BANK(MapHeaderBanks))
	push hl
	push bc
	ld c, a
	ld b, $00
	ld a, BANK(MapHeaderBanks)
	call BankswitchHome
;> hMapROMBank = mem[MapHeaderBanks + map]
	ld hl, MapHeaderBanks
	add hl, bc
	ld a, [hl]
	ldh [hMapROMBank], a
;> BankswitchBack()
	call BankswitchBack
;> hLoadedROMBank = hMapROMBank
;> set_rom_bank(hMapROMBank)
	ldh a, [hMapROMBank]
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	pop bc
	pop hl
	ret

;@ path: home/overworld
;@ def IgnoreInputForHalfSecond()
;@ Ignore the joypad for 30 frames (after going through a warp).
IgnoreInputForHalfSecond:
;> wIgnoreInputCounter = 30
	ld a, 30
	ld [wIgnoreInputCounter], a
;> wStatusFlags5 |= 1 << BIT_DISABLE_JOYPAD | 1 << BIT_UNKNOWN_5_2 | 1 << BIT_UNKNOWN_5_1
	ld hl, wStatusFlags5
	ld a, [hl]
	or (1 << BIT_DISABLE_JOYPAD) | (1 << BIT_UNKNOWN_5_2) | (1 << BIT_UNKNOWN_5_1)
	ld [hl], a ; set ignore input bit
	ret

;@ path: home/overworld
;@ def ResetUsingStrengthOutOfBattleBit()
;@ Strength ends when the player enters a map.
ResetUsingStrengthOutOfBattleBit:
;> wStatusFlags1 &= ~(1 << BIT_STRENGTH_ACTIVE) & 0xFF
	ld hl, wStatusFlags1
	res BIT_STRENGTH_ACTIVE, [hl]
	ret

;@ path: home/overworld
;@ def ForceBikeOrSurf()
;@ Put the player on the bike or in the water as the map demands (wWalkBikeSurfState is already set): load the
;@ matching sprite and music.
;@ test: skip copies the sprite to VRAM, waiting for VBlank
ForceBikeOrSurf::
;> Bankswitch(BANK(RedSprite), LoadPlayerSpriteGraphics)
;> return PlayDefaultMusic()
	ld b, BANK(RedSprite)
	ld hl, LoadPlayerSpriteGraphics ; in bank 0
	call Bankswitch
	jp PlayDefaultMusic ; update map/player state?

;@ path: home/overworld
;@ def CheckForUserInterruption(frames: c) -> carry
;@ Wait up to `frames` frames for the player to interrupt (the intro, the title screen): carry when START or A
;@ is pressed, or Up+SELECT+B held.
;@ test: skip waits for frames
CheckForUserInterruption::
; Return carry if Up+Select+B, Start or A are pressed in c frames.
; Used only in the intro and title screen.
;>@lp while True:
;>     DelayFrame()
	call DelayFrame

;>     JoypadLowSensitivity()
	push bc
	call JoypadLowSensitivity
	pop bc

;>     if hJoyHeld == PAD_UP + PAD_SELECT + PAD_B:
	ldh a, [hJoyHeld]
	cp PAD_UP + PAD_SELECT + PAD_B
	jr z, .input

;>@r1         return True
;>     if hJoy5 & (PAD_START | PAD_A):
	ldh a, [hJoy5]
	and PAD_START | PAD_A
	jr nz, .input

;>@r2         return True
;>     frames = u8(frames - 1)
	dec c
;>     if frames == 0:
	jr nz, CheckForUserInterruption

;>         return False
	and a
	ret

.input
;=@r1
	scf
	ret

; function to load position data for destination warp when switching maps
; INPUT:
; a = ID of destination warp within destination map
;@ path: home/overworld
;@ def LoadDestinationWarpPosition(warp: a, table: hl)
;@ Set the player's view and position for arriving at a warp: copy its 4 bytes (block map view pointer, y and x
;@ within the block) from the table at hl, in the bank in wPredefParentBank, to wCurrentTileBlockMapViewPointer.
LoadDestinationWarpPosition::
;> saved = hLoadedROMBank
	ld b, a
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = wPredefParentBank
	ld a, [wPredefParentBank]
	ldh [hLoadedROMBank], a
;> set_rom_bank(wPredefParentBank)
	ld [rROMB], a
;> table += u8(warp * 4)               # 4 bytes per warp
	ld a, b
	add a
	add a
	ld c, a
	ld b, 0
	add hl, bc
;> CopyData(table, addr(wCurrentTileBlockMapViewPointer), 4)
	ld bc, 4
	ld de, wCurrentTileBlockMapViewPointer
	call CopyData
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret
;@ path: home/pokemon
;@ def DrawHPBar(dest: hl, length: d, pixels: e, sliver: c)
;@ Draw an HP bar at dest: "HP:", then `length` tiles filled to `pixels` pixels (8 per tile), then the right
;@ end, which depends on wHPBarType. With sliver set, an empty bar still shows one pixel. Keeps hl, de, bc.
;@ test: length = rand(1, 8); pixels = rand(0, 8 * length); dest = rand_ram(12)
DrawHPBar::
; Draw an HP bar d tiles long, and fill it to e pixels.
; If c is nonzero, show at least a sliver regardless.
; The right end of the bar changes with [wHPBarType].

;> # (registers kept on the stack)
	push hl
	push de
	push bc

	; Left
;> mem[dest] = 0x71                    # "HP:"
	ld a, $71 ; "HP:"
	ld [hli], a
;> mem[dest + 1] = 0x62                # left end
	ld a, $62
	ld [hli], a

;> p = dest + 2                        # (kept on the stack)
	push hl

	; Middle
;> for i in range(length):
;>     mem[p + i] = 0x63               # empty
	ld a, $63 ; empty
.draw
	ld [hli], a
	dec d
	jr nz, .draw

	; Right
;> mem[p + length] = 0x6D if wHPBarType == 1 else 0x6C   # status screen and battle, or party menu
	ld a, [wHPBarType]
	dec a
	ld a, $6d ; status screen and battle
	jr z, .ok
	dec a ; pokemon menu
.ok
	ld [hl], a

;> # (p comes back off the stack)
	pop hl

;> if not pixels:
	ld a, e
	and a
	jr nz, .fill

	; If c is nonzero, draw a pixel anyway.
;>     if not sliver:
;>@d1         return
	ld a, c
	and a
	jr z, .done
;>     pixels = 1
	ld e, 1

;>@full while pixels >= 8:
.fill
	ld a, e
	sub 8
	jr c, .partial
;>     pixels -= 8
	ld e, a
;>     mem[p] = 0x6B                   # full
;>     p += 1
	ld a, $6b ; full
	ld [hli], a
;>     if not pixels:
;>@d2         return
	ld a, e
	and a
	jr z, .done
;=@full
	jr .fill

.partial
	; Fill remaining pixels at the end if necessary.
;> mem[p] = 0x63 + pixels              # the partly filled tile
	ld a, $63 ; empty
	add e
	ld [hl], a
.done
;=@d1
;=@d2
	pop bc
	pop de
	pop hl
	ret


; loads pokemon data from one of multiple sources to wLoadedMon
; loads base stats to wMonHeader
; INPUT:
; [wWhichPokemon] = index of pokemon within party/box
; [wMonDataLocation] = source
; 00: player's party
; 01: enemy's party
; 02: current box
; 03: daycare
; OUTPUT:
; [wCurPartySpecies] = pokemon ID
; wLoadedMon = base address of pokemon data
; wMonHeader = base address of base stats
;@ path: home/pokemon
;@ def LoadMonData()
;@ Load Pokémon wWhichPokemon from the place wMonDataLocation names (player's party, enemy's party, current
;@ box or day care) into wLoadedMon, and its species' base data into wMonHeader (LoadMonData_).
LoadMonData::
;> LoadMonData_()
;> set_rom_bank(hLoadedROMBank)    # a far call returns to the bank in hLoadedROMBank
	ld hl, LoadMonData_
	ld b, BANK(LoadMonData_)
	jp Bankswitch

;@ path: home/pokemon
;@ def OverwritewMoves(index: b, move: c)
;@ Put `move` into slot `index` of wMoves. Not used.
;@ test: index = rand(0, 3)
OverwritewMoves::
; Write c to [wMoves + b]. Unused.
;> p = addr(wMoves) + index
	ld hl, wMoves
	ld e, b
	ld d, 0
	add hl, de
;> mem[p] = move
	ld a, c
	ld [hl], a
	ret

;@ path: home/pokemon
;@ def LoadFlippedFrontSpriteByMonIndex(dest: hl)
;@ LoadFrontSpriteByMonIndex, mirrored left to right.
LoadFlippedFrontSpriteByMonIndex::
;> wSpriteFlipped = 1
;> LoadFrontSpriteByMonIndex(dest)
	ld a, 1
	ld [wSpriteFlipped], a

;@ path: home/pokemon
;@ def LoadFrontSpriteByMonIndex(dest: hl)
;@ Show the front picture of species wCurPartySpecies with its top left tile at dest in the screen buffer.
;@ A species without a valid Pokédex number (0 or above 151) becomes Rhydon instead, and nothing is drawn.
LoadFrontSpriteByMonIndex::
;> saved = wPokedexNum
	push hl
	ld a, [wPokedexNum]
	push af
;> wPokedexNum = wCurPartySpecies
	ld a, [wCurPartySpecies]
	ld [wPokedexNum], a
;> Predef((IndexToPokedexPredef - PredefPointers) // 3)    # IndexToPokedex
	ld a, (IndexToPokedexPredef - PredefPointers) / 3
	call Predef
;> dex = wPokedexNum
	ld hl, wPokedexNum
	ld a, [hl]
;> wPokedexNum = saved
	pop bc
	ld [hl], b
;> if not dex or dex > NUM_POKEMON:
	and a
	pop hl
	jr z, .invalidDexNumber ; dex #0 invalid
	cp NUM_POKEMON + 1
	jr c, .validDexNumber   ; dex >#151 invalid
.invalidDexNumber
	; This is the so-called "Rhydon trap" or "Rhydon glitch"
	; to fail-safe invalid dex numbers
	; (see https://glitchcity.wiki/wiki/Rhydon_trap
	; or https://bulbapedia.bulbagarden.net/wiki/Rhydon_glitch)
;>     wCurPartySpecies = RHYDON
	ld a, RHYDON
	ld [wCurPartySpecies], a
;>     return
	ret
.validDexNumber
;> LoadMonFrontSprite(vFrontPic)
	push hl
	ld de, vFrontPic
	call LoadMonFrontSprite
	pop hl
;> saved_bank = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(CopyUncompressedPicToHL)
	ld a, BANK(CopyUncompressedPicToHL)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(CopyUncompressedPicToHL))
	ld [rROMB], a
;> hStartTileID = 0
	xor a
	ldh [hStartTileID], a
;> CopyUncompressedPicToHL(dest)
	call CopyUncompressedPicToHL
;> wSpriteFlipped = 0
	xor a
	ld [wSpriteFlipped], a
;> hLoadedROMBank = saved_bank
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved_bank)
	ld [rROMB], a
	ret


;@ path: home/pokemon
;@ def PlayCry(mon: a)
;@ Play the cry of species `mon` and wait until it is over.
;@ test: skip waits for the sound engine, which runs from an interrupt
PlayCry::
; Play monster a's cry.
;> PlaySound(GetCryData(mon))
;> WaitForSoundToFinish()
	call GetCryData
	call PlaySound
	jp WaitForSoundToFinish

;@ path: home/pokemon
;@ def GetCryData(mon: a) -> a
;@ The sound ID of species `mon`'s cry, from its CryData entry (base cry, pitch, length); the pitch and length
;@ go to wFrequencyModifier and wTempoModifier.
;@ test: mon = rand(1, 190)
GetCryData::
; Load cry data for monster a.
;> i = u8(mon - 1)
	dec a
	ld c, a
	ld b, 0
;> entry = CryData + 3 * i
	ld hl, CryData
	add hl, bc
	add hl, bc
	add hl, bc

;> BankswitchHome(BANK(CryData))
	ld a, BANK(CryData)
	call BankswitchHome
;> cry = mem[entry]
	ld a, [hli]
	ld b, a ; cry id
;> wFrequencyModifier = mem[entry + 1]
	ld a, [hli]
	ld [wFrequencyModifier], a
;> wTempoModifier = mem[entry + 2]
	ld a, [hl]
	ld [wTempoModifier], a
;> BankswitchBack()
	call BankswitchBack

	; Cry headers have 3 channels,
	; and start from index CRY_SFX_START,
	; so add 3 times the cry id.
;> return u8(3 * cry + SFX_CRY_00)    # three channels per cry header
	ld a, b
	ld c, CRY_SFX_START
	rlca ; * 2
	add b
	add c
	ret

;@ path: home/pokemon
;@ def DisplayPartyMenu() -> carry
;@ Show the party menu and let the player pick a Pokémon (carry if they backed out); the tile animations
;@ stop meanwhile.
;@ test: skip waits for the player to pick a Pokémon
DisplayPartyMenu::
;> saved = hTileAnimations
	ldh a, [hTileAnimations]
	push af
;> hTileAnimations = 0
	xor a
	ldh [hTileAnimations], a
;> GBPalWhiteOutWithDelay3()
	call GBPalWhiteOutWithDelay3
;> ClearSprites()
	call ClearSprites
;> PartyMenuInit()
	call PartyMenuInit
;> DrawPartyMenu()
	call DrawPartyMenu
;> return HandlePartyMenuInput(saved)
	jp HandlePartyMenuInput

;@ path: home/pokemon
;@ def GoBackToPartyMenu() -> carry
;@ Return to the party menu from a submenu: redraw it and let the player pick again (carry if they backed
;@ out).
;@ test: skip waits for the player to pick a Pokémon
GoBackToPartyMenu::
;> saved = hTileAnimations
;> hTileAnimations = 0
	ldh a, [hTileAnimations]
	push af
	xor a
	ldh [hTileAnimations], a
;> PartyMenuInit()
;> RedrawPartyMenu()
	call PartyMenuInit
	call RedrawPartyMenu
;> return HandlePartyMenuInput(saved)  # it finds the saved setting on the stack
	jp HandlePartyMenuInput

;@ path: home/pokemon
;@ def PartyMenuInit()
;@ Prepare the party menu: switch to bank 1 (BankswitchBack goes back later), load the HP bar tiles, print
;@ text at once, and set up the menu: one entry per party member, the cursor where it was last time, A and B
;@ watched (only A when the player must choose).
PartyMenuInit::
;> BankswitchHome(1)
	ld a, 1 ; hardcoded bank
	call BankswitchHome
;> LoadHpBarAndStatusTilePatterns()
	call LoadHpBarAndStatusTilePatterns
;> wStatusFlags5 = wStatusFlags5 | 1 << BIT_NO_TEXT_DELAY
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
;> wMonDataLocation = PLAYER_PARTY_DATA
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
;> wMenuWatchMovingOutOfBounds = 0
	ld [wMenuWatchMovingOutOfBounds], a
;> wTopMenuItemY = 1
	ld hl, wTopMenuItemY
	inc a
	ld [hli], a ; top menu item Y
;> wTopMenuItemX = 0
	xor a
	ld [hli], a ; top menu item X
;> wCurrentMenuItem = wPartyAndBillsPCSavedMenuItem
	ld a, [wPartyAndBillsPCSavedMenuItem]
	push af
	ld [hli], a ; current menu item ID
;> wMaxMenuItem = wPartyCount - 1 if wPartyCount else 0
	inc hl
	ld a, [wPartyCount]
	and a ; are there more than 0 pokemon in the party?
	jr z, .storeMaxMenuItemID
	dec a
; if party is not empty, the max menu item ID is ([wPartyCount] - 1)
; otherwise, it is 0
.storeMaxMenuItemID
	ld [hli], a ; max menu item ID
;> if wForcePlayerToChooseMon:
	ld a, [wForcePlayerToChooseMon]
	and a
	ld a, PAD_A | PAD_B
	jr z, .next
;>     wForcePlayerToChooseMon = 0
	xor a
	ld [wForcePlayerToChooseMon], a
;>     wMenuWatchedKeys = PAD_A
;> else:
;>     wMenuWatchedKeys = PAD_A | PAD_B
	inc a ; a = PAD_A
.next
	ld [hli], a ; menu watched keys
;> wLastMenuItem = wPartyAndBillsPCSavedMenuItem
	pop af
	ld [hl], a ; old menu item ID
	ret

;@ path: home/pokemon
;@ def HandlePartyMenuInput(saved_tile_animations) -> carry
;@ Let the player move through the party menu and pick a Pokémon: then wWhichPokemon, wCurPartySpecies and
;@ wBattleMonSpecies2 are set; carry if they pressed B or the party is empty. While two Pokémon are being
;@ swapped, A completes the swap and B cancels it, and the menu goes on. At the end the tile animation
;@ setting comes back (the caller left it on the stack) and so does the ROM bank.
;@ test: skip waits for the player to pick a Pokémon
HandlePartyMenuInput::
;>@loop while True:
;>     wMenuWrappingEnabled = 1
	ld a, 1
	ld [wMenuWrappingEnabled], a
;>     wPartyMenuAnimMonEnabled = 0x40 # the selected Pokémon's icon moves
	ld a, $40
	ld [wPartyMenuAnimMonEnabled], a
;>     keys = PlaceUnfilledArrowMenuCursor(HandleMenuInput_())
	call HandleMenuInput_
	call PlaceUnfilledArrowMenuCursor
	ld b, a
;>     wPartyMenuAnimMonEnabled = 0
	xor a
	ld [wPartyMenuAnimMonEnabled], a
;>     wPartyAndBillsPCSavedMenuItem = wCurrentMenuItem
	ld a, [wCurrentMenuItem]
	ld [wPartyAndBillsPCSavedMenuItem], a
;>     wStatusFlags5 &= ~(1 << BIT_NO_TEXT_DELAY) & 0xFF
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
;>     if not wMenuItemToSwap:         # no swap going on: the choice is made
	ld a, [wMenuItemToSwap]
	and a
	jp nz, .swappingPokemon
;>         hTileAnimations = saved_tile_animations
	pop af
	ldh [hTileAnimations], a
;>         if keys & 1 << B_PAD_B or not wPartyCount:   # backed out, or nobody to pick
	bit B_PAD_B, b
	jr nz, .noPokemonChosen
	ld a, [wPartyCount]
	and a
	jr z, .noPokemonChosen
;>@n1             BankswitchBack()
;>@n2             return True
;>         wWhichPokemon = wCurrentMenuItem
	ld a, [wCurrentMenuItem]
	ld [wWhichPokemon], a
;>         species = wPartySpecies[wCurrentMenuItem]
	ld hl, wPartySpecies
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
;>         wCurPartySpecies = species
;>         wBattleMonSpecies2 = species
	ld [wCurPartySpecies], a
	ld [wBattleMonSpecies2], a
;>         BankswitchBack()
	call BankswitchBack
;>         return False
	and a
	ret
.noPokemonChosen
;=@n1
	call BankswitchBack
;=@n2
	scf
	ret
.swappingPokemon
;>     if keys & 1 << B_PAD_B:         # B cancels the swap
	bit B_PAD_B, b
	jr z, .handleSwap
; cancel swap if the B button was pressed
;>         ErasePartyMenuCursors()
	ld b, BANK(ErasePartyMenuCursors)
	ld hl, ErasePartyMenuCursors
	call Bankswitch
;>         wMenuItemToSwap = 0
;>         wPartyMenuTypeOrMessageID = 0
	xor a
	ld [wMenuItemToSwap], a
	ld [wPartyMenuTypeOrMessageID], a
;>         RedrawPartyMenu()
	call RedrawPartyMenu
;=@loop
	jr HandlePartyMenuInput
.handleSwap
;>     else:                           # A swaps the two Pokémon
;>         wWhichPokemon = wCurrentMenuItem
	ld a, [wCurrentMenuItem]
	ld [wWhichPokemon], a
;>         SwitchPartyMon()
	ld b, BANK(SwitchPartyMon)
	ld hl, SwitchPartyMon
	call Bankswitch
;=@loop
	jr HandlePartyMenuInput

;@ path: home/pokemon
;@ def DrawPartyMenu()
;@ Draw the party menu from scratch (DrawPartyMenu_).
DrawPartyMenu::
;> DrawPartyMenuCommon(DrawPartyMenu_)
	ld hl, DrawPartyMenu_
	jr DrawPartyMenuCommon

;@ path: home/pokemon
;@ def RedrawPartyMenu()
;@ Draw the party menu's entries again (RedrawPartyMenu_).
RedrawPartyMenu::
;> DrawPartyMenuCommon(RedrawPartyMenu_)
	ld hl, RedrawPartyMenu_

;@ path: home/pokemon
;@ def DrawPartyMenuCommon(func: hl)
;@ Run the party menu drawing function `func` in its bank.
DrawPartyMenuCommon::
;> Bankswitch(BANK(RedrawPartyMenu_), func)
	ld b, BANK(RedrawPartyMenu_)
	jp Bankswitch

; prints a pokemon's status condition
; INPUT:
; de = address of status condition
; hl = destination address
;@ path: home/pokemon
;@ def PrintStatusCondition(status: de, dest: hl) -> hl
;@ Print the status of the Pokémon whose status byte is at status (its HP comes 3 and 2 bytes before):
;@ "FNT" with 0 HP, otherwise its ailment, if any.
PrintStatusCondition::
;> # (status kept on the stack)
	push de
;> hp = mem[status - 2]
	dec de
	dec de ; de = address of current HP
	ld a, [de]
	ld b, a
;> hp |= mem[status - 3]               # zero only when both HP bytes are
	dec de
	ld a, [de]
	or b ; is the pokemon's HP zero?
;> if hp:
;>     return PrintStatusConditionNotFainted(status, dest)
	pop de
	jr nz, PrintStatusConditionNotFainted
; if the pokemon's HP is 0, print "FNT"
;> mem[dest], mem[dest + 1], mem[dest + 2] = charmap('FNT')   # fainted
	ld a, CHARVAL(STRCHAR("FNT", $0))
	ld [hli], a
	ld a, CHARVAL(STRCHAR("FNT", $1))
	ld [hli], a
	ld [hl], CHARVAL(STRCHAR("FNT", CHARLEN("FNT") - 1))
;> return dest + 2
	and a
	ret

;@ path: home/pokemon
;@ def PrintStatusConditionNotFainted(status: de, dest: hl) -> hl
;@ Print the ailment in the status byte at status (PrintStatusAilment, in its bank).
PrintStatusConditionNotFainted::
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(PrintStatusAilment)
	ld a, BANK(PrintStatusAilment)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(PrintStatusAilment))
	ld [rROMB], a
;> dest = PrintStatusAilment(status, dest)
	call PrintStatusAilment
;> hLoadedROMBank = saved
	pop bc
	ld a, b
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
;> return dest
	ret

; function to print pokemon level, leaving off the ":L" if the level is at least 100
; INPUT:
; hl = destination address
; [wLoadedMonLevel] = level
;@ path: home/pokemon
;@ def PrintLevel(dest: hl) -> hl
;@ Print wLoadedMonLevel as ":L" and two digits, or from level 100 three digits without the ":L".
;@ test: dest = rand_ram(4)
PrintLevel::
;> mem[dest] = 0x6E                    # ":L"
	ld a, '<LV>' ; ":L" tile ID
	ld [hli], a
;> if wLoadedMonLevel < 100:
;>     return PrintLevelCommon(dest + 1, 2, wLoadedMonLevel)
	ld c, 2 ; number of digits
	ld a, [wLoadedMonLevel] ; level
	cp 100
	jr c, PrintLevelCommon
; if level at least 100, write over the ":L" tile
;> return PrintLevelCommon(dest, 3, wLoadedMonLevel)   # three digits, over the ":L"
	dec hl
	inc c ; increment number of digits to 3
	jr PrintLevelCommon

; prints the level without leaving off ":L" regardless of level
; INPUT:
; hl = destination address
; [wLoadedMonLevel] = level
;@ path: home/pokemon
;@ def PrintLevelFull(dest: hl) -> hl
;@ Print wLoadedMonLevel as ":L" and up to three digits.
;@ test: dest = rand_ram(4)
PrintLevelFull::
;> mem[dest] = 0x6E    # ":L"
;> return PrintLevelCommon(dest + 1, 3, mem[addr(wLoadedMonLevel)])
	ld a, '<LV>' ; ":L" tile ID
	ld [hli], a
	ld c, 3 ; number of digits
	ld a, [wLoadedMonLevel] ; level

;@ path: home/pokemon
;@ def PrintLevelCommon(dest: hl, digits: c, level: a) -> hl
;@ Print the number `level` left-aligned in up to `digits` digits (through wTempByteValue).
;@ test: dest = rand_ram(4); digits = rand(1, 3)
PrintLevelCommon::
;> mem[addr(wTempByteValue)] = level
;> return PrintNumber(addr(wTempByteValue), dest, LEFT_ALIGN | 1, digits)
	ld [wTempByteValue], a
	ld de, wTempByteValue
	ld b, LEFT_ALIGN | 1 ; 1 byte
	jp PrintNumber

;@ path: home/pokemon
;@ def GetwMoves(index: a) -> a
;@ The move in slot `index` of wMoves. Not used.
;@ test: index = rand(0, 3)
GetwMoves::
; Unused. Returns the move at index a from wMoves in a
;> return mem[addr(wMoves) + index]
	ld hl, wMoves
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ret

; copies the base stat data of a pokemon to wMonHeader
; INPUT:
; [wCurSpecies] = pokemon ID
;@ path: home/pokemon
;@ def GetMonHeader()
;@ Copy the base data of species wCurSpecies to wMonHeader (Mew's lives in another bank). The Kabutops and
;@ Aerodactyl fossils and the ghost only get a picture size and front picture. Keeps hl, de, bc.
;@ test: wCurSpecies = rng.choice((FOSSIL_KABUTOPS, MON_GHOST, FOSSIL_AERODACTYL, MEW, rand(1, 190)))
GetMonHeader::
;> saved_bank = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(BaseStats)
	ld a, BANK(BaseStats)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(BaseStats))
	ld [rROMB], a
;> # (registers kept on the stack)
	push bc
	push de
	push hl
;> saved_dex = wPokedexNum
	ld a, [wPokedexNum]
	push af
;> species = wCurSpecies
	ld a, [wCurSpecies]
;> wPokedexNum = species
	ld [wPokedexNum], a
;> size, pic = 0x66, FossilKabutopsPic   # the Kabutops fossil
	ld de, FossilKabutopsPic
	ld b, $66 ; size of Kabutops fossil and Ghost sprites
;> if species != FOSSIL_KABUTOPS:
	cp FOSSIL_KABUTOPS ; Kabutops fossil
	jr z, .specialID
;>     pic = GhostPic                  # the ghost, the same size
	ld de, GhostPic
;>     if species != MON_GHOST:
	cp MON_GHOST ; Ghost
	jr z, .specialID
;>         size, pic = 0x77, FossilAerodactylPic
	ld de, FossilAerodactylPic
	ld b, $77 ; size of Aerodactyl fossil sprite
;> if species in (FOSSIL_KABUTOPS, MON_GHOST, FOSSIL_AERODACTYL):   # only a picture
	cp FOSSIL_AERODACTYL ; Aerodactyl fossil
	jr z, .specialID
;>@s2     wMonHSpriteDim = size
;>@s3     wMonHFrontSprite[0], wMonHFrontSprite[1] = lo(pic), hi(pic)
;> elif species == MEW:
	cp MEW
	jr z, .mew
;>@m1     FarCopyData(BANK(MewBaseStats), MewBaseStats, addr(wMonHeader), BASE_DATA_SIZE)
;> else:
;>     Predef((IndexToPokedexPredef - PredefPointers) // 3)   # IndexToPokedex
	ld a, (IndexToPokedexPredef - PredefPointers) / 3
	call Predef
;>     src = AddNTimes(BaseStats, BASE_DATA_SIZE, u8(wPokedexNum - 1))
	ld a, [wPokedexNum]
	dec a
	ld bc, BASE_DATA_SIZE
	ld hl, BaseStats
	call AddNTimes
;>     CopyData(src, addr(wMonHeader), BASE_DATA_SIZE)
	ld de, wMonHeader
	ld bc, BASE_DATA_SIZE
	call CopyData
	jr .done
.specialID
;=@s2
	ld hl, wMonHSpriteDim
	ld [hl], b ; write sprite dimensions
;=@s3
	inc hl
	ld [hl], e ; write front sprite pointer
	inc hl
	ld [hl], d
	jr .done
.mew
;=@m1
	ld hl, MewBaseStats
	ld de, wMonHeader
	ld bc, BASE_DATA_SIZE
	ld a, BANK(MewBaseStats)
	call FarCopyData
.done
;> wMonHIndex = wCurSpecies
	ld a, [wCurSpecies]
	ld [wMonHIndex], a
;> wPokedexNum = saved_dex
	pop af
	ld [wPokedexNum], a
;> # (registers come back off the stack)
	pop hl
	pop de
	pop bc
;> hLoadedROMBank = saved_bank
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved_bank)
	ld [rROMB], a
	ret

; copy party pokemon's name to wNameBuffer
;@ path: home/pokemon
;@ def GetPartyMonName2() -> de
;@ Copy the nickname of party member wWhichPokemon to wNameBuffer.
;@ test: wWhichPokemon = rand(0, 5)
GetPartyMonName2::
;> return GetPartyMonName(wWhichPokemon, wPartyMonNicks)
	ld a, [wWhichPokemon] ; index within party
	ld hl, wPartyMonNicks

; this is called more often
;@ path: home/pokemon
;@ def GetPartyMonName(index: a, names: hl) -> de
;@ Copy name `index` of the list of NAME_LENGTH-byte names at names to wNameBuffer, which de points at.
;@ Keeps hl and bc.
;@ test: index = rand(0, 5); names = wPartyMonNicks
GetPartyMonName::
;> name = SkipFixedLengthTextEntries(names, index)
	push hl
	push bc
	call SkipFixedLengthTextEntries ; add NAME_LENGTH to hl, a times
;> CopyData(name, wNameBuffer, NAME_LENGTH)
	ld de, wNameBuffer
	push de
	ld bc, NAME_LENGTH
	call CopyData
;> return addr(wNameBuffer)
	pop de
	pop bc
	pop hl
	ret
; function to print a BCD (Binary-coded decimal) number
; de = address of BCD number
; hl = destination address
; c = flags and length
; bit 7: if set, do not print leading zeroes
;        if unset, print leading zeroes
; bit 6: if set, left-align the string (do not pad empty digits with spaces)
;        if unset, right-align the string
; bit 5: if set, print currency symbol at the beginning of the string
;        if unset, do not print the currency symbol
; bits 0-4: length of BCD number in bytes
; Note that bits 5 and 7 are modified during execution. The above reflects
; their meaning at the beginning of the functions's execution.
;@ path: home/print_bcd
;@ def PrintBCDNumber(src: de, dest: hl, flags: c) -> (de, hl)
;@ Print the packed BCD number at src (big-endian, flags & $1F bytes long) at dest. Flags: leading zeroes left
;@ out, left alignment, a '¥' in front. A number that is all zeroes still prints one '0'.
;@ test: flags = rand(1, 3) | rand(0, 7) << 5; src = rand_ram(4)
PrintBCDNumber::
;> length = flags & ~(1 << BIT_LEADING_ZEROES | 1 << BIT_LEFT_ALIGN | 1 << BIT_MONEY_SIGN) & 0xFF
	ld b, c ; save flags in b
	res BIT_LEADING_ZEROES, c
	res BIT_LEFT_ALIGN, c
	res BIT_MONEY_SIGN, c ; c now holds the length
;> if flags >> BIT_MONEY_SIGN & 1 and not flags >> BIT_LEADING_ZEROES & 1:
	bit BIT_MONEY_SIGN, b
	jr z, .loop
	bit BIT_LEADING_ZEROES, b
	jr nz, .loop
;>     mem[dest] = 0xF0                # '¥'
	ld [hl], '¥'
;>     dest += 1
	inc hl
.loop
;>@lp for i in range(length):
;>     dest, flags = PrintBCDDigit(swap(mem[src]), dest, flags)
	ld a, [de]
	swap a
	call PrintBCDDigit ; print upper digit
;>     dest, flags = PrintBCDDigit(mem[src], dest, flags)
	ld a, [de]
	call PrintBCDDigit ; print lower digit
;>     src += 1
	inc de
;=@lp
	dec c
	jr nz, .loop
;> if flags >> BIT_LEADING_ZEROES & 1:  # nothing printed yet: the number is 0
	bit BIT_LEADING_ZEROES, b ; were any non-zero digits printed?
	jr z, .done ; if so, we are done
; if every digit of the BCD number is zero, print the last 0
;>     if not flags >> BIT_LEFT_ALIGN & 1:
	bit BIT_LEFT_ALIGN, b
	jr nz, .skipRightAlignmentAdjustment
;>         dest -= 1
	dec hl ; if the string is right-aligned, it needs to be moved back one space
.skipRightAlignmentAdjustment
;>     if flags >> BIT_MONEY_SIGN & 1:
	bit BIT_MONEY_SIGN, b
	jr z, .skipCurrencySymbol
;>         mem[dest] = 0xF0            # '¥'
	ld [hl], '¥'
;>         dest += 1
	inc hl
.skipCurrencySymbol
;>     mem[dest] = 0xF6                # '0'
	ld [hl], '0'
;>     PrintLetterDelay()
	call PrintLetterDelay
;>     dest += 1
	inc hl
.done
;> return (src, dest)
	ret

;@ path: home/print_bcd
;@ def PrintBCDDigit(digit: a, dest: hl, flags: b) -> (hl, b)
;@ Print the low digit of `digit` at dest. While no digit has been printed yet (BIT_LEADING_ZEROES set), a
;@ zero is left out: a space when right-aligned, nothing when left-aligned. The first real digit clears that
;@ bit, putting the '¥' in front first if asked.
PrintBCDDigit::
;> d = digit & 0xF
	and $f
;>@nz if d or not flags >> BIT_LEADING_ZEROES & 1:
	and a
	jr z, .zeroDigit
.nonzeroDigit
;>     if flags >> BIT_LEADING_ZEROES & 1:  # the first digit printed
	bit BIT_LEADING_ZEROES, b
	jr z, .outputDigit
; if bit 7 is set, then no numbers have been printed yet
;>         if flags >> BIT_MONEY_SIGN & 1:
	bit BIT_MONEY_SIGN, b
	jr z, .skipCurrencySymbol
;>             mem[dest] = 0xF0        # '¥'
	ld [hl], '¥'
;>             dest += 1
	inc hl
;>             flags &= ~(1 << BIT_MONEY_SIGN) & 0xFF
	res BIT_MONEY_SIGN, b
.skipCurrencySymbol
;>         flags &= ~(1 << BIT_LEADING_ZEROES) & 0xFF
	res BIT_LEADING_ZEROES, b
.outputDigit
;>     mem[dest] = 0xF6 + d            # '0' + d
	add '0'
	ld [hli], a
;>     PrintLetterDelay()
;>     return (dest + 1, flags)
	jp PrintLetterDelay
.zeroDigit
;=@nz
	bit BIT_LEADING_ZEROES, b
	jr z, .outputDigit ; if so, print a zero digit
;> # a leading zero is left out: a space when right-aligned
;> if flags >> BIT_LEFT_ALIGN & 1:
;>     return (dest, flags)
	bit BIT_LEFT_ALIGN, b
	ret nz
;> return (dest + 1, flags)
	inc hl ; if right-aligned, "print" a space by advancing the pointer
	ret
; uncompresses the front or back sprite of the specified mon
; assumes the corresponding mon header is already loaded
; hl contains offset to sprite pointer ($b for front or $d for back)
;@ path: home/pics
;@ def UncompressMonSprite(offset: hl)
;@ Decompress the picture whose pointer sits at wMonHeader + offset (front or back picture of species
;@ wCurPartySpecies) into the sprite buffers. The pictures are spread over five banks by species number;
;@ Mew's and the Kabutops fossil's live elsewhere.
;@ test: skip needs a real compressed picture as input
UncompressMonSprite::
;> p = addr(wMonHeader) + offset
	ld bc, wMonHeader
	add hl, bc
;> wSpriteInputPtr[0] = mem[p]
	ld a, [hli]
	ld [wSpriteInputPtr], a    ; fetch sprite input pointer
;> wSpriteInputPtr[1] = mem[p + 1]
	ld a, [hl]
	ld [wSpriteInputPtr+1], a
; define (by index number) the bank that a pokemon's image is in
; index = MEW:             bank $1
; index = FOSSIL_KABUTOPS: bank $B
;       index < $1F:       bank $9 ("Pics 1")
; $1F ≤ index < $4A:       bank $A ("Pics 2")
; $4A ≤ index < $74:       bank $B ("Pics 3")
; $74 ≤ index < $99:       bank $C ("Pics 4")
; $99 ≤ index:             bank $D ("Pics 5")
;> species = wCurPartySpecies
	ld a, [wCurPartySpecies]
	ld b, a
;> if species == MEW:
;>     bank = BANK(MewPicFront)
	cp MEW
	ld a, BANK(MewPicFront)
	jr z, .GotBank
;> elif species == FOSSIL_KABUTOPS:
;>     bank = BANK(FossilKabutopsPic)
	ld a, b
	cp FOSSIL_KABUTOPS
	ld a, BANK(FossilKabutopsPic)
	jr z, .GotBank
;> elif species <= TANGELA:
;>     bank = 0x09    # "Pics 1"
	ld a, b
	cp TANGELA + 1
	ld a, BANK("Pics 1")
	jr c, .GotBank
;> elif species <= MOLTRES:
;>     bank = 0x0A    # "Pics 2"
	ld a, b
	cp MOLTRES + 1
	ld a, BANK("Pics 2")
	jr c, .GotBank
;> elif species <= BEEDRILL + 1:
;>     bank = 0x0B    # "Pics 3"
	ld a, b
	cp BEEDRILL + 2
	ld a, BANK("Pics 3")
	jr c, .GotBank
;> elif species <= STARMIE:
;>     bank = 0x0C    # "Pics 4"
	ld a, b
	cp STARMIE + 1
	ld a, BANK("Pics 4")
	jr c, .GotBank
;> else:
;>     bank = 0x0D    # "Pics 5"
	ld a, BANK("Pics 5")
.GotBank
;> UncompressSpriteData(bank)
	jp UncompressSpriteData

; de: destination location
;@ path: home/pics
;@ def LoadMonFrontSprite(dest: de)
;@ Decompress the front picture of the species in wMonHeader and put it, centred in a 7 x 7 tile square,
;@ into VRAM at dest.
;@ test: skip needs a real compressed picture as input
LoadMonFrontSprite::
;> # (dest kept on the stack)
	push de
;> UncompressMonSprite(addr(wMonHFrontSprite) - addr(wMonHeader))
	ld hl, wMonHFrontSprite - wMonHeader
	call UncompressMonSprite
;> size = wMonHSpriteDim
	ld hl, wMonHSpriteDim
	ld a, [hli]
	ld c, a
;> LoadUncompressedSpriteData(dest, size, size)
	pop de
	; fall through

; postprocesses uncompressed sprite chunks to a 2bpp sprite and loads it into video ram
; calculates alignment parameters to place both sprite chunks in the center of the 7*7 tile sprite buffers
; de: destination location
; a,c:  sprite dimensions (in tiles of 8x8 each)
;@ path: home/pics
;@ def LoadUncompressedSpriteData(dest: de, width: a, height: c)
;@ Turn the two decompressed bit planes in sSpriteBuffer1 and 2 into a picture at dest in VRAM: each plane
;@ is moved to the middle of a 7 x 7 tile square (width in tiles in the low nybble of `width`, height in the
;@ high nybble of `height`), then the planes are interlaced into 2 bits per pixel.
;@ test: width = rand(1, 7); height = rand(1, 7) << 4; dest = 0x9000
LoadUncompressedSpriteData::
;> # (dest kept on the stack)
	push de
;> w = width & 0xF
	and $f
;> hSpriteWidth = w
	ldh [hSpriteWidth], a ; each byte contains 8 pixels (in 1bpp), so tiles=bytes for width
;> half = u8(8 - w) >> 1               # the columns to skip to centre it, rounded up
	ld b, a
	ld a, $7
	sub b      ; 7-w
	inc a      ; 8-w
	srl a      ; (8-w)/2     ; horizontal center (in tiles, rounded up)
;> hSpriteOffset = u8(7 * half)        # in tiles, 7 per column
	ld b, a
	add a
	add a
	add a
	sub b      ; 7*((8-w)/2) ; skip for horizontal center (in tiles)
	ldh [hSpriteOffset], a
;> h = height >> 4
	ld a, c
	swap a
	and $f
	ld b, a
;> hSpriteHeight = u8(8 * h)
	add a
	add a
	add a     ; 8*tiles is height in bytes
	ldh [hSpriteHeight], a
;> skip = u8(7 - h)                    # the rows above it (aligned to the bottom)
	ld a, $7
	sub b      ; 7-h         ; skip for vertical center (in tiles, relative to current column)
	ld b, a
;> hSpriteOffset = u8(8 * u8(hSpriteOffset + skip))   # in bytes
	ldh a, [hSpriteOffset]
	add b     ; 7*((8-w)/2) + 7-h ; combined overall offset (in tiles)
	add a
	add a
	add a     ; 8*(7*((8-w)/2) + 7-h) ; combined overall offset (in bytes)
	ldh [hSpriteOffset], a
;> rRAMB = 0
	xor a
	ld [rRAMB], a
;> ZeroSpriteBuffer(sSpriteBuffer0)
	ld hl, sSpriteBuffer0
	call ZeroSpriteBuffer   ; zero buffer 0
;> AlignSpriteDataCentered(sSpriteBuffer0, sSpriteBuffer1)
	ld de, sSpriteBuffer1
	ld hl, sSpriteBuffer0
	call AlignSpriteDataCentered    ; copy and align buffer 1 to 0 (containing the MSB of the 2bpp sprite)
;> ZeroSpriteBuffer(sSpriteBuffer1)
	ld hl, sSpriteBuffer1
	call ZeroSpriteBuffer   ; zero buffer 1
;> AlignSpriteDataCentered(sSpriteBuffer1, sSpriteBuffer2)
	ld de, sSpriteBuffer2
	ld hl, sSpriteBuffer1
	call AlignSpriteDataCentered    ; copy and align buffer 2 to 1 (containing the LSB of the 2bpp sprite)
;> InterlaceMergeSpriteBuffers(dest)
	pop de
	jp InterlaceMergeSpriteBuffers

; copies and aligns the sprite data properly inside the sprite buffer
; sprite buffers are 7*7 tiles in size, the loaded sprite is centered within this area
;@ path: home/pics
;@ def AlignSpriteDataCentered(dest: hl, src: de)
;@ Copy a hSpriteWidth x hSpriteHeight bit plane from src into the 7 x 7 tile buffer at dest, starting
;@ hSpriteOffset bytes in (the buffers are stored column by column, 56 bytes each).
;@ test: hSpriteWidth = rand(1, 7); hSpriteHeight = 8 * rand(1, 7); hSpriteOffset = 8 * rand(0, 12); dest = sSpriteBuffer0; src = sSpriteBuffer1
AlignSpriteDataCentered::
;> dest += hSpriteOffset
	ldh a, [hSpriteOffset]
	ld b, $0
	ld c, a
	add hl, bc
;>@col for _ in range(hSpriteWidth or 256):
	ldh a, [hSpriteWidth]
.columnLoop
;>     # (the count and the column's start kept on the stack)
	push af
	push hl
;>@row     for row in range(hSpriteHeight or 256):
	ldh a, [hSpriteHeight]
	ld c, a
.columnInnerLoop
;>         mem[dest + row] = mem[src]
;>         src += 1
	ld a, [de]
	inc de
	ld [hli], a
;=@row
	dec c
	jr nz, .columnInnerLoop
;>     dest += 7 * TILE_1BPP_SIZE
	pop hl
	ld bc, 7 * TILE_1BPP_SIZE
	add hl, bc ; advance one full column
;=@col
	pop af
	dec a
	jr nz, .columnLoop
;> return
	ret

; fills the sprite buffer (pointed to in hl) with zeros
;@ path: home/pics
;@ def ZeroSpriteBuffer(dest: hl) -> hl
;@ Clear a sprite buffer (SPRITEBUFFERSIZE bytes) at dest.
;@ test: dest = sSpriteBuffer0
ZeroSpriteBuffer::
;>@f fill(dest, 0, SPRITEBUFFERSIZE)
	ld bc, SPRITEBUFFERSIZE
.nextByteLoop
;=@f
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .nextByteLoop
;> return dest + SPRITEBUFFERSIZE
	ret

; combines the (7*7 tiles, 1bpp) sprite chunks in buffer 0 and 1 into a 2bpp sprite located in buffer 1 through 2
; in the resulting sprite, the rows of the two source sprites are interlaced
; de: output address
;@ path: home/pics
;@ def InterlaceMergeSpriteBuffers(dest: de)
;@ Interlace the bit planes in sSpriteBuffer0 and 1 into a 2-bit-per-pixel picture in sSpriteBuffer1 and 2
;@ (working backwards from the end, so nothing is overwritten too early), mirror it if wSpriteFlipped is
;@ set (the nybble swap works with the mirrored decoding tables), and copy its 49 tiles to dest in VRAM.
;@ test: dest = 0x9000
InterlaceMergeSpriteBuffers::
;> rRAMB = 0
	xor a
	ld [rRAMB], a
;> # (dest kept on the stack)
	push de
;> out = sSpriteBuffer2 + SPRITEBUFFERSIZE - 1
	ld hl, sSpriteBuffer2 + (SPRITEBUFFERSIZE - 1) ; destination: end of buffer 2
;> plane1 = sSpriteBuffer1 + SPRITEBUFFERSIZE - 1
	ld de, sSpriteBuffer1 + (SPRITEBUFFERSIZE - 1) ; source 2: end of buffer 1
;> plane0 = sSpriteBuffer0 + SPRITEBUFFERSIZE - 1
	ld bc, sSpriteBuffer0 + (SPRITEBUFFERSIZE - 1) ; source 1: end of buffer 0
;>@il for _ in range(SPRITEBUFFERSIZE // 2):   # counted down in hSpriteInterlaceCounter
	ld a, SPRITEBUFFERSIZE / 2
	ldh [hSpriteInterlaceCounter], a
.interlaceLoop
;>     mem[out], mem[out - 1] = mem[plane1], mem[plane0]   # a byte of each plane
;>     out, plane1, plane0 = out - 2, plane1 - 1, plane0 - 1
	ld a, [de]
	dec de
	ld [hld], a   ; write byte of source 2
	ld a, [bc]
	dec bc
	ld [hld], a   ; write byte of source 1
;>     mem[out], mem[out - 1] = mem[plane1], mem[plane0]
;>     out, plane1, plane0 = out - 2, plane1 - 1, plane0 - 1
	ld a, [de]
	dec de
	ld [hld], a   ; write byte of source 2
	ld a, [bc]
	dec bc
	ld [hld], a   ; write byte of source 1
;=@il
	ldh a, [hSpriteInterlaceCounter]
	dec a
	ldh [hSpriteInterlaceCounter], a
	jr nz, .interlaceLoop
;> hSpriteInterlaceCounter = 0         # where the count ends
;> if wSpriteFlipped:
	ld a, [wSpriteFlipped]
	and a
	jr z, .notFlipped
;>@sw     for i in range(2 * SPRITEBUFFERSIZE):
	ld bc, 2 * SPRITEBUFFERSIZE
	ld hl, sSpriteBuffer1
.swapLoop
;>         mem[sSpriteBuffer1 + i] = swap(mem[sSpriteBuffer1 + i])
	swap [hl]    ; if flipped swap nybbles in all bytes
;=@sw
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .swapLoop
.notFlipped
;> CopyVideoData(dest, sSpriteBuffer1, hLoadedROMBank, PIC_SIZE)
	pop hl ; hl = output address
	ld de, sSpriteBuffer1
	ld c, PIC_SIZE ; tiles
	ldh a, [hLoadedROMBank]
	ld b, a
	jp CopyVideoData


;@ path: data/tilesets/collision_tile_ids
Underground_Coll::
	db $0b,$0c,$13,$15,$18
	db -1

;@ path: data/tilesets/collision_tile_ids
Overworld_Coll::
	db $00,$10,$1b,$20,$21,$23,$2c,$2d,$2e,$30,$31,$33,$39,$3c,$3e,$52,$54,$58,$5b
	db -1

;@ path: data/tilesets/collision_tile_ids
RedsHouse1_Coll::
;@ path: data/tilesets/collision_tile_ids
RedsHouse2_Coll::
	db $01,$02,$03,$11,$12,$13,$14,$1c,$1a
	db -1

;@ path: data/tilesets/collision_tile_ids
Mart_Coll::
;@ path: data/tilesets/collision_tile_ids
Pokecenter_Coll::
	db $11,$1a,$1c,$3c,$5e
	db -1

;@ path: data/tilesets/collision_tile_ids
Dojo_Coll::
;@ path: data/tilesets/collision_tile_ids
Gym_Coll::
	db $11,$16,$19,$2b,$3c,$3d,$3f,$4a,$4c,$4d,$03
	db -1

;@ path: data/tilesets/collision_tile_ids
Forest_Coll::
	db $1e,$20,$2e,$30,$34,$37,$39,$3a,$40,$51,$52,$5a,$5c,$5e,$5f
	db -1

;@ path: data/tilesets/collision_tile_ids
House_Coll::
	db $01,$12,$14,$28,$32,$37,$44,$54,$5c
	db -1

;@ path: data/tilesets/collision_tile_ids
ForestGate_Coll::
;@ path: data/tilesets/collision_tile_ids
Museum_Coll::
;@ path: data/tilesets/collision_tile_ids
Gate_Coll::
	db $01,$12,$14,$1a,$1c,$37,$38,$3b,$3c,$5e
	db -1

;@ path: data/tilesets/collision_tile_ids
Ship_Coll::
	db $04,$0d,$17,$1d,$1e,$23,$34,$37,$39,$4a
	db -1

;@ path: data/tilesets/collision_tile_ids
ShipPort_Coll::
	db $0a,$1a,$32,$3b
	db -1

;@ path: data/tilesets/collision_tile_ids
Cemetery_Coll::
	db $01,$10,$13,$1b,$22,$42,$52
	db -1

;@ path: data/tilesets/collision_tile_ids
Interior_Coll::
	db $04,$0f,$15,$1f,$3b,$45,$47,$55,$56
	db -1

;@ path: data/tilesets/collision_tile_ids
Cavern_Coll::
	db $05,$15,$18,$1a,$20,$21,$22,$2a,$2d,$30
	db -1

	; unused
	db -1

;@ path: data/tilesets/collision_tile_ids
Lobby_Coll::
	db $14,$17,$1a,$1c,$20,$38,$45
	db -1

;@ path: data/tilesets/collision_tile_ids
Mansion_Coll::
	db $01,$05,$11,$12,$14,$1a,$1c,$2c,$53
	db -1

;@ path: data/tilesets/collision_tile_ids
Lab_Coll::
	db $0c,$26,$16,$1e,$34,$37
	db -1

;@ path: data/tilesets/collision_tile_ids
Club_Coll::
	db $0f,$1a,$1f,$26,$28,$29,$2c,$2d,$2e,$2f,$41
	db -1

;@ path: data/tilesets/collision_tile_ids
Facility_Coll::
	db $01,$10,$11,$13,$1b,$20,$21,$22,$30,$31,$32,$42,$43,$48,$52,$55,$58,$5e
	db -1

;@ path: data/tilesets/collision_tile_ids
Plateau_Coll::
	db $1b,$23,$2c,$2d,$3b,$45
	db -1

;@ path: home/copy2
;@ def FarCopyData2(bank: a, src: hl, dest: de, count: bc)
;@ Copy count bytes from src in ROM bank `bank` to dest (like FarCopyData, keeping the bank in hROMBankTemp).
;@ test: bank = rand(1, 0x2C); count = rand(1, 64); src = rand(0x4000, 0x7FB0); dest = rand_ram(64)
FarCopyData2::
; Identical to FarCopyData, but uses hROMBankTemp
; as temp space instead of wBuffer.
;> hROMBankTemp = bank
	ldh [hROMBankTemp], a
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = bank
	ldh a, [hROMBankTemp]
	ldh [hLoadedROMBank], a
;> set_rom_bank(bank)
	ld [rROMB], a
;> CopyData(src, dest, count)
	call CopyData
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret

;@ path: home/copy2
;@ def FarCopyData3(bank: a, src: de, dest: hl, count: bc)
;@ FarCopyData2 with source and destination the other way round; keeps hl and de.
;@ test: bank = rand(1, 0x2C); count = rand(1, 64); src = rand(0x4000, 0x7FB0); dest = rand_ram(64)
FarCopyData3::
; Copy bc bytes from a:de to hl.
;> hROMBankTemp = bank
	ldh [hROMBankTemp], a
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = bank
	ldh a, [hROMBankTemp]
	ldh [hLoadedROMBank], a
;> set_rom_bank(bank)
	ld [rROMB], a
;> # (dest and src kept on the stack)
	push hl
	push de
;> CopyData(src, dest, count)           # the two pointers swapped through the stack
	push de
	ld d, h
	ld e, l
	pop hl
	call CopyData
;> # (src and dest come back off the stack)
	pop de
	pop hl
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret

;@ path: home/copy2
;@ def FarCopyDataDouble(bank: a, src: hl, dest: de, count: bc)
;@ Expand count bytes of a 1-bit-per-pixel picture at src in ROM bank `bank` to 2 bits per pixel at dest:
;@ every byte is written twice (both bit planes the same, so shade 0 or 3).
;@ test: bank = rand(1, 0x2C); count = rand(1, 64); src = rand(0x4000, 0x7FB0); dest = rand_ram(128)
FarCopyDataDouble::
; Expand bc bytes of 1bpp image data
; from a:hl to 2bpp data at de.
;> hROMBankTemp = bank
	ldh [hROMBankTemp], a
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = bank
	ldh a, [hROMBankTemp]
	ldh [hLoadedROMBank], a
;> set_rom_bank(bank)
	ld [rROMB], a
;> for i in range(count):
.loop
;>     mem[dest + 2 * i] = mem[src + i]
	ld a, [hli]
	ld [de], a
	inc de
;>     mem[dest + 2 * i + 1] = mem[src + i]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, .loop
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret

;@ path: home/copy2
;@ def CopyVideoData(dest: hl, src: de, bank: b, tiles: c)
;@ Copy `tiles` 2-bit-per-pixel tiles from src in ROM bank `bank` to dest in VRAM, 8 tiles per VBlank (the
;@ VBlank handler does the copying), with the automatic BG map transfer paused meanwhile.
CopyVideoData::
; Wait for the next VBlank, then copy c 2bpp
; tiles from b:de to hl, 8 tiles at a time.
; This takes c/8 frames.

;> saved_auto = hAutoBGTransferEnabled
;> hAutoBGTransferEnabled = 0          # no automatic BG map transfer meanwhile
	ldh a, [hAutoBGTransferEnabled]
	push af
	xor a ; disable auto-transfer while copying
	ldh [hAutoBGTransferEnabled], a

;> hROMBankTemp = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	ldh [hROMBankTemp], a

;> hLoadedROMBank = bank
;> set_rom_bank(bank)
	ld a, b
	ldh [hLoadedROMBank], a
	ld [rROMB], a

;> hVBlankCopySource[0] = lo(src)
;> hVBlankCopySource[1] = hi(src)
	ld a, e
	ldh [hVBlankCopySource], a
	ld a, d
	ldh [hVBlankCopySource + 1], a

;> hVBlankCopyDest[0] = lo(dest)
;> hVBlankCopyDest[1] = hi(dest)
	ld a, l
	ldh [hVBlankCopyDest], a
	ld a, h
	ldh [hVBlankCopyDest + 1], a

;>@loop while tiles >= 8:
.loop
	ld a, c
	cp 8
	jr nc, .keepgoing

; done
;>@k1     hVBlankCopySize = 8           # VBlank copies 8 tiles
;>@k2     DelayFrame()
;>@k3     tiles -= 8
;> hVBlankCopySize = tiles             # the rest
	ldh [hVBlankCopySize], a
;> DelayFrame()
	call DelayFrame
;> hLoadedROMBank = hROMBankTemp
;> set_rom_bank(hROMBankTemp)
	ldh a, [hROMBankTemp]
	ldh [hLoadedROMBank], a
	ld [rROMB], a
;> hAutoBGTransferEnabled = saved_auto
	pop af
	ldh [hAutoBGTransferEnabled], a
	ret

.keepgoing
;=@k1
	ld a, 8
	ldh [hVBlankCopySize], a
;=@k2
	call DelayFrame
;=@k3
	ld a, c
	sub 8
	ld c, a
;=@loop
	jr .loop

;@ path: home/copy2
;@ def CopyVideoDataDouble(dest: hl, src: de, bank: b, tiles: c)
;@ CopyVideoData for 1-bit-per-pixel tiles, expanded to 2 bits per pixel as they are copied.
CopyVideoDataDouble::
; Wait for the next VBlank, then copy c 1bpp
; tiles from b:de to hl, 8 tiles at a time.
; This takes c/8 frames.
;> saved_auto = hAutoBGTransferEnabled
;> hAutoBGTransferEnabled = 0          # no automatic BG map transfer meanwhile
	ldh a, [hAutoBGTransferEnabled]
	push af
	xor a ; disable auto-transfer while copying
	ldh [hAutoBGTransferEnabled], a
;> hROMBankTemp = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	ldh [hROMBankTemp], a

;> hLoadedROMBank = bank
;> set_rom_bank(bank)
	ld a, b
	ldh [hLoadedROMBank], a
	ld [rROMB], a

;> hVBlankCopyDoubleSource[0] = lo(src)
;> hVBlankCopyDoubleSource[1] = hi(src)
	ld a, e
	ldh [hVBlankCopyDoubleSource], a
	ld a, d
	ldh [hVBlankCopyDoubleSource + 1], a

;> hVBlankCopyDoubleDest[0] = lo(dest)
;> hVBlankCopyDoubleDest[1] = hi(dest)
	ld a, l
	ldh [hVBlankCopyDoubleDest], a
	ld a, h
	ldh [hVBlankCopyDoubleDest + 1], a

;>@loop while tiles >= 8:
.loop
	ld a, c
	cp 8
	jr nc, .keepgoing

; done
;>@k1     hVBlankCopyDoubleSize = 8     # VBlank copies 8 tiles
;>@k2     DelayFrame()
;>@k3     tiles -= 8
;> hVBlankCopyDoubleSize = tiles       # the rest
	ldh [hVBlankCopyDoubleSize], a
;> DelayFrame()
	call DelayFrame
;> hLoadedROMBank = hROMBankTemp
;> set_rom_bank(hROMBankTemp)
	ldh a, [hROMBankTemp]
	ldh [hLoadedROMBank], a
	ld [rROMB], a
;> hAutoBGTransferEnabled = saved_auto
	pop af
	ldh [hAutoBGTransferEnabled], a
	ret

.keepgoing
;=@k1
	ld a, 8
	ldh [hVBlankCopyDoubleSize], a
;=@k2
	call DelayFrame
;=@k3
	ld a, c
	sub 8
	ld c, a
;=@loop
	jr .loop

;@ path: home/copy2
;@ def ClearScreenArea(dest: hl, width: c, height: b)
;@ Blank a `width` x `height` rectangle of the screen buffer at dest with spaces ($7F).
;@ test: dest = wTileMap; width = rand(1, 20); height = rand(1, 18)
ClearScreenArea::
; Clear tilemap area cxb at hl.
;>@rows for row in range(height):
	ld a, ' '
	ld de, SCREEN_WIDTH
.loopRows
	push hl
	push bc
;>     for col in range(width):
;>         mem[dest + row * SCREEN_WIDTH + col] = 0x7F   # a space
.loopTiles
	ld [hli], a
	dec c
	jr nz, .loopTiles
;=@rows
	pop bc
	pop hl
	add hl, de
	dec b
	jr nz, .loopRows
	ret

;@ path: home/copy2
;@ def CopyScreenTileBufferToVRAM(base: b)
;@ Copy the screen buffer wTileMap to the BG map at base * $100, six rows per VBlank: three frames.
CopyScreenTileBufferToVRAM::
; Copy wTileMap to the BG Map starting at b * $100.
; This is done in thirds of 6 rows, so it takes 3 frames.

;> rows = SCREEN_HEIGHT // 3           # six rows a frame
	ld c, SCREEN_HEIGHT / 3

;>@third for row in (0, 6, 12):
;>@dest     dest = GetRowColAddressBgMap(row, 0, base)   # (row and column 0 go in first)
	ld hl, ((0) & $ff) << 8 + ((0) & $ff)
;>     src = coord(0, row)
;>@src     hVBlankCopyBGSource[0], hVBlankCopyBGSource[1] = lo(src), hi(src)   # for VBlank
	ld de, (6 * 0) * SCREEN_WIDTH + (0) + wTileMap
;>@dw     hVBlankCopyBGDest[0], hVBlankCopyBGDest[1] = lo(dest), hi(dest)
;>@rows     hVBlankCopyBGNumRows = rows
	call .setup
;>@delay     DelayFrame()
	call DelayFrame

;=@third
	ld hl, ((SCREEN_HEIGHT / 3) & $ff) << 8 + ((0) & $ff)
	ld de, (6 * 1) * SCREEN_WIDTH + (0) + wTileMap
	call .setup
;=@delay
	call DelayFrame

;=@third
	ld hl, ((2 * SCREEN_HEIGHT / 3) & $ff) << 8 + ((0) & $ff)
	ld de, (6 * 2) * SCREEN_WIDTH + (0) + wTileMap
	call .setup
;=@delay
	jp DelayFrame

.setup
;=@src
	ld a, d
	ldh [hVBlankCopyBGSource+1], a
;=@dest
	call GetRowColAddressBgMap
;=@dw
	ld a, l
	ldh [hVBlankCopyBGDest], a
	ld a, h
	ldh [hVBlankCopyBGDest+1], a
;=@rows
	ld a, c
	ldh [hVBlankCopyBGNumRows], a
;=@src
	ld a, e
	ldh [hVBlankCopyBGSource], a
	ret

;@ path: home/copy2
;@ def ClearScreen()
;@ Fill the screen buffer with spaces, then wait three frames for the BG map to catch up.
ClearScreen::
; Clear wTileMap, then wait
; for the bg map to update.
;>@f fill(coord(0, 0), 0x7F, SCREEN_AREA)
	ld bc, SCREEN_AREA
	inc b
	ld hl, (0) * SCREEN_WIDTH + (0) + wTileMap
	ld a, ' '
.loop
;=@f
	ld [hli], a
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
;> Delay3()
	jp Delay3
;@ path: home/text
;@ def TextBoxBorder(corner: hl, rows: b, width: c)
;@ Draw the frame of a text box: corner is its top left, rows and width count the space inside the frame.
;@ test: corner = wTileMap + rand(0, 40); rows = rand(1, 10); width = rand(1, 18)
TextBoxBorder::
; Draw a c×b text box at hl.

	; top row
;> mem[corner] = 0x79                  # '┌'
	push hl
	ld a, '┌'
	ld [hli], a
;>@fill fill(corner + 1, 0x7A, width)  # '─' (the code at .PlaceChars)
	inc a ; "─"
	call .PlaceChars
;> mem[corner + 1 + width] = 0x7B      # '┐'
	inc a ; "┐"
	ld [hl], a
	pop hl

;>@rows for r in range(1, rows + 1):
;>     row = corner + r * SCREEN_WIDTH
	ld de, SCREEN_WIDTH
	add hl, de

	; middle rows
;>     mem[row] = 0x7C                 # '│'
.next
	push hl
	ld a, '│'
	ld [hli], a
;>     fill(row + 1, 0x7F, width)      # spaces
	ld a, ' '
	call .PlaceChars
;>     mem[row + 1 + width] = 0x7C     # '│'
	ld [hl], '│'
	pop hl

;=@rows
	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .next

	; bottom row
;> row = corner + (rows + 1) * SCREEN_WIDTH
;> mem[row] = 0x7D                     # '└'
	ld a, '└'
	ld [hli], a
;> fill(row + 1, 0x7A, width)          # '─'
	ld a, '─'
	call .PlaceChars
;> mem[row + 1 + width] = 0x7E         # '┘'
	ld [hl], '┘'
	ret

.PlaceChars::
; Place char a c times.
;=@fill
	ld d, c
.loop
	ld [hli], a
	dec d
	jr nz, .loop
	ret

;@ path: home/text
;@ def PlaceString(text: de, dest: hl) -> (bc, de)
;@ Print the '@'-terminated string at text to the screen buffer at dest, letter by letter. Returns bc = where
;@ the next letter would go and de = the end of the string. Control characters in the string move to the next
;@ line, insert names, wait for a button, scroll the text box...
PlaceString::
;> return PlaceNextChar(text, dest, dest)  # the start of the current line goes on the stack
	push hl

;@ path: home/text
;@ def PlaceNextChar(text: de, dest: hl, line) -> (bc, de)
;@ One step of PlaceString: line is the start of the current line, which PlaceString keeps on the stack.
;@ Control characters jump to their own routine; any other character is printed.
;@ test: skip continues PlaceString with the start of the line on the stack
PlaceNextChar::
;> c = mem[text]
;> if c == 0x50:                       # '@': the end
	ld a, [de]
	cp '@'
	jr nz, .NotTerminator
;>     return (dest, text)             # the start of the line comes off the stack
	ld b, h
	ld c, l
	pop hl
	ret

.NotTerminator
;> if c == 0x4E:                       # '<NEXT>': the next line, one or two rows down
	cp '<NEXT>'
	jr nz, .NotNext
;>     step = SCREEN_WIDTH if hUILayoutFlags >> BIT_SINGLE_SPACED_LINES & 1 else 2 * SCREEN_WIDTH
	ld bc, 2 * SCREEN_WIDTH
	ldh a, [hUILayoutFlags]
	bit BIT_SINGLE_SPACED_LINES, a
	jr z, .ok
	ld bc, SCREEN_WIDTH
.ok
;>     line += step
	pop hl
	add hl, bc
	push hl
;>     return NextChar(text, line, line)
	jp NextChar

.NotNext
;> if c == 0x4F:                       # '<LINE>': the second line of the text box
	cp '<LINE>'
	jr nz, .NotLine
;>     line = coord(1, 16)
	pop hl
	ld hl, (16) * SCREEN_WIDTH + (1) + wTileMap
	push hl
;>     return NextChar(text, line, line)
	jp NextChar

.NotLine

; Check against a dictionary
;> if c == 0x00:                       # the other control characters jump to their routine
;>     return NullChar(text, dest, line)
	and a
	jp z, NullChar
;> if c == 0x4C:                       # '<SCROLL>'
;>     return _ContTextNoPause(text, dest, line)
	cp '<SCROLL>'
	jp z, _ContTextNoPause
;> if c == 0x4B:                       # '<_CONT>'
;>     return _ContText(text, dest, line)
	cp '<_CONT>'
	jp z, _ContText
;> if c == 0x51:                       # '<PARA>'
;>     return Paragraph(text, dest, line)
	cp '<PARA>'
	jp z, Paragraph
;> if c == 0x49:                       # '<PAGE>'
;>     return PageChar(text, dest, line)
	cp '<PAGE>'
	jp z, PageChar
;> if c == 0x52:                       # '<PLAYER>'
;>     return PrintPlayerName(text, dest, line)
	cp '<PLAYER>'
	jp z, PrintPlayerName
;> if c == 0x53:                       # '<RIVAL>'
;>     return PrintRivalName(text, dest, line)
	cp '<RIVAL>'
	jp z, PrintRivalName
;> if c == 0x54:                       # '#'
;>     return PlacePOKe(text, dest, line)
	cp '#'
	jp z, PlacePOKe
;> if c == 0x5B:                       # '<PC>'
;>     return PCChar(text, dest, line)
	cp '<PC>'
	jp z, PCChar
;> if c == 0x5E:                       # '<ROCKET>'
;>     return RocketChar(text, dest, line)
	cp '<ROCKET>'
	jp z, RocketChar
;> if c == 0x5C:                       # '<TM>'
;>     return TMChar(text, dest, line)
	cp '<TM>'
	jp z, TMChar
;> if c == 0x5D:                       # '<TRAINER>'
;>     return TrainerChar(text, dest, line)
	cp '<TRAINER>'
	jp z, TrainerChar
;> if c == 0x55:                       # '<CONT>'
;>     return ContText(text, dest, line)
	cp '<CONT>'
	jp z, ContText
;> if c == 0x56:                       # '<……>'
;>     return SixDotsChar(text, dest, line)
	cp '<……>'
	jp z, SixDotsChar
;> if c == 0x57:                       # '<DONE>'
;>     return DoneText(text, dest, line)
	cp '<DONE>'
	jp z, DoneText
;> if c == 0x58:                       # '<PROMPT>'
;>     return PromptText(text, dest, line)
	cp '<PROMPT>'
	jp z, PromptText
;> if c == 0x4A:                       # '<PKMN>'
;>     return PlacePKMN(text, dest, line)
	cp '<PKMN>'
	jp z, PlacePKMN
;> if c == 0x5F:                       # '<DEXEND>'
;>     return PlaceDexEnd(text, dest, line)
	cp '<DEXEND>'
	jp z, PlaceDexEnd
;> if c == 0x59:                       # '<TARGET>'
;>     return PlaceMoveTargetsName(text, dest, line)
	cp '<TARGET>'
	jp z, PlaceMoveTargetsName
;> if c == 0x5A:                       # '<USER>'
;>     return PlaceMoveUsersName(text, dest, line)
	cp '<USER>'
	jp z, PlaceMoveUsersName

;> mem[dest] = c                       # a character to print
	ld [hli], a
;> PrintLetterDelay()
	call PrintLetterDelay
;> return NextChar(text, dest + 1, line)   # it follows right below

;@ path: home/text
;@ def NextChar(text: de, dest: hl, line) -> (bc, de)
;@ Go on with the next character of the string.
;@ test: skip continues PlaceString with the start of the line on the stack
NextChar::
;> return PlaceNextChar(text + 1, dest, line)
	inc de
	jp PlaceNextChar

;@ path: home/text
;@ def NullChar(text: de, dest: hl, line) -> (bc, de)
;@ '<NULL>' in a string: a debugging leftover. It ends the string with de just before TextIDErrorText, so the
;@ text that follows is "[hTextID] ERROR." with the text number.
;@ test: skip continues PlaceString with the start of the line on the stack
NullChar::
;> return (dest, TextIDErrorText - 1)
	ld b, h
	ld c, l
	pop hl
	; A "<NULL>" character in a printed string
	; displays an error message with the current value
	; of hTextID in decimal format.
	; This is a debugging leftover.
	ld de, TextIDErrorText
	dec de
	ret

;@ path: home/text
TextIDErrorText:: ; "[hTextID] ERROR."
	db TX_FAR
	dw _TextIDErrorText
	db BANK(_TextIDErrorText)
	db TX_END


;@ path: home/text
;@ def PrintPlayerName(text: de, dest: hl, line) -> (bc, de)
;@ '<PLAYER>': print the player's name in the middle of a string, then go on with the string.
;@ test: skip continues PlaceString with the start of the line on the stack
PrintPlayerName::
;> return PlaceCommandCharacter(addr(wPlayerName), dest, text, line)
	push de
	ld de, wPlayerName
	jr PlaceCommandCharacter
;@ path: home/text
;@ def PrintRivalName(text: de, dest: hl, line) -> (bc, de)
;@ '<RIVAL>': print the rival's name in the middle of a string, then go on with the string.
;@ test: skip continues PlaceString with the start of the line on the stack
PrintRivalName::
;> return PlaceCommandCharacter(addr(wRivalName), dest, text, line)
	push de
	ld de, wRivalName
	jr PlaceCommandCharacter

;@ path: home/text
;@ def TrainerChar(text: de, dest: hl, line) -> (bc, de)
;@ '<TRAINER>': print "TRAINER" in the middle of a string, then go on with the string.
;@ test: skip continues PlaceString with the start of the line on the stack
TrainerChar::
;> return PlaceCommandCharacter(TrainerCharText, dest, text, line)
	push de
	ld de, TrainerCharText
	jr PlaceCommandCharacter
;@ path: home/text
;@ def TMChar(text: de, dest: hl, line) -> (bc, de)
;@ '<TM>': print "TM" in the middle of a string, then go on with the string.
;@ test: skip continues PlaceString with the start of the line on the stack
TMChar::
;> return PlaceCommandCharacter(TMCharText, dest, text, line)
	push de
	ld de, TMCharText
	jr PlaceCommandCharacter
;@ path: home/text
;@ def PCChar(text: de, dest: hl, line) -> (bc, de)
;@ '<PC>': print "PC" in the middle of a string, then go on with the string.
;@ test: skip continues PlaceString with the start of the line on the stack
PCChar::
;> return PlaceCommandCharacter(PCCharText, dest, text, line)
	push de
	ld de, PCCharText
	jr PlaceCommandCharacter
;@ path: home/text
;@ def RocketChar(text: de, dest: hl, line) -> (bc, de)
;@ '<ROCKET>': print "ROCKET" in the middle of a string, then go on with the string.
;@ test: skip continues PlaceString with the start of the line on the stack
RocketChar::
;> return PlaceCommandCharacter(RocketCharText, dest, text, line)
	push de
	ld de, RocketCharText
	jr PlaceCommandCharacter
;@ path: home/text
;@ def PlacePOKe(text: de, dest: hl, line) -> (bc, de)
;@ '<POKé>': print "POKé" in the middle of a string, then go on with the string.
;@ test: skip continues PlaceString with the start of the line on the stack
PlacePOKe::
;> return PlaceCommandCharacter(PlacePOKeText, dest, text, line)
	push de
	ld de, PlacePOKeText
	jr PlaceCommandCharacter
;@ path: home/text
;@ def SixDotsChar(text: de, dest: hl, line) -> (bc, de)
;@ '<……>': print six dots in the middle of a string, then go on with the string.
;@ test: skip continues PlaceString with the start of the line on the stack
SixDotsChar::
;> return PlaceCommandCharacter(SixDotsCharText, dest, text, line)
	push de
	ld de, SixDotsCharText
	jr PlaceCommandCharacter
;@ path: home/text
;@ def PlacePKMN(text: de, dest: hl, line) -> (bc, de)
;@ '<PKMN>': print the two-tile "PKMN" symbol in the middle of a string, then go on with the string.
;@ test: skip continues PlaceString with the start of the line on the stack
PlacePKMN::
;> return PlaceCommandCharacter(PlacePKMNText, dest, text, line)
	push de
	ld de, PlacePKMNText
	jr PlaceCommandCharacter

;@ path: home/text
;@ def PlaceMoveTargetsName(text: de, dest: hl, line) -> (bc, de)
;@ '<TARGET>': the name of the Pokémon the move is used on - the one whose turn it is not. The enemy's gets
;@ "Enemy " in front.
;@ test: skip continues PlaceString with the start of the line on the stack
PlaceMoveTargetsName::
;> if hWhoseTurn ^ 1 == 0:             # the target is the player's Pokémon
;>     name = wBattleMonNick
	ldh a, [hWhoseTurn]
	xor 1
;> else:                               # (both in the code shared with '<USER>')
;>@e1     dest = PlaceString(EnemyText, dest)[0]   # "Enemy "
;>@e2     name = wEnemyMonNick
;> return PlaceCommandCharacter(name, dest, text, line)
	jr PlaceMoveUsersName.place

;@ path: home/text
;@ def PlaceMoveUsersName(text: de, dest: hl, line) -> (bc, de)
;@ '<USER>': the name of the Pokémon using the move (whose turn it is); the enemy's gets "Enemy " in front.
;@ test: skip continues PlaceString with the start of the line on the stack
PlaceMoveUsersName::
;> side = hWhoseTurn
	ldh a, [hWhoseTurn]

.place:
;> if side == 0:
	push de
	and a
	jr nz, .enemy

;>     name = wBattleMonNick
	ld de, wBattleMonNick
	jr PlaceCommandCharacter

.enemy
;> else:
;>     dest = PlaceString(EnemyText, dest)[0]  # "Enemy "
	ld de, EnemyText
	call PlaceString
	ld h, b
	ld l, c
;>     name = wEnemyMonNick
;> return PlaceCommandCharacter(name, dest, text, line)
	ld de, wEnemyMonNick
	; fallthrough

;@ path: home/text
;@ def PlaceCommandCharacter(name: de, dest: hl, text, line) -> (bc, de)
;@ Print a name in the middle of a string (the player's, the rival's, "POKé", "TRAINER"...), then go on with
;@ the string after the control character (its address is on the stack).
;@ test: skip continues PlaceString with the string and the start of the line on the stack
PlaceCommandCharacter::
;> dest = PlaceString(name, dest)[0]
;> return PlaceNextChar(text + 1, dest, line)
	call PlaceString
	ld h, b
	ld l, c
	pop de
	inc de
	jp PlaceNextChar

;@ path: home/text
TMCharText::      db "TM@"
;@ path: home/text
TrainerCharText:: db "TRAINER@"
;@ path: home/text
PCCharText::      db "PC@"
;@ path: home/text
RocketCharText::  db "ROCKET@"
;@ path: home/text
PlacePOKeText::   db "POKé@"
;@ path: home/text
SixDotsCharText:: db "……@"
;@ path: home/text
EnemyText::       db "Enemy @"
;@ path: home/text
PlacePKMNText::   db "<PK><MN>@"

;@ path: home/text
;@ def ContText(text: de, dest: hl, line) -> (bc, de)
;@ '<CONT>': run the text commands of ContCharText (which wait for a button and scroll the box up), then go on.
;@ test: skip continues PlaceString with the start of the line on the stack
ContText::
;> # (text kept on the stack)
	push de
;> dest = TextCommandProcessor(ContCharText, dest)
	ld b, h
	ld c, l
	ld hl, ContCharText
	call TextCommandProcessor
	ld h, b
	ld l, c
;> return PlaceNextChar(text + 1, dest, line)
	pop de
	inc de
	jp PlaceNextChar

;@ path: home/text
ContCharText::
	db TX_FAR
	dw _ContCharText
	db BANK(_ContCharText)
	db TX_END

;@ path: home/text
;@ def PlaceDexEnd(text: de, dest: hl, line, bc: bc = 0) -> (bc, de)
;@ '<DEXEND>': end a Pokédex entry with a '.' and end the string (bc is left as it was).
;@ test: skip continues PlaceString with the start of the line on the stack
PlaceDexEnd::
;> mem[dest] = 0xE8  # '.'
;> return (bc, text)
	ld [hl], '.'
	pop hl
	ret

;@ path: home/text
;@ def PromptText(text: de, dest: hl, line) -> (bc, de)
;@ '<PROMPT>': show the blinking '▼' (not in a link battle), wait for A or B, then end the text.
;@ test: skip continues PlaceString with the start of the line on the stack
PromptText::
;> if wLinkState != LINK_STATE_BATTLING:
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z, .ok
;>     mem[coord(18, 16)] = 0xEE  # '▼'
	ld a, '▼'
	ld [(16) * SCREEN_WIDTH + (18) + wTileMap], a
.ok
;> ProtectedDelay3()
	call ProtectedDelay3
;> ManualTextScroll()
	call ManualTextScroll
;> mem[coord(18, 16)] = 0x7F
	ld a, ' '
	ld [(16) * SCREEN_WIDTH + (18) + wTileMap], a
;> return DoneText(text, dest, line)

;@ path: home/text
;@ def DoneText(text: de, dest: hl, line) -> (bc, de)
;@ '<DONE>': end the string and the text: de is left just before a text_end, so the text commands stop too.
;@ bc is left as it was.
;@ test: skip continues PlaceString with the start of the line on the stack
DoneText::
;> return (None, DoneText + 5)  # bc untouched; de: the byte before the text_end right after this code
	pop hl
	ld de, .stop
	dec de
	ret

.stop:
	db TX_END

;@ path: home/text
;@ def Paragraph(text: de, dest: hl, line) -> (bc, de)
;@ '<PARA>': wait for a button with '▼' showing, clear the text box and go on at its first line.
;@ test: skip continues PlaceString with the start of the line on the stack
Paragraph::
;> mem[coord(18, 16)] = 0xEE  # '▼'
	push de
	ld a, '▼'
	ld [(16) * SCREEN_WIDTH + (18) + wTileMap], a
;> ProtectedDelay3()
	call ProtectedDelay3
;> ManualTextScroll()
	call ManualTextScroll
;> ClearScreenArea(coord(1, 13), 4, 18)
	ld hl, (13) * SCREEN_WIDTH + (1) + wTileMap
	ld bc, ((4) & $ff) << 8 + ((18) & $ff)
	call ClearScreenArea
;> DelayFrames(20)
	ld c, 20
	call DelayFrames
;> return NextChar(text, coord(1, 14), line)
	pop de
	ld hl, (14) * SCREEN_WIDTH + (1) + wTileMap
	jp NextChar

;@ path: home/text
;@ def PageChar(text: de, dest: hl, line) -> (bc, de)
;@ '<PAGE>': like '<PARA>' for a bigger box (Pokédex entries): wait, clear seven rows, start again at row 11.
;@ test: skip continues PlaceString with the start of the line on the stack
PageChar::
;> mem[coord(18, 16)] = 0xEE  # '▼'
	push de
	ld a, '▼'
	ld [(16) * SCREEN_WIDTH + (18) + wTileMap], a
;> ProtectedDelay3()
	call ProtectedDelay3
;> ManualTextScroll()
	call ManualTextScroll
;> ClearScreenArea(coord(1, 10), 7, 18)
	ld hl, (10) * SCREEN_WIDTH + (1) + wTileMap
	ld bc, ((7) & $ff) << 8 + ((18) & $ff)
	call ClearScreenArea
;> DelayFrames(20)
	ld c, 20
	call DelayFrames
;> line = coord(1, 11)
	pop de
	pop hl
	ld hl, (11) * SCREEN_WIDTH + (1) + wTileMap
	push hl
;> return NextChar(text, line, line)
	jp NextChar

;@ path: home/text
;@ def _ContText(text: de, dest: hl, line) -> (bc, de)
;@ The '<_CONT>' behind '<CONT>': wait for a button with '▼' showing, then scroll the text up a line.
;@ test: skip continues PlaceString with the start of the line on the stack
_ContText::
;> mem[coord(18, 16)] = 0xEE           # '▼'
	ld a, '▼'
	ld [(16) * SCREEN_WIDTH + (18) + wTileMap], a
;> ProtectedDelay3()
	call ProtectedDelay3
;> ManualTextScroll()                  # waits for a button, then scrolls the text up a line
	push de
	call ManualTextScroll
	pop de
;> mem[coord(18, 16)] = 0x7F           # the '▼' goes
	ld a, ' '
	ld [(16) * SCREEN_WIDTH + (18) + wTileMap], a
;> return _ContTextNoPause(text, dest, line)   # it follows right below
;@ path: home/text
;@ def _ContTextNoPause(text: de, dest: hl, line) -> (bc, de)
;@ '<SCROLL>': scroll the text box up a line without waiting, and go on at its second line.
;@ test: skip continues PlaceString with the start of the line on the stack
_ContTextNoPause::
;> # (text kept on the stack)
	push de
;> ScrollTextUpOneLine()
	call ScrollTextUpOneLine
;> ScrollTextUpOneLine()
	call ScrollTextUpOneLine
;> return NextChar(text, coord(1, 16), line)
	ld hl, (16) * SCREEN_WIDTH + (1) + wTileMap
	pop de
	jp NextChar

; move both rows of text in the normal text box up one row
; always called twice in a row
; first time, copy the two rows of text to the "in between" rows that are usually empty
; second time, copy the bottom row of text into the top row of text
;@ path: home/text
;@ def ScrollTextUpOneLine()
;@ Move the three rows of the text box (rows 14 to 16) up one row and blank the bottom line, then wait five
;@ frames. Called twice in a row: the first copies the two lines of text into the gap between them, the
;@ second the bottom line into the top one.
ScrollTextUpOneLine::
;>@cp copy(coord(0, 13), coord(0, 14), SCREEN_WIDTH * 3)
	; top row of text
	ld hl, (14) * SCREEN_WIDTH + (0) + wTileMap
	; empty line above text
	ld de, (13) * SCREEN_WIDTH + (0) + wTileMap
	ld b, SCREEN_WIDTH * 3
.copyText
;=@cp
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copyText
;> fill(coord(1, 16), 0x7F, SCREEN_WIDTH - 2)  # ' '
	ld hl, (16) * SCREEN_WIDTH + (1) + wTileMap
	ld a, ' '
	ld b, SCREEN_WIDTH - 2
.clearText
	ld [hli], a
	dec b
	jr nz, .clearText

;> for _ in range(5):
;>     DelayFrame()
	ld b, 5
.WaitFrame
	call DelayFrame
	dec b
	jr nz, .WaitFrame

	ret

;@ path: home/text
;@ def ProtectedDelay3()
;@ Wait three frames, keeping bc.
ProtectedDelay3::
;> Delay3()
	push bc
	call Delay3
	pop bc
	ret

;@ path: home/text
;@ def TextCommandProcessor(text: hl, dest: bc) -> bc
;@ Run a text: a list of text commands (print a string, a number, wait for a button, play a sound...) ended by
;@ TX_END, printing at dest. Letters are printed one by one with a delay while it runs, unless
;@ hClearLetterPrintingDelayFlags turns that off; the delay setting is restored at the end.
TextCommandProcessor::
;> saved = wLetterPrintingDelayFlags   # (kept on the stack)
	ld a, [wLetterPrintingDelayFlags]
	push af
;> wLetterPrintingDelayFlags = (saved | 1 << BIT_TEXT_DELAY) ^ hClearLetterPrintingDelayFlags
	set BIT_TEXT_DELAY, a
	ld e, a
	ldh a, [hClearLetterPrintingDelayFlags]
	xor e
	ld [wLetterPrintingDelayFlags], a
;> wTextDest[0] = lo(dest)
	ld a, c
	ld [wTextDest], a
;> wTextDest[1] = hi(dest)
	ld a, b
	ld [wTextDest + 1], a
;> return NextTextCommand(text, dest, saved)

;@ path: home/text
;@ def NextTextCommand(text: hl, dest: bc, saved) -> bc
;@ Do the next command of a text. saved is the delay setting TextCommandProcessor keeps on the stack; each
;@ command gets the address after its command byte on the stack and comes back here.
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
NextTextCommand::
;> cmd = mem[text]
;> text += 1
	ld a, [hli]
;> if cmd == TX_END:
	cp TX_END
	jr nz, .TextCommand
;>     wLetterPrintingDelayFlags = saved   # the end of the text
	pop af
	ld [wLetterPrintingDelayFlags], a
;>     return dest
	ret

.TextCommand:
;> # (text kept on the stack for the command)
	push hl
;> if cmd == TX_FAR:
;>     return TextCommand_FAR(dest, text, saved)
	cp TX_FAR
	jp z, TextCommand_FAR
;> if cmd >= TX_SOUND_POKEDEX_RATING:  # the sound commands
;>     return TextCommand_SOUND(dest, text, saved)
	cp TX_SOUND_POKEDEX_RATING
	jp nc, TextCommand_SOUND
;> entry = TextCommandJumpTable
	ld hl, TextCommandJumpTable
;> # (dest kept on the stack)
	push bc
;> entry += 2 * cmd
	add a
	ld b, 0
	ld c, a
	add hl, bc
;> # (dest comes back off the stack)
	pop bc
;> handler = TextCommandJumpTable[cmd]   # the word at entry
	ld a, [hli]
	ld h, [hl]
	ld l, a
;> return handler(dest, text, saved)
	jp hl

;@ path: home/text
;@ def TextCommand_BOX(dest: bc, text, saved) -> bc
;@ TX_BOX corner, rows, width: draw a text box frame. Afterwards bc holds what drawing it left there (b = 0,
;@ c = width), not the old cursor.
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
TextCommand_BOX::
; draw a box (height, width)
;> corner = mem16[text]                # (text comes off the stack)
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
;> rows = mem[text + 2]
	ld a, [hli]
	ld b, a
;> width = mem[text + 3]
	ld a, [hli]
	ld c, a
;> # (text + 4 kept on the stack)
	push hl
;> TextBoxBorder(corner, rows, width)
	ld h, d
	ld l, e
	call TextBoxBorder
;> return NextTextCommand(text + 4, width, saved)
	pop hl
	jr NextTextCommand

;@ path: home/text
;@ def TextCommand_START(dest: bc, text, saved) -> bc
;@ TX_START: print the string that follows the command, up to its '@'.
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
TextCommand_START::
; write text until "@"
;> dest, end = PlaceString(text, dest) # (text comes off the stack)
	pop hl
	ld d, h
	ld e, l
	ld h, b
	ld l, c
	call PlaceString
;> return NextTextCommand(end + 1, dest, saved)
	ld h, d
	ld l, e
	inc hl
	jr NextTextCommand

;@ path: home/text
;@ def TextCommand_RAM(dest: bc, text, saved) -> bc
;@ TX_RAM address: print the string at an address (a name in RAM, usually).
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
TextCommand_RAM::
; write text from a ram address (little endian)
;> src = mem16[text]                   # the string's address
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
;> dest = PlaceString(src, dest)[0]
	push hl
	ld h, b
	ld l, c
	call PlaceString
	pop hl
;> return NextTextCommand(text + 2, dest, saved)
	jr NextTextCommand

;@ path: home/text
;@ def TextCommand_BCD(dest: bc, text, saved) -> bc
;@ TX_BCD address, flags: print a packed BCD number (money, coins) from an address.
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
TextCommand_BCD::
; write bcd from address, typically ram
;> src = mem16[text]                   # (text comes off the stack)
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
;> flags = mem[text + 2]
	ld a, [hli]
;> # (text + 3 kept on the stack)
	push hl
;> dest = PrintBCDNumber(src, dest, flags)[1]
	ld h, b
	ld l, c
	ld c, a
	call PrintBCDNumber
	ld b, h
	ld c, l
;> return NextTextCommand(text + 3, dest, saved)
	pop hl
	jr NextTextCommand

;@ path: home/text
;@ def TextCommand_MOVE(dest: bc, text, saved) -> bc
;@ TX_MOVE address: go on printing at another place of the screen buffer.
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
TextCommand_MOVE::
; move to a new tile
;> # (text comes off the stack)
	pop hl
;> lo = mem[text]
;> wTextDest[0] = lo
	ld a, [hli]
	ld [wTextDest], a
	ld c, a
;> hi_ = mem[text + 1]
;> wTextDest[1] = hi_
	ld a, [hli]
	ld [wTextDest + 1], a
	ld b, a
;> return NextTextCommand(text + 2, hi_ << 8 | lo, saved)
	jp NextTextCommand

;@ path: home/text
;@ def TextCommand_LOW(dest: bc, text, saved) -> bc
;@ TX_LOW: go on at the second line of the text box.
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
TextCommand_LOW::
; write text at (1,16)
;> return NextTextCommand(text, coord(1, 16), saved)
	pop hl
	; second line of dialogue text box
	ld bc, (16) * SCREEN_WIDTH + (1) + wTileMap
	jp NextTextCommand

;@ path: home/text
;@ def TextCommand_PROMPT_BUTTON(dest: bc, text, saved) -> bc
;@ TX_PROMPT_BUTTON: wait for A or B with the blinking '▼' in the corner of the box (without it in a link
;@ battle).
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
TextCommand_PROMPT_BUTTON::
; wait for button press; show arrow
;> if wLinkState == LINK_STATE_BATTLING:
;>     return TextCommand_WAIT_BUTTON(dest, text, saved)
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z, TextCommand_WAIT_BUTTON
;> mem[coord(18, 16)] = 0xEE  # '▼'
	ld a, '▼'
	; place down arrow in lower right corner of dialogue text box
	ld [(16) * SCREEN_WIDTH + (18) + wTileMap], a
;> ManualTextScroll()
	push bc
	call ManualTextScroll ; blink arrow and wait for A or B to be pressed
	pop bc
;> mem[coord(18, 16)] = 0x7F  # ' '
	ld a, ' '
	; overwrite down arrow with blank space
	ld [(16) * SCREEN_WIDTH + (18) + wTileMap], a
;> return NextTextCommand(text, dest, saved)
	pop hl
	jp NextTextCommand

;@ path: home/text
;@ def TextCommand_SCROLL(dest: bc, text, saved) -> bc
;@ TX_SCROLL: scroll the text up two lines and go on at the second line of the box.
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
TextCommand_SCROLL::
; pushes text up two lines and sets the BC cursor to the border tile
; below the first character column of the text box.
;> mem[coord(18, 16)] = 0x7F  # ' '
	ld a, ' '
	; place blank space in lower right corner of dialogue text box
	ld [(16) * SCREEN_WIDTH + (18) + wTileMap], a
;> ScrollTextUpOneLine()
	call ScrollTextUpOneLine
;> ScrollTextUpOneLine()
	call ScrollTextUpOneLine
;> return NextTextCommand(text, coord(1, 16), saved)   # (text comes off the stack)
	pop hl
	; second line of dialogue text box
	ld bc, (16) * SCREEN_WIDTH + (1) + wTileMap
	jp NextTextCommand

;@ path: home/text
;@ def TextCommand_START_ASM(dest: bc, text, saved) -> bc
;@ TX_START_ASM: the text goes on as code, right after the command byte. When that code returns, it lands in
;@ NextTextCommand with whatever hl and bc it leaves.
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
TextCommand_START_ASM::
; run assembly code
;> goto(text)  # with NextTextCommand as its return address
	pop hl
	ld de, NextTextCommand
	push de
	jp hl

;@ path: home/text
;@ def TextCommand_NUM(dest: bc, text, saved) -> bc
;@ TX_NUM address, spec: print a number from an address, left-aligned. spec: bytes in the high nibble,
;@ digits in the low one.
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
TextCommand_NUM::
; print a number
;> src = mem16[text]                   # (text comes off the stack)
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
;> spec = mem[text + 2]
	ld a, [hli]
;> # (text + 3 kept on the stack)
	push hl
;> digits = spec & 0x0F
	ld h, b
	ld l, c
	ld b, a
	and $0f
	ld c, a
;> flags = spec >> 4 | 1 << BIT_LEFT_ALIGN   # the number's bytes, left-aligned
	ld a, b
	and $f0
	swap a
	set BIT_LEFT_ALIGN, a
	ld b, a
;> dest = PrintNumber(src, dest, flags, digits)
	call PrintNumber
	ld b, h
	ld c, l
;> return NextTextCommand(text + 3, dest, saved)
	pop hl
	jp NextTextCommand

;@ path: home/text
;@ def TextCommand_PAUSE(dest: bc, text, saved) -> bc
;@ TX_PAUSE: wait half a second, unless A or B is held.
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
TextCommand_PAUSE::
; wait for button press or 30 frames
;> # (dest kept on the stack)
	push bc
;> Joypad()
	call Joypad
;> if not hJoyHeld & (PAD_A | PAD_B):
	ldh a, [hJoyHeld]
	and PAD_A | PAD_B
	jr nz, .done
;>     DelayFrames(30)
	ld c, 30 ; half a second
	call DelayFrames
.done
;> # (dest comes back off the stack)
	pop bc
;> return NextTextCommand(text, dest, saved)   # (text comes off the stack)
	pop hl
	jp NextTextCommand

;@ path: home/text
;@ def TextCommand_SOUND(dest: bc, text, saved) -> bc
;@ The sound commands (TX_SOUND_*): play the sound TextCommandSounds pairs with this command and wait for it to
;@ end. Three of them are Pokémon cries.
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
TextCommand_SOUND::
; play a sound effect from TextCommandSounds
;> cmd = mem[text - 1]                 # the command byte
	pop hl
	push bc
	dec hl
	ld a, [hli]
	ld b, a ; b = text command number that got us here
	push hl
;> i = 0
;>@look while mem[TextCommandSounds + 2 * i] != cmd:   # look the command up
	ld hl, TextCommandSounds
.loop
	ld a, [hli]
	cp b
	jr z, .play
;>     i += 1
	inc hl
;=@look
	jr .loop

.play
;> sound = mem[TextCommandSounds + 2 * i + 1]
;> if cmd not in (TX_SOUND_CRY_NIDORINA, TX_SOUND_CRY_PIDGEOT, TX_SOUND_CRY_DEWGONG):
	cp TX_SOUND_CRY_NIDORINA
	jr z, .pokemonCry
	cp TX_SOUND_CRY_PIDGEOT
	jr z, .pokemonCry
	cp TX_SOUND_CRY_DEWGONG
	jr z, .pokemonCry
;>     PlaySound(sound)
	ld a, [hl]
	call PlaySound
;>     WaitForSoundToFinish()
	call WaitForSoundToFinish
;>     return NextTextCommand(text, dest, saved)
	pop hl
	pop bc
	jp NextTextCommand

.pokemonCry
;> else:                               # a Pokémon cry
;>     PlayCry(sound)
	push de
	ld a, [hl]
	call PlayCry
	pop de
;>     return NextTextCommand(text, dest, saved)
	pop hl
	pop bc
	jp NextTextCommand

;@ path: home/text
TextCommandSounds::
	db TX_SOUND_GET_ITEM_1,           SFX_GET_ITEM_1 ; actually plays SFX_LEVEL_UP when the battle music engine is loaded
	db TX_SOUND_CAUGHT_MON,           SFX_CAUGHT_MON
	db TX_SOUND_POKEDEX_RATING,       SFX_POKEDEX_RATING ; unused
	db TX_SOUND_GET_ITEM_1_DUPLICATE, SFX_GET_ITEM_1 ; unused
	db TX_SOUND_GET_ITEM_2,           SFX_GET_ITEM_2
	db TX_SOUND_GET_KEY_ITEM,         SFX_GET_KEY_ITEM
	db TX_SOUND_DEX_PAGE_ADDED,       SFX_DEX_PAGE_ADDED
	db TX_SOUND_CRY_NIDORINA,         NIDORINA ; used in OakSpeech
	db TX_SOUND_CRY_PIDGEOT,          PIDGEOT  ; used in SaffronCityPidgeotText
	db TX_SOUND_CRY_DEWGONG,          DEWGONG  ; unused

;@ path: home/text
;@ def TextCommand_DOTS(dest: bc, text, saved) -> bc
;@ TX_DOTS n: print n '…', each followed by a short wait unless A or B is held.
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
TextCommand_DOTS::
; wait for button press or 30 frames while printing "…"s
;> n = mem[text]
	pop hl
	ld a, [hli]
	ld d, a
	push hl
	ld h, b
	ld l, c

;>@dots for _ in range(n):
;>     mem[dest] = 0x75                # '…'
;>     dest += 1
.loop
	ld a, '…'
	ld [hli], a
;>     Joypad()
	push de
	call Joypad
	pop de
;>     if not hJoyHeld & (PAD_A | PAD_B):   # A or B held: no wait
;>         DelayFrames(10)
	ldh a, [hJoyHeld] ; joypad state
	and PAD_A | PAD_B
	jr nz, .next ; if so, skip the delay
	ld c, 10
	call DelayFrames
.next
;=@dots
	dec d
	jr nz, .loop

;> return NextTextCommand(text + 1, dest, saved)
	ld b, h
	ld c, l
	pop hl
	jp NextTextCommand

;@ path: home/text
;@ def TextCommand_WAIT_BUTTON(dest: bc, text, saved) -> bc
;@ TX_WAIT_BUTTON: wait for A or B, without an arrow.
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
TextCommand_WAIT_BUTTON::
; wait for button press; don't show arrow
;> ManualTextScroll()
;> return NextTextCommand(text, dest, saved)
	push bc
	call ManualTextScroll
	pop bc
	pop hl
	jp NextTextCommand

;@ path: home/text
;@ def TextCommand_FAR(dest: bc, text, saved) -> bc
;@ TX_FAR address, bank: run a text that lives in another bank (most texts do), then switch back.
;@ test: skip goes on with values TextCommandProcessor keeps on the stack
TextCommand_FAR::
; write text from a different bank (little endian)
;> old = hLoadedROMBank
	pop hl
	ldh a, [hLoadedROMBank]
	push af

;> far = mem16[text]
;> bank = mem[text + 2]
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]

;> hLoadedROMBank = bank
;> set_rom_bank(bank)
	ldh [hLoadedROMBank], a
	ld [rROMB], a

;> dest = TextCommandProcessor(far, dest)
	push hl
	ld l, e
	ld h, d
	call TextCommandProcessor
	pop hl

;> hLoadedROMBank = old
;> set_rom_bank(old)
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
;> return NextTextCommand(text + 3, dest, saved)
	jp NextTextCommand

;@ path: home/text
TextCommandJumpTable::
; entries correspond to TX_* constants (see macros/scripts/text.asm)
	dw TextCommand_START         ; TX_START
	dw TextCommand_RAM           ; TX_RAM
	dw TextCommand_BCD           ; TX_BCD
	dw TextCommand_MOVE          ; TX_MOVE
	dw TextCommand_BOX           ; TX_BOX
	dw TextCommand_LOW           ; TX_LOW
	dw TextCommand_PROMPT_BUTTON ; TX_PROMPT_BUTTON
	dw TextCommand_SCROLL        ; TX_SCROLL
	dw TextCommand_START_ASM     ; TX_START_ASM
	dw TextCommand_NUM           ; TX_NUM
	dw TextCommand_PAUSE         ; TX_PAUSE
	dw TextCommand_SOUND         ; TX_SOUND_GET_ITEM_1 (also handles other TX_SOUND_* commands)
	dw TextCommand_DOTS          ; TX_DOTS
	dw TextCommand_WAIT_BUTTON   ; TX_WAIT_BUTTON
	; greater TX_* constants are handled directly by NextTextCommand
; this function seems to be used only once
; it store the address of a row and column of the VRAM background map in hl
; INPUT: h - row, l - column, b - high byte of background tile map address in VRAM
;@ path: home/vcopy
;@ def GetRowColAddressBgMap(row: h, col: l, base: b) -> hl
;@ The address of (col, row) in the BG map starting at base * $100 (32 tiles per row).
GetRowColAddressBgMap::
;> low = 0
	xor a
;> low = (row & 7) << 5                # 32 tiles a row: the row's low 3 bits go into the low byte
;> row >>= 3
	srl h
	rr a
	srl h
	rr a
	srl h
	rr a
;> low |= col
	or l
	ld l, a
;> return (base | row) << 8 | low
	ld a, b
	or h
	ld h, a
	ret

; clears a VRAM background map with blank space tiles
; INPUT: h - high byte of background tile map address in VRAM
;@ path: home/vcopy
;@ def ClearBgMap(high: h)
;@ Fill the 32 x 32 BG map at high * $100 with spaces.
;@ test: high = rand(0x98, 0xDA)
ClearBgMap::
;> FillBgMapCommon(high, 0x7F)
	ld a, ' '
	jr FillBgMapCommon

; fills a VRAM background map with tile index in register l
; INPUT: h - high byte of background tile map address in VRAM
;@ path: home/vcopy
;@ def FillBgMap(high: h, tile: l)
;@ Fill the 32 x 32 BG map at high * $100 with `tile`.
;@ test: high = rand(0x98, 0xDA)
FillBgMap:: ; unreferenced
;> FillBgMapCommon(high, tile)
	ld a, l

;@ path: home/vcopy
;@ def FillBgMapCommon(high: h, tile: a)
;@ Fill the TILEMAP_AREA bytes from high * $100 with `tile`.
;@ test: high = rand(0x98, 0xDA)
FillBgMapCommon:
;>@f fill(high << 8, tile, TILEMAP_AREA)
	ld de, TILEMAP_AREA
	ld l, e
.loop
;=@f
	ld [hli], a
	dec e
	jr nz, .loop
	dec d
	jr nz, .loop
	ret

; This function redraws a BG row of height 2 or a BG column of width 2.
; One of its main uses is redrawing the row or column that will be exposed upon
; scrolling the BG when the player takes a step. Redrawing only the exposed
; row or column is more efficient than redrawing the entire screen.
; However, this function is also called repeatedly to redraw the whole screen
; when necessary. It is also used in trade animation and elevator code.
;@ path: home/vcopy
;@ def RedrawRowOrColumn()
;@ While walking, draw the newly visible strip of the map into the BG map in VBlank: a column (mode 1) of
;@ 2 x 18 tiles or a row (mode 2) of 20 x 2 tiles from wRedrawRowOrColumnSrcTiles, at hRedrawRowOrColumnDest.
;@ The column wraps from the bottom of the BG map to the top, the row from the right edge to the left.
;@ test: hRedrawRowOrColumnMode = rand(0, 3); d = rand(0x9800, 0x9BFE); mem[hRedrawRowOrColumnDest] = d & 0xFF; mem[hRedrawRowOrColumnDest + 1] = d >> 8
RedrawRowOrColumn::
;> mode = hRedrawRowOrColumnMode
	ldh a, [hRedrawRowOrColumnMode]
;> if not mode:
;>     return
	and a
	ret z
;> hRedrawRowOrColumnMode = 0
	ld b, a
	xor a
	ldh [hRedrawRowOrColumnMode], a
;> src = 0
;> if mode == 1:                       # a column
	dec b
	jr nz, .redrawRow
.redrawColumn
;>     dest = hRedrawRowOrColumnDest[0] | hRedrawRowOrColumnDest[1] << 8
	ld hl, wRedrawRowOrColumnSrcTiles
	ldh a, [hRedrawRowOrColumnDest]
	ld e, a
	ldh a, [hRedrawRowOrColumnDest + 1]
	ld d, a
;>@col     for _ in range(SCREEN_HEIGHT):
	ld c, SCREEN_HEIGHT
.loop1
;>         mem[dest] = wRedrawRowOrColumnSrcTiles[src]
	ld a, [hli]
	ld [de], a
;>         dest += 1
	inc de
;>         mem[dest] = wRedrawRowOrColumnSrcTiles[src + 1]
;>         src += 2
	ld a, [hli]
	ld [de], a
;>         dest += TILEMAP_WIDTH - 1   # the next row
	ld a, TILEMAP_WIDTH - 1
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
; the following 4 lines wrap us from bottom to top if necessary
;>         dest = vBGMap0 | dest & (TILEMAP_AREA - 1)   # round from the bottom to the top
	ld a, d
	and HIGH(TILEMAP_AREA - 1)
	or HIGH(vBGMap0)
	ld d, a
;=@col
	dec c
	jr nz, .loop1
;>     hRedrawRowOrColumnMode = 0
;>     return
	xor a
	ldh [hRedrawRowOrColumnMode], a
	ret
.redrawRow
;> else:                               # a row
;>     dest = hRedrawRowOrColumnDest[0] | hRedrawRowOrColumnDest[1] << 8
	ld hl, wRedrawRowOrColumnSrcTiles
	ldh a, [hRedrawRowOrColumnDest]
	ld e, a
	ldh a, [hRedrawRowOrColumnDest + 1]
	ld d, a
;>     for start in (dest, dest & 0xFF00 | (dest + TILEMAP_WIDTH) & 0xFF):   # the upper half, then the lower (no carry)
	push de
	call .DrawHalf ; draw upper half
	pop de
	ld a, TILEMAP_WIDTH
	add e
	ld e, a
	; fall through and draw lower half

.DrawHalf
;>         d = start
;>@half         for _ in range(SCREEN_WIDTH // 2):
	ld c, SCREEN_WIDTH / 2
.loop2
;>             mem[d] = wRedrawRowOrColumnSrcTiles[src]
	ld a, [hli]
	ld [de], a
;>             d = (d + 1) & 0xFFFF
	inc de
;>             mem[d] = wRedrawRowOrColumnSrcTiles[src + 1]
;>             src += 2
	ld a, [hli]
	ld [de], a
;>             col = (d + 1) & 0x1F    # the next tile
	ld a, e
	inc a
; the following 6 lines wrap us from the right edge to the left edge if necessary
	and %11111
	ld b, a
;>             d = d & 0xFFE0 | col    # round from the right edge to the left
	ld a, e
	and %11100000
	or b
	ld e, a
;=@half
	dec c
	jr nz, .loop2
	ret

; This function automatically transfers tile number data from the tile map at
; wTileMap to VRAM during V-blank. Note that it only transfers one third of the
; background per V-blank. It cycles through which third it draws.
; This transfer is turned off when walking around the map, but is turned
; on when talking to sprites, battling, using menus, etc. This is because
; the above function, RedrawRowOrColumn, is used when walking to
; improve efficiency.
;@ path: home/vcopy
;@ def AutoBgMapTransfer()
;@ In VBlank, copy a third of the screen buffer wTileMap (six rows) to the BG map at hAutoBGTransferDest,
;@ the next third every frame. Reads the tiles with the stack pointer for speed.
;@ test: skip copies with the stack pointer
AutoBgMapTransfer::
;> if not hAutoBGTransferEnabled:
;>     return
	ldh a, [hAutoBGTransferEnabled]
	and a
	ret z
;> # the stack pointer is kept in hSPTemp: the tiles are read with it
	ld hl, sp + 0
	ld a, h
	ldh [hSPTemp], a
	ld a, l
	ldh [hSPTemp + 1], a ; save stack pointer
;> portion = hAutoBGTransferPortion
	ldh a, [hAutoBGTransferPortion]
;> if portion == TRANSFERTOP:
	and a
	jr z, .transferTopThird
;>@t1     src = coord(0, 0)               # read with the stack pointer
;>@t2     dest = hAutoBGTransferDest[0] | hAutoBGTransferDest[1] << 8
;>@t3     nxt = TRANSFERMIDDLE
;> elif portion == TRANSFERMIDDLE:
	dec a
	jr z, .transferMiddleThird
;>@m1     src = coord(0, SCREEN_HEIGHT // 3)
;>@m2     dest = hAutoBGTransferDest[0] | hAutoBGTransferDest[1] << 8
;>@m3     dest += 6 * TILEMAP_WIDTH
;>@m4     nxt = TRANSFERBOTTOM
.transferBottomThird
;> else:
;>     src = coord(0, 2 * SCREEN_HEIGHT // 3)
	ld hl, (2 * SCREEN_HEIGHT / 3) * SCREEN_WIDTH + (0) + wTileMap
	ld sp, hl
;>     dest = hAutoBGTransferDest[0] | hAutoBGTransferDest[1] << 8
	ldh a, [hAutoBGTransferDest + 1]
	ld h, a
	ldh a, [hAutoBGTransferDest]
	ld l, a
;>     dest += 12 * TILEMAP_WIDTH
	ld de, 12 * TILEMAP_WIDTH
	add hl, de
;>     nxt = TRANSFERTOP
	xor a ; TRANSFERTOP
	jr .doTransfer
.transferTopThird
;=@t1
	ld hl, (0) * SCREEN_WIDTH + (0) + wTileMap
	ld sp, hl
;=@t2
	ldh a, [hAutoBGTransferDest + 1]
	ld h, a
	ldh a, [hAutoBGTransferDest]
	ld l, a
;=@t3
	ld a, TRANSFERMIDDLE
	jr .doTransfer
.transferMiddleThird
;=@m1
	ld hl, (SCREEN_HEIGHT / 3) * SCREEN_WIDTH + (0) + wTileMap
	ld sp, hl
;=@m2
	ldh a, [hAutoBGTransferDest + 1]
	ld h, a
	ldh a, [hAutoBGTransferDest]
	ld l, a
;=@m3
	ld de, 6 * TILEMAP_WIDTH
	add hl, de
;=@m4
	ld a, TRANSFERBOTTOM
.doTransfer
;> hAutoBGTransferPortion = nxt
	ldh [hAutoBGTransferPortion], a ; store next portion
;> TransferBgRows(src, dest, SCREEN_HEIGHT // 3)   # it follows right below
	ld b, SCREEN_HEIGHT / 3

;@ path: home/vcopy
;@ def TransferBgRows(src, dest: hl, rows: b)
;@ Copy `rows` rows of 20 tiles from src (which the stack pointer points at: the tiles are read with pop)
;@ to the BG map at dest, 32 tiles per row there; then put the stack pointer back from hSPTemp.
;@ test: skip copies with the stack pointer
TransferBgRows::
; unrolled loop and using pop for speed
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
	ld [hl], e
	inc l
	ld [hl], d

	ld a, TILEMAP_WIDTH - (SCREEN_WIDTH - 1)
	add l
	ld l, a
	jr nc, .ok
	inc h
.ok
	dec b
	jr nz, TransferBgRows

	ldh a, [hSPTemp]
	ld h, a
	ldh a, [hSPTemp + 1]
	ld l, a
	ld sp, hl
	ret

; Copies [hVBlankCopyBGNumRows] rows from hVBlankCopyBGSource to hVBlankCopyBGDest.
; If hVBlankCopyBGSource is XX00, the transfer is disabled.
;@ path: home/vcopy
;@ def VBlankCopyBgMap()
;@ In VBlank, copy hVBlankCopyBGNumRows rows from hVBlankCopyBGSource to the BG map at hVBlankCopyBGDest,
;@ once: a source with low byte 0 means nothing to do, and the low byte is cleared afterwards.
;@ test: skip copies with the stack pointer
VBlankCopyBgMap::
;> if not hVBlankCopyBGSource[0]:
;>     return
	ldh a, [hVBlankCopyBGSource] ; doubles as enabling byte
	and a
	ret z
;> # the stack pointer is kept in hSPTemp: the source is read with it
	ld hl, sp + 0
	ld a, h
	ldh [hSPTemp], a
	ld a, l
	ldh [hSPTemp + 1], a ; save stack pointer
;> src = hVBlankCopyBGSource[0] | hVBlankCopyBGSource[1] << 8
	ldh a, [hVBlankCopyBGSource]
	ld l, a
	ldh a, [hVBlankCopyBGSource + 1]
	ld h, a
	ld sp, hl
;> dest = hVBlankCopyBGDest[0] | hVBlankCopyBGDest[1] << 8
	ldh a, [hVBlankCopyBGDest]
	ld l, a
	ldh a, [hVBlankCopyBGDest + 1]
	ld h, a
;> rows = hVBlankCopyBGNumRows
	ldh a, [hVBlankCopyBGNumRows]
	ld b, a
;> hVBlankCopyBGSource[0] = 0
	xor a
	ldh [hVBlankCopyBGSource], a ; disable transfer so it doesn't continue next V-blank
;> TransferBgRows(src, dest, rows)
	jr TransferBgRows


;@ path: home/vcopy
;@ def VBlankCopyDouble()
;@ In VBlank, copy hVBlankCopyDoubleSize 1-bit-per-pixel tiles from hVBlankCopyDoubleSource to
;@ hVBlankCopyDoubleDest, writing every byte twice to make 2 bits per pixel. Both addresses move on, so the
;@ next frame can continue.
;@ test: skip copies with the stack pointer
VBlankCopyDouble::
; Copy [hVBlankCopyDoubleSize] 1bpp tiles
; from hVBlankCopyDoubleSource to hVBlankCopyDoubleDest.

; While we're here, convert to 2bpp.
; The process is straightforward:
; copy each byte twice.

;> n = hVBlankCopyDoubleSize
	ldh a, [hVBlankCopyDoubleSize]
;> if not n:
;>     return
	and a
	ret z

;> # the stack pointer is kept in hSPTemp: the source is read with it
	ld hl, sp + 0
	ld a, h
	ldh [hSPTemp], a
	ld a, l
	ldh [hSPTemp + 1], a

;> src = hVBlankCopyDoubleSource[0] | hVBlankCopyDoubleSource[1] << 8
	ldh a, [hVBlankCopyDoubleSource]
	ld l, a
	ldh a, [hVBlankCopyDoubleSource + 1]
	ld h, a
	ld sp, hl

;> dest = hVBlankCopyDoubleDest[0] | hVBlankCopyDoubleDest[1] << 8
	ldh a, [hVBlankCopyDoubleDest]
	ld l, a
	ldh a, [hVBlankCopyDoubleDest + 1]
	ld h, a

;> hVBlankCopyDoubleSize = 0           # done
	ldh a, [hVBlankCopyDoubleSize]
	ld b, a
	xor a ; transferred
	ldh [hVBlankCopyDoubleSize], a

;>@tiles for _ in range(4 * n):        # 8 bytes make a tile; the loop is written out 4 times per tile
;>@rd     x, y, src = mem[src], mem[src + 1], src + 2   # two pixel rows, read off the stack
.loop
	pop de
;>@wx     mem[dest] = mem[dest + 1] = x   # each byte twice: 2 bits per pixel
	ld [hl], e
	inc l
	ld [hl], e
	inc l
;>@wy     mem[dest + 2] = mem[dest + 3] = y
	ld [hl], d
	inc l
	ld [hl], d
;>@nx     dest += 4
	inc l
;=@rd
	pop de
;=@wx
	ld [hl], e
	inc l
	ld [hl], e
	inc l
;=@wy
	ld [hl], d
	inc l
	ld [hl], d
;=@nx
	inc l
;=@rd
	pop de
;=@wx
	ld [hl], e
	inc l
	ld [hl], e
	inc l
;=@wy
	ld [hl], d
	inc l
	ld [hl], d
;=@nx
	inc l
;=@rd
	pop de
;=@wx
	ld [hl], e
	inc l
	ld [hl], e
	inc l
;=@wy
	ld [hl], d
	inc l
	ld [hl], d
;=@nx
	inc hl
;=@tiles
	dec b
	jr nz, .loop

;> hVBlankCopyDoubleDest[0] = lo(dest)
	ld a, l
	ldh [hVBlankCopyDoubleDest], a
;> hVBlankCopyDoubleDest[1] = hi(dest)
	ld a, h
	ldh [hVBlankCopyDoubleDest + 1], a

;> hVBlankCopyDoubleSource[0] = lo(src)
	ld hl, sp + 0
	ld a, l
	ldh [hVBlankCopyDoubleSource], a
;> hVBlankCopyDoubleSource[1] = hi(src)
	ld a, h
	ldh [hVBlankCopyDoubleSource + 1], a

;> # the stack pointer back from hSPTemp
	ldh a, [hSPTemp]
	ld h, a
	ldh a, [hSPTemp + 1]
	ld l, a
	ld sp, hl

	ret


;@ path: home/vcopy
;@ def VBlankCopy()
;@ In VBlank, copy hVBlankCopySize 2-bit-per-pixel tiles from hVBlankCopySource to hVBlankCopyDest. Both
;@ addresses move on, so the next frame can continue.
;@ test: skip copies with the stack pointer
VBlankCopy::
; Copy [hVBlankCopySize] 2bpp tiles (or 16 * [hVBlankCopySize] tile map entries)
; from hVBlankCopySource to hVBlankCopyDest.

; Source and destination addresses are updated,
; so transfer can continue in subsequent calls.

;> n = hVBlankCopySize
	ldh a, [hVBlankCopySize]
;> if not n:
;>     return
	and a
	ret z

;> # the stack pointer is kept in hSPTemp: the source is read with it
	ld hl, sp + 0
	ld a, h
	ldh [hSPTemp], a
	ld a, l
	ldh [hSPTemp + 1], a

;> src = hVBlankCopySource[0] | hVBlankCopySource[1] << 8
	ldh a, [hVBlankCopySource]
	ld l, a
	ldh a, [hVBlankCopySource + 1]
	ld h, a
	ld sp, hl

;> dest = hVBlankCopyDest[0] | hVBlankCopyDest[1] << 8
	ldh a, [hVBlankCopyDest]
	ld l, a
	ldh a, [hVBlankCopyDest + 1]
	ld h, a

;> hVBlankCopySize = 0                 # done
	ldh a, [hVBlankCopySize]
	ld b, a
	xor a ; transferred
	ldh [hVBlankCopySize], a

;>@tiles for _ in range(8 * n):        # 16 bytes a tile; the loop is written out 8 times per tile
;>@rd     x, y, src = mem[src], mem[src + 1], src + 2   # read off the stack
.loop
	pop de
;>@wr     mem[dest], mem[dest + 1] = x, y
	ld [hl], e
	inc l
	ld [hl], d
;>@nx     dest += 2
	inc l
;=@rd
	pop de
;=@wr
	ld [hl], e
	inc l
	ld [hl], d
;=@nx
	inc l
;=@rd
	pop de
;=@wr
	ld [hl], e
	inc l
	ld [hl], d
;=@nx
	inc l
;=@rd
	pop de
;=@wr
	ld [hl], e
	inc l
	ld [hl], d
;=@nx
	inc l
;=@rd
	pop de
;=@wr
	ld [hl], e
	inc l
	ld [hl], d
;=@nx
	inc l
;=@rd
	pop de
;=@wr
	ld [hl], e
	inc l
	ld [hl], d
;=@nx
	inc l
;=@rd
	pop de
;=@wr
	ld [hl], e
	inc l
	ld [hl], d
;=@nx
	inc l
;=@rd
	pop de
;=@wr
	ld [hl], e
	inc l
	ld [hl], d
;=@nx
	inc hl
;=@tiles
	dec b
	jr nz, .loop

;> hVBlankCopyDest[0] = lo(dest)
	ld a, l
	ldh [hVBlankCopyDest], a
;> hVBlankCopyDest[1] = hi(dest)
	ld a, h
	ldh [hVBlankCopyDest + 1], a

;> hVBlankCopySource[0] = lo(src)
	ld hl, sp + 0
	ld a, l
	ldh [hVBlankCopySource], a
;> hVBlankCopySource[1] = hi(src)
	ld a, h
	ldh [hVBlankCopySource + 1], a

;> # the stack pointer back from hSPTemp
	ldh a, [hSPTemp]
	ld h, a
	ldh a, [hSPTemp + 1]
	ld l, a
	ld sp, hl

	ret


;@ path: home/vcopy
;@ def UpdateMovingBgTiles()
;@ Animate the overworld's water and flowers. Every 20 frames the water tile ($14) shifts its pixels one
;@ step (right four times, then left four times); with flowers, the frame after that shows the next of the
;@ flower pictures in tile $03.
UpdateMovingBgTiles::
; Animate water and flower
; tiles in the overworld.

;> if not hTileAnimations:
;>     return
	ldh a, [hTileAnimations]
	and a
	ret z

;> hMovingBGTilesCounter1 = u8(hMovingBGTilesCounter1 + 1)
	ldh a, [hMovingBGTilesCounter1]
	inc a
	ldh [hMovingBGTilesCounter1], a
;> if hMovingBGTilesCounter1 < 20:
;>     return
	cp 20
	ret c
;> if hMovingBGTilesCounter1 != 21:    # frame 20: the water
	cp 21
	jr z, .flower

; water

;>     water = vTileset + 0x14 * TILE_SIZE
	ld hl, vTileset + TILE_SIZE * $14
	ld c, TILE_SIZE

;>     wMovingBGTilesCounter2 = (wMovingBGTilesCounter2 + 1) & 7
	ld a, [wMovingBGTilesCounter2]
	inc a
	and 7
	ld [wMovingBGTilesCounter2], a

;>     if not wMovingBGTilesCounter2 & 4:
	and 4
	jr nz, .left
;>         for i in range(TILE_SIZE):  # one pixel right, round
;>             mem[water + i] = (mem[water + i] >> 1 | mem[water + i] << 7) & 0xFF
.right
	ld a, [hl]
	rrca
	ld [hli], a
	dec c
	jr nz, .right
	jr .done
.left
;>     else:
;>         for i in range(TILE_SIZE):  # one pixel left, round
;>             mem[water + i] = (mem[water + i] << 1 | mem[water + i] >> 7) & 0xFF
	ld a, [hl]
	rlca
	ld [hli], a
	dec c
	jr nz, .left
.done
;>     if hTileAnimations & 1:         # water only: start over now (otherwise the flowers come next frame)
	ldh a, [hTileAnimations]
	rrca
	ret nc

;>         hMovingBGTilesCounter1 = 0
	xor a
	ldh [hMovingBGTilesCounter1], a
	ret

.flower
;> else:                               # frame 21: the flowers' next picture
;>     hMovingBGTilesCounter1 = 0
	xor a
	ldh [hMovingBGTilesCounter1], a

;>     phase = wMovingBGTilesCounter2 & 3
	ld a, [wMovingBGTilesCounter2]
	and 3
	cp 2
;>     tile = FlowerTile1 if phase < 2 else FlowerTile2 if phase == 2 else FlowerTile3
	ld hl, FlowerTile1
	jr c, .copy
	ld hl, FlowerTile2
	jr z, .copy
	ld hl, FlowerTile3
.copy
;>@cp     copy(vTileset + 0x03 * TILE_SIZE, tile, TILE_SIZE)
	ld de, vTileset + TILE_SIZE * $03
	ld c, TILE_SIZE
.loop
;=@cp
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

;@ path: home/vcopy
FlowerTile1:
	db $81, $00, $00, $18, $00, $24, $85, $5a, $1c, $42, $18, $a5, $00, $7e, $81, $18
;@ path: home/vcopy
FlowerTile2:
	db $81, $00, $00, $0c, $00, $12, $82, $2d, $0e, $e1, $0c, $73, $00, $3e, $81, $18
;@ path: home/vcopy
FlowerTile3:
	db $81, $18, $00, $24, $04, $5a, $9d, $42, $18, $24, $00, $db, $00, $7e, $81, $18
;@ path: home/init
;@ def SoftReset()
;@ Restart the game (A + B + Start + Select): silence, white palettes, half a second, then Init.
;@ test: skip goes on into Init and never returns
SoftReset::
;> StopAllSounds()
	call StopAllSounds
;> GBPalWhiteOut()
	call GBPalWhiteOut
;> DelayFrames(32)
	ld c, 32
	call DelayFrames
;> Init()
	; fallthrough

;@ path: home/init
;@ def Init()
;@ Start the game from scratch: every I/O register, all of WRAM, VRAM and HRAM cleared, the OAM DMA
;@ routine copied to HRAM, interrupts on, the Super Game Boy set up, then the intro and the title screen.
;@ test: skip resets the stack, plays the intro and never returns
Init::
;  Program init.
;> disable_interrupts()
	di

;> rIF = rIE = rSCX = rSCY = 0
	xor a
	ldh [rIF], a
	ldh [rIE], a
	ldh [rSCX], a
	ldh [rSCY], a
;> rSB = rSC = rWX = rWY = 0
	ldh [rSB], a
	ldh [rSC], a
	ldh [rWX], a
	ldh [rWY], a
;> rTMA = rTAC = rBGP = rOBP0 = rOBP1 = 0
	ldh [rTMA], a
	ldh [rTAC], a
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a

;> rLCDC = LCDC_ON
	ld a, LCDC_ON
	ldh [rLCDC], a
;> DisableLCD()
	call DisableLCD

;> reset_stack(wStack)
	ld sp, wStack

;>@w fill(0xC000, 0, 0x2000)           # all of WRAM
	ld hl, STARTOF(WRAM0)
	ld bc, SIZEOF(WRAM0)
.loop
;=@w
	ld [hl], 0
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .loop

;> ClearVram()
	call ClearVram

;> FillMemory(0xFF80, 0x7F, 0)         # all of HRAM
	ld hl, STARTOF(HRAM)
	ld bc, SIZEOF(HRAM)
	call FillMemory

;> ClearSprites()
	call ClearSprites

;> hLoadedROMBank = BANK(WriteDMACodeToHRAM)
	ld a, BANK(WriteDMACodeToHRAM)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(WriteDMACodeToHRAM))
	ld [rROMB], a
;> WriteDMACodeToHRAM()                # the OAM DMA routine
	call WriteDMACodeToHRAM

;> hTileAnimations = rSTAT = hSCX = hSCY = rIF = 0
	xor a
	ldh [hTileAnimations], a
	ldh [rSTAT], a
	ldh [hSCX], a
	ldh [hSCY], a
	ldh [rIF], a
;> rIE = IE_VBLANK | IE_TIMER | IE_SERIAL
	ld a, IE_VBLANK | IE_TIMER | IE_SERIAL
	ldh [rIE], a

;> hWY = rWY = 144                     # the window below the screen
	ld a, 144 ; move the window off-screen
	ldh [hWY], a
	ldh [rWY], a
;> rWX = 7
	ld a, 7
	ldh [rWX], a

;> hSerialConnectionStatus = CONNECTION_NOT_ESTABLISHED
	ld a, CONNECTION_NOT_ESTABLISHED
	ldh [hSerialConnectionStatus], a

;> ClearBgMap(hi(vBGMap0))
	ld h, HIGH(vBGMap0)
	call ClearBgMap
;> ClearBgMap(hi(vBGMap1))
	ld h, HIGH(vBGMap1)
	call ClearBgMap

;> rLCDC = LCDC_DEFAULT
	ld a, LCDC_DEFAULT
	ldh [rLCDC], a
;> hSoftReset = 16
	ld a, 16
	ldh [hSoftReset], a
;> StopAllSounds()
	call StopAllSounds

;> enable_interrupts()
	ei

;> LoadSGB()
	ld a, (LoadSGBPredef - PredefPointers) / 3
	call Predef

;> wAudioROMBank = wAudioSavedROMBank = BANK(SFX_Shooting_Star)
	ld a, BANK(SFX_Shooting_Star)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
;> hAutoBGTransferDest[1] = hi(vBGMap1)
	ld a, HIGH(vBGMap1)
	ldh [hAutoBGTransferDest + 1], a
;> hAutoBGTransferDest[0] = 0
	xor a
	ldh [hAutoBGTransferDest], a
;> wUpdateSpritesEnabled = 0xFF
	dec a
	ld [wUpdateSpritesEnabled], a

;> PlayIntro()
	ld a, (PlayIntroPredef - PredefPointers) / 3
	call Predef

;> DisableLCD()
	call DisableLCD
;> ClearVram()
	call ClearVram
;> GBPalNormal()
	call GBPalNormal
;> ClearSprites()
	call ClearSprites
;> rLCDC = LCDC_DEFAULT
	ld a, LCDC_DEFAULT
	ldh [rLCDC], a

;> PrepareTitleScreen()
	jp PrepareTitleScreen

;@ path: home/init
;@ def ClearVram()
;@ Zero all 8 KiB of VRAM.
ClearVram::
;> FillMemory(0x8000, 0x2000, 0)
	ld hl, STARTOF(VRAM)
	ld bc, SIZEOF(VRAM)
	xor a
	jp FillMemory


;@ path: home/init
;@ def StopAllSounds()
;@ Silence everything: the first audio engine's bank, no fade-out, no new or last music, then sound $FF
;@ (stop all) through PlaySound.
StopAllSounds::
;> wAudioROMBank = BANK(Audio1_UpdateMusic)    # the "Audio Engine 1" bank
	ld a, BANK("Audio Engine 1")
	ld [wAudioROMBank], a
;> wAudioSavedROMBank = BANK(Audio1_UpdateMusic)
	ld [wAudioSavedROMBank], a
;> wAudioFadeOutControl = 0
	xor a
	ld [wAudioFadeOutControl], a
;> wNewSoundID = 0
	ld [wNewSoundID], a
;> wLastMusicSoundID = 0
	ld [wLastMusicSoundID], a
;> PlaySound(0xFF)
	dec a
	jp PlaySound
;@ path: home/vblank
;@ def VBlank()
;@ The VBlank interrupt, once per frame: scroll and window registers, the BG map and tile copies queued
;@ during the frame, the sprites (OAM DMA), the random numbers, the frame counter, the music, the play
;@ time and the joypad. It switches banks freely and puts the interrupted code's bank back at the end.
;@ test: skip the interrupt handler: hardware, DMA and the whole sound engine
VBlank::

;> # (the registers are saved on the stack)
	push af
	push bc
	push de
	push hl

;> wVBlankSavedROMBank = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	ld [wVBlankSavedROMBank], a

;> rSCX = hSCX
	ldh a, [hSCX]
	ldh [rSCX], a
;> rSCY = hSCY
	ldh a, [hSCY]
	ldh [rSCY], a

;> if not wDisableVBlankWYUpdate:
	ld a, [wDisableVBlankWYUpdate]
	and a
	jr nz, .ok
;>     rWY = hWY
	ldh a, [hWY]
	ldh [rWY], a
.ok

;> AutoBgMapTransfer()
	call AutoBgMapTransfer
;> VBlankCopyBgMap()
	call VBlankCopyBgMap
;> RedrawRowOrColumn()
	call RedrawRowOrColumn
;> VBlankCopy()
	call VBlankCopy
;> VBlankCopyDouble()
	call VBlankCopyDouble
;> UpdateMovingBgTiles()
	call UpdateMovingBgTiles
;> hDMARoutine()                       # the sprites to OAM
	call hDMARoutine
;> hLoadedROMBank = BANK(PrepareOAMData)
	ld a, BANK(PrepareOAMData)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(PrepareOAMData))
	ld [rROMB], a
;> PrepareOAMData()
	call PrepareOAMData

	; VBlank-sensitive operations end.

;> Random()
	call Random

;> if hVBlankOccurred:
	ldh a, [hVBlankOccurred]
	and a
	jr z, .skipZeroing
;>     hVBlankOccurred = 0             # tells DelayFrame the frame is over
	xor a
	ldh [hVBlankOccurred], a

.skipZeroing
;> if hFrameCounter:
	ldh a, [hFrameCounter]
	and a
	jr z, .skipDec
;>     hFrameCounter -= 1
	dec a
	ldh [hFrameCounter], a

.skipDec
;> FadeOutAudio()
	call FadeOutAudio

;> bank = wAudioROMBank
;> hLoadedROMBank = bank
	ld a, [wAudioROMBank] ; music ROM bank
	ldh [hLoadedROMBank], a
;> set_rom_bank(bank)
	ld [rROMB], a

;> if bank == BANK(Audio1_UpdateMusic):
	cp BANK(Audio1_UpdateMusic)
	jr nz, .checkForAudio2
.audio1
;>     Audio1_UpdateMusic()
	call Audio1_UpdateMusic
	jr .afterMusic
.checkForAudio2
;> elif bank == BANK(Audio2_UpdateMusic):
	cp BANK(Audio2_UpdateMusic)
	jr nz, .audio3
.audio2
;>     Music_DoLowHealthAlarm()
	call Music_DoLowHealthAlarm
;>     Audio2_UpdateMusic()
	call Audio2_UpdateMusic
	jr .afterMusic
.audio3
;> else:
;>     Audio3_UpdateMusic()
	call Audio3_UpdateMusic
.afterMusic

;> TrackPlayTime()
	; keep track of time played
	ld b, BANK(TrackPlayTime)
	ld hl, TrackPlayTime
	call Bankswitch

;> if not hDisableJoypadPolling:
;>     ReadJoypad()
	ldh a, [hDisableJoypadPolling]
	and a
	call z, ReadJoypad

;> hLoadedROMBank = wVBlankSavedROMBank
	ld a, [wVBlankSavedROMBank]
	ldh [hLoadedROMBank], a
;> set_rom_bank(wVBlankSavedROMBank)
	ld [rROMB], a

;> # (the registers come back off the stack)
	pop hl
	pop de
	pop bc
	pop af
	reti


;@ path: home/vblank
;@ def DelayFrame()
;@ Wait for the next VBlank: mark the frame as not done yet and halt until the VBlank interrupt has
;@ cleared hVBlankOccurred (halting also saves battery).
DelayFrame::
; Wait for the next vblank interrupt.
; As a bonus, this saves battery.

;> hVBlankOccurred = NOT_VBLANKED
DEF NOT_VBLANKED EQU 1

	ld a, NOT_VBLANKED
	ldh [hVBlankOccurred], a
;> wait_vblank_flag()                  # halt until the VBlank interrupt clears it
.halt
	halt
	ldh a, [hVBlankOccurred]
	and a
	jr nz, .halt
	ret
; These routines manage gradual fading
; (e.g., entering a doorway)
;@ path: home/fade
;@ def LoadGBPal()
;@ Set the palettes for the current map: FadePal4, or a darker step before it in dark caves (wMapPalOffset
;@ bytes back).
LoadGBPal::
;> back = wMapPalOffset
	ld a, [wMapPalOffset] ; tells if wCurMap is dark (requires HM5_FLASH?)
	ld b, a
;> pal = FadePal4 - back
	ld hl, FadePal4
	ld a, l
	sub b
	ld l, a
	jr nc, .ok
	dec h
.ok
;> rBGP = mem[pal]
	ld a, [hli]
	ldh [rBGP], a
;> rOBP0 = mem[pal + 1]
	ld a, [hli]
	ldh [rOBP0], a
;> rOBP1 = mem[pal + 2]
	ld a, [hli]
	ldh [rOBP1], a
	ret

;@ path: home/fade
;@ def GBFadeInFromBlack()
;@ Fade the screen in from black: four palette steps, 8 frames each.
GBFadeInFromBlack::
;> GBFadeIncCommon(FadePal1, 4)
	ld hl, FadePal1
	ld b, 4
	jr GBFadeIncCommon

;@ path: home/fade
;@ def GBFadeOutToWhite()
;@ Fade the screen out to white: three palette steps, 8 frames each.
GBFadeOutToWhite::
;> GBFadeIncCommon(FadePal6, 3)
	ld hl, FadePal6
	ld b, 3

;@ path: home/fade
;@ def GBFadeIncCommon(pal: hl, steps: b)
;@ Step forwards through the fade palettes from pal: BGP, OBP0, OBP1 for each step, then 8 frames.
GBFadeIncCommon:
;> for _ in range(steps):
;>     rBGP = mem[pal]
	ld a, [hli]
	ldh [rBGP], a
;>     rOBP0 = mem[pal + 1]
	ld a, [hli]
	ldh [rOBP0], a
;>     rOBP1 = mem[pal + 2]
;>     pal += 3
	ld a, [hli]
	ldh [rOBP1], a
;>     DelayFrames(8)
	ld c, 8
	call DelayFrames
	dec b
	jr nz, GBFadeIncCommon
	ret

;@ path: home/fade
;@ def GBFadeOutToBlack()
;@ Fade the screen out to black: four palette steps back from the normal ones, 8 frames each.
GBFadeOutToBlack::
;> GBFadeDecCommon(FadePal4 + 2, 4)
	ld hl, FadePal4 + 2
	ld b, 4
	jr GBFadeDecCommon

;@ path: home/fade
;@ def GBFadeInFromWhite()
;@ Fade the screen in from white: three palette steps, 8 frames each.
GBFadeInFromWhite::
;> GBFadeDecCommon(FadePal7 + 2, 3)
	ld hl, FadePal7 + 2
	ld b, 3

;@ path: home/fade
;@ def GBFadeDecCommon(pal: hl, steps: b)
;@ Step backwards through the fade palettes: pal points at a step's OBP1 byte, before it OBP0 and BGP.
GBFadeDecCommon:
;> for _ in range(steps):
;>     rOBP1 = mem[pal]
	ld a, [hld]
	ldh [rOBP1], a
;>     rOBP0 = mem[pal - 1]
	ld a, [hld]
	ldh [rOBP0], a
;>     rBGP = mem[pal - 2]
;>     pal -= 3
	ld a, [hld]
	ldh [rBGP], a
;>     DelayFrames(8)
	ld c, 8
	call DelayFrames
	dec b
	jr nz, GBFadeDecCommon
	ret

;@ path: home/fade
FadePal1::
	db ((3) << 6) | ((3) << 4) | ((3) << 2) | (3)
	db ((3) << 6) | ((3) << 4) | ((3) << 2) | (3)
	db ((3) << 6) | ((3) << 4) | ((3) << 2) | (3)
;@ path: home/fade
FadePal2::
	db ((3) << 6) | ((3) << 4) | ((3) << 2) | (2)
	db ((3) << 6) | ((3) << 4) | ((3) << 2) | (2)
	db ((3) << 6) | ((3) << 4) | ((2) << 2) | (0)
;@ path: home/fade
FadePal3::
	db ((3) << 6) | ((3) << 4) | ((2) << 2) | (1)
	db ((3) << 6) | ((2) << 4) | ((1) << 2) | (0)
	db ((3) << 6) | ((2) << 4) | ((1) << 2) | (0)
;@ path: home/fade
FadePal4::
	db ((3) << 6) | ((2) << 4) | ((1) << 2) | (0)
	db ((3) << 6) | ((1) << 4) | ((0) << 2) | (0)
	db ((3) << 6) | ((2) << 4) | ((0) << 2) | (0)
;              rBGP     rOBP0    rOBP1
;@ path: home/fade
FadePal5::
	db ((3) << 6) | ((2) << 4) | ((1) << 2) | (0)
	db ((3) << 6) | ((1) << 4) | ((0) << 2) | (0)
	db ((3) << 6) | ((2) << 4) | ((0) << 2) | (0)
;@ path: home/fade
FadePal6::
	db ((2) << 6) | ((1) << 4) | ((0) << 2) | (0)
	db ((2) << 6) | ((0) << 4) | ((0) << 2) | (0)
	db ((2) << 6) | ((1) << 4) | ((0) << 2) | (0)
;@ path: home/fade
FadePal7::
	db ((1) << 6) | ((0) << 4) | ((0) << 2) | (0)
	db ((1) << 6) | ((0) << 4) | ((0) << 2) | (0)
	db ((1) << 6) | ((0) << 4) | ((0) << 2) | (0)
;@ path: home/fade
FadePal8::
	db ((0) << 6) | ((0) << 4) | ((0) << 2) | (0)
	db ((0) << 6) | ((0) << 4) | ((0) << 2) | (0)
	db ((0) << 6) | ((0) << 4) | ((0) << 2) | (0)
;@ path: home/serial
;@ def Serial()
;@ The serial interrupt: a byte has been exchanged over the link cable. Store the byte received, put the next
;@ byte to send in place (hSerialSendData, then "no data") and flag new data. Before the connection is set
;@ up, the first byte received decides which side drives the clock; the other side waits a moment and
;@ listens for the next transfer.
Serial::
;> # (the registers are saved on the stack)
	push af
	push bc
	push de
	push hl
;> if hSerialConnectionStatus != 0xFF:  # connected
	ldh a, [hSerialConnectionStatus]
	inc a
	jr z, .connectionNotYetEstablished
;>     hSerialReceiveData = rSB
	ldh a, [rSB]
	ldh [hSerialReceiveData], a
;>     rSB = hSerialSendData
	ldh a, [hSerialSendData]
	ldh [rSB], a
;>     if hSerialConnectionStatus != USING_INTERNAL_CLOCK:
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .done
; using external clock
;>         rSC = SC_START | SC_EXTERNAL   # wait for the other side's clock
	ld a, SC_START | SC_EXTERNAL
	ldh [rSC], a
	jr .done
.connectionNotYetEstablished
;> else:
;>     received = rSB
;>     hSerialReceiveData = received
	ldh a, [rSB]
	ldh [hSerialReceiveData], a
;>     hSerialConnectionStatus = received  # the other side's choice decides ours
	ldh [hSerialConnectionStatus], a
;>     if received != USING_INTERNAL_CLOCK:
	cp USING_INTERNAL_CLOCK
	jr z, .usingInternalClock
; using external clock
;>         rSB = 0
	xor a
	ldh [rSB], a
;>         rDIV = 3                    # resets the divider
	ld a, $3
	ldh [rDIV], a
;>         while rDIV & 0x80:
;>             wait_div()
.waitLoop
	ldh a, [rDIV]
	bit 7, a ; wait until rDIV has incremented from $3 to $80 or more
	jr nz, .waitLoop
;>         rSC = SC_START | SC_EXTERNAL
	ld a, SC_START | SC_EXTERNAL
	ldh [rSC], a
	jr .done
.usingInternalClock
;>     else:
;>         rSB = 0
	xor a
	ldh [rSB], a
.done
;> hSerialReceivedNewData = 1
	ld a, $1
	ldh [hSerialReceivedNewData], a
;> hSerialSendData = SERIAL_NO_DATA_BYTE
	ld a, SERIAL_NO_DATA_BYTE
	ldh [hSerialSendData], a
;> # (the registers come back off the stack)
	pop hl
	pop de
	pop bc
	pop af
	reti

; hl = send data
; de = receive data
; bc = length of data
;@ path: home/serial
;@ def Serial_ExchangeBytes(send: hl, receive: de, count: bc)
;@ Exchange `count` bytes with the other Game Boy: send from send, store what comes back at receive. The
;@ first byte is sent again and again until the partner's preamble byte has arrived.
;@ test: skip waits for the other Game Boy
Serial_ExchangeBytes::
;> hSerialIgnoringInitialData = 1
	ld a, 1
	ldh [hSerialIgnoringInitialData], a
;>@lp while True:
.loop
;>     hSerialSendData = mem[send]
	ld a, [hl]
	ldh [hSerialSendData], a
;>     byte = Serial_ExchangeByte(send)
	call Serial_ExchangeByte
;>     # (count kept on the stack, the byte held aside)
	push bc
	ld b, a
;>     send += 1
	inc hl
;>     # (a short pause: 48 counted down)
	ld a, 48
.waitLoop
	dec a
	jr nz, .waitLoop
;>     if hSerialIgnoringInitialData:
	ldh a, [hSerialIgnoringInitialData]
	and a
	ld a, b
	pop bc
	jr z, .storeReceivedByte
;>         send -= 1                   # the first byte again
	dec hl
;>         if byte == SERIAL_PREAMBLE_BYTE:
	cp SERIAL_PREAMBLE_BYTE
	jr nz, .loop
;>             hSerialIgnoringInitialData = 0
	xor a
	ldh [hSerialIgnoringInitialData], a
;>         continue
	jr .loop
.storeReceivedByte
;>     mem[receive] = byte
	ld [de], a
;>     receive += 1
	inc de
;>     count = (count - 1) & 0xFFFF
	dec bc
;>     if not count:
;>         return
	ld a, b
	or c
	jr nz, .loop
	ret

;@ path: home/serial
;@ def Serial_ExchangeByte(send: hl) -> a
;@ Exchange hSerialSendData for a byte from the other Game Boy and return it: start the transfer when this
;@ side drives the clock, then wait for the serial interrupt. Gives up with SERIAL_NO_DATA_BYTE (or $FF
;@ when wUnknownSerialCounter runs out) and then tries again with the byte at send after a frame.
;@ test: skip waits for the other Game Boy
Serial_ExchangeByte::
;>@mask mask = IE_SERIAL | IE_TIMER | IE_STAT | IE_VBLANK
;>@lp while True:
;>     hSerialReceivedNewData = 0
	xor a
	ldh [hSerialReceivedNewData], a
;>     if hSerialConnectionStatus == USING_INTERNAL_CLOCK:
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr nz, .loop
;>         rSC = SC_START | SC_INTERNAL
	ld a, SC_START | SC_INTERNAL
	ldh [rSC], a
.loop
;>     while not hSerialReceivedNewData:    # set by the serial interrupt
	ldh a, [hSerialReceivedNewData]
	and a
	jr nz, .ok
;>         if hSerialConnectionStatus == USING_EXTERNAL_CLOCK:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr nz, .doNotIncrementUnknownCounter
;>             if not IsUnknownCounterZero():
	call IsUnknownCounterZero
	jr z, .doNotIncrementUnknownCounter
;>                 WaitLoop_15Iterations()
	call WaitLoop_15Iterations
;>                 # (send kept on the stack)
	push hl
;>                 n = (wUnknownSerialCounter[0] << 8 | wUnknownSerialCounter[1]) + 1
;>                 wUnknownSerialCounter[0], wUnknownSerialCounter[1] = hi(n), lo(n)
	ld hl, wUnknownSerialCounter + 1
	inc [hl]
	jr nz, .noCarry
	dec hl
	inc [hl]
.noCarry
;>                 # (send comes back off the stack)
	pop hl
;>                 if IsUnknownCounterZero():
;>                     return SetUnknownCounterToFFFF(0)
	call IsUnknownCounterZero
	jr nz, .loop
	jp SetUnknownCounterToFFFF
;>@cont                 continue
.doNotIncrementUnknownCounter
;>         if rIE & mask != IE_SERIAL:
;>             continue
	ldh a, [rIE]
	and IE_SERIAL | IE_TIMER | IE_STAT | IE_VBLANK
	cp IE_SERIAL
	jr nz, .loop
;>         wUnknownSerialCounter2[0] = u8(wUnknownSerialCounter2[0] - 1)
	ld a, [wUnknownSerialCounter2]
	dec a
	ld [wUnknownSerialCounter2], a
;>         if wUnknownSerialCounter2[0]:
;>             continue
	jr nz, .loop
;>         wUnknownSerialCounter2[1] = u8(wUnknownSerialCounter2[1] - 1)
	ld a, [wUnknownSerialCounter2 + 1]
	dec a
	ld [wUnknownSerialCounter2 + 1], a
;>         if wUnknownSerialCounter2[1]:
;>             continue
	jr nz, .loop
;>         if hSerialConnectionStatus != USING_EXTERNAL_CLOCK:   # timed out
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .ok
;>             pass                    # (a short pause: 255 counted down)
	ld a, 255
.waitLoop
	dec a
	jr nz, .waitLoop
;>@brk         break
.ok
;>     hSerialReceivedNewData = 0
	xor a
	ldh [hSerialReceivedNewData], a
;>     if rIE & mask == IE_SERIAL:
	ldh a, [rIE]
	and IE_SERIAL | IE_TIMER | IE_STAT | IE_VBLANK
	sub IE_SERIAL
	jr nz, .skipReloadingUnknownCounter2
;>         wUnknownSerialCounter2[0] = 0
	ld [wUnknownSerialCounter2], a
;>         wUnknownSerialCounter2[1] = 0x50
	ld a, $50
	ld [wUnknownSerialCounter2 + 1], a
.skipReloadingUnknownCounter2
;>     if hSerialReceiveData != SERIAL_NO_DATA_BYTE:
;>         return hSerialReceiveData
	ldh a, [hSerialReceiveData]
	cp SERIAL_NO_DATA_BYTE
	ret nz
;>     if not IsUnknownCounterZero():
	call IsUnknownCounterZero
	jr z, .done
;>         # (send kept on the stack)
	push hl
;>         wUnknownSerialCounter[1] = u8(wUnknownSerialCounter[1] - 1)
	ld hl, wUnknownSerialCounter + 1
	ld a, [hl]
	dec a
	ld [hld], a
;>         if wUnknownSerialCounter[1] == 0xFF:   # the borrow from the high byte
;>             wUnknownSerialCounter[0] = u8(wUnknownSerialCounter[0] - 1)
	inc a
	jr nz, .noBorrow
	dec [hl]
.noBorrow
;>         # (send comes back off the stack)
	pop hl
;>         if IsUnknownCounterZero():
;>             return SetUnknownCounterToFFFF(0)
	call IsUnknownCounterZero
	jr z, SetUnknownCounterToFFFF
.done
;>     if rIE & mask == IE_SERIAL:
	ldh a, [rIE]
	and IE_SERIAL | IE_TIMER | IE_STAT | IE_VBLANK
	cp IE_SERIAL
;>         return SERIAL_NO_DATA_BYTE
	ld a, SERIAL_NO_DATA_BYTE
	ret z
;>     hSerialSendData = mem[send]
	ld a, [hl]
	ldh [hSerialSendData], a
;>     DelayFrame()
	call DelayFrame
;=@lp
	jp Serial_ExchangeByte

;@ path: home/serial
;@ def WaitLoop_15Iterations()
;@ A short busy wait (15 loops).
WaitLoop_15Iterations::
;> return
	ld a, 15
.waitLoop
	dec a
	jr nz, .waitLoop
	ret

;@ path: home/serial
;@ def IsUnknownCounterZero() -> zero
;@ Zero flag if wUnknownSerialCounter is 0. Keeps hl.
IsUnknownCounterZero::
;> return not (wUnknownSerialCounter[0] | wUnknownSerialCounter[1])
	push hl
	ld hl, wUnknownSerialCounter
	ld a, [hli]
	or [hl]
	pop hl
	ret

; a is always 0 when this is called
;@ path: home/serial
;@ def SetUnknownCounterToFFFF(zero: a) -> a
;@ Set both bytes of wUnknownSerialCounter to a - 1, which is $FF since a is always 0 here.
SetUnknownCounterToFFFF::
;> v = u8(zero - 1)
	dec a
;> wUnknownSerialCounter[0] = v
	ld [wUnknownSerialCounter], a
;> wUnknownSerialCounter[1] = v
	ld [wUnknownSerialCounter + 1], a
;> return v
	ret

; This is used to exchange the button press and selected menu item on the link menu.
; The data is sent thrice and read twice to increase reliability.
;@ path: home/serial
;@ def Serial_ExchangeLinkMenuSelection()
;@ Exchange the link menu's button press and cursor position (2 bytes) with the other Game Boy, one byte per
;@ frame, ignoring the first byte that comes back.
;@ test: skip waits for the other Game Boy
Serial_ExchangeLinkMenuSelection::
;> send = addr(wLinkMenuSelectionSendBuffer)
	ld hl, wLinkMenuSelectionSendBuffer
;> receive = addr(wLinkMenuSelectionReceiveBuffer)
	ld de, wLinkMenuSelectionReceiveBuffer
;> left = 2
	ld c, 2 ; number of bytes to save
;> hSerialIgnoringInitialData = 1
	ld a, 1
	ldh [hSerialIgnoringInitialData], a
;> while True:
.loop
;>     DelayFrame()
	call DelayFrame
;>     hSerialSendData = mem[send]
	ld a, [hl]
	ldh [hSerialSendData], a
;>     byte = Serial_ExchangeByte(send)
	call Serial_ExchangeByte
	ld b, a
;>     send += 1
	inc hl
;>     ignoring = hSerialIgnoringInitialData
	ldh a, [hSerialIgnoringInitialData]
	and a
;>     hSerialIgnoringInitialData = 0
	ld a, 0
	ldh [hSerialIgnoringInitialData], a
;>     if ignoring:
;>         continue
	jr nz, .loop
;>     mem[receive] = byte
	ld a, b
	ld [de], a
;>     receive += 1
	inc de
;>     left -= 1
	dec c
;>     if not left:
;>         return
	jr nz, .loop
	ret

;@ path: home/serial
;@ def Serial_PrintWaitingTextAndSyncAndExchangeNybble()
;@ Show "Waiting...!" while exchanging a nybble with the other Game Boy, then restore the screen.
;@ test: skip waits for the other Game Boy
Serial_PrintWaitingTextAndSyncAndExchangeNybble::
;> SaveScreenTilesToBuffer1()
	call SaveScreenTilesToBuffer1
;> PrintWaitingText()                  # "Waiting...!"
	ld hl, PrintWaitingText
	ld b, BANK(PrintWaitingText)
	call Bankswitch
;> Serial_SyncAndExchangeNybble()
	call Serial_SyncAndExchangeNybble
;> LoadScreenTilesFromBuffer1()
	jp LoadScreenTilesFromBuffer1

;@ path: home/serial
;@ def Serial_SyncAndExchangeNybble()
;@ Exchange wSerialExchangeNybbleSendData with the other Game Boy until a nybble comes back (or
;@ wUnknownSerialCounter runs out), keep exchanging for 10 more frames and send zeros for 10, so both sides
;@ finish together. The nybble ends up in wSerialSyncAndExchangeNybbleReceiveData.
;@ test: skip waits for the other Game Boy
Serial_SyncAndExchangeNybble::
;> wSerialExchangeNybbleReceiveData = 0xFF
	ld a, $ff
	ld [wSerialExchangeNybbleReceiveData], a
;> while True:
.loop1
;>     Serial_ExchangeNybble()
	call Serial_ExchangeNybble
;>     DelayFrame()
	call DelayFrame
;>     if not IsUnknownCounterZero():
	call IsUnknownCounterZero
	jr z, .next1
;>         wUnknownSerialCounter[1] = u8(wUnknownSerialCounter[1] - 1)
;>         if not wUnknownSerialCounter[1]:
	push hl
	ld hl, wUnknownSerialCounter + 1
	dec [hl]
	jr nz, .next2
;>             wUnknownSerialCounter[0] = u8(wUnknownSerialCounter[0] - 1)
;>             if not wUnknownSerialCounter[0]:
	dec hl
	dec [hl]
	jr nz, .next2
;>                 return SetUnknownCounterToFFFF(0)
	pop hl
	xor a
	jp SetUnknownCounterToFFFF
.next2
	pop hl
.next1
;>     if wSerialExchangeNybbleReceiveData != 0xFF:
;>         break
	ld a, [wSerialExchangeNybbleReceiveData]
	inc a
	jr z, .loop1
;> for _ in range(10):
	ld b, 10
.loop2
;>     DelayFrame()
	call DelayFrame
;>     Serial_ExchangeNybble()
	call Serial_ExchangeNybble
	dec b
	jr nz, .loop2
;> for _ in range(10):
	ld b, 10
.loop3
;>     DelayFrame()
	call DelayFrame
;>     Serial_SendZeroByte()
	call Serial_SendZeroByte
	dec b
	jr nz, .loop3
;> wSerialSyncAndExchangeNybbleReceiveData = wSerialExchangeNybbleReceiveData
	ld a, [wSerialExchangeNybbleReceiveData]
	ld [wSerialSyncAndExchangeNybbleReceiveData], a
	ret

;@ path: home/serial
;@ def Serial_ExchangeNybble()
;@ Take a nybble from the last byte received if it is marked as one ($6x), then send our nybble the same way
;@ (wSerialExchangeNybbleSendData + $60) and look at the received byte again.
Serial_ExchangeNybble::
;> for step in range(2):
	call .doExchange
;>     if step:
;>         hSerialSendData = u8(wSerialExchangeNybbleSendData + 0x60)
	ld a, [wSerialExchangeNybbleSendData]
	add $60
	ldh [hSerialSendData], a
;>         if hSerialConnectionStatus == USING_INTERNAL_CLOCK:
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr nz, .doExchange
;>             rSC = SC_START | SC_INTERNAL
	ld a, SC_START | SC_INTERNAL
	ldh [rSC], a
.doExchange
;>     received = hSerialReceiveData
	ldh a, [hSerialReceiveData]
;>     wSerialExchangeNybbleTempReceiveData = received
	ld [wSerialExchangeNybbleTempReceiveData], a
;>     if received & 0xF0 == 0x60:
	and $f0
	cp $60
	ret nz
;>         hSerialReceiveData = 0
	xor a
	ldh [hSerialReceiveData], a
;>         wSerialExchangeNybbleReceiveData = received & 0xF
	ld a, [wSerialExchangeNybbleTempReceiveData]
	and $f
	ld [wSerialExchangeNybbleReceiveData], a
	ret

;@ path: home/serial
;@ def Serial_SendZeroByte()
;@ Send a 0 next (starting the transfer when this side drives the clock).
Serial_SendZeroByte::
;> hSerialSendData = 0
	xor a
	ldh [hSerialSendData], a
;> if hSerialConnectionStatus != USING_INTERNAL_CLOCK:
;>     return
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	ret nz
;> rSC = SC_START | SC_INTERNAL       # this side drives the clock: start the transfer
	ld a, SC_START | SC_INTERNAL
	ldh [rSC], a
	ret

;@ path: home/serial
;@ def Serial_TryEstablishingExternallyClockedConnection()
;@ Offer to be the side that follows the other's clock: put ESTABLISH_CONNECTION_WITH_EXTERNAL_CLOCK in the
;@ serial register and wait for a transfer.
Serial_TryEstablishingExternallyClockedConnection::
;> rSB = ESTABLISH_CONNECTION_WITH_EXTERNAL_CLOCK
	ld a, ESTABLISH_CONNECTION_WITH_EXTERNAL_CLOCK
	ldh [rSB], a
;> hSerialReceiveData = 0
	xor a
	ldh [hSerialReceiveData], a
;> rSC = SC_START | SC_EXTERNAL
	ld a, SC_START | SC_EXTERNAL
	ldh [rSC], a
	ret
; timer interrupt is apparently not invoked anyway
;@ path: home/timer
;@ def Timer()
;@ The timer interrupt: unused, it returns at once.
Timer::
;> return
	reti
;@ path: home/audio
;@ def PlayDefaultMusic()
;@ Once the sound effects are done, start the default music right away (no fade-out).
;@ test: skip waits for the sound engine, which runs from an interrupt
PlayDefaultMusic::
;> WaitForSoundToFinish()
	call WaitForSoundToFinish
;> wLastMusicSoundID = 0
;> PlayDefaultMusicCommon(0, 0)
	xor a
	ld c, a
	ld d, a
	ld [wLastMusicSoundID], a
	jr PlayDefaultMusicCommon

;@ path: home/audio
;@ def PlayDefaultMusicFadeOutCurrent()
;@ Fade the current music out and start the default music (after a battle or blackout: always restart it).
PlayDefaultMusicFadeOutCurrent::
; Fade out the current music and then play the default music.
;> fade, fade_first = 10, 0
	ld c, 10
	ld d, 0
;> if wStatusFlags4 & 1 << BIT_BATTLE_OVER_OR_BLACKOUT:   # after a battle or a blackout
	ld a, [wStatusFlags4]
	bit BIT_BATTLE_OVER_OR_BLACKOUT, a
	jr z, PlayDefaultMusicCommon
;>     wLastMusicSoundID = 0           # the music starts again even if it is the same
	xor a
	ld [wLastMusicSoundID], a
;>     fade, fade_first = 8, 8
	ld c, 8
	ld d, c
;> PlayDefaultMusicCommon(fade, fade_first)   # it follows right below

;@ path: home/audio
;@ def PlayDefaultMusicCommon(fade: c, fade_first: d)
;@ Start the music that belongs here: the bike or surfing music, or the map's own. Nothing happens if it is
;@ already playing in the same audio bank; `fade` is the fade-out speed for the music that is playing.
PlayDefaultMusicCommon::
;> if wWalkBikeSurfState:
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .walking
;>     music = MUSIC_SURFING if wWalkBikeSurfState == 2 else MUSIC_BIKE_RIDING
	cp $2
	jr z, .surfing
	ld a, MUSIC_BIKE_RIDING
	jr .next

.surfing
	ld a, MUSIC_SURFING

.next
;>     if not fade_first:
	ld b, a
	ld a, d
	and a ; should current music be faded out first?
	ld a, BANK(Music_BikeRiding)
	jr nz, .next2

; Only change the audio ROM bank if the current music isn't going to be faded
; out before the default music begins.
;>         wAudioROMBank = BANK(Music_BikeRiding)    # else FadeOutAudio switches once the old music is gone
	ld [wAudioROMBank], a

.next2
; [wAudioSavedROMBank] will be copied to [wAudioROMBank] after fading out the
; current music (if the current music is faded out).
;>     wAudioSavedROMBank = BANK(Music_BikeRiding)
	ld [wAudioSavedROMBank], a
;>     new_bank = False
	jr .next3

.walking
;> else:
;>     music = wMapMusicSoundID
	ld a, [wMapMusicSoundID]
	ld b, a
;>     new_bank = CompareMapMusicBankWithCurrentBank(fade)
	call CompareMapMusicBankWithCurrentBank
	jr c, .next4

.next3
;> if not new_bank and wLastMusicSoundID == music:
;>     return
	ld a, [wLastMusicSoundID]
	cp b ; is the default music already playing?
	ret z ; if so, do nothing

.next4
;> wAudioFadeOutControl = fade
	ld a, c
	ld [wAudioFadeOutControl], a
;> wLastMusicSoundID = music
	ld a, b
	ld [wLastMusicSoundID], a
;> wNewSoundID = music
	ld [wNewSoundID], a
;> PlaySound(music)
	jp PlaySound

;@ path: home/audio
;@ def UpdateMusic6Times()
;@ Run the music engine of the current audio bank six times, when entering a map before the music changes.
UpdateMusic6Times::
; This is called when entering a map, before fading out the current music and
; playing the default music (i.e. the map's music or biking/surfing music).
;> bank = wAudioROMBank
	ld a, [wAudioROMBank]
	ld b, a
;> if bank == BANK(Audio1_UpdateMusic):
	cp BANK(Audio1_UpdateMusic)
	jr nz, .checkForAudio2
; audio 1
;>     func = Audio1_UpdateMusic
	ld hl, Audio1_UpdateMusic
	jr .next

.checkForAudio2
;> elif bank == BANK(Audio2_UpdateMusic):
	cp BANK(Audio2_UpdateMusic)
	jr nz, .audio3
; audio 2
;>     func = Audio2_UpdateMusic
	ld hl, Audio2_UpdateMusic
	jr .next

.audio3
;> else:
;>     func = Audio3_UpdateMusic
	ld hl, Audio3_UpdateMusic

.next
;>@lp for _ in range(6):
	ld c, 6
.loop
;>     Bankswitch(bank, func)
	push bc
	push hl
	call Bankswitch
	pop hl
	pop bc
;=@lp
	dec c
	jr nz, .loop
	ret

;@ path: home/audio
;@ def CompareMapMusicBankWithCurrentBank(fade: c) -> carry
;@ Carry if the map's music lives in another audio bank than the current one. Then wAudioSavedROMBank gets
;@ the map's bank, and wAudioROMBank too unless the current music is fading out (fade not 0).
CompareMapMusicBankWithCurrentBank::
; Compares the map music's audio ROM bank with the current audio ROM bank
; and updates the audio ROM bank variables.
; Returns whether the banks are different in carry.
;> if wAudioROMBank == wMapMusicROMBank:
	ld a, [wMapMusicROMBank]
	ld e, a
	ld a, [wAudioROMBank]
	cp e
	jr nz, .differentBanks
;>     wAudioSavedROMBank = wAudioROMBank
	ld [wAudioSavedROMBank], a
;>     return False
	and a
	ret
.differentBanks
;> if not fade:
	ld a, c ; this is a fade-out counter value and it's always non-zero
	and a
	ld a, e
	jr nz, .next
; If the fade-counter is non-zero, we don't change the audio ROM bank because
; it's needed to keep playing the music as it fades out. The FadeOutAudio
; routine will take care of copying [wAudioSavedROMBank] to [wAudioROMBank]
; when the music has faded out.
;>     wAudioROMBank = wMapMusicROMBank
	ld [wAudioROMBank], a
.next
;> wAudioSavedROMBank = wMapMusicROMBank
	ld [wAudioSavedROMBank], a
;> return True
	scf
	ret

;@ path: home/audio
;@ def PlayMusic(music: a, bank: c)
;@ Start `music`, which lives in audio bank `bank`, without a fade-out.
PlayMusic::
;> wNewSoundID = music
	ld b, a
	ld [wNewSoundID], a
;> wAudioFadeOutControl = 0
	xor a
	ld [wAudioFadeOutControl], a
;> wAudioROMBank = bank
	ld a, c
	ld [wAudioROMBank], a
;> wAudioSavedROMBank = bank
	ld [wAudioSavedROMBank], a
;> PlaySound(music)
	ld a, b

; plays music specified by a. If value is $ff, music is stopped
;@ path: home/audio
;@ def PlaySound(sound: a)
;@ Play `sound` with the audio engine of bank wAudioROMBank. A new song (wNewSoundID set) frees the effect
;@ channels; with a fade-out length in wAudioFadeOutControl, the playing music fades out first and the new
;@ song is kept in wAudioFadeOutControl until then (FadeOutAudio starts it). Keeps hl, de and bc.
;@ test: wAudioROMBank = rng.choice((0x02, 0x08, 0x1F))
PlaySound::
;> # (the registers are saved on the stack)
	push hl
	push de
	push bc
;> if wNewSoundID:                     # a new song: the effect channels are freed
	ld b, a
	ld a, [wNewSoundID]
	and a
	jr z, .next
;>     for ch in (CHAN5, CHAN6, CHAN7, CHAN8):
;>         wChannelSoundIDs[ch] = 0
	xor a
	ld [wChannelSoundIDs + CHAN5], a
	ld [wChannelSoundIDs + CHAN6], a
	ld [wChannelSoundIDs + CHAN7], a
	ld [wChannelSoundIDs + CHAN8], a
.next
;> if wAudioFadeOutControl:            # a fade-out length: the music fades out first
	ld a, [wAudioFadeOutControl]
	and a ; has a fade-out length been specified?
	jr z, .noFadeOut
;>     if not wNewSoundID:
;>@r1         return
	ld a, [wNewSoundID]
	and a ; is the new sound ID 0?
	jr z, .done ; if so, do nothing
;>     wNewSoundID = 0
	xor a
	ld [wNewSoundID], a
;>     if wLastMusicSoundID != 0xFF:   # music is playing: fade it out, the new song waits
	ld a, [wLastMusicSoundID]
	cp $ff ; has the music been stopped?
	jr nz, .fadeOut ; if not, fade out the current music
;>@f1         wLastMusicSoundID = sound
;>@f2         wAudioFadeOutCounterReloadValue = wAudioFadeOutControl   # the fade-out length
;>@f4         wAudioFadeOutCounter = wAudioFadeOutCounterReloadValue
;>@f5         wAudioFadeOutControl = sound    # the song that waits
;>@f3         return
; If it has been stopped, start playing the new music immediately.
;>     wAudioFadeOutControl = 0        # the music was stopped: start the new song at once
	xor a
	ld [wAudioFadeOutControl], a
.noFadeOut
;> wNewSoundID = 0
	xor a
	ld [wNewSoundID], a
;> hSavedROMBank = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	ldh [hSavedROMBank], a
;> bank = wAudioROMBank
;> hLoadedROMBank = bank
	ld a, [wAudioROMBank]
	ldh [hLoadedROMBank], a
;> set_rom_bank(bank)
	ld [rROMB], a
;> if bank == BANK(Audio1_PlaySound):
	cp BANK(Audio1_PlaySound)
	jr nz, .checkForAudio2
; audio 1
;>     Audio1_PlaySound(sound)
	ld a, b
	call Audio1_PlaySound
	jr .next2

.checkForAudio2
;> elif bank == BANK(Audio2_PlaySound):
	cp BANK(Audio2_PlaySound)
	jr nz, .audio3
; audio 2
;>     Audio2_PlaySound(sound)
	ld a, b
	call Audio2_PlaySound
	jr .next2

.audio3
;> else:
;>     Audio3_PlaySound(sound)
	ld a, b
	call Audio3_PlaySound

.next2
;> hLoadedROMBank = hSavedROMBank
	ldh a, [hSavedROMBank]
	ldh [hLoadedROMBank], a
;> set_rom_bank(hSavedROMBank)
	ld [rROMB], a
	jr .done

.fadeOut
;=@f1
	ld a, b
	ld [wLastMusicSoundID], a
;=@f2
	ld a, [wAudioFadeOutControl]
	ld [wAudioFadeOutCounterReloadValue], a
;=@f4
	ld [wAudioFadeOutCounter], a
;=@f5
	ld a, b
	ld [wAudioFadeOutControl], a

.done
;=@r1
;=@f3
	pop bc
	pop de
	pop hl
	ret
;@ path: home/update_sprites
;@ def UpdateSprites()
;@ Update the sprites of the people on the map (_UpdateSprites), if wUpdateSpritesEnabled is 1.
UpdateSprites::
;> if wUpdateSpritesEnabled != 1:
;>     return
	ld a, [wUpdateSpritesEnabled]
	dec a
	ret nz
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(_UpdateSprites)
	ld a, BANK(_UpdateSprites)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(_UpdateSprites))
	ld [rROMB], a
;> _UpdateSprites()
	call _UpdateSprites
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret

; mart inventories are below
; they are texts

;@ path: data/items/marts
ViridianMartClerkText::
	db TX_SCRIPT_MART
	db $4
	db POKE_BALL,ANTIDOTE,PARLYZ_HEAL,BURN_HEAL
	db -1

;@ path: data/items/marts
PewterMartClerkText::
	db TX_SCRIPT_MART
	db $7
	db POKE_BALL,POTION,ESCAPE_ROPE,ANTIDOTE,BURN_HEAL,AWAKENING,PARLYZ_HEAL
	db -1

;@ path: data/items/marts
CeruleanMartClerkText::
	db TX_SCRIPT_MART
	db $7
	db POKE_BALL,POTION,REPEL,ANTIDOTE,BURN_HEAL,AWAKENING,PARLYZ_HEAL
	db -1

;@ path: data/items/marts
UnusedBikeShopClerkText:: ; unreferenced
	db TX_SCRIPT_MART
	db $1
	db BICYCLE
	db -1

;@ path: data/items/marts
VermilionMartClerkText::
	db TX_SCRIPT_MART
	db $6
	db POKE_BALL,SUPER_POTION,ICE_HEAL,AWAKENING,PARLYZ_HEAL,REPEL
	db -1

;@ path: data/items/marts
LavenderMartClerkText::
	db TX_SCRIPT_MART
	db $9
	db GREAT_BALL,SUPER_POTION,REVIVE,ESCAPE_ROPE,SUPER_REPEL,ANTIDOTE,BURN_HEAL,ICE_HEAL,PARLYZ_HEAL
	db -1

;@ path: data/items/marts
CeladonMart2FClerk1Text::
	db TX_SCRIPT_MART
	db $9
	db GREAT_BALL,SUPER_POTION,REVIVE,SUPER_REPEL,ANTIDOTE,BURN_HEAL,ICE_HEAL,AWAKENING,PARLYZ_HEAL
	db -1

;@ path: data/items/marts
CeladonMart2FClerk2Text::
	db TX_SCRIPT_MART
	db $9
	db TM_DOUBLE_TEAM,TM_REFLECT,TM_RAZOR_WIND,TM_HORN_DRILL,TM_EGG_BOMB,TM_MEGA_PUNCH,TM_MEGA_KICK,TM_TAKE_DOWN,TM_SUBMISSION
	db -1

;@ path: data/items/marts
CeladonMart4FClerkText::
	db TX_SCRIPT_MART
	db $5
	db POKE_DOLL,FIRE_STONE,THUNDER_STONE,WATER_STONE,LEAF_STONE
	db -1

;@ path: data/items/marts
CeladonMart5FClerk1Text::
	db TX_SCRIPT_MART
	db $7
	db X_ACCURACY,GUARD_SPEC,DIRE_HIT,X_ATTACK,X_DEFEND,X_SPEED,X_SPECIAL
	db -1

;@ path: data/items/marts
CeladonMart5FClerk2Text::
	db TX_SCRIPT_MART
	db $5
	db HP_UP,PROTEIN,IRON,CARBOS,CALCIUM
	db -1

;@ path: data/items/marts
FuchsiaMartClerkText::
	db TX_SCRIPT_MART
	db $6
	db ULTRA_BALL,GREAT_BALL,SUPER_POTION,REVIVE,FULL_HEAL,SUPER_REPEL
	db -1

;@ path: data/items/marts
UnusedMartClerkText:: ; unreferenced
	db TX_SCRIPT_MART
	db $5
	db GREAT_BALL,HYPER_POTION,SUPER_POTION,FULL_HEAL,REVIVE
	db -1

;@ path: data/items/marts
CinnabarMartClerkText::
	db TX_SCRIPT_MART
	db $7
	db ULTRA_BALL,GREAT_BALL,HYPER_POTION,MAX_REPEL,ESCAPE_ROPE,FULL_HEAL,REVIVE
	db -1

;@ path: data/items/marts
SaffronMartClerkText::
	db TX_SCRIPT_MART
	db $6
	db GREAT_BALL,HYPER_POTION,MAX_REPEL,ESCAPE_ROPE,FULL_HEAL,REVIVE
	db -1

;@ path: data/items/marts
IndigoPlateauLobbyClerkText::
	db TX_SCRIPT_MART
	db $7
	db ULTRA_BALL,GREAT_BALL,FULL_RESTORE,MAX_POTION,FULL_HEAL,REVIVE,MAX_REPEL
	db -1

;@ path: home/overworld_text
TextScriptEndingText::
	db TX_END

;@ path: home/overworld_text
;@ def TextScriptEnd() -> hl
;@ The end of a text script written in code: hand back the empty text that ends it.
TextScriptEnd::
;> return TextScriptEndingText
	ld hl, TextScriptEndingText
	ret

;@ path: home/overworld_text
ExclamationText::
	db TX_FAR
	dw _ExclamationText
	db BANK(_ExclamationText)
	db TX_END

;@ path: home/overworld_text
GroundRoseText::
	db TX_FAR
	dw _GroundRoseText
	db BANK(_GroundRoseText)
	db TX_END

;@ path: home/overworld_text
BoulderText::
	db TX_FAR
	dw _BoulderText
	db BANK(_BoulderText)
	db TX_END

;@ path: home/overworld_text
MartSignText::
	db TX_FAR
	dw _MartSignText
	db BANK(_MartSignText)
	db TX_END

;@ path: home/overworld_text
PokeCenterSignText::
	db TX_FAR
	dw _PokeCenterSignText
	db BANK(_PokeCenterSignText)
	db TX_END

;@ path: home/overworld_text
;@ def PickUpItemText() -> hl
;@ The text shown when the player picks up an item ball: code started by the text engine after its text_asm
;@ byte, which picks the item up and ends the text.
;@ test: skip the text engine enters it after the text_asm byte, not at the label
PickUpItemText::
	db TX_START_ASM
;> PickUpItem()
;> return TextScriptEnd()
	ld a, (PickUpItemPredef - PredefPointers) / 3
	call Predef
	jp TextScriptEnd
; wSpriteLoadFlags bits, streamed from compressed sprite data
	; 0
DEF BIT_USE_SPRITE_BUFFER_2 EQU 0
	; 1
DEF BIT_LAST_SPRITE_CHUNK EQU 1

; bankswitches and runs _UncompressSpriteData
; bank is given in a, sprite input stream is pointed to in wSpriteInputPtr
;@ path: home/uncompress
;@ def UncompressSpriteData(bank: a)
;@ Decompress the picture at wSpriteInputPtr in ROM bank `bank` into sSpriteBuffer1 and 2, with the
;@ cartridge RAM enabled.
;@ test: skip needs a real compressed picture as input
UncompressSpriteData::
;> saved = hLoadedROMBank
	ld b, a
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = bank
	ld a, b
	ldh [hLoadedROMBank], a
;> set_rom_bank(bank)
	ld [rROMB], a
;> rRAMG = RAMG_SRAM_ENABLE
	ld a, RAMG_SRAM_ENABLE
	ld [rRAMG], a
;> rRAMB = 0
	xor a
	ld [rRAMB], a
;> _UncompressSpriteData()
	call _UncompressSpriteData
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret

; initializes necessary data to load a sprite and runs UncompressSpriteDataLoop
;@ path: home/uncompress
;@ def _UncompressSpriteData()
;@ Clear both output buffers, read the picture's size (first byte: width and height in tiles), and which
;@ buffer gets the first bit plane (first bit), then decompress.
;@ test: skip needs a real compressed picture as input
_UncompressSpriteData::
;> FillMemory(sSpriteBuffer1, 2 * SPRITEBUFFERSIZE, 0)
	ld hl, sSpriteBuffer1
	ld c, LOW(2 * SPRITEBUFFERSIZE)
	ld b, HIGH(2 * SPRITEBUFFERSIZE)
	xor a
	call FillMemory           ; clear sprite buffer 1 and 2
;> wSpriteInputBitCounter = 1
	ld a, $1
	ld [wSpriteInputBitCounter], a
;> wSpriteOutputBitOffset = 3
	ld a, $3
	ld [wSpriteOutputBitOffset], a
;> wSpriteCurPosX = 0
	xor a
	ld [wSpriteCurPosX], a
;> wSpriteCurPosY = 0
	ld [wSpriteCurPosY], a
;> wSpriteLoadFlags = 0
	ld [wSpriteLoadFlags], a
;> size = ReadNextInputByte()
	call ReadNextInputByte    ; first byte of input determines sprite width (high nybble) and height (low nybble) in tiles (8x8 pixels)
;> wSpriteHeight = u8((size & 0xF) * 8)
	ld b, a
	and $f
	add a
	add a
	add a
	ld [wSpriteHeight], a
;> w = size >> 4
	ld a, b
	swap a
	and $f
;> wSpriteWidth = u8(w * 8)
	add a
	add a
	add a
	ld [wSpriteWidth], a
;> wSpriteLoadFlags = ReadNextInputBit()
	call ReadNextInputBit
	ld [wSpriteLoadFlags], a ; initialize bit1 to 0 and bit0 to the first input bit
                             ; this will load two chunks of data to sSpriteBuffer1 and sSpriteBuffer2
                             ; bit 0 decides in which one the first chunk is placed
;> UncompressSpriteDataLoop()
	; fall through

; uncompresses a chunk from the sprite input data stream (pointed to by wSpriteInputPtr) into sSpriteBuffer1 or sSpriteBuffer2
; each chunk is a 1bpp sprite. A 2bpp sprite consist of two chunks which are merged afterwards
; note that this is an endless loop which is terminated during a call to MoveToNextBufferPosition by manipulating the stack
;@ path: home/uncompress
;@ def UncompressSpriteDataLoop()
;@ Decompress one bit plane into its buffer, 2 bits at a time, column by column (each column 8 pixels wide,
;@ filled in four passes of 2 bits). The input alternates between literal 2-bit groups (ended by 00) and
;@ runs of 00 groups, whose length is stored as n one bits, a zero and n + 1 bits, plus 2^(n+1) - 1. Before
;@ the second plane comes the unpack mode (0, 10 = 1 or 11 = 2). It stops when MoveToNextBufferPosition has
;@ filled the plane.
;@ test: skip needs a real compressed picture as input
UncompressSpriteDataLoop::
;> buffer = sSpriteBuffer2 if wSpriteLoadFlags & 1 << BIT_USE_SPRITE_BUFFER_2 else sSpriteBuffer1
	ld hl, sSpriteBuffer1
	ld a, [wSpriteLoadFlags]
	bit BIT_USE_SPRITE_BUFFER_2, a
	jr z, .useSpriteBuffer1    ; check which buffer to use
	ld hl, sSpriteBuffer2
.useSpriteBuffer1
;> StoreSpriteOutputPointer(buffer)
	call StoreSpriteOutputPointer
;> if wSpriteLoadFlags & 1 << BIT_LAST_SPRITE_CHUNK:   # the second plane: the unpack mode comes first
	ld a, [wSpriteLoadFlags]
	bit BIT_LAST_SPRITE_CHUNK, a
	jr z, .startDecompression  ; check if last iteration
;>     mode = ReadNextInputBit()
	call ReadNextInputBit      ; if last chunk, read 1-2 bit unpacking mode
;>     if mode:
	and a
	jr z, .unpackingMode0      ; 0   -> mode 0
;>         mode = ReadNextInputBit() + 1
	call ReadNextInputBit      ; 1 0 -> mode 1
	inc a                      ; 1 1 -> mode 2
.unpackingMode0
;>     wSpriteUnpackMode = mode
	ld [wSpriteUnpackMode], a
.startDecompression
;> literal = ReadNextInputBit()        # does the input start with literal groups or with zeros?
	call ReadNextInputBit
;>@outer while True:
;>@lit     while literal:
	and a
	jr z, .readRLEncodedZeros ; if first bit is 0, the input starts with zeroes, otherwise with (non-zero) input
.readNextInput
;>         first = ReadNextInputBit()
	call ReadNextInputBit
	ld c, a
;>         bits = first << 1 | ReadNextInputBit()
	call ReadNextInputBit
	sla c
	or c                       ; read next two bits into c
;>         if not bits:                # 00: a run of zeros follows
;>             break
	and a
	jr z, .readRLEncodedZeros ; 00 -> RLEncoded zeroes following
;>         WriteSpriteBitsToBuffer(bits)
	call WriteSpriteBitsToBuffer  ; otherwise write input to output and repeat
;>         if MoveToNextBufferPosition():   # the plane is full
;>             return
	call MoveToNextBufferPosition
;=@lit
	jr .readNextInput
.readRLEncodedZeros
;>     literal = True
;>     n = 0
	ld c, $0                   ; number of zeroes it length encoded, the number
.countConsecutiveOnesLoop      ; of consecutive ones determines the number of bits the number has
;>@ones     while ReadNextInputBit():   # n one bits
	call ReadNextInputBit
	and a
	jr z, .countConsecutiveOnesFinished
;>         n += 1
	inc c
;=@ones
	jr .countConsecutiveOnesLoop
.countConsecutiveOnesFinished
;>     i = u8(2 * n)
	ld a, c
	add a
;>     entry = LengthEncodingOffsetList + i
	ld hl, LengthEncodingOffsetList
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
;>     offset = mem16[entry]           # 2^(n+1) - 1 (kept on the stack)
	ld a, [hli]                ; read offset that is added to the number later on
	ld e, a                    ; adding an offset of 2^length - 1 makes every integer uniquely
	ld d, [hl]                 ; representable in the length encoding and saves bits
	push de
;>     bits = n + 1                    # then n + 1 bits
	inc c
;>     value = 0
	ld e, $0
	ld d, e
;>@num     while True:
;>         value |= ReadNextInputBit()
.readNumberOfZerosLoop        ; reads the next c+1 bits of input
	call ReadNextInputBit
	or e
	ld e, a
;>         bits -= 1
	dec c
;>         if not bits:
;>             break
	jr z, .readNumberOfZerosDone
;>         value = (value << 1) & 0xFFFF
	sla e
	rl d
;=@num
	jr .readNumberOfZerosLoop
.readNumberOfZerosDone
;>     count = (offset + value) & 0xFFFF   # the number of 00 groups
	pop hl                     ; add the offset
	add hl, de
	ld e, l
	ld d, h
;>     while True:
;>         WriteSpriteBitsToBuffer(0)
.writeZerosLoop
	ld b, e
	xor a                      ; write 00 to buffer
	call WriteSpriteBitsToBuffer
;>         if MoveToNextBufferPosition():
;>             return
	ld e, b
	call MoveToNextBufferPosition
;>         count = (count - 1) & 0xFFFF
	dec de
;>         if not count:
;>             break
	ld a, d
	and a
	jr nz, .continueLoop
	ld a, e
	and a
.continueLoop
	jr nz, .writeZerosLoop
;=@outer
	jr .readNextInput

; moves output pointer to next position
; also cancels the calling function if the all output is done (by removing the return pointer from stack)
; and calls postprocessing functions according to the unpack mode
;@ path: home/uncompress
;@ def MoveToNextBufferPosition()
;@ Step the output one row down; at the bottom of a column go back to its top for the next 2 bits, and after
;@ four passes on to the next column. When the plane is complete it does not return to its caller (it drops
;@ its return address): it starts on the second plane, or, after that, unpacks the picture (UnpackSprite).
;@ test: skip drops its caller's return address
MoveToNextBufferPosition::
;> y = u8(wSpriteCurPosY + 1)
;> if y != wSpriteHeight:
	ld a, [wSpriteHeight]
	ld b, a
	ld a, [wSpriteCurPosY]
	inc a
	cp b
	jr z, .curColumnDone
;>     wSpriteCurPosY = y
	ld [wSpriteCurPosY], a
;>     p = (wSpriteOutputPtr[0] | wSpriteOutputPtr[1] << 8) + 1
;>     wSpriteOutputPtr[0] = lo(p)
	ld a, [wSpriteOutputPtr]
	inc a
	ld [wSpriteOutputPtr], a
	ret nz
;>     wSpriteOutputPtr[1] = hi(p)
	ld a, [wSpriteOutputPtr+1]
	inc a
	ld [wSpriteOutputPtr+1], a
;>     return False
	ret
.curColumnDone
;> wSpriteCurPosY = 0
	xor a
	ld [wSpriteCurPosY], a
;> if wSpriteOutputBitOffset:
	ld a, [wSpriteOutputBitOffset]
	and a
	jr z, .bitOffsetsDone
;>     wSpriteOutputBitOffset -= 1
	dec a
	ld [wSpriteOutputBitOffset], a
;>     wSpriteOutputPtr[0] = wSpriteOutputPtrCached[0]
	ld hl, wSpriteOutputPtrCached
	ld a, [hli]
	ld [wSpriteOutputPtr], a
;>     wSpriteOutputPtr[1] = wSpriteOutputPtrCached[1]
	ld a, [hl]
	ld [wSpriteOutputPtr+1], a
;>     return False
	ret
.bitOffsetsDone
;> wSpriteOutputBitOffset = 3
	ld a, $3
	ld [wSpriteOutputBitOffset], a
;> wSpriteCurPosX = u8(wSpriteCurPosX + 8)
	ld a, [wSpriteCurPosX]
	add $8
	ld [wSpriteCurPosX], a
;> if wSpriteCurPosX != wSpriteWidth:
	ld b, a
	ld a, [wSpriteWidth]
	cp b
	jr z, .allColumnsDone
;>     StoreSpriteOutputPointer((wSpriteOutputPtr[0] | wSpriteOutputPtr[1] << 8) + 1)
;>     return False
	ld a, [wSpriteOutputPtr]
	ld l, a
	ld a, [wSpriteOutputPtr+1]
	ld h, a
	inc hl
	jp StoreSpriteOutputPointer
.allColumnsDone
;> wSpriteCurPosX = 0
	pop hl
	xor a
	ld [wSpriteCurPosX], a
;> if not wSpriteLoadFlags & 1 << BIT_LAST_SPRITE_CHUNK:
	ld a, [wSpriteLoadFlags]
	bit BIT_LAST_SPRITE_CHUNK, a
	jr nz, .done            ; test if there is one more sprite to go
;>     wSpriteLoadFlags = wSpriteLoadFlags ^ 1 << BIT_USE_SPRITE_BUFFER_2 | 1 << BIT_LAST_SPRITE_CHUNK
	xor 1 << BIT_USE_SPRITE_BUFFER_2
	set BIT_LAST_SPRITE_CHUNK, a
	ld [wSpriteLoadFlags], a
;>     UncompressSpriteDataLoop()
	jp UncompressSpriteDataLoop
.done
;> else:
;>     UnpackSprite()
;> return True    # finished: the caller does not get control back
	jp UnpackSprite

; writes 2 bits (from a) to the output buffer (pointed to from wSpriteOutputPtr)
;@ path: home/uncompress
;@ def WriteSpriteBitsToBuffer(bits: a)
;@ OR 2 bits into the output byte at wSpriteOutputPtr, at the position wSpriteOutputBitOffset gives
;@ (3 = top two bits, 0 = bottom two).
;@ test: p = rand_ram(1); mem[wSpriteOutputPtr] = p & 0xFF; mem[wSpriteOutputPtr + 1] = p >> 8
WriteSpriteBitsToBuffer::
;> offset = wSpriteOutputBitOffset
	ld e, a
	ld a, [wSpriteOutputBitOffset]
;> if offset == 0:
;>     e = bits
	and a
	jr z, .offset0
;> elif offset == 1:
	cp $2
	jr c, .offset1
;>@o1     e = u8(bits << 2)
;> elif offset == 2:
	jr z, .offset2
;>@o2     e = swap(bits)
;> else:
;>     e = (bits >> 2 | bits << 6) & 0xFF
	rrc e ; offset 3
	rrc e
	jr .offset0
.offset1
;=@o1
	sla e
	sla e
	jr .offset0
.offset2
;=@o2
	swap e
.offset0
;> p = wSpriteOutputPtr[0] | wSpriteOutputPtr[1] << 8
	ld a, [wSpriteOutputPtr]
	ld l, a
	ld a, [wSpriteOutputPtr+1]
	ld h, a
;> mem[p] = mem[p] | e
	ld a, [hl]
	or e
	ld [hl], a
	ret

; reads next bit from input stream and returns it in a
;@ path: home/uncompress
;@ def ReadNextInputBit() -> a
;@ The next bit of the compressed input, most significant first.
ReadNextInputBit::
;> n = u8(wSpriteInputBitCounter - 1)
	ld a, [wSpriteInputBitCounter]
	dec a
;> if not n:
	jr nz, .curByteHasMoreBitsToRead
;>     wSpriteInputCurByte = ReadNextInputByte()
	call ReadNextInputByte
	ld [wSpriteInputCurByte], a
;>     n = 8
	ld a, $8
.curByteHasMoreBitsToRead
;> wSpriteInputBitCounter = n
	ld [wSpriteInputBitCounter], a
;> v = wSpriteInputCurByte
	ld a, [wSpriteInputCurByte]
;> v = (v << 1 | v >> 7) & 0xFF
	rlca
;> wSpriteInputCurByte = v
	ld [wSpriteInputCurByte], a
;> return v & 1
	and $1
	ret

; reads next byte from input stream and returns it in a
;@ path: home/uncompress
;@ def ReadNextInputByte() -> a
;@ The next byte of the compressed input at wSpriteInputPtr.
ReadNextInputByte::
;> p = wSpriteInputPtr[0] | wSpriteInputPtr[1] << 8
	ld a, [wSpriteInputPtr]
	ld l, a
	ld a, [wSpriteInputPtr+1]
	ld h, a
;> value = mem[p]
;> p = (p + 1) & 0xFFFF
	ld a, [hli]
	ld b, a
;> wSpriteInputPtr[0] = lo(p)
	ld a, l
	ld [wSpriteInputPtr], a
;> wSpriteInputPtr[1] = hi(p)
	ld a, h
	ld [wSpriteInputPtr+1], a
;> return value
	ld a, b
	ret

; the nth item is 2^n - 1
;@ path: home/uncompress
LengthEncodingOffsetList::
	dw %0000000000000001
	dw %0000000000000011
	dw %0000000000000111
	dw %0000000000001111
	dw %0000000000011111
	dw %0000000000111111
	dw %0000000001111111
	dw %0000000011111111
	dw %0000000111111111
	dw %0000001111111111
	dw %0000011111111111
	dw %0000111111111111
	dw %0001111111111111
	dw %0011111111111111
	dw %0111111111111111
	dw %1111111111111111

; unpacks the sprite data depending on the unpack mode
;@ path: home/uncompress
;@ def UnpackSprite()
;@ Undo the encoding of the two decompressed planes: mode 0 decodes both planes, mode 1 decodes the second and
;@ XORs it into the first, mode 2 decodes both and then XORs.
;@ test: wSpriteWidth = 8 * rand(1, 7); wSpriteHeight = 8 * rand(1, 7); wSpriteUnpackMode = rand(0, 3)
UnpackSprite::
;> mode = wSpriteUnpackMode
	ld a, [wSpriteUnpackMode]
;> if mode == 2:
;>     return UnpackSpriteMode2()
	cp $2
	jp z, UnpackSpriteMode2
;> if mode:
;>     return XorSpriteChunks()
	and a
	jp nz, XorSpriteChunks
;> SpriteDifferentialDecode(sSpriteBuffer1)
	ld hl, sSpriteBuffer1
	call SpriteDifferentialDecode
;> SpriteDifferentialDecode(sSpriteBuffer2)
	ld hl, sSpriteBuffer2
	; fall through

; decodes differential encoded sprite data
; input bit value 0 preserves the current bit value and input bit value 1 toggles it (starting from initial value 0).
;@ path: home/uncompress
;@ def SpriteDifferentialDecode(buffer: hl)
;@ Decode the plane at buffer row by row (a row runs through all columns): every 1 bit flips the pixel
;@ colour, every 0 keeps it, starting each row with 0. Nybble by nybble through decoding tables (mirrored
;@ ones for a flipped picture).
;@ test: wSpriteWidth = 8 * rand(1, 7); wSpriteHeight = 8 * rand(1, 7); buffer = sSpriteBuffer1
SpriteDifferentialDecode::
;> wSpriteCurPosX = 0
	xor a
	ld [wSpriteCurPosX], a
;> wSpriteCurPosY = 0
	ld [wSpriteCurPosY], a
;> StoreSpriteOutputPointer(buffer)
	call StoreSpriteOutputPointer
;> if wSpriteFlipped:
	ld a, [wSpriteFlipped]
	and a
	jr z, .notFlipped
;>     t0, t1 = DecodeNybble0TableFlipped, DecodeNybble1TableFlipped
	ld hl, DecodeNybble0TableFlipped
	ld de, DecodeNybble1TableFlipped
	jr .storeDecodeTablesPointers
.notFlipped
;> else:
;>     t0, t1 = DecodeNybble0Table, DecodeNybble1Table
	ld hl, DecodeNybble0Table
	ld de, DecodeNybble1Table
.storeDecodeTablesPointers
;> wSpriteDecodeTable0Ptr[0] = lo(t0)
	ld a, l
	ld [wSpriteDecodeTable0Ptr], a
;> wSpriteDecodeTable0Ptr[1] = hi(t0)
	ld a, h
	ld [wSpriteDecodeTable0Ptr+1], a
;> wSpriteDecodeTable1Ptr[0] = lo(t1)
	ld a, e
	ld [wSpriteDecodeTable1Ptr], a
;> wSpriteDecodeTable1Ptr[1] = hi(t1)
	ld a, d
	ld [wSpriteDecodeTable1Ptr+1], a
;> last = 0
	ld e, $0                          ; last decoded nybble, initialized to 0
;> while True:
.decodeNextByteLoop
;>     p = wSpriteOutputPtr[0] | wSpriteOutputPtr[1] << 8
	ld a, [wSpriteOutputPtr]
	ld l, a
	ld a, [wSpriteOutputPtr+1]
	ld h, a
;>     byte = mem[p]
	ld a, [hl]
	ld b, a
;>     high, last = DifferentialDecodeNybble(byte >> 4, last)
	swap a
	and $f
	call DifferentialDecodeNybble     ; decode high nybble
;>     low, last = DifferentialDecodeNybble(byte & 0xF, last)
	swap a
	ld d, a
	ld a, b
	and $f
	call DifferentialDecodeNybble     ; decode low nybble
;>     v = high << 4 | low
	or d
	ld b, a
;>     p = wSpriteOutputPtr[0] | wSpriteOutputPtr[1] << 8
	ld a, [wSpriteOutputPtr]
	ld l, a
	ld a, [wSpriteOutputPtr+1]
	ld h, a
;>     mem[p] = v
	ld a, b
	ld [hl], a                        ; write back decoded data
;>     p = (p + wSpriteHeight) & 0xFFFF    # same row, next column
	ld a, [wSpriteHeight]
	add l                             ; move on to next column
	jr nc, .noCarry
	inc h
.noCarry
;>     wSpriteOutputPtr[0] = lo(p)
	ld [wSpriteOutputPtr], a
;>     wSpriteOutputPtr[1] = hi(p)
	ld a, h
	ld [wSpriteOutputPtr+1], a
;>     wSpriteCurPosX = u8(wSpriteCurPosX + 8)
	ld a, [wSpriteCurPosX]
	add $8
	ld [wSpriteCurPosX], a
;>     if wSpriteCurPosX != wSpriteWidth:
;>         continue
	ld b, a
	ld a, [wSpriteWidth]
	cp b
	jr nz, .decodeNextByteLoop        ; test if current row is done
;>     last = 0
	xor a
	ld e, a
;>     wSpriteCurPosX = 0
	ld [wSpriteCurPosX], a
;>     wSpriteCurPosY = u8(wSpriteCurPosY + 1)
	ld a, [wSpriteCurPosY]           ; move on to next row
	inc a
	ld [wSpriteCurPosY], a
;>     if wSpriteCurPosY == wSpriteHeight:
;>         break
	ld b, a
	ld a, [wSpriteHeight]
	cp b
	jr z, .done                       ; test if all rows finished
;>     p = (wSpriteOutputPtrCached[0] | wSpriteOutputPtrCached[1] << 8) + 1   # the next row's start
	ld a, [wSpriteOutputPtrCached]
	ld l, a
	ld a, [wSpriteOutputPtrCached+1]
	ld h, a
	inc hl
;>     StoreSpriteOutputPointer(p)
	call StoreSpriteOutputPointer
	jr .decodeNextByteLoop
.done
;> wSpriteCurPosY = 0
	xor a
	ld [wSpriteCurPosY], a
	ret

; decodes the nybble stored in a. Last decoded data is assumed to be in e (needed to determine if initial value is 0 or 1)
;@ path: home/uncompress
;@ def DifferentialDecodeNybble(nybble: a, last: e) -> (a, e)
;@ Decode 4 bits: the table depends on the colour the previous nybble ended with (its lowest bit, or its
;@ highest one for a flipped picture). Returns the decoded nybble twice.
DifferentialDecodeNybble::
;> index = nybble >> 1
	srl a               ; c=a%2, a/=2
;> odd = nybble & 1                    # (index kept aside)
	ld c, $0
	jr nc, .evenNumber
	ld c, $1
.evenNumber
	ld l, a
;> ended_with_1 = last & (8 if wSpriteFlipped else 1)
	ld a, [wSpriteFlipped]
	and a
	jr z, .notFlipped     ; determine if initial value is 0 or one
	bit 3, e              ; if flipped, consider MSB of last data
	jr .selectLookupTable
.notFlipped
	bit 0, e              ; else consider LSB
.selectLookupTable
;> if ended_with_1:
	ld e, l
	jr nz, .initialValue1 ; load the appropriate table
;>@t1     table = wSpriteDecodeTable1Ptr[0] | wSpriteDecodeTable1Ptr[1] << 8
;> else:
;>     table = wSpriteDecodeTable0Ptr[0] | wSpriteDecodeTable0Ptr[1] << 8
	ld a, [wSpriteDecodeTable0Ptr]
	ld l, a
	ld a, [wSpriteDecodeTable0Ptr+1]
	jr .tableLookup
.initialValue1
;=@t1
	ld a, [wSpriteDecodeTable1Ptr]
	ld l, a
	ld a, [wSpriteDecodeTable1Ptr+1]
.tableLookup
;> p = (table + index) & 0xFFFF
	ld h, a
	ld a, e
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
;> v = mem[p]
	ld a, [hl]
;> if not odd:
	bit 0, c
	jr nz, .selectLowNybble
;>     v = v >> 4    # two entries per table byte: even nybbles use the high half
	swap a  ; select high nybble
.selectLowNybble
;> v &= 0xF
	and $f
;> return (v, v)
	ld e, a ; update last decoded data
	ret

;@ path: home/uncompress
DecodeNybble0Table::
	db (($0) << 4) | ($1)
	db (($3) << 4) | ($2)
	db (($7) << 4) | ($6)
	db (($4) << 4) | ($5)
	db (($f) << 4) | ($e)
	db (($c) << 4) | ($d)
	db (($8) << 4) | ($9)
	db (($b) << 4) | ($a)
;@ path: home/uncompress
DecodeNybble1Table::
	db (($f) << 4) | ($e)
	db (($c) << 4) | ($d)
	db (($8) << 4) | ($9)
	db (($b) << 4) | ($a)
	db (($0) << 4) | ($1)
	db (($3) << 4) | ($2)
	db (($7) << 4) | ($6)
	db (($4) << 4) | ($5)
;@ path: home/uncompress
DecodeNybble0TableFlipped::
	db (($0) << 4) | ($8)
	db (($c) << 4) | ($4)
	db (($e) << 4) | ($6)
	db (($2) << 4) | ($a)
	db (($f) << 4) | ($7)
	db (($3) << 4) | ($b)
	db (($1) << 4) | ($9)
	db (($d) << 4) | ($5)
;@ path: home/uncompress
DecodeNybble1TableFlipped::
	db (($f) << 4) | ($7)
	db (($3) << 4) | ($b)
	db (($1) << 4) | ($9)
	db (($d) << 4) | ($5)
	db (($0) << 4) | ($8)
	db (($c) << 4) | ($4)
	db (($e) << 4) | ($6)
	db (($2) << 4) | ($a)

; combines the two loaded chunks with xor (the chunk loaded second is the destination). The source chunk is differential decoded beforehand.
;@ path: home/uncompress
;@ def XorSpriteChunks()
;@ Decode the plane wSpriteOutputPtr points at (see ResetSpriteBufferPointers), then XOR it into the other
;@ one, mirroring the other one's nybbles first for a flipped picture.
;@ test: wSpriteWidth = 8 * rand(1, 7); wSpriteHeight = 8 * rand(1, 7)
XorSpriteChunks::
;> wSpriteCurPosX = 0
	xor a
	ld [wSpriteCurPosX], a
;> wSpriteCurPosY = 0
	ld [wSpriteCurPosY], a
;> ResetSpriteBufferPointers()
	call ResetSpriteBufferPointers
;> SpriteDifferentialDecode(wSpriteOutputPtr[0] | wSpriteOutputPtr[1] << 8)
	ld a, [wSpriteOutputPtr]          ; points to buffer 1 or 2, depending on flags
	ld l, a
	ld a, [wSpriteOutputPtr+1]
	ld h, a
	call SpriteDifferentialDecode      ; decode buffer 1 or 2, depending on flags
;> ResetSpriteBufferPointers()
	call ResetSpriteBufferPointers
;> src = wSpriteOutputPtr[0] | wSpriteOutputPtr[1] << 8
	ld a, [wSpriteOutputPtr]          ; source buffer, points to buffer 1 or 2, depending on flags
	ld l, a
	ld a, [wSpriteOutputPtr+1]
	ld h, a
;> dest = wSpriteOutputPtrCached[0] | wSpriteOutputPtrCached[1] << 8
	ld a, [wSpriteOutputPtrCached]    ; destination buffer, points to buffer 2 or 1, depending on flags
	ld e, a
	ld a, [wSpriteOutputPtrCached+1]
	ld d, a
;> while True:
.xorChunksLoop
;>     if wSpriteFlipped:              # mirror the other plane's byte first
	ld a, [wSpriteFlipped]
	and a
	jr z, .notFlipped
;>         b = mem[dest]
	push de
	ld a, [de]
	ld b, a
;>         hi = swap(ReverseNybble(b >> 4))
	swap a
	and $f
	call ReverseNybble                 ; if flipped reverse the nybbles in the destination buffer
	swap a
	ld c, a
;>         mem[dest] = hi | ReverseNybble(b & 0xF)
	ld a, b
	and $f
	call ReverseNybble
	or c
	pop de
	ld [de], a
.notFlipped
;>     mem[dest] = mem[dest] ^ mem[src]
;>     src += 1
	ld a, [hli]
	ld b, a
	ld a, [de]
	xor b
	ld [de], a
;>     dest += 1
	inc de
;>     wSpriteCurPosY = u8(wSpriteCurPosY + 1)
	ld a, [wSpriteCurPosY]
	inc a
	ld [wSpriteCurPosY], a             ; go to next row
;>     if wSpriteCurPosY != wSpriteHeight:
;>         continue
	ld b, a
	ld a, [wSpriteHeight]
	cp b
	jr nz, .xorChunksLoop               ; test if column finished
;>     wSpriteCurPosY = 0              # the column is done
	xor a
	ld [wSpriteCurPosY], a
;>     wSpriteCurPosX = u8(wSpriteCurPosX + 8)
	ld a, [wSpriteCurPosX]
	add $8
	ld [wSpriteCurPosX], a             ; go to next column
;>     if wSpriteCurPosX == wSpriteWidth:
;>         break
	ld b, a
	ld a, [wSpriteWidth]
	cp b
	jr nz, .xorChunksLoop               ; test if all columns finished
;> wSpriteCurPosX = 0
	xor a
	ld [wSpriteCurPosX], a
	ret

; reverses the bits in the nybble given in register a
;@ path: home/uncompress
;@ def ReverseNybble(n: a) -> a
;@ The 4 bits of n in reverse order (from NybbleReverseTable).
;@ test: n = rand(0, 15)
ReverseNybble::
;> p = NybbleReverseTable + n
	ld de, NybbleReverseTable
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
;> return mem[p]
	ld a, [de]
	ret

; resets sprite buffer pointers to buffer 1 and 2, depending on wSpriteLoadFlags
;@ path: home/uncompress
;@ def ResetSpriteBufferPointers()
;@ Point wSpriteOutputPtr at the plane that was decompressed second and wSpriteOutputPtrCached at the one
;@ decompressed first (wSpriteLoadFlags tells which buffer that was).
ResetSpriteBufferPointers::
;> if wSpriteLoadFlags & 1 << BIT_USE_SPRITE_BUFFER_2:
	ld a, [wSpriteLoadFlags]
	bit BIT_USE_SPRITE_BUFFER_2, a
	jr nz, .buffer2Selected
;>     out, cached = addr(sSpriteBuffer1), addr(sSpriteBuffer2)
;> else:
;>     out, cached = addr(sSpriteBuffer2), addr(sSpriteBuffer1)
	ld de, sSpriteBuffer1
	ld hl, sSpriteBuffer2
	jr .storeBufferPointers
.buffer2Selected
	ld de, sSpriteBuffer2
	ld hl, sSpriteBuffer1
.storeBufferPointers
;> wSpriteOutputPtr[0] = lo(out)
	ld a, l
	ld [wSpriteOutputPtr], a
;> wSpriteOutputPtr[1] = hi(out)
	ld a, h
	ld [wSpriteOutputPtr+1], a
;> wSpriteOutputPtrCached[0] = lo(cached)
	ld a, e
	ld [wSpriteOutputPtrCached], a
;> wSpriteOutputPtrCached[1] = hi(cached)
	ld a, d
	ld [wSpriteOutputPtrCached+1], a
	ret

; maps each nybble to its reverse
;@ path: home/uncompress
NybbleReverseTable::
	db $0, $8, $4, $c, $2, $a, $6, $e, $1, $9, $5, $d, $3, $b, $7, $f

; combines the two loaded chunks with xor (the chunk loaded second is the destination). Both chunks are differential decoded beforehand.
;@ path: home/uncompress
;@ def UnpackSpriteMode2()
;@ Mode 2: decode the first plane (never mirrored), then decode the second and XOR it in (XorSpriteChunks).
;@ test: wSpriteWidth = 8 * rand(1, 7); wSpriteHeight = 8 * rand(1, 7)
UnpackSpriteMode2::
;> ResetSpriteBufferPointers()
	call ResetSpriteBufferPointers
;> saved = wSpriteFlipped
	ld a, [wSpriteFlipped]
	push af
;> wSpriteFlipped = 0
	xor a
	ld [wSpriteFlipped], a            ; temporarily clear flipped flag for decoding the destination chunk
;> SpriteDifferentialDecode(wSpriteOutputPtrCached[0] | wSpriteOutputPtrCached[1] << 8)
	ld a, [wSpriteOutputPtrCached]
	ld l, a
	ld a, [wSpriteOutputPtrCached+1]
	ld h, a
	call SpriteDifferentialDecode
;> ResetSpriteBufferPointers()
	call ResetSpriteBufferPointers
;> wSpriteFlipped = saved
	pop af
	ld [wSpriteFlipped], a
;> XorSpriteChunks()
	jp XorSpriteChunks

; stores hl into the output pointers
;@ path: home/uncompress
;@ def StoreSpriteOutputPointer(ptr: hl)
;@ Set both wSpriteOutputPtr and wSpriteOutputPtrCached to ptr.
StoreSpriteOutputPointer::
;> wSpriteOutputPtr[0] = lo(ptr)
	ld a, l
	ld [wSpriteOutputPtr], a
;> wSpriteOutputPtrCached[0] = lo(ptr)
	ld [wSpriteOutputPtrCached], a
;> wSpriteOutputPtr[1] = hi(ptr)
	ld a, h
	ld [wSpriteOutputPtr+1], a
;> wSpriteOutputPtrCached[1] = hi(ptr)
	ld [wSpriteOutputPtrCached+1], a
	ret
;@ path: home/reset_player_sprite
;@ def ResetPlayerSpriteData()
;@ Clear the player's two sprite records and put the player back in the middle of the screen, picture 1.
ResetPlayerSpriteData::
;> ResetPlayerSpriteData_ClearSpriteData(wSpriteStateData1)
;> ResetPlayerSpriteData_ClearSpriteData(wSpriteStateData2)
	ld hl, wSpriteStateData1
	call ResetPlayerSpriteData_ClearSpriteData
	ld hl, wSpriteStateData2
	call ResetPlayerSpriteData_ClearSpriteData
;> mem[addr(wSpritePlayerStateData1PictureID)] = 1
;> mem[addr(wSpritePlayerStateData2ImageBaseOffset)] = 1
	ld a, $1
	ld [wSpritePlayerStateData1PictureID], a
	ld [wSpritePlayerStateData2ImageBaseOffset], a
;> mem[addr(wSpritePlayerStateData1YPixels)] = 0x3C        # Y on screen
;> mem[addr(wSpritePlayerStateData1YPixels) + 2] = 0x40    # X on screen
	ld hl, wSpritePlayerStateData1YPixels
	ld [hl], $3c     ; set Y screen pos
	inc hl
	inc hl
	ld [hl], $40     ; set X screen pos
	ret

; overwrites sprite data with zeroes
;@ path: home/reset_player_sprite
;@ def ResetPlayerSpriteData_ClearSpriteData(dest: hl) -> hl
;@ Zero one sprite record (SPRITESTATEDATA1_LENGTH bytes) at dest.
ResetPlayerSpriteData_ClearSpriteData::
;> return FillMemory(dest, SPRITESTATEDATA1_LENGTH, 0)
	ld bc, SPRITESTATEDATA1_LENGTH
	ASSERT SPRITESTATEDATA2_LENGTH == SPRITESTATEDATA1_LENGTH
	xor a
	jp FillMemory
;@ path: home/fade_audio
;@ def FadeOutAudio()
;@ Runs every frame. While a fade-out is going on, turn the master volume down one step every few frames; at
;@ silence, stop the music and start the song that was waiting in wAudioFadeOutControl. Otherwise keep the
;@ volume at full, unless fading is switched off.
FadeOutAudio::
;> if wAudioFadeOutControl == 0:       # no fade-out going on
	ld a, [wAudioFadeOutControl]
	and a ; currently fading out audio?
	jr nz, .fadingOut
;>     if wStatusFlags2 >> BIT_NO_AUDIO_FADE_OUT & 1:
;>         return
	ld a, [wStatusFlags2]
	bit BIT_NO_AUDIO_FADE_OUT, a
	ret nz
;>     rAUDVOL = 0x77                  # both speakers at full volume
;>     return
	ld a, $77
	ldh [rAUDVOL], a
	ret
.fadingOut
;> if wAudioFadeOutCounter:            # not yet time for the next step
	ld a, [wAudioFadeOutCounter]
	and a
	jr z, .counterReachedZero
;>     wAudioFadeOutCounter -= 1
;>     return
	dec a
	ld [wAudioFadeOutCounter], a
	ret
.counterReachedZero
;> wAudioFadeOutCounter = wAudioFadeOutCounterReloadValue
	ld a, [wAudioFadeOutCounterReloadValue]
	ld [wAudioFadeOutCounter], a
;> vol = rAUDVOL
;> if vol:
	ldh a, [rAUDVOL]
	and a ; has the volume reached 0?
	jr z, .fadeOutComplete
;>     right = ((vol & 0x0F) - 1) & 0xFF
	ld b, a
	and $f
	dec a
	ld c, a
;>     left = ((vol >> 4) - 1) & 0xFF
	ld a, b
	and $f0
	swap a
	dec a
;>     rAUDVOL = ((left << 4 | left >> 4) & 0xFF) | right   # one step quieter on both sides
;>     return
	swap a
	or c
	ldh [rAUDVOL], a
	ret
.fadeOutComplete
;> next_song = wAudioFadeOutControl    # silent: the waiting song starts
;> wAudioFadeOutControl = 0
	ld a, [wAudioFadeOutControl]
	ld b, a
	xor a
	ld [wAudioFadeOutControl], a
;> wNewSoundID = SFX_STOP_ALL_MUSIC
;> PlaySound(SFX_STOP_ALL_MUSIC)
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
;> wAudioROMBank = wAudioSavedROMBank
	ld a, [wAudioSavedROMBank]
	ld [wAudioROMBank], a
;> wNewSoundID = next_song
;> return PlaySound(next_song)
	ld a, b
	ld [wNewSoundID], a
	jp PlaySound
; this function is used to display sign messages, sprite dialog, etc.
; INPUT: [hSpriteIndex] = sprite ID or [hTextID] = text ID
;@ path: home/text_script
;@ def DisplayTextID()
;@ Show text hTextID of the current map: a person's or sign's text from the map's text list, or one of the
;@ special ids (start menu, fainted, blacked out, repel wore off, Safari game over). Texts that start with a
;@ script byte open the mart, the nurse, a PC, a vending machine... The ROM bank in use stays on the stack
;@ until CloseTextDisplay puts it back.
DisplayTextID::
;> saved = hLoadedROMBank              # stays on the stack until CloseTextDisplay
	ASSERT hSpriteIndex == hTextID ; these are at the same memory location
	ldh a, [hLoadedROMBank]
	push af
;> DisplayTextIDInit()
	; initialization
	ld b, BANK(DisplayTextIDInit)
	ld hl, DisplayTextIDInit
	call Bankswitch
;> predef = wTextPredefFlag >> BIT_TEXT_PREDEF & 1
	ld hl, wTextPredefFlag
	bit BIT_TEXT_PREDEF, [hl]
;> wTextPredefFlag &= ~(1 << BIT_TEXT_PREDEF) & 0xFF
	res BIT_TEXT_PREDEF, [hl]
;> if not predef:
	jr nz, .skipSwitchToMapBank
;>     SwitchToMapRomBank(wCurMap)
	ld a, [wCurMap]
	call SwitchToMapRomBank
.skipSwitchToMapBank
;> hFrameCounter = 30                  # half a second: the joypad poll timer
	ld a, 30 ; half a second
	ldh [hFrameCounter], a ; used as joypad poll timer
;> texts = wCurMapTextPtr[0] | wCurMapTextPtr[1] << 8   # the map's text list
	ld hl, wCurMapTextPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = map text pointer
;> id = hTextID
	ld d, $00
	ldh a, [hTextID]
;> wSpriteIndex = id
	ld [wSpriteIndex], a

;> if id == TEXT_START_MENU:
;>     return DisplayStartMenu(saved)
	and a
	jp z, DisplayStartMenu
;> if id == TEXT_SAFARI_GAME_OVER:
;>     return DisplaySafariGameOverText(saved)
	cp TEXT_SAFARI_GAME_OVER
	jp z, DisplaySafariGameOverText
;> if id == TEXT_MON_FAINTED:
;>     return DisplayPokemonFaintedText(saved)
	cp TEXT_MON_FAINTED
	jp z, DisplayPokemonFaintedText
;> if id == TEXT_BLACKED_OUT:
;>     return DisplayPlayerBlackedOutText(saved)
	cp TEXT_BLACKED_OUT
	jp z, DisplayPlayerBlackedOutText
;> if id == TEXT_REPEL_WORE_OFF:
;>     return DisplayRepelWoreOffText(saved)
	cp TEXT_REPEL_WORE_OFF
	jp z, DisplayRepelWoreOffText

;> if id <= wNumSprites:               # a person: they turn to the player, then their text id counts
	ld a, [wNumSprites]
	ld e, a
	ldh a, [hSpriteIndex] ; sprite ID
	cp e
	jr z, .spriteHandling
	jr nc, .skipSpriteHandling
.spriteHandling
; get the text ID of the sprite
;>     UpdateSpriteFacingOffsetAndDelayMovement()
	push hl
	push de
	push bc
	; update the graphics of the sprite the player is talking to (to face the right direction)
	ld b, BANK(UpdateSpriteFacingOffsetAndDelayMovement)
	ld hl, UpdateSpriteFacingOffsetAndDelayMovement
	call Bankswitch
;>@entry     entry = addr(wMapSpriteData) + u8((id - 1) * 2)
	pop bc
	pop de
	ld hl, wMapSpriteData ; NPC text entries
	ldh a, [hSpriteIndex]
	dec a
	add a
;=@entry
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
;>     id = mem[entry + 1]             # the person's text id
	inc hl
	ld a, [hl] ; a = text ID of the sprite
	pop hl
.skipSpriteHandling
; look up the address of the text in the map's text entries
;> offset = u8(id - 1) * 2 & 0xFF
	dec a
	ld e, a
	sla e
;> text = mem16[texts + offset]
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = address of the text
;> first = mem[text]                   # a script byte opens something else
	ld a, [hl] ; a = first byte of text

; check first byte of text for special cases


;> if first == u8(TX_SCRIPT_MART):
;>     return DisplayPokemartDialogue(text, saved)
	cp TX_SCRIPT_MART
	jp z, DisplayPokemartDialogue
;> if first == u8(TX_SCRIPT_POKECENTER_NURSE):
;>     return DisplayPokemonCenterDialogue(text, saved)
	cp TX_SCRIPT_POKECENTER_NURSE
	jp z, DisplayPokemonCenterDialogue
;> if first == u8(TX_SCRIPT_PLAYERS_PC):
;>     return TextScript_ItemStoragePC()
	cp TX_SCRIPT_PLAYERS_PC
	jp z, TextScript_ItemStoragePC
;> if first == u8(TX_SCRIPT_BILLS_PC):
;>     return TextScript_BillsPC()
	cp TX_SCRIPT_BILLS_PC
	jp z, TextScript_BillsPC
;> if first == u8(TX_SCRIPT_POKECENTER_PC):
;>     return TextScript_PokemonCenterPC()
	cp TX_SCRIPT_POKECENTER_PC
	jp z, TextScript_PokemonCenterPC
;> if first == u8(TX_SCRIPT_VENDING_MACHINE):
	cp TX_SCRIPT_VENDING_MACHINE
	jr nz, .not_u2
;>     VendingMachineMenu()
	ld b, BANK(VendingMachineMenu)
	ld hl, VendingMachineMenu
	call Bankswitch
;>     return AfterDisplayingTextID(saved)
	jr AfterDisplayingTextID
.not_u2
;> if first == u8(TX_SCRIPT_PRIZE_VENDOR):
;>     return TextScript_GameCornerPrizeMenu()
	cp TX_SCRIPT_PRIZE_VENDOR
	jp z, TextScript_GameCornerPrizeMenu
;> if first == u8(TX_SCRIPT_CABLE_CLUB_RECEPTIONIST):
	cp TX_SCRIPT_CABLE_CLUB_RECEPTIONIST
	jr nz, .not_u3
;>     CableClubNPC()
	ld hl, CableClubNPC
	ld b, BANK(CableClubNPC)
	call Bankswitch
;>     return AfterDisplayingTextID(saved)
	jr AfterDisplayingTextID
.not_u3

;> PrintText_NoCreatingTextBox(text)   # an ordinary text
	call PrintText_NoCreatingTextBox
;> if wDoNotWaitForButtonPressAfterDisplayingText:
;>     return HoldTextDisplayOpen(saved)
	ld a, [wDoNotWaitForButtonPressAfterDisplayingText]
	and a
	jr nz, HoldTextDisplayOpen
;> return AfterDisplayingTextID(saved) # it follows right below

;@ path: home/text_script
;@ def AfterDisplayingTextID(saved)
;@ After a text: wait for A or B (not when entering the Cable Club), then close the text box.
;@ test: skip saved is the ROM bank DisplayTextID left on the stack
AfterDisplayingTextID::
;> if not wEnteringCableClub[0]:
	ld a, [wEnteringCableClub]
	and a
	jr nz, HoldTextDisplayOpen
;>     WaitForTextScrollButtonPress()
	call WaitForTextScrollButtonPress
;> return HoldTextDisplayOpen(saved)

; loop to hold the dialogue box open as long as the player keeps holding down the A button
;@ path: home/text_script
;@ def HoldTextDisplayOpen(saved)
;@ Keep the text box open while A is held down, then close it.
;@ test: skip saved is the ROM bank DisplayTextID left on the stack
HoldTextDisplayOpen::
;> while True:
;>     Joypad()
	call Joypad
;>     if not hJoyHeld & PAD_A:
;>         break
	ldh a, [hJoyHeld]
	bit B_PAD_A, a
	jr nz, HoldTextDisplayOpen
;> return CloseTextDisplay(saved)      # it follows right below

;@ path: home/text_script
;@ def CloseTextDisplay(saved)
;@ Close the text box: move the window off the screen, turn every person back the way they faced before the
;@ talk, reload the sprite graphics the font tiles covered and the map view, then put back the ROM bank saved
;@ by DisplayTextID.
;@ test: skip saved is the ROM bank DisplayTextID left on the stack
CloseTextDisplay::
;> SwitchToMapRomBank(wCurMap)
	ld a, [wCurMap]
	call SwitchToMapRomBank
;> hWY = 0x90                          # the window off the screen
	ld a, $90
	ldh [hWY], a ; move the window off the screen
;> DelayFrame()
	call DelayFrame
;> LoadGBPal()
	call LoadGBPal
;> hAutoBGTransferEnabled = 0
	xor a
	ldh [hAutoBGTransferEnabled], a ; disable continuous WRAM to VRAM transfer each V-blank
; loop to make sprites face the directions they originally faced before the dialogue
;>@each for i in range(NUM_SPRITESTATEDATA_STRUCTS - 1):   # everybody faces the way they did before
	ld hl, wSprite01StateData2OrigFacingDirection
	ld c, NUM_SPRITESTATEDATA_STRUCTS - 1
	ld de, SPRITESTATEDATA1_LENGTH
;>     a = wSprite01StateData2OrigFacingDirection + i * SPRITESTATEDATA1_LENGTH
;>     mem[a - 0x100] = mem[a]         # facing direction = original facing direction
.restoreSpriteFacingDirectionLoop
	ld a, [hl] ; x#SPRITESTATEDATA2_ORIGFACINGDIRECTION
	dec h
	ld [hl], a ; [x#SPRITESTATEDATA1_FACINGDIRECTION]
	inc h
;=@each
	add hl, de
	dec c
	jr nz, .restoreSpriteFacingDirectionLoop
;> hLoadedROMBank = BANK(InitMapSprites)
	ld a, BANK(InitMapSprites)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(InitMapSprites))
	ld [rROMB], a
;> InitMapSprites()                    # the font covered part of the sprites' tiles
	call InitMapSprites ; reload sprite tile pattern data (since it was partially overwritten by text tile patterns)
;> wFontLoaded &= ~(1 << BIT_FONT_LOADED) & 0xFF
	ld hl, wFontLoaded
	res BIT_FONT_LOADED, [hl]
;> if not wStatusFlags6 >> BIT_FLY_WARP & 1:
;>     LoadPlayerSpriteGraphics()
	ld a, [wStatusFlags6]
	bit BIT_FLY_WARP, a
	call z, LoadPlayerSpriteGraphics
;> LoadCurrentMapView()
	call LoadCurrentMapView
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
;> return UpdateSprites()
	jp UpdateSprites

;@ path: home/text_script
;@ def DisplayPokemartDialogue(text: hl, saved)
;@ A mart clerk: greet, load the items for sale (they follow the script byte) and open the buy / sell menu.
;@ test: skip saved is the ROM bank DisplayTextID left on the stack
DisplayPokemartDialogue::
;> PrintText(PokemartGreetingText)
	push hl
	ld hl, PokemartGreetingText
	call PrintText
;> LoadItemList(text + 1)              # the items follow the script byte
	pop hl
	inc hl
	call LoadItemList
;> wListMenuID = PRICEDITEMLISTMENU
	ld a, PRICEDITEMLISTMENU
	ld [wListMenuID], a
;> saved_bank = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(DisplayPokemartDialogue_)
	ld a, BANK(DisplayPokemartDialogue_)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(DisplayPokemartDialogue_))
	ld [rROMB], a
;> DisplayPokemartDialogue_()
	call DisplayPokemartDialogue_
;> hLoadedROMBank = saved_bank
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved_bank)
	ld [rROMB], a
;> return AfterDisplayingTextID(saved)
	jp AfterDisplayingTextID

;@ path: home/text_script
PokemartGreetingText::
	db TX_FAR
	dw _PokemartGreetingText
	db BANK(_PokemartGreetingText)
	db TX_END

;@ path: home/text_script
;@ def LoadItemList(items: hl)
;@ Copy an item list ended by $FF to wItemList, remembering where it came from (wItemListPointer, high byte
;@ first).
;@ test: items = rand_ram(20); n = rand(0, 15); [mem.__setitem__(items + i, rand(0, 0xFE)) for i in range(n)]; mem[items + n] = 0xFF
LoadItemList::
;> wUpdateSpritesEnabled = 1
	ld a, 1
	ld [wUpdateSpritesEnabled], a
;> wItemListPointer[0] = hi(items)
	ld a, h
	ld [wItemListPointer], a
;> wItemListPointer[1] = lo(items)
	ld a, l
	ld [wItemListPointer + 1], a
;> i = 0
	ld de, wItemList
;> while True:
.loop
;>     c = mem[items + i]
	ld a, [hli]
;>     wItemList[i] = c
	ld [de], a
;>     i += 1
	inc de
;>     if c == 0xFF:
;>         return
	cp $ff
	jr nz, .loop
	ret

;@ path: home/text_script
;@ def DisplayPokemonCenterDialogue(text: hl, saved)
;@ The Pokémon Center nurse: heal the party if the player wants.
;@ test: skip saved is the ROM bank DisplayTextID left on the stack
DisplayPokemonCenterDialogue::
; zeroing these doesn't appear to serve any purpose
;> hItemPrice[0] = hItemPrice[1] = hItemPrice[2] = 0
	xor a
	ldh [hItemPrice], a
	ldh [hItemPrice + 1], a
	ldh [hItemPrice + 2], a

;> saved_bank = hLoadedROMBank         # (text moves past the script byte)
	inc hl
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(DisplayPokemonCenterDialogue_)
	ld a, BANK(DisplayPokemonCenterDialogue_)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(DisplayPokemonCenterDialogue_))
	ld [rROMB], a
;> DisplayPokemonCenterDialogue_()
	call DisplayPokemonCenterDialogue_
;> hLoadedROMBank = saved_bank
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved_bank)
	ld [rROMB], a
;> return AfterDisplayingTextID(saved)
	jp AfterDisplayingTextID

;@ path: home/text_script
;@ def DisplaySafariGameOverText(saved)
;@ The Safari Zone's "time's up" text.
;@ test: skip saved is the ROM bank DisplayTextID left on the stack
DisplaySafariGameOverText::
;> PrintSafariGameOverText()
;> return AfterDisplayingTextID(saved)
	ld hl, PrintSafariGameOverText
	ld b, BANK(PrintSafariGameOverText)
	call Bankswitch
	jp AfterDisplayingTextID

;@ path: home/text_script
;@ def DisplayPokemonFaintedText(saved)
;@ The text when a Pokémon faints from poison while walking.
;@ test: skip saved is the ROM bank DisplayTextID left on the stack
DisplayPokemonFaintedText::
;> PrintText(PokemonFaintedText)
;> return AfterDisplayingTextID(saved)
	ld hl, PokemonFaintedText
	call PrintText
	jp AfterDisplayingTextID

;@ path: home/text_script
PokemonFaintedText::
	db TX_FAR
	dw _PokemonFaintedText
	db BANK(_PokemonFaintedText)
	db TX_END

;@ path: home/text_script
;@ def DisplayPlayerBlackedOutText(saved)
;@ "<PLAYER> blacked out!": the player gets off the bike too.
;@ test: skip saved is the ROM bank DisplayTextID left on the stack
DisplayPlayerBlackedOutText::
;> PrintText(PlayerBlackedOutText)
	ld hl, PlayerBlackedOutText
	call PrintText
;> wStatusFlags6 &= ~(1 << BIT_ALWAYS_ON_BIKE) & 0xFF
	ld a, [wStatusFlags6]
	res BIT_ALWAYS_ON_BIKE, a
	ld [wStatusFlags6], a
;> return HoldTextDisplayOpen(saved)
	jp HoldTextDisplayOpen

;@ path: home/text_script
PlayerBlackedOutText::
	db TX_FAR
	dw _PlayerBlackedOutText
	db BANK(_PlayerBlackedOutText)
	db TX_END

;@ path: home/text_script
;@ def DisplayRepelWoreOffText(saved)
;@ The text when a Repel runs out.
;@ test: skip saved is the ROM bank DisplayTextID left on the stack
DisplayRepelWoreOffText::
;> PrintText(RepelWoreOffText)
;> return AfterDisplayingTextID(saved)
	ld hl, RepelWoreOffText
	call PrintText
	jp AfterDisplayingTextID

;@ path: home/text_script
RepelWoreOffText::
	db TX_FAR
	dw _RepelWoreOffText
	db BANK(_RepelWoreOffText)
	db TX_END
;@ path: home/start_menu
;@ def DisplayStartMenu(saved)
;@ Open the start menu with its sound.
;@ test: skip saved is the ROM bank DisplayTextID left on the stack
DisplayStartMenu::
;> hLoadedROMBank = BANK(StartMenu_Pokedex)
	ld a, BANK(StartMenu_Pokedex)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(StartMenu_Pokedex))
	ld [rROMB], a
;> wWalkBikeSurfStateCopy = wWalkBikeSurfState
	ld a, [wWalkBikeSurfState] ; walking/biking/surfing
	ld [wWalkBikeSurfStateCopy], a
;> PlaySound(0x8F)                     # SFX_START_MENU
	ld a, SFX_START_MENU
	call PlaySound
;> return RedisplayStartMenu(saved)    # it follows right below

;@ path: home/start_menu
;@ def RedisplayStartMenu(saved)
;@ Draw the start menu and run it: Up past the top wraps to the bottom item and Down past the bottom to the top
;@ (POKéDEX is only there once the player has it). A opens the item; B or START closes the menu.
;@ test: skip saved is the ROM bank DisplayTextID left on the stack
RedisplayStartMenu::
;> DrawStartMenu()
	ld b, BANK(DrawStartMenu)
	ld hl, DrawStartMenu
	call Bankswitch
;> PrintSafariZoneSteps()              # in the Safari Zone
	; print Safari Zone info, if in Safari Zone
	ld b, BANK(PrintSafariZoneSteps)
	ld hl, PrintSafariZoneSteps
	call Bankswitch
;> UpdateSprites()
	call UpdateSprites
;> while True:
;>     keys = HandleMenuInput()
.loop
	call HandleMenuInput
	ld b, a
; check if Up pressed
;>     if keys & PAD_UP:
	bit B_PAD_UP, a
	jr z, .checkIfDownPressed
;>         if wCurrentMenuItem == 0 and wLastMenuItem == 0:   # past the top item: round to the bottom
	ld a, [wCurrentMenuItem] ; menu selection
	and a
	jr nz, .loop
	ld a, [wLastMenuItem]
	and a
	jr nz, .loop
; if the player pressed tried to go past the top item, wrap around to the bottom
;>             wCurrentMenuItem = 6 if event(EVENT_GOT_POKEDEX) else 5
	ld a, [wEventFlags + $4]
	bit (EVENT_GOT_POKEDEX) % 8, a
	ld a, 6 ; there are 7 menu items with the pokedex, so the max index is 6
	jr nz, .wrapMenuItemId
	dec a ; there are only 6 menu items without the pokedex
.wrapMenuItemId
	ld [wCurrentMenuItem], a
;>             EraseMenuCursor()
	call EraseMenuCursor
;>         continue
	jr .loop
.checkIfDownPressed
;>     if keys & PAD_DOWN:
	bit B_PAD_DOWN, a
	jr z, .buttonPressed
; if the player pressed tried to go past the bottom item, wrap around to the top
;>         last = 7 if event(EVENT_GOT_POKEDEX) else 6   # one past the bottom item
	ld a, [wEventFlags + $4]
	bit (EVENT_GOT_POKEDEX) % 8, a
	ld a, [wCurrentMenuItem]
	ld c, 7 ; there are 7 menu items with the pokedex
	jr nz, .checkIfPastBottom
	dec c ; there are only 6 menu items without the pokedex
.checkIfPastBottom
;>         if wCurrentMenuItem == last:
	cp c
	jr nz, .loop
; the player went past the bottom, so wrap to the top
;>             wCurrentMenuItem = 0
	xor a
	ld [wCurrentMenuItem], a
;>             EraseMenuCursor()
	call EraseMenuCursor
;>         continue
	jr .loop
;>     break                           # A, B or START
.buttonPressed ; A, B, or Start button pressed
;> PlaceUnfilledArrowMenuCursor(keys)
	call PlaceUnfilledArrowMenuCursor
;> wBattleAndStartSavedMenuItem = wCurrentMenuItem
	ld a, [wCurrentMenuItem]
	ld [wBattleAndStartSavedMenuItem], a ; save current menu selection
;> if keys & (PAD_B | PAD_START):
;>     return CloseStartMenu(saved)
	ld a, b
	and PAD_B | PAD_START ; was the Start button or B button pressed?
	jp nz, CloseStartMenu
;> SaveScreenTilesToBuffer2()
	call SaveScreenTilesToBuffer2 ; copy background from wTileMap to wTileMapBackup2
;> item = wCurrentMenuItem if event(EVENT_GOT_POKEDEX) else wCurrentMenuItem + 1   # no POKéDEX item yet
	ld a, [wEventFlags + $4]
	bit (EVENT_GOT_POKEDEX) % 8, a
	ld a, [wCurrentMenuItem]
	jr nz, .displayMenuItem
	inc a ; adjust position to account for missing pokedex menu item
.displayMenuItem
;> if item == 0:
;>     return StartMenu_Pokedex()
	cp 0
	jp z, StartMenu_Pokedex
;> if item == 1:
;>     return StartMenu_Pokemon()
	cp 1
	jp z, StartMenu_Pokemon
;> if item == 2:
;>     return StartMenu_Item()
	cp 2
	jp z, StartMenu_Item
;> if item == 3:
;>     return StartMenu_TrainerInfo()
	cp 3
	jp z, StartMenu_TrainerInfo
;> if item == 4:
;>     return StartMenu_SaveReset()
	cp 4
	jp z, StartMenu_SaveReset
;> if item == 5:
;>     return StartMenu_Option()
	cp 5
	jp z, StartMenu_Option
;> return CloseStartMenu(saved)        # EXIT: it follows right below

; EXIT falls through to here
;@ path: home/start_menu
;@ def CloseStartMenu(saved)
;@ Close the start menu once A is let go.
;@ test: skip saved is the ROM bank DisplayTextID left on the stack
CloseStartMenu::
;> while True:
;>     Joypad()
	call Joypad
;>     if not hJoyPressed & PAD_A:
;>         break
	ldh a, [hJoyPressed]
	bit B_PAD_A, a
	jr nz, CloseStartMenu
;> LoadTextBoxTilePatterns()
	call LoadTextBoxTilePatterns
;> return CloseTextDisplay(saved)
	jp CloseTextDisplay
; function to count how many bits are set in a string of bytes
; INPUT:
; hl = address of string of bytes
; b = length of string of bytes
; OUTPUT:
; [wNumSetBits] = number of set bits
;@ def CountSetBits(src: hl, count: b) -> a
;@ Count the bits set in the count bytes at src. The total goes to wNumSetBits as well.
;@ writes: wNumSetBits
;@ test: count = rand(1, 40); src = rand_ram(40)
CountSetBits::
;> total = 0
	ld c, 0
;>@by for i in range(count):
;>     byte = mem[src + i]
.loop
	ld a, [hli]
	ld e, a
;>@bt     for bit in range(8):
	ld d, 8
.innerLoop ; count how many bits are set in the current byte
;>         total += byte >> bit & 1
	srl e
	ld a, 0
	adc c
	ld c, a
;=@bt
	dec d
	jr nz, .innerLoop
;=@by
	dec b
	jr nz, .loop
;> wNumSetBits = total
	ld a, c
	ld [wNumSetBits], a
;> return total
	ret
;@ path: home/inventory
;@ def SubtractAmountPaidFromMoney()
;@ Take the price in hMoney from the player's money (SubtractAmountPaidFromMoney_, in its own bank).
SubtractAmountPaidFromMoney::
;> SubtractAmountPaidFromMoney_()
;> set_rom_bank(hLoadedROMBank)    # a far call returns to the bank in hLoadedROMBank
	ld b, BANK(SubtractAmountPaidFromMoney_)
	ld hl, SubtractAmountPaidFromMoney_
	jp Bankswitch

; adds the amount the player sold to their money
;@ path: home/inventory
;@ def AddAmountSoldToMoney()
;@ Add the 3-byte BCD sale total in hMoney to the player's money, redraw the money box and play the
;@ purchase sound.
AddAmountSoldToMoney::
;> AddBCD(wPlayerMoney + 2, hMoney + 2, 3)    # through the AddBCDPredef predef
	ld de, wPlayerMoney + 2
	ld hl, hMoney + 2 ; total price of items
	ld c, 3 ; length of money in bytes
	; add total price to money
	ld a, (AddBCDPredefPredef - PredefPointers) / 3
	call Predef
;> wTextBoxID = MONEY_BOX
;> DisplayTextBoxID()
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID ; redraw money text box
;> PlaySoundWaitForCurrent(SFX_PURCHASE)
;> WaitForSoundToFinish()
	ld a, SFX_PURCHASE
	call PlaySoundWaitForCurrent
	jp WaitForSoundToFinish

; function to remove an item (in varying quantities) from the player's bag or PC box
; INPUT:
; HL = address of inventory (either wNumBagItems or wNumBoxItems)
; [wWhichPokemon] = index (within the inventory) of the item to remove
; [wItemQuantity] = quantity to remove
;@ path: home/inventory
;@ def RemoveItemFromInventory(inventory: hl)
;@ Remove wItemQuantity of the item at index wWhichPokemon from `inventory` (the bag or the PC box).
;@ test: inventory = rand_ram(64)
RemoveItemFromInventory::
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(RemoveItemFromInventory_)
	ld a, BANK(RemoveItemFromInventory_)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(RemoveItemFromInventory_))
	ld [rROMB], a
;> RemoveItemFromInventory_(inventory)
	call RemoveItemFromInventory_
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret

; function to add an item (in varying quantities) to the player's bag or PC box
; INPUT:
; HL = address of inventory (either wNumBagItems or wNumBoxItems)
; [wCurItem] = item ID
; [wItemQuantity] = item quantity
; sets carry flag if successful, unsets carry flag if unsuccessful
;@ path: home/inventory
;@ def AddItemToInventory(inventory: hl) -> carry
;@ Add wItemQuantity of wCurItem to `inventory` (the bag or the PC box): carry if it fit. Keeps bc.
;@ test: inventory = rand_ram(64)
AddItemToInventory::
;> saved_bank = hLoadedROMBank
	push bc
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(AddItemToInventory_)
	ld a, BANK(AddItemToInventory_)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(AddItemToInventory_))
	ld [rROMB], a
;> added = AddItemToInventory_(inventory)
	call AddItemToInventory_
;> hLoadedROMBank = saved_bank
	pop bc
	ld a, b
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved_bank)
	ld [rROMB], a
;> return added
	pop bc
	ret
; INPUT:
; [wListMenuID] = list menu ID
; [wListPointer] = address of the list (2 bytes)
;@ path: home/list_menu
;@ def DisplayListMenuID() -> carry
;@ Open a scrolling list menu (items, moves, a mart's goods, Pokémon in the PC) for the list at wListPointer:
;@ its first byte is the number of entries, then the entries ($FF ends the list, item lists have a quantity
;@ after each item). Shows up to four entries and CANCEL, and runs the menu until the player picks one (its
;@ name lands in wStringBuffer) or cancels (carry set).
;@ test: skip waits for the player
DisplayListMenuID::
;> hAutoBGTransferEnabled = 0
	xor a
	ldh [hAutoBGTransferEnabled], a ; disable auto-transfer
;> hJoy7 = 1                           # the joypad state is updated
	ld a, 1
	ldh [hJoy7], a ; joypad state update flag
;> bank = BANK(DisplayBattleMenu) if wBattleType else 1   # the Old Man's demonstration uses the battle menu's bank
	ld a, [wBattleType]
	and a ; is it the Old Man battle?
	jr nz, .specialBattleType
	ld a, $01 ; hardcoded bank
	jr .bankswitch
.specialBattleType ; Old Man battle
	ld a, BANK(DisplayBattleMenu)
.bankswitch
;> BankswitchHome(bank)
	call BankswitchHome
;> wStatusFlags5 |= 1 << BIT_NO_TEXT_DELAY
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
;> wMenuItemToSwap = 0                 # no item being swapped
	xor a
	ld [wMenuItemToSwap], a ; 0 means no item is currently being swapped
;> wListCount = 0
	ld [wListCount], a
;> wListCount = mem[wListPointer[0] | wListPointer[1] << 8]   # the list's first byte: the number of entries
	ld a, [wListPointer]
	ld l, a
	ld a, [wListPointer + 1]
	ld h, a ; hl = address of the list
	ld a, [hl] ; the first byte is the number of entries in the list
	ld [wListCount], a
;> wTextBoxID = LIST_MENU_BOX
	ld a, LIST_MENU_BOX
	ld [wTextBoxID], a
;> DisplayTextBoxID()
	call DisplayTextBoxID ; draw the menu text box
;> UpdateSprites()
	call UpdateSprites ; disable sprites behind the text box
;> # (the box corner and size set up here are not used)
; the code up to .skipMovingSprites appears to be useless
	; coordinates of upper left corner of menu text box
	ld hl, (2) * SCREEN_WIDTH + (4) + wTileMap
	; height and width of menu text box
	ld de, ((9) & $ff) << 8 + ((14) & $ff)
;> if wListMenuID == PCPOKEMONLISTMENU:
;>     UpdateSprites()
	ld a, [wListMenuID]
	and a ; PCPOKEMONLISTMENU?
	jr nz, .skipMovingSprites
	call UpdateSprites
.skipMovingSprites
;> wMenuWatchMovingOutOfBounds = 1
	ld a, 1 ; max menu item ID is 1 if the list has less than 2 entries
	ld [wMenuWatchMovingOutOfBounds], a
;> wMaxMenuItem = 1 if wListCount < 2 else 2
	ld a, [wListCount]
	cp 2 ; does the list have less than 2 entries?
	jr c, .setMenuVariables
	ld a, 2 ; max menu item ID is 2 if the list has at least 2 entries
.setMenuVariables
	ld [wMaxMenuItem], a
;> wTopMenuItemY = 4
	ld a, 4
	ld [wTopMenuItemY], a
;> wTopMenuItemX = 5
	ld a, 5
	ld [wTopMenuItemX], a
;> wMenuWatchedKeys = PAD_A | PAD_B | PAD_SELECT
	ld a, PAD_A | PAD_B | PAD_SELECT
	ld [wMenuWatchedKeys], a
;> DelayFrames(10)
	ld c, 10
	call DelayFrames
;> return DisplayListMenuIDLoop()      # it follows right below

;@ path: home/list_menu
;@ def DisplayListMenuIDLoop() -> carry
;@ The list menu's loop: print the visible entries, wait for a key. A picks the entry under the cursor (CANCEL
;@ or an empty list leaves through ExitListMenu), B cancels, SELECT starts swapping two items, Up and Down
;@ scroll the list. In the Old Man's catching demonstration the first entry is picked by itself.
;@ test: skip waits for the player
DisplayListMenuIDLoop::
;> while True:
;>     hAutoBGTransferEnabled = 0
	xor a
	ldh [hAutoBGTransferEnabled], a ; disable transfer
;>     PrintListMenuEntries()
	call PrintListMenuEntries
;>     hAutoBGTransferEnabled = 1
	ld a, 1
	ldh [hAutoBGTransferEnabled], a ; enable transfer
;>     Delay3()
	call Delay3
;>     if wBattleType:                 # the Old Man's demonstration: the first entry is picked by itself
	ld a, [wBattleType]
	and a ; is it the Old Man battle?
	jr z, .notOldManBattle
; Old Man battle
;>         mem[coord(5, 4)] = 0xED     # '▶'
	ld a, '▶'
	; place menu cursor in front of first menu entry
	ld [(4) * SCREEN_WIDTH + (5) + wTileMap], a
;>         DelayFrames(80)
	ld c, 80
	call DelayFrames
;>         wCurrentMenuItem = 0
	xor a
	ld [wCurrentMenuItem], a
;>         wMenuCursorLocation[0] = lo(coord(5, 4))
	ld hl, (4) * SCREEN_WIDTH + (5) + wTileMap
	ld a, l
	ld [wMenuCursorLocation], a
;>         wMenuCursorLocation[1] = hi(coord(5, 4))
	ld a, h
	ld [wMenuCursorLocation + 1], a
;>         keys = PAD_A
	jr .buttonAPressed
.notOldManBattle
;>     else:
;>         LoadGBPal()
	call LoadGBPal
;>         keys = HandleMenuInput()
	call HandleMenuInput
	push af
;>         PlaceMenuCursor()
	call PlaceMenuCursor
	pop af
;>     if keys & PAD_A:
	bit B_PAD_A, a
	jp z, .checkOtherKeys
.buttonAPressed
;>         PlaceUnfilledArrowMenuCursor(wCurrentMenuItem)
	ld a, [wCurrentMenuItem]
	call PlaceUnfilledArrowMenuCursor

; pointless because both values are overwritten before they are read
;>         wMenuExitMethod = wChosenMenuItem = 1   # both written again before they are read
	ld a, $01
	ld [wMenuExitMethod], a
	ld [wChosenMenuItem], a

;>         wMenuWatchMovingOutOfBounds = 0
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
;>         chosen = u8(wCurrentMenuItem + wListScrollOffset)
	ld a, [wCurrentMenuItem]
	ld c, a
	ld a, [wListScrollOffset]
	add c
	ld c, a
;>         if wListCount == 0:         # an empty list
;>             return ExitListMenu()
	ld a, [wListCount]
	and a ; is the list empty?
	jp z, ExitListMenu ; if so, exit the menu
;>         if chosen > wListCount - 1: # CANCEL
;>             return ExitListMenu()
	dec a
	cp c ; did the player select Cancel?
	jp c, ExitListMenu ; if so, exit the menu
;>         wWhichPokemon = chosen
	ld a, c
	ld [wWhichPokemon], a
;>         if wListMenuID == ITEMLISTMENU:
	ld a, [wListMenuID]
	cp ITEMLISTMENU
	jr nz, .skipMultiplying
; if it's an item menu
;>             chosen = u8(chosen * 2) # item entries are 2 bytes long
	sla c ; item entries are 2 bytes long, so multiply by 2
.skipMultiplying
;>         entries = (wListPointer[0] | wListPointer[1] << 8) + 1   # past the count
	ld a, [wListPointer]
	ld l, a
	ld a, [wListPointer + 1]
	ld h, a
	inc hl ; hl = beginning of list entries
;>         entry = entries + chosen
	ld b, 0
	add hl, bc
;>         wCurListMenuItem = mem[entry]
	ld a, [hl]
	ld [wCurListMenuItem], a
;>         if wListMenuID != PCPOKEMONLISTMENU:   # an item list
	ld a, [wListMenuID]
	and a ; PCPOKEMONLISTMENU?
	jr z, .pokemonList
; if it's an item menu
;>             GetItemPrice()          # wCurItem is wCurListMenuItem
	ASSERT wCurListMenuItem == wCurItem
	push hl
	call GetItemPrice
	pop hl
;>             if wListMenuID == ITEMLISTMENU:
	ld a, [wListMenuID]
	cp ITEMLISTMENU
	jr nz, .skipGettingQuantity
;>                 wMaxItemQuantity = mem[entry + 1]   # the quantity the player has
	inc hl
	ld a, [hl] ; a = item quantity
	ld [wMaxItemQuantity], a
.skipGettingQuantity
;>             wNameListIndex = wCurItem
	ld a, [wCurItem]
	ld [wNameListIndex], a
;>             wPredefBank = BANK(ItemNames)
	ld a, BANK(ItemNames)
	ld [wPredefBank], a
;>             GetName()
	call GetName
	jr .storeChosenEntry
.pokemonList
;>         else:
;>             party = wListPointer[0] == lo(addr(wPartyCount))   # the party or a box (wCurPartySpecies is wCurListMenuItem)
	ASSERT wCurListMenuItem == wCurPartySpecies
	ld hl, wPartyCount
	ld a, [wListPointer]
	cp l ; is it a list of party pokemon or box pokemon?
;>             nicks = addr(wPartyMonNicks) if party else addr(wBoxMonNicks)
	ld hl, wPartyMonNicks
	jr z, .getPokemonName
	ld hl, wBoxMonNicks ; box pokemon names
.getPokemonName
;>             GetPartyMonName(wWhichPokemon, nicks)
	ld a, [wWhichPokemon]
	call GetPartyMonName
.storeChosenEntry ; store the menu entry that the player chose and return
;>         CopyToStringBuffer(addr(wNameBuffer))
	ld de, wNameBuffer
	call CopyToStringBuffer
;>         wMenuExitMethod = CHOSE_MENU_ITEM
	ld a, CHOSE_MENU_ITEM
	ld [wMenuExitMethod], a
;>         wChosenMenuItem = wCurrentMenuItem
	ld a, [wCurrentMenuItem]
	ld [wChosenMenuItem], a
;>         hJoy7 = 0
	xor a
	ldh [hJoy7], a ; joypad state update flag
;>         wStatusFlags5 &= ~(1 << BIT_NO_TEXT_DELAY) & 0xFF
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
;>         BankswitchBack()
;>         return False
	jp BankswitchBack
.checkOtherKeys ; check B, SELECT, Up, and Down keys
;>     if keys & PAD_B:
;>         return ExitListMenu()
	bit B_PAD_B, a
	jp nz, ExitListMenu ; if so, exit the menu
;>     if keys & PAD_SELECT:           # start swapping two items
;>         return HandleItemListSwapping()
	bit B_PAD_SELECT, a
	jp nz, HandleItemListSwapping ; if so, allow the player to swap menu entries
;>     if keys & PAD_DOWN:
	ld b, a
	bit B_PAD_DOWN, b
	ld hl, wListScrollOffset
	jr z, .upPressed
; Down pressed
;>         if wListCount >= u8(wListScrollOffset + 3):   # not scrolling past CANCEL
	ld a, [hl]
	add 3
	ld b, a
	ld a, [wListCount]
	cp b ; will going down scroll past the Cancel button?
	jp c, DisplayListMenuIDLoop
;>             wListScrollOffset += 1
	inc [hl] ; if not, go down
	jp DisplayListMenuIDLoop
.upPressed
;>     elif wListScrollOffset:         # Up
	ld a, [hl]
	and a
	jp z, DisplayListMenuIDLoop
;>         wListScrollOffset -= 1
	dec [hl]
	jp DisplayListMenuIDLoop

;@ path: home/list_menu
;@ def DisplayChooseQuantityMenu() -> a
;@ Ask how many of the chosen item: a small box with "×01", in a mart also the total price (halved when
;@ selling). Up and Down change the number, wrapping between 1 and wMaxItemQuantity. Returns 0 for A (the
;@ number is in wItemQuantity), $FF for B.
;@ test: skip waits for the player
DisplayChooseQuantityMenu::
; text box dimensions/coordinates for just quantity
;> corner, rows, width = coord(15, 9), 1, 3   # a box for the quantity
	ld hl, (9) * SCREEN_WIDTH + (15) + wTileMap
	ld b, 1 ; height
	ld c, 3 ; width
;> priced = wListMenuID == PRICEDITEMLISTMENU
	ld a, [wListMenuID]
	cp PRICEDITEMLISTMENU
;> if priced:
	jr nz, .drawTextBox
; text box dimensions/coordinates for quantity and price
;>     corner, rows, width = coord(7, 9), 1, 11   # with room for the price
	ld hl, (9) * SCREEN_WIDTH + (7) + wTileMap
	ld b, 1  ; height
	ld c, 11 ; width
.drawTextBox
;> TextBoxBorder(corner, rows, width)
	call TextBoxBorder
;> pos = coord(8, 10) if priced else coord(16, 10)
	ld hl, (10) * SCREEN_WIDTH + (16) + wTileMap
	ld a, [wListMenuID]
	cp PRICEDITEMLISTMENU
	jr nz, .printInitialQuantity
	ld hl, (10) * SCREEN_WIDTH + (8) + wTileMap
.printInitialQuantity
;> PlaceString(InitialQuantityText, pos)   # "×01"
	ld de, InitialQuantityText
	call PlaceString
;> wItemQuantity = 0
	xor a
	ld [wItemQuantity], a ; initialize current quantity to 0
;> keys = PAD_UP                       # the first round counts up to 1
	jp .incrementQuantity
.waitForKeyPressLoop
;=@joy
	call JoypadLowSensitivity
;=@keys
	ldh a, [hJoyPressed] ; newly pressed buttons
;=@ia
	bit B_PAD_A, a
	jp nz, .buttonAPressed
;=@ib
	bit B_PAD_B, a
	jp nz, .buttonBPressed
;=@ud
	bit B_PAD_UP, a
	jr nz, .incrementQuantity
	bit B_PAD_DOWN, a
	jr nz, .decrementQuantity
;=@wait
	jr .waitForKeyPressLoop
.incrementQuantity
;>@outer while True:
;>@isup     if keys & PAD_UP:
;>         top = u8(wMaxItemQuantity + 1)
	ld a, [wMaxItemQuantity]
	inc a
	ld b, a
;>         wItemQuantity = u8(wItemQuantity + 1)
	ld hl, wItemQuantity ; current quantity
	inc [hl]
;>         if wItemQuantity == top:
	ld a, [hl]
	cp b
	jr nz, .handleNewQuantity
; wrap to 1 if the player goes above the max quantity
;>             wItemQuantity = 1       # round to 1
	ld a, 1
	ld [hl], a
	jr .handleNewQuantity
.decrementQuantity
;>     else:
;>         wItemQuantity = u8(wItemQuantity - 1)
	ld hl, wItemQuantity ; current quantity
	dec [hl]
;>         if wItemQuantity == 0:
	jr nz, .handleNewQuantity
; wrap to the max quantity if the player goes below 1
;>             wItemQuantity = wMaxItemQuantity   # round to the most
	ld a, [wMaxItemQuantity]
	ld [hl], a
.handleNewQuantity
;>     pos = coord(17, 10)
	ld hl, (10) * SCREEN_WIDTH + (17) + wTileMap
;>     if priced:
	ld a, [wListMenuID]
	cp PRICEDITEMLISTMENU
	jr nz, .printQuantity
.printPrice
;>         n = wItemQuantity
	ld c, $03
	ld a, [wItemQuantity]
	ld b, a
;>         hMoney[0] = hMoney[1] = hMoney[2] = 0   # the total
	ld hl, hMoney ; total price
; initialize total price to 0
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
;>@add         for _ in range(n or 256):   # the price times the quantity, by adding
;>             AddBCD(addr(hMoney) + 2, addr(hItemPrice) + 2, 3)
.addLoop ; loop to multiply the individual price by the quantity to get the total price
	ld de, hMoney + 2
	ld hl, hItemPrice + 2
	push bc
	; add the individual price to the current sum
	ld a, (AddBCDPredefPredef - PredefPointers) / 3
	call Predef
	pop bc
;=@add
	dec b
	jr nz, .addLoop
;>         if hHalveItemPrices:        # selling: half the price
	ldh a, [hHalveItemPrices]
	and a ; should the price be halved (for selling items)?
	jr z, .skipHalvingPrice
;>             hDivideBCDDivisor[0] = hDivideBCDDivisor[1] = 0
	xor a
	ldh [hDivideBCDDivisor], a
	ldh [hDivideBCDDivisor + 1], a
;>             hDivideBCDDivisor[2] = 2
	ld a, $02
	ldh [hDivideBCDDivisor + 2], a
;>             DivideBCD()
	; halves the price
	ld a, (DivideBCDPredef3Predef - PredefPointers) / 3
	call Predef
; store the halved price
;>             hMoney[0] = hDivideBCDQuotient[0]
	ldh a, [hDivideBCDQuotient]
	ldh [hMoney], a
;>             hMoney[1] = hDivideBCDQuotient[1]
	ldh a, [hDivideBCDQuotient + 1]
	ldh [hMoney + 1], a
;>             hMoney[2] = hDivideBCDQuotient[2]
	ldh a, [hDivideBCDQuotient + 2]
	ldh [hMoney + 2], a
.skipHalvingPrice
;>         PlaceString(SpacesBetweenQuantityAndPriceText, coord(12, 10))
	ld hl, (10) * SCREEN_WIDTH + (12) + wTileMap
	ld de, SpacesBetweenQuantityAndPriceText
	call PlaceString
;>         PrintBCDNumber(addr(hMoney), coord(13, 10), 3 | LEADING_ZEROES | MONEY_SIGN)
	ld de, hMoney ; total price
	ld c, 3 | LEADING_ZEROES | MONEY_SIGN
	call PrintBCDNumber
;>         pos = coord(9, 10)
	ld hl, (10) * SCREEN_WIDTH + (9) + wTileMap
.printQuantity
;>     PrintNumber(addr(wItemQuantity), pos, LEADING_ZEROES | 1, 2)
	ld de, wItemQuantity ; current quantity
	; 1 byte, 2 digits
	ld bc, ((LEADING_ZEROES | 1) & $ff) << 8 + ((2) & $ff)
	call PrintNumber
;=@wait
	jp .waitForKeyPressLoop
;>@wait     while True:                # wait for a key
;>@joy         JoypadLowSensitivity()
;>@keys         keys = hJoyPressed
;>@ia         if keys & PAD_A:        # take that many
;>             wMenuItemToSwap = 0
.buttonAPressed ; the player chose to make the transaction
	xor a
	ld [wMenuItemToSwap], a ; 0 means no item is currently being swapped
;>             return 0
	ret
.buttonBPressed ; the player chose to cancel the transaction
;>@ib         if keys & PAD_B:        # cancel
;>             wMenuItemToSwap = 0
	xor a
	ld [wMenuItemToSwap], a ; 0 means no item is currently being swapped
;>             return 0xFF
	ld a, $ff
	ret
;>@ud         if keys & (PAD_UP | PAD_DOWN):
;>@ud2             break

;@ path: home/list_menu
InitialQuantityText::
	db "×01@"

;@ path: home/list_menu
SpacesBetweenQuantityAndPriceText::
	db "      @"

;@ path: home/list_menu
;@ def ExitListMenu() -> carry
;@ Leave a list menu without a choice: CANCELLED_MENU in wMenuExitMethod, the ROM bank switched back, carry
;@ set.
;@ test: wBankswitchHomeSavedROMBank = rand(1, 0x2C)
ExitListMenu::
;> wChosenMenuItem = wCurrentMenuItem
	ld a, [wCurrentMenuItem]
	ld [wChosenMenuItem], a
;> wMenuExitMethod = CANCELLED_MENU
	ld a, CANCELLED_MENU
	ld [wMenuExitMethod], a
;> wMenuWatchMovingOutOfBounds = CANCELLED_MENU
	ld [wMenuWatchMovingOutOfBounds], a
;> hJoy7 = 0
	xor a
	ldh [hJoy7], a
;> wStatusFlags5 &= ~(1 << BIT_NO_TEXT_DELAY) & 0xFF
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
;> BankswitchBack()
	call BankswitchBack
;> wMenuItemToSwap = 0
	xor a
	ld [wMenuItemToSwap], a ; 0 means no item is currently being swapped
;> return True
	scf
	ret

;@ path: home/list_menu
;@ def PrintListMenuEntries()
;@ Print the four list entries from wListScrollOffset on: the names, and as the menu needs, the price, a
;@ Pokémon's level, an item's quantity (not for key items) and '▷' at the item chosen for swapping. The list's
;@ end prints CANCEL; a '▼' at the bottom shows there is more.
;@ test: skip needs a whole list menu set up (list, names, prices)
PrintListMenuEntries::
;> ClearScreenArea(coord(5, 3), 14, 9)
	ld hl, (3) * SCREEN_WIDTH + (5) + wTileMap
	ld b, 9
	ld c, 14
	call ClearScreenArea
;> entry = (wListPointer[0] | wListPointer[1] << 8) + 1   # past the count
	ld a, [wListPointer]
	ld e, a
	ld a, [wListPointer + 1]
	ld d, a
	inc de ; de = beginning of list entries
;> first = wListScrollOffset
	ld a, [wListScrollOffset]
	ld c, a
;> item_menu = wListMenuID == ITEMLISTMENU
	ld a, [wListMenuID]
	cp ITEMLISTMENU
	ld a, c
;> if item_menu:
	jr nz, .skipMultiplying
; if it's an item menu
; item entries are 2 bytes long, so multiply by 2
;>     first = u8(first * 2)           # item entries are 2 bytes long
	sla a
	sla c
.skipMultiplying
;> entry += first
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
;> dest = coord(6, 4)
	; coordinates of first list entry name
	ld hl, (4) * SCREEN_WIDTH + (6) + wTileMap
;>@each for k in range(4):
	ld b, 4 ; print 4 names
.loop
;>     wWhichPokemon = 4 - k           # counted down
	ld a, b
	ld [wWhichPokemon], a
;>     wNamedObjectIndex = mem[entry]
	ld a, [de]
	ld [wNamedObjectIndex], a
;>     if mem[entry] == 0xFF:          # the end of the list
;>@cancel         return PlaceString(ListMenuCancelText, dest)
	cp $ff
	jp z, .printCancelMenuItem
;>     # (the counter, entry and dest are kept on the stack)
	push bc
	push de
	push hl
	push hl
	push de
;>     if wListMenuID == PCPOKEMONLISTMENU:
	ld a, [wListMenuID]
	and a ; PCPOKEMONLISTMENU?
	jr z, .pokemonPCMenu
;>@party         party = wListPointer[0] == lo(addr(wPartyCount))
;>@nicks         nicks = addr(wPartyMonNicks) if party else addr(wBoxMonNicks)
;>@k         k = 4 - wWhichPokemon
;>@index         index = u8(wListScrollOffset + k)
;>@getname         GetPartyMonName(index, nicks)
;>@name         name = addr(wNameBuffer)
;>     elif wListMenuID == MOVESLISTMENU:
	cp MOVESLISTMENU
	jr z, .movesMenu
; item menu
;>@move         name = GetMoveName()
;>     else:
;>         name = GetItemName()
	call GetItemName
	jr .placeNameString
.pokemonPCMenu
;=@party
	push hl
	ld hl, wPartyCount
	ld a, [wListPointer]
	cp l ; is it a list of party pokemon or box pokemon?
;=@nicks
	ld hl, wPartyMonNicks
	jr z, .getPokemonName
	ld hl, wBoxMonNicks ; box pokemon names
.getPokemonName
;=@k
	ld a, [wWhichPokemon]
	ld b, a
	ld a, 4
	sub b
	ld b, a
;=@index
	ld a, [wListScrollOffset]
	add b
;=@getname
	call GetPartyMonName
	pop hl
	jr .placeNameString
.movesMenu
;=@move
	call GetMoveName
.placeNameString
;>     PlaceString(name, dest)
	call PlaceString
	pop de
	pop hl
;>     if wPrintItemPrices:
	ld a, [wPrintItemPrices]
	and a ; should prices be printed?
	jr z, .skipPrintingItemPrice
; print item price
;>         wCurItem = mem[entry]
	push hl
	ld a, [de]
	ld de, ItemPrices
	ld [wCurItem], a
;>         GetItemPrice()
	call GetItemPrice
	pop hl
;>         PrintBCDNumber(addr(hItemPrice), dest + SCREEN_WIDTH + 5, 3 | LEADING_ZEROES | MONEY_SIGN)   # a row down
	ld bc, SCREEN_WIDTH + 5 ; 1 row down and 5 columns right
	add hl, bc
	ld c, 3 | LEADING_ZEROES | MONEY_SIGN
	call PrintBCDNumber
.skipPrintingItemPrice
;>     if wListMenuID == PCPOKEMONLISTMENU:   # a Pokémon's level
	ld a, [wListMenuID]
	and a ; PCPOKEMONLISTMENU?
	jr nz, .skipPrintingPokemonLevel
; print Pokemon level
;>         saved = wNamedObjectIndex
	ld a, [wNamedObjectIndex]
	push af
	push hl
;>         party = wListPointer[0] == lo(addr(wPartyCount))
	ld hl, wPartyCount
	ld a, [wListPointer]
	cp l ; is it a list of party pokemon or box pokemon?
;>         wMonDataLocation = PLAYER_PARTY_DATA if party else BOX_DATA
	ld a, PLAYER_PARTY_DATA
	jr z, .next
	ld a, BOX_DATA
.next
	ld [wMonDataLocation], a
;>         k = 4 - wWhichPokemon
	ld hl, wWhichPokemon
	ld a, [hl]
	ld b, a
	ld a, $04
	sub b
	ld b, a
;>         wWhichPokemon = u8(wListScrollOffset + k)
	ld a, [wListScrollOffset]
	add b
	ld [hl], a
;>         LoadMonData()
	call LoadMonData
;>         if wMonDataLocation:        # a box Pokémon keeps its level in another place
;>             wLoadedMonLevel = wLoadedMonBoxLevel
	ld a, [wMonDataLocation]
	and a ; is it a list of party pokemon or box pokemon?
	jr z, .skipCopyingLevel
; copy level
	ld a, [wLoadedMonBoxLevel]
	ld [wLoadedMonLevel], a
.skipCopyingLevel
;>         PrintLevel(dest + SCREEN_WIDTH + 8)
	pop hl
	ld bc, SCREEN_WIDTH + 8 ; 1 row down and 8 columns right
	add hl, bc
	call PrintLevel
;>         wNamedObjectIndex = saved
	pop af
	ld [wNamedObjectIndex], a
.skipPrintingPokemonLevel
;>     entry += 1
	pop hl
	pop de
	inc de
;>     if item_menu:
	ld a, [wListMenuID]
	cp ITEMLISTMENU
	jr nz, .nextListEntry
; print item quantity
;>         wCurItem = wNamedObjectIndex
	ld a, [wNamedObjectIndex]
	ld [wCurItem], a
;>         IsKeyItem()
	call IsKeyItem ; check if item is unsellable
;>         if not wIsKeyItem:          # key items have no quantity
	ld a, [wIsKeyItem]
	and a ; is the item unsellable?
	jr nz, .skipPrintingItemQuantity ; if so, don't print the quantity
;>             q = dest + SCREEN_WIDTH + 8
	push hl
	ld bc, SCREEN_WIDTH + 8 ; 1 row down and 8 columns right
	add hl, bc
;>             mem[q] = 0xF1           # '×'
	ld a, '×'
	ld [hli], a
;>             wMaxItemQuantity = mem[entry]
	ld a, [wNamedObjectIndex]
	push af
	ld a, [de]
	ld [wMaxItemQuantity], a
;>             wTempByteValue = mem[entry]
	push de
	ld de, wTempByteValue
	ld [de], a
;>             PrintNumber(addr(wTempByteValue), q + 1, 1, 2)
	ld bc, ((1) & $ff) << 8 + ((2) & $ff)
	call PrintNumber
	pop de
	pop af
	ld [wNamedObjectIndex], a
	pop hl
.skipPrintingItemQuantity
;>         entry += 1
	inc de
;>         n = u8(first + 2 * k + 2)   # this entry's number (from 1), times 2
	pop bc
	inc c
	push bc
	inc c
;>         if wMenuItemToSwap and u8(wMenuItemToSwap * 2) == n:   # the item chosen for swapping
	ld a, [wMenuItemToSwap] ; ID of item chosen for swapping (counts from 1)
	and a ; is an item being swapped?
	jr z, .nextListEntry
	sla a
	cp c ; is it this item?
	jr nz, .nextListEntry
;>             mem[dest - 1] = 0xEC    # '▷'
	dec hl
	ld a, '▷'
	ld [hli], a
.nextListEntry
;>     dest += 2 * SCREEN_WIDTH
	ld bc, 2 * SCREEN_WIDTH ; 2 rows
	add hl, bc
	pop bc
;=@each
	inc c
	dec b
	jp nz, .loop
;> mem[dest - 8] = 0xEE                # '▼': there is more
	ld bc, -8
	add hl, bc
	ld a, '▼'
	ld [hl], a
	ret
.printCancelMenuItem
;=@cancel
	ld de, ListMenuCancelText
	jp PlaceString

;@ path: home/list_menu
ListMenuCancelText::
	db "CANCEL@"
;@ path: home/names
;@ def GetMonName() -> de
;@ Copy the name of Pokémon number wNamedObjectIndex to wNameBuffer, ended with '@'. The names are in another
;@ bank: switch it in, then back.
GetMonName::
;> saved = hLoadedROMBank
	push hl
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(MonsterNames)
	ld a, BANK(MonsterNames)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(MonsterNames))
	ld [rROMB], a
;> name = AddNTimes(MonsterNames, NAME_LENGTH - 1, u8(wNamedObjectIndex - 1))
	ld a, [wNamedObjectIndex]
	dec a
	ld hl, MonsterNames
	ld c, NAME_LENGTH - 1
	ld b, 0
	call AddNTimes
;> CopyData(name, wNameBuffer, NAME_LENGTH - 1)
	ld de, wNameBuffer
	push de
	ld bc, NAME_LENGTH - 1
	call CopyData
;> wNameBuffer[NAME_LENGTH - 1] = 0x50 # '@'
	ld hl, wNameBuffer + NAME_LENGTH - 1
	ld [hl], '@'
	pop de
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
;> return wNameBuffer
	ld [rROMB], a
	pop hl
	ret

;@ path: home/names
;@ def GetItemName() -> de
;@ The name of item wNamedObjectIndex into wNameBuffer: TMs and HMs are spelled out ("TM01"), every other
;@ item comes from the item name list.
GetItemName::
; given an item ID at [wNamedObjectIndex], store the name of the item in wNameBuffer
;> if wNamedObjectIndex < HM01:        # an ordinary item
	push hl
	push bc
	ld a, [wNamedObjectIndex]
	cp HM01 ; is this a TM/HM?
	jr nc, .Machine

;>     wNameListIndex = wNamedObjectIndex
	ld [wNameListIndex], a
;>     wNameListType = ITEM_NAME
	ld a, ITEM_NAME
	ld [wNameListType], a
;>     wPredefBank = BANK(ItemNames)
	ld a, BANK(ItemNames)
	ld [wPredefBank], a
;>     GetName()
	call GetName
	jr .Finish

.Machine
;> else:                               # a TM or HM
;>     GetMachineName()
	call GetMachineName
.Finish
;> return wNameBuffer
	ld de, wNameBuffer
	pop bc
	pop hl
	ret

;@ path: home/names
;@ def GetMachineName()
;@ Spell the TM or HM number of item wNamedObjectIndex into wNameBuffer: "TM" or "HM" and two digits. HMs
;@ come before TMs in the item list, so an HM borrows the TM digit code by adding the number of HMs first.
GetMachineName::
; copies the name of the TM/HM in [wNamedObjectIndex] to wNameBuffer
;> item = wNamedObjectIndex
	push hl
	push de
	push bc
	ld a, [wNamedObjectIndex]
	push af
;> if item < TM01:                     # an HM
	cp TM01 ; is this a TM? [not HM]
	jr nc, .WriteTM
; if HM, then write "HM" and add NUM_HMS to the item ID, so we can reuse the
; TM printing code
;>     wNamedObjectIndex = u8(item + NUM_HMS)   # numbered like the TMs after it
	add NUM_HMS
	ld [wNamedObjectIndex], a
;>     prefix = HiddenPrefix           # "HM"
	ld hl, HiddenPrefix ; points to "HM"
	ld bc, 2
	jr .WriteMachinePrefix
.WriteTM
;> else:
;>     prefix = TechnicalPrefix        # "TM"
	ld hl, TechnicalPrefix ; points to "TM"
	ld bc, 2
.WriteMachinePrefix
;> CopyData(prefix, wNameBuffer, 2)
	ld de, wNameBuffer
	call CopyData

; now get the machine number and convert it to text
;> n = u8(wNamedObjectIndex - (TM01 - 1))   # the number, from 1
	ld a, [wNamedObjectIndex]
	sub TM01 - 1
;> tens = 0xF6                         # '0'
	ld b, '0'
;>@tens while n >= 10:
;>     n -= 10
.FirstDigit
	sub 10
	jr c, .SecondDigit
;>     tens += 1
	inc b
;=@tens
	jr .FirstDigit
.SecondDigit
;> # (the last subtraction of 10 is undone)
	add 10
;> wNameBuffer[2] = tens
	push af
	ld a, b
	ld [de], a
	inc de
	pop af
;> wNameBuffer[3] = u8(0xF6 + n)       # the ones
	ld b, '0'
	add b
	ld [de], a
	inc de
;> wNameBuffer[4] = 0x50               # '@'
	ld a, '@'
	ld [de], a
;> wNamedObjectIndex = item
	pop af
	ld [wNamedObjectIndex], a
	pop bc
	pop de
	pop hl
	ret

;@ path: home/names
TechnicalPrefix::
	db "TM"
;@ path: home/names
HiddenPrefix::
	db "HM"

; sets carry if item is HM, clears carry if item is not HM
; Input: a = item ID
;@ path: home/names
;@ def IsItemHM(item: a) -> carry
;@ Whether an item is one of the HMs (they sit just before the TMs in the item numbers).
IsItemHM::
;> return HM01 <= item < TM01
	cp HM01
	jr c, .notHM
	cp TM01
	ret
.notHM
	and a
	ret

; sets carry if move is an HM, clears carry if move is not an HM
; Input: a = move ID
;@ path: home/names
;@ def IsMoveHM(move: a) -> carry
;@ Whether a move is one of the HM moves: a search of the HMMoves list, which ends with $FF.
IsMoveHM::
;> _, _, found = IsInArray(move, HMMoves, 1)
;> return found
	ld hl, HMMoves
	ld de, 1
	jp IsInArray

;@ path: home/names
HMMoves::
; This file is INCLUDEd twice:
; - for HMMoves in home/names.asm
; - for HMMoveArray in engine/pokemon/bills_pc.asm

	db CUT
	db FLY
	db SURF
	db STRENGTH
	db FLASH
	db -1 ; end

;@ path: home/names
;@ def GetMoveName() -> de
;@ The name of move wNamedObjectIndex into wNameBuffer.
GetMoveName::
;> wNameListType = MOVE_NAME
	push hl
	ld a, MOVE_NAME
	ld [wNameListType], a
;> wNameListIndex = wNamedObjectIndex
	ld a, [wNamedObjectIndex]
	ld [wNameListIndex], a
;> wPredefBank = BANK(MoveNames)
	ld a, BANK(MoveNames)
	ld [wPredefBank], a
;> GetName()
	call GetName
;> return wNameBuffer
	ld de, wNameBuffer
	pop hl
	ret
; reloads text box tile patterns, current map view, and tileset tile patterns
;@ path: home/reload_tiles
;@ def ReloadMapData()
;@ Redraw the map from scratch with the LCD off: text box tiles, the visible blocks and the tileset's tiles.
ReloadMapData::
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> SwitchToMapRomBank(wCurMap)
	ld a, [wCurMap]
	call SwitchToMapRomBank
;> DisableLCD()
	call DisableLCD
;> LoadTextBoxTilePatterns()
	call LoadTextBoxTilePatterns
;> LoadCurrentMapView()
	call LoadCurrentMapView
;> LoadTilesetTilePatternData()
	call LoadTilesetTilePatternData
;> EnableLCD()
	call EnableLCD
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret

; reloads tileset tile patterns
;@ path: home/reload_tiles
;@ def ReloadTilesetTilePatterns()
;@ Load the current map's tileset tiles again, with the LCD off.
ReloadTilesetTilePatterns::
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> SwitchToMapRomBank(wCurMap)
	ld a, [wCurMap]
	call SwitchToMapRomBank
;> DisableLCD()
	call DisableLCD
;> LoadTilesetTilePatternData()
	call LoadTilesetTilePatternData
;> EnableLCD()
	call EnableLCD
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret

; shows the town map and lets the player choose a destination to fly to
;@ path: home/reload_tiles
;@ def ChooseFlyDestination()
;@ Show the town map to pick a place to fly to (LoadTownMap_Fly), clearing the no-battles flag first.
ChooseFlyDestination::
;> wStatusFlags4 = wStatusFlags4 & ~(1 << BIT_NO_BATTLES)
	ld hl, wStatusFlags4
	res BIT_NO_BATTLES, [hl]
;> LoadTownMap_Fly()
;> set_rom_bank(hLoadedROMBank)    # a far call returns to the bank in hLoadedROMBank
	ld b, BANK(LoadTownMap_Fly)
	ld hl, LoadTownMap_Fly
	jp Bankswitch

; causes the text box to close without waiting for a button press after displaying text
;@ path: home/reload_tiles
;@ def DisableWaitingAfterTextDisplay()
;@ Let the next text box close without waiting for a button.
DisableWaitingAfterTextDisplay::
;> wDoNotWaitForButtonPressAfterDisplayingText = 1
	ld a, $01
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ret
; uses an item
; UseItem is used with dummy items to perform certain other functions as well
; INPUT:
; [wCurItem] = item ID
; OUTPUT:
; [wActionResultOrTookBattleTurn] = success
; 00: unsuccessful
; 01: successful
; 02: not able to be used right now, no extra menu displayed (only certain items use this)
;@ path: home/item
;@ def UseItem()
;@ Use the item in wCurItem (UseItem_, in its own bank).
UseItem::
;> UseItem_()
;> set_rom_bank(hLoadedROMBank)    # a far call returns to the bank in hLoadedROMBank
	ld b, BANK(UseItem_)
	ld hl, UseItem_
	jp Bankswitch

; confirms the item toss and then tosses the item
; INPUT:
; hl = address of inventory (either wNumBagItems or wNumBoxItems)
; [wCurItem] = item ID
; [wWhichPokemon] = index of item within inventory
; [wItemQuantity] = quantity to toss
; OUTPUT:
; clears carry flag if the item is tossed, sets carry flag if not
;@ path: home/item
;@ def TossItem(inventory: hl) -> carry
;@ Ask whether to toss wItemQuantity of the item at index wWhichPokemon of `inventory` (the bag or the PC
;@ box) and toss it: no carry if it was tossed.
;@ test: inventory = rand_ram(64)
TossItem::
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(TossItem_)
	ld a, BANK(TossItem_)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(TossItem_))
	ld [rROMB], a
;> tossed = TossItem_(inventory)
	call TossItem_
;> hLoadedROMBank = saved
	pop de
	ld a, d
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
;> return tossed
	ret

; checks if an item is a key item
; INPUT:
; [wCurItem] = item ID
; OUTPUT:
; [wIsKeyItem] = result
; 00: item is not key item
; 01: item is key item
;@ path: home/item
;@ def IsKeyItem()
;@ Set wIsKeyItem to 1 if wCurItem is a key item, else 0; keeps hl, de and bc.
;@ test: skip IsKeyItem_ calls through the predef table (which keeps its registers in wPredefHL/DE/BC)
IsKeyItem::
;> IsKeyItem_()                        # in its own bank
	push hl
	push de
	push bc
	ld b, BANK(IsKeyItem_)
	ld hl, IsKeyItem_
	call Bankswitch
;> set_rom_bank(hLoadedROMBank)        # Bankswitch switches back
	pop bc
	pop de
	pop hl
	ret
; function to draw various text boxes
; INPUT:
; [wTextBoxID] = text box ID
; b, c = y, x cursor position (TWO_OPTION_MENU only)
;@ path: home/textbox
;@ def DisplayTextBoxID()
;@ Draw text box wTextBoxID (two-option menus take their corner in hl and their size in bc): DisplayTextBoxID_
;@ in its own bank, keeping the flags.
DisplayTextBoxID::
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(DisplayTextBoxID_)
	ld a, BANK(DisplayTextBoxID_)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(DisplayTextBoxID_))
	ld [rROMB], a
;> DisplayTextBoxID_()
	call DisplayTextBoxID_
;> hLoadedROMBank = saved              # the flags stay as DisplayTextBoxID_ left them
	pop bc
	ld a, b
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret
; not zero if an NPC movement script is running, the player character is
; automatically stepping down from a door, or joypad states are being simulated
;@ path: home/npc_movement
;@ def IsPlayerCharacterBeingControlledByGame() -> zero
;@ No zero flag while a script moves the player: an NPC movement script, stepping out of a door, or a
;@ scripted movement.
IsPlayerCharacterBeingControlledByGame::
;> if wNPCMovementScriptPointerTableNum:   # an NPC movement script
;>     return False
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret nz
;> if wMovementFlags & 1 << BIT_EXITING_DOOR:   # stepping out of a door
;>     return False
	ld a, [wMovementFlags]
	bit BIT_EXITING_DOOR, a
	ret nz
;> return not (wStatusFlags5 & 1 << BIT_SCRIPTED_MOVEMENT_STATE)
	ld a, [wStatusFlags5]
	and 1 << BIT_SCRIPTED_MOVEMENT_STATE
	ret

;@ path: home/npc_movement
;@ def RunNPCMovementScript()
;@ Step the running NPC movement script (in Pallet Town, the Pewter museum or gym): function
;@ wNPCMovementScriptFunctionNum of its table, in wNPCMovementScriptBank. Stepping out of a door comes first.
;@ test: skip calls the script functions through a table
RunNPCMovementScript::
;> on_door = wMovementFlags & 1 << BIT_STANDING_ON_DOOR
;> wMovementFlags = wMovementFlags & ~(1 << BIT_STANDING_ON_DOOR)
	ld hl, wMovementFlags
	bit BIT_STANDING_ON_DOOR, [hl]
	res BIT_STANDING_ON_DOOR, [hl]
;> if on_door:
	jr nz, .playerStepOutFromDoor
;>@door     PlayerStepOutFromDoor()
;>@db     set_rom_bank(hLoadedROMBank)    # a far call returns to the bank in hLoadedROMBank
;>@dr     return
;> if not wNPCMovementScriptPointerTableNum:
;>     return
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret z
;> i = wNPCMovementScriptPointerTableNum - 1   # two bytes per table address
	dec a
	add a
	ld d, 0
	ld e, a
;> tables = (PalletMovementScriptPointerTable, PewterMuseumGuyMovementScriptPointerTable, PewterGymGuyMovementScriptPointerTable)
	ld hl, .NPCMovementScriptPointerTables
	add hl, de
;> table = tables[i]
	ld a, [hli]
	ld h, [hl]
	ld l, a
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = wNPCMovementScriptBank
	ld a, [wNPCMovementScriptBank]
	ldh [hLoadedROMBank], a
;> set_rom_bank(wNPCMovementScriptBank)
	ld [rROMB], a
;> CallFunctionInTable(wNPCMovementScriptFunctionNum, table)
	ld a, [wNPCMovementScriptFunctionNum]
	call CallFunctionInTable
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret

.NPCMovementScriptPointerTables
	dw PalletMovementScriptPointerTable
	dw PewterMuseumGuyMovementScriptPointerTable
	dw PewterGymGuyMovementScriptPointerTable
.playerStepOutFromDoor
;=@door
	ld b, BANK(PlayerStepOutFromDoor)
	ld hl, PlayerStepOutFromDoor
	jp Bankswitch

;@ path: home/npc_movement
;@ def EndNPCMovementScript()
;@ End the NPC movement script (_EndNPCMovementScript, in its own bank).
EndNPCMovementScript::
;> _EndNPCMovementScript()
;> set_rom_bank(hLoadedROMBank)    # a far call returns to the bank in hLoadedROMBank
	ld b, BANK(_EndNPCMovementScript)
	ld hl, _EndNPCMovementScript
	jp Bankswitch

;@ path: home/npc_movement
;@ def DebugPressedOrHeldB()
;@ In the debug version: whether B lets the player skip trainers and scripts. In this version it does
;@ nothing.
DebugPressedOrHeldB:: ; dummy except in _DEBUG
; This is used to skip Trainer battles, the
; Safari Game step counter, and some NPC scripts.
;> return
	ret
;@ path: home/trainers
;@ def StoreTrainerHeaderPointer(header: hl)
;@ Remember the trainer header at `header` in wTrainerHeaderPtr (high byte first).
StoreTrainerHeaderPointer::
;> wTrainerHeaderPtr[0] = hi(header)
;> wTrainerHeaderPtr[1] = lo(header)
	ld a, h
	ld [wTrainerHeaderPtr], a
	ld a, l
	ld [wTrainerHeaderPtr+1], a
	ret

; executes the current map script from the function pointer array provided in de.
; a: map script index to execute (unless overridden by [wStatusFlags7] BIT_USE_CUR_MAP_SCRIPT)
; hl: trainer header pointer
;@ path: home/trainers
;@ def ExecuteCurMapScriptInTable(index: a, header: hl, table: de) -> a
;@ Run the map's current script: entry `index` of the function table at `table`, or entry wCurMapScript if
;@ a script asked for that (BIT_USE_CUR_MAP_SCRIPT, cleared here). Remembers the map's trainer headers and
;@ returns the script index afterwards.
ExecuteCurMapScriptInTable::
;> # (index and table kept on the stack)
	push af
	push de
;> StoreTrainerHeaderPointer(header)
	call StoreTrainerHeaderPointer
;> # (table and index come back; table stays on the stack)
	pop hl
	pop af
	push hl
;> use_cur = wStatusFlags7 & 1 << BIT_USE_CUR_MAP_SCRIPT
	ld hl, wStatusFlags7
	bit BIT_USE_CUR_MAP_SCRIPT, [hl]
;> wStatusFlags7 &= ~(1 << BIT_USE_CUR_MAP_SCRIPT) & 0xFF
	res BIT_USE_CUR_MAP_SCRIPT, [hl]
;> if use_cur:
	jr z, .useProvidedIndex
;>     index = wCurMapScript
	ld a, [wCurMapScript]
.useProvidedIndex
;> # (table comes back off the stack)
	pop hl
;> wCurMapScript = index
	ld [wCurMapScript], a
;> CallFunctionInTable(index, table)
	call CallFunctionInTable
;> return wCurMapScript
	ld a, [wCurMapScript]
	ret

;@ path: home/trainers
;@ def LoadGymLeaderAndCityName(city: hl, leader: de)
;@ Copy a gym's city name to wGymCityName and its leader's name to wGymLeaderName.
LoadGymLeaderAndCityName::
;> # (leader kept on the stack)
	push de
;> CopyData(city, addr(wGymCityName), GYM_CITY_LENGTH)
	ld de, wGymCityName
	ld bc, GYM_CITY_LENGTH
	call CopyData
;> CopyData(leader, addr(wGymLeaderName), NAME_LENGTH)
	pop hl
	ld de, wGymLeaderName
	ld bc, NAME_LENGTH
	jp CopyData

; reads specific information from trainer header (pointed to at wTrainerHeaderPtr)
; a: offset in header data
;@ path: home/trainers
;@ def ReadTrainerHeaderInfo(offset: a) -> hl
;@ Read field `offset` of the trainer header at wTrainerHeaderPtr: the event flag bit (offset 0, stored in
;@ wTrainerHeaderFlagBit; hl points at it) or one of the pointers (event flags, texts before and after the
;@ battle, the text when the player wins). The lose text pointer is read into de, but de is restored
;@ before returning, so it is lost. Keeps de.
;@ test: offset = rng.choice((0, 1, 2, 4, 6, 8, 10))
ReadTrainerHeaderInfo::
;> # (de and offset kept on the stack)
	push de
	push af
;> p = wTrainerHeaderPtr[0] << 8 | wTrainerHeaderPtr[1]   # (high byte first)
	ld d, 0
	ld e, a
	ld hl, wTrainerHeaderPtr
	ld a, [hli]
	ld l, [hl]
	ld h, a
;> p = (p + offset) & 0xFFFF
	add hl, de
;> if offset == TRAINER_EVENT_FLAG_BIT:
	pop af
	and a
	jr nz, .nonZeroOffset
;>     wTrainerHeaderFlagBit = mem[p]
	ld a, [hl]
	ld [wTrainerHeaderFlagBit], a
;>     return p
	jr .done
.nonZeroOffset
;> if offset == TRAINER_EVENT_FLAG_POINTER:
;>@rp     return mem16[p]
	cp TRAINER_EVENT_FLAG_POINTER
	jr z, .readPointer
;> if offset == TRAINER_BEFORE_BATTLE_TEXT:
;>@rp2     return mem16[p]
	cp TRAINER_BEFORE_BATTLE_TEXT
	jr z, .readPointer
;> if offset == TRAINER_AFTER_BATTLE_TEXT:
;>@rp3     return mem16[p]
	cp TRAINER_AFTER_BATTLE_TEXT
	jr z, .readPointer
;> if offset == TRAINER_WON_BATTLE_TEXT:
;>@rp4     return mem16[p]
	cp TRAINER_WON_BATTLE_TEXT
	jr z, .readPointer
;> if offset == TRAINER_LOST_BATTLE_TEXT:
	cp TRAINER_LOST_BATTLE_TEXT
	jr nz, .done
;>     lost = mem16[p]                 # read into de, which is restored below: lost
	ld a, [hli] ; TRAINER_LOST_BATTLE_TEXT pointer is overwritten afterwards (XXX why, bug?)
	ld d, [hl]
	ld e, a
;>     return p + 1
	jr .done
.readPointer
;=@rp
	ld a, [hli]
	ld h, [hl]
	ld l, a
.done
;> return p
	pop de
	ret

;@ path: home/trainers
;@ def TrainerFlagAction(field: hl, bit: c, action: b) -> c
;@ FlagAction through its predef: test, set or reset bit `bit` of the flags at field.
TrainerFlagAction::
;> Predef((FlagActionPredefPredef - PredefPointers) // 3)    # FlagActionPredef: FlagAction(field, bit, action)
;> return c    # what FlagAction returned
	ld a, (FlagActionPredefPredef - PredefPointers) / 3
	jp Predef

;@ path: home/trainers
;@ def TalkToTrainer(header: hl)
;@ The player talks to a trainer: after the battle, print the "after battle" text. Otherwise print the text
;@ before the battle, remember the end-of-battle texts and have the map script go on with the battle (right
;@ away if the player walked up to the trainer; a trainer who saw the player is already on the way).
TalkToTrainer::
;> StoreTrainerHeaderPointer(header)
	call StoreTrainerHeaderPointer
;> ReadTrainerHeaderInfo(TRAINER_EVENT_FLAG_BIT)
	xor a ; TRAINER_EVENT_FLAG_BIT
	call ReadTrainerHeaderInfo
;> flags = ReadTrainerHeaderInfo(TRAINER_EVENT_FLAG_POINTER)
	ld a, TRAINER_EVENT_FLAG_POINTER
	call ReadTrainerHeaderInfo
;> beaten = TrainerFlagAction(flags, wTrainerHeaderFlagBit, FLAG_TEST)
	ld a, [wTrainerHeaderFlagBit]
	ld c, a
	ld b, FLAG_TEST
	call TrainerFlagAction
	ld a, c
;> if beaten:
	and a
	jr z, .trainerNotYetFought
;>     return PrintText(ReadTrainerHeaderInfo(TRAINER_AFTER_BATTLE_TEXT))
	ld a, TRAINER_AFTER_BATTLE_TEXT
	call ReadTrainerHeaderInfo
	jp PrintText
.trainerNotYetFought
;> PrintText(ReadTrainerHeaderInfo(TRAINER_BEFORE_BATTLE_TEXT))
	ld a, TRAINER_BEFORE_BATTLE_TEXT
	call ReadTrainerHeaderInfo
	call PrintText
;> ReadTrainerHeaderInfo(TRAINER_LOST_BATTLE_TEXT)    # de keeps what it held, see ReadTrainerHeaderInfo
	ld a, TRAINER_LOST_BATTLE_TEXT
	call ReadTrainerHeaderInfo
;> win = ReadTrainerHeaderInfo(TRAINER_WON_BATTLE_TEXT)   # (de kept on the stack)
	push de
	ld a, TRAINER_WON_BATTLE_TEXT
	call ReadTrainerHeaderInfo
;> SaveEndBattleTextPointers(win, de)
	pop de
	call SaveEndBattleTextPointers
;> wStatusFlags7 = wStatusFlags7 | 1 << BIT_USE_CUR_MAP_SCRIPT
	ld hl, wStatusFlags7
	set BIT_USE_CUR_MAP_SCRIPT, [hl] ; activate map script index override (index is set below)
;> if wMiscFlags & 1 << BIT_SEEN_BY_TRAINER:
;>     return
	ld hl, wMiscFlags
	bit BIT_SEEN_BY_TRAINER, [hl]
	ret nz
; if the player talked to the trainer of their own volition
;> EngageMapTrainer()
	call EngageMapTrainer
;> wCurMapScript = u8(wCurMapScript + 1)    # StartTrainerBattle adds another 1
	ld hl, wCurMapScript
	inc [hl] ; increment map script index before StartTrainerBattle increments it again (next script function is usually EndTrainerBattle)
;> StartTrainerBattle()
	jp StartTrainerBattle

; checks if any trainers are seeing the player and wanting to fight
;@ path: home/trainers
;@ def CheckFightingMapTrainers()
;@ The map script step that looks for a trainer who sees the player: if one does, show the "!" bubble, freeze
;@ the d-pad, let the trainer walk up and go on to the next script step.
CheckFightingMapTrainers::
;> CheckForEngagingTrainers()
	call CheckForEngagingTrainers
;> if wSpriteIndex == 0xFF:
	ld a, [wSpriteIndex]
	cp $ff
	jr nz, .trainerEngaging
;>     wSpriteIndex = 0
	xor a
	ld [wSpriteIndex], a
;>     wTrainerHeaderFlagBit = 0
	ld [wTrainerHeaderFlagBit], a
;>     return
	ret
.trainerEngaging
;> wStatusFlags7 = wStatusFlags7 | 1 << BIT_TRAINER_BATTLE
	ld hl, wStatusFlags7
	set BIT_TRAINER_BATTLE, [hl]
;> wEmotionBubbleSpriteIndex = wSpriteIndex
	ld [wEmotionBubbleSpriteIndex], a
;> wWhichEmotionBubble = EXCLAMATION_BUBBLE
	xor a ; EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
;> Predef((EmotionBubblePredef - PredefPointers) // 3)    # EmotionBubble
	ld a, (EmotionBubblePredef - PredefPointers) / 3
	call Predef
;> wJoyIgnore = PAD_CTRL_PAD
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
;> hJoyHeld = 0
	xor a
	ldh [hJoyHeld], a
;> TrainerWalkUpToPlayer_Bank0()
	call TrainerWalkUpToPlayer_Bank0
;> wCurMapScript = u8(wCurMapScript + 1)
	ld hl, wCurMapScript
	inc [hl] ; increment map script index (next script function is usually DisplayEnemyTrainerTextAndStartBattle)
	ret

; display the before battle text after the enemy trainer has walked up to the player's sprite
;@ path: home/trainers
;@ def DisplayEnemyTrainerTextAndStartBattle()
;@ The map script step after a trainer walked up: once the trainer stands next to the player, show the
;@ trainer's text and start the battle.
DisplayEnemyTrainerTextAndStartBattle::
;> if wStatusFlags5 & 1 << BIT_SCRIPTED_NPC_MOVEMENT:
;>     return
	ld a, [wStatusFlags5]
	and 1 << BIT_SCRIPTED_NPC_MOVEMENT
	ret nz ; return if the enemy trainer hasn't finished walking to the player's sprite
;> wJoyIgnore = 0
	ld [wJoyIgnore], a
;> hSpriteIndex = wSpriteIndex
	ld a, [wSpriteIndex]
	ldh [hSpriteIndex], a
;> DisplayTextID()
	call DisplayTextID
;> StartTrainerBattle()
	; fall through

;@ path: home/trainers
;@ def StartTrainerBattle()
;@ Set up the battle against the engaged trainer (it starts once the map script returns) and go on to the next
;@ script step.
StartTrainerBattle::
;> wJoyIgnore = 0
	xor a
	ld [wJoyIgnore], a
;> InitBattleEnemyParameters()
	call InitBattleEnemyParameters
;> wStatusFlags3 |= 1 << BIT_TALKED_TO_TRAINER | 1 << BIT_PRINT_END_BATTLE_TEXT
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
;> wStatusFlags4 |= 1 << BIT_UNKNOWN_4_1
	ld hl, wStatusFlags4
	set BIT_UNKNOWN_4_1, [hl]
;> wCurMapScript = u8(wCurMapScript + 1)   # the next step, usually EndTrainerBattle
	ld hl, wCurMapScript
	inc [hl] ; increment map script index (next script function is usually EndTrainerBattle)
	ret

;@ path: home/trainers
;@ def EndTrainerBattle()
;@ The map script step after a trainer battle: reload the map, and unless the player lost, mark the trainer
;@ as beaten. After a battle against a Pokémon on the map (not a trainer) its sprite is hidden. Then the map
;@ script starts over, unless the script asked to keep its index (BIT_UNKNOWN_5_4, cleared here).
EndTrainerBattle::
;> wCurrentMapScriptFlags = wCurrentMapScriptFlags | 1 << BIT_CUR_MAP_LOADED_1 | 1 << BIT_CUR_MAP_LOADED_2
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	set BIT_CUR_MAP_LOADED_2, [hl]
;> wStatusFlags3 = wStatusFlags3 & ~(1 << BIT_PRINT_END_BATTLE_TEXT)
	ld hl, wStatusFlags3
	res BIT_PRINT_END_BATTLE_TEXT, [hl]
;> wMiscFlags = wMiscFlags & ~(1 << BIT_SEEN_BY_TRAINER)
	ld hl, wMiscFlags
	res BIT_SEEN_BY_TRAINER, [hl]
;> if wIsInBattle == LOST_BATTLE:
;>     return ResetButtonPressedAndMapScript()
	ld a, [wIsInBattle]
	cp LOST_BATTLE
	jp z, ResetButtonPressedAndMapScript
;> flags = ReadTrainerHeaderInfo(TRAINER_EVENT_FLAG_POINTER)
	ld a, TRAINER_EVENT_FLAG_POINTER
	call ReadTrainerHeaderInfo
;> TrainerFlagAction(flags, wTrainerHeaderFlagBit, FLAG_SET)
	ld a, [wTrainerHeaderFlagBit]
	ld c, a
	ld b, FLAG_SET
	call TrainerFlagAction ; flag trainer as fought
;> if wEnemyMonOrTrainerClass < OPP_ID_OFFSET:
	ld a, [wEnemyMonOrTrainerClass]
	cp OPP_ID_OFFSET
	jr nc, .skipRemoveSprite
;>     index, entry, found = IsInArray(wSpriteIndex, addr(wToggleableObjectList), 2)
	ld hl, wToggleableObjectList
	ld de, $2
	ld a, [wSpriteIndex]
	call IsInArray ; search for sprite ID
;>     wToggleableObjectIndex = mem[entry + 1]
	inc hl
	ld a, [hl]
	ld [wToggleableObjectIndex], a
;>     Predef((HideObjectPredef - PredefPointers) // 3)    # HideObject
	ld a, (HideObjectPredef - PredefPointers) / 3
	call Predef
.skipRemoveSprite
;> keep = wStatusFlags5 & 1 << BIT_UNKNOWN_5_4
	ld hl, wStatusFlags5
	bit BIT_UNKNOWN_5_4, [hl]
;> wStatusFlags5 = wStatusFlags5 & ~(1 << BIT_UNKNOWN_5_4)
	res BIT_UNKNOWN_5_4, [hl]
;> if keep:
;>     return
	ret nz
;> ResetButtonPressedAndMapScript()    # it follows right below

;@ path: home/trainers
;@ def ResetButtonPressedAndMapScript()
;@ Clear the joypad state and the ignored buttons, and set the map script back to step 0.
ResetButtonPressedAndMapScript::
;> wJoyIgnore = 0
	xor a
	ld [wJoyIgnore], a
;> hJoyHeld = 0
	ldh [hJoyHeld], a
;> hJoyPressed = 0
	ldh [hJoyPressed], a
;> hJoyReleased = 0
	ldh [hJoyReleased], a
;> wCurMapScript = 0
	ld [wCurMapScript], a
	ret

;@ path: home/trainers
;@ def TrainerWalkUpToPlayer_Bank0()
;@ TrainerWalkUpToPlayer from the home bank.
TrainerWalkUpToPlayer_Bank0::
;> TrainerWalkUpToPlayer()
;> set_rom_bank(hLoadedROMBank)    # a far call returns to the bank in hLoadedROMBank
	ld b, BANK(TrainerWalkUpToPlayer)
	ld hl, TrainerWalkUpToPlayer
	jp Bankswitch

; sets opponent trainer class and party level based on the engaging trainer data
;@ path: home/trainers
;@ def InitBattleEnemyParameters()
;@ Make the engaged trainer the opponent: its class, and its party number, or for a Pokémon on the map (an ID
;@ below OPP_ID_OFFSET) its level.
InitBattleEnemyParameters::
;> opponent = wEngagedTrainerClass
	ld a, [wEngagedTrainerClass]
;> wCurOpponent = opponent
	ld [wCurOpponent], a
;> wEnemyMonOrTrainerClass = opponent
	ld [wEnemyMonOrTrainerClass], a
;> if opponent >= OPP_ID_OFFSET:
	cp OPP_ID_OFFSET
	ld a, [wEngagedTrainerSet]
	jr c, .noTrainer
;>     wTrainerNo = wEngagedTrainerSet
	ld [wTrainerNo], a
	ret
.noTrainer
;> else:
;>     wCurEnemyLevel = wEngagedTrainerSet
	ld [wCurEnemyLevel], a
	ret

;@ path: home/trainers
;@ def GetSpritePosition1()
;@ _GetSpritePosition1 in its bank.
GetSpritePosition1::
;> SpritePositionBankswitch(_GetSpritePosition1)
	ld hl, _GetSpritePosition1
	jr SpritePositionBankswitch

;@ path: home/trainers
;@ def GetSpritePosition2()
;@ _GetSpritePosition2 in its bank.
GetSpritePosition2::
;> SpritePositionBankswitch(_GetSpritePosition2)
	ld hl, _GetSpritePosition2
	jr SpritePositionBankswitch

;@ path: home/trainers
;@ def SetSpritePosition1()
;@ _SetSpritePosition1 in its bank.
SetSpritePosition1::
;> SpritePositionBankswitch(_SetSpritePosition1)
	ld hl, _SetSpritePosition1
	jr SpritePositionBankswitch

;@ path: home/trainers
;@ def SetSpritePosition2()
;@ _SetSpritePosition2 in its bank.
SetSpritePosition2::
;> SpritePositionBankswitch(_SetSpritePosition2)
	ld hl, _SetSpritePosition2
;@ path: home/trainers
;@ def SpritePositionBankswitch(func: hl)
;@ Run one of the four sprite position functions, which live in the "Trainer Sight" bank.
SpritePositionBankswitch::
;> Bankswitch(BANK(_GetSpritePosition1), func)
	ld b, BANK("Trainer Sight")
	jp Bankswitch ; indirect jump to one of the four functions

;@ path: home/trainers
;@ def CheckForEngagingTrainers()
;@ Go through the map's trainer headers (TRAINER_STRUCT_SIZE bytes each, ending with -1) and let each trainer
;@ not beaten yet look for the player (TrainerEngage). Stops at the first one who sees the player:
;@ wSpriteIndex is then that trainer's sprite, otherwise -1.
CheckForEngagingTrainers::
;> entry = ReadTrainerHeaderInfo(TRAINER_EVENT_FLAG_BIT)    # the first header
	xor a ; TRAINER_EVENT_FLAG_BIT
	call ReadTrainerHeaderInfo
	ld d, h
	ld e, l
;> while True:
.trainerLoop
;>     StoreTrainerHeaderPointer(entry)
	call StoreTrainerHeaderPointer
;>     sprite = mem[entry]
	ld a, [de]
;>     wSpriteIndex = sprite
	ld [wSpriteIndex], a
;>     wTrainerHeaderFlagBit = sprite
	ld [wTrainerHeaderFlagBit], a
;>     if sprite == 0xFF:
;>         return
	cp -1
	ret z
;>     flags = ReadTrainerHeaderInfo(TRAINER_EVENT_FLAG_POINTER)
	ld a, TRAINER_EVENT_FLAG_POINTER
	call ReadTrainerHeaderInfo
;>     beaten = TrainerFlagAction(flags, wTrainerHeaderFlagBit, FLAG_TEST)
	ld b, FLAG_TEST
	ld a, [wTrainerHeaderFlagBit]
	ld c, a
	call TrainerFlagAction
	ld a, c
;>     if not beaten:
	and a ; has the trainer already been defeated?
	jr nz, .continue
;>         # (the flag pointer and entry kept on the stack)
	push hl
	push de
;>         p = ReadTrainerHeaderInfo(TRAINER_EVENT_FLAG_BIT)
	push hl
	xor a ; TRAINER_EVENT_FLAG_BIT
	call ReadTrainerHeaderInfo
;>         wTrainerEngageDistance = mem[p + 1]
	inc hl
	ld a, [hl]
	pop hl
	ld [wTrainerEngageDistance], a
;>         wTrainerSpriteOffset = swap(wSpriteIndex)
	ld a, [wSpriteIndex]
	swap a
	ld [wTrainerSpriteOffset], a
;>         Predef((TrainerEngagePredef - PredefPointers) // 3)    # TrainerEngage
	ld a, (TrainerEngagePredef - PredefPointers) / 3
	call Predef
;>         # (entry and the flag pointer come back off the stack)
	pop de
	pop hl
;>         if wTrainerSpriteOffset:
;>             return
	ld a, [wTrainerSpriteOffset]
	and a
	ret nz ; break if the trainer is engaging
.continue
;>     entry += TRAINER_STRUCT_SIZE
	ld hl, TRAINER_STRUCT_SIZE
	add hl, de
	ld d, h
	ld e, l
	jr .trainerLoop

; hl = text if the player wins
; de = text if the player loses
;@ path: home/trainers
;@ def SaveEndBattleTextPointers(win: hl, lose: de)
;@ Remember the trainer's texts for when the player wins and loses (high byte first), and the bank they are in.
SaveEndBattleTextPointers::
;> wEndBattleTextRomBank = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	ld [wEndBattleTextRomBank], a
;> wEndBattleWinTextPointer[0] = hi(win)
	ld a, h
	ld [wEndBattleWinTextPointer], a
;> wEndBattleWinTextPointer[1] = lo(win)
	ld a, l
	ld [wEndBattleWinTextPointer + 1], a
;> wEndBattleLoseTextPointer[0] = hi(lose)
	ld a, d
	ld [wEndBattleLoseTextPointer], a
;> wEndBattleLoseTextPointer[1] = lo(lose)
	ld a, e
	ld [wEndBattleLoseTextPointer + 1], a
	ret

; loads data of some trainer on the current map and plays pre-battle music
; [wSpriteIndex]: sprite ID of trainer who is engaged
;@ path: home/trainers
;@ def EngageMapTrainer()
;@ Take the trainer class and party number of sprite wSpriteIndex from wMapSpriteExtraData and play the music
;@ for meeting that trainer.
EngageMapTrainer::
;> p = addr(wMapSpriteExtraData)
	ld hl, wMapSpriteExtraData
	ld d, 0
;> p += u8(2 * u8(wSpriteIndex - 1))   # two bytes per person
	ld a, [wSpriteIndex]
	dec a
	add a
	ld e, a
	add hl, de
;> wEngagedTrainerClass = mem[p]
	ld a, [hli]
	ld [wEngagedTrainerClass], a
;> wEngagedTrainerSet = mem[p + 1]
	ld a, [hl]
	ld [wEngagedTrainerSet], a
;> return PlayTrainerMusic()
	jp PlayTrainerMusic

;@ path: home/trainers
;@ def PrintEndBattleText()
;@ After a trainer battle, print the trainer's name and win or lose text (once), then let the trainer stand
;@ still and wait for the sound to end. Keeps hl.
;@ test: skip waits for the sound engine, which runs from an interrupt
PrintEndBattleText::
;> show = wStatusFlags3 & 1 << BIT_PRINT_END_BATTLE_TEXT
;> wStatusFlags3 = wStatusFlags3 & ~(1 << BIT_PRINT_END_BATTLE_TEXT)
	push hl
	ld hl, wStatusFlags3
	bit BIT_PRINT_END_BATTLE_TEXT, [hl]
	res BIT_PRINT_END_BATTLE_TEXT, [hl]
;> if not show:
;>     return
	pop hl
	ret z
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = wEndBattleTextRomBank
	ld a, [wEndBattleTextRomBank]
	ldh [hLoadedROMBank], a
;> set_rom_bank(wEndBattleTextRomBank)
	ld [rROMB], a
;> SaveTrainerName()
;> set_rom_bank(hLoadedROMBank)    # a far call returns to the bank in hLoadedROMBank
	push hl
	ld b, BANK(SaveTrainerName)
	ld hl, SaveTrainerName
	call Bankswitch
;> PrintText(TrainerEndBattleText)
	ld hl, TrainerEndBattleText
	call PrintText
;> hLoadedROMBank = saved
	pop hl
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
;> SetEnemyTrainerToStayAndFaceAnyDirection()
;> set_rom_bank(hLoadedROMBank)
	ld b, BANK(SetEnemyTrainerToStayAndFaceAnyDirection)
	ld hl, SetEnemyTrainerToStayAndFaceAnyDirection
	call Bankswitch
;> WaitForSoundToFinish()
	jp WaitForSoundToFinish

;@ path: home/trainers
;@ def GetSavedEndBattleTextPointer() -> hl
;@ The trainer's text for the battle's result: the win text, or the lose text if wBattleResult is set.
GetSavedEndBattleTextPointer::
;> if not wBattleResult:               # won
	ld a, [wBattleResult]
	and a
	jr nz, .lostBattle
; won battle
;>     return wEndBattleWinTextPointer[0] << 8 | wEndBattleWinTextPointer[1]
	ld a, [wEndBattleWinTextPointer]
	ld h, a
	ld a, [wEndBattleWinTextPointer + 1]
	ld l, a
	ret
.lostBattle
;> return wEndBattleLoseTextPointer[0] << 8 | wEndBattleLoseTextPointer[1]
	ld a, [wEndBattleLoseTextPointer]
	ld h, a
	ld a, [wEndBattleLoseTextPointer + 1]
	ld l, a
	ret

;@ path: home/trainers
;@ def TrainerEndBattleText(cursor: bc) -> hl
;@ A text: the trainer's name, then (in code) the trainer's own win or lose text, printed at the cursor.
;@ test: skip starts with text commands; the code runs inside the text engine
TrainerEndBattleText::
	db TX_FAR
	dw _TrainerNameText
	db BANK(_TrainerNameText)
	db TX_START_ASM
;> TextCommandProcessor(GetSavedEndBattleTextPointer(), cursor)
;> return TextScriptEnd()
	call GetSavedEndBattleTextPointer
	call TextCommandProcessor
	jp TextScriptEnd

; only engage with the trainer if the player is not already
; engaged with another trainer
; XXX unused?
;@ path: home/trainers
;@ def CheckIfAlreadyEngaged() -> zero
;@ Unless a trainer has already seen the player, engage the trainer of sprite wSpriteIndex (zero flag then).
;@ Not used.
CheckIfAlreadyEngaged::
;> if wMiscFlags & 1 << BIT_SEEN_BY_TRAINER:
;>     return False
	ld a, [wMiscFlags]
	bit BIT_SEEN_BY_TRAINER, a
	ret nz
;> EngageMapTrainer()
	call EngageMapTrainer
;> return True
	xor a
	ret

;@ path: home/trainers
;@ def PlayTrainerMusic()
;@ Play the music for meeting trainer class wEngagedTrainerClass: the evil trainer, female trainer or male
;@ trainer tune. Not for the rival or a gym leader, who have their own music.
PlayTrainerMusic::
;> opponent = wEngagedTrainerClass
	ld a, [wEngagedTrainerClass]
;> if opponent in (OPP_RIVAL1, OPP_RIVAL2, OPP_RIVAL3):
;>     return
	cp OPP_RIVAL1
	ret z
	cp OPP_RIVAL2
	ret z
	cp OPP_RIVAL3
	ret z
;> if wGymLeaderNo:
;>     return
	ld a, [wGymLeaderNo]
	and a
	ret nz
;> wAudioFadeOutControl = 0
	xor a
	ld [wAudioFadeOutControl], a
;> PlaySound(SFX_STOP_ALL_MUSIC)
	ld a, SFX_STOP_ALL_MUSIC
	call PlaySound
;> wAudioROMBank = BANK(Music_MeetEvilTrainer)
	ld a, BANK(Music_MeetEvilTrainer)
	ld [wAudioROMBank], a
;> wAudioSavedROMBank = BANK(Music_MeetEvilTrainer)
	ld [wAudioSavedROMBank], a
;> p = EvilTrainerList
	ld a, [wEngagedTrainerClass]
	ld b, a
	ld hl, EvilTrainerList
;> while mem[p] != 0xFF and mem[p] != opponent:
;>     p += 1
.evilTrainerListLoop
	ld a, [hli]
	cp $ff
	jr z, .noEvilTrainer
	cp b
	jr nz, .evilTrainerListLoop
;> if mem[p] != 0xFF:
;>     music = MUSIC_MEET_EVIL_TRAINER
	ld a, MUSIC_MEET_EVIL_TRAINER
	jr .PlaySound
.noEvilTrainer
;> else:
;>     p = FemaleTrainerList
	ld hl, FemaleTrainerList
;>     while mem[p] != 0xFF and mem[p] != opponent:
;>         p += 1
.femaleTrainerListLoop
	ld a, [hli]
	cp $ff
	jr z, .maleTrainer
	cp b
	jr nz, .femaleTrainerListLoop
;>     music = MUSIC_MEET_FEMALE_TRAINER if mem[p] != 0xFF else MUSIC_MEET_MALE_TRAINER
	ld a, MUSIC_MEET_FEMALE_TRAINER
	jr .PlaySound
.maleTrainer
	ld a, MUSIC_MEET_MALE_TRAINER
.PlaySound
;> wNewSoundID = music
	ld [wNewSoundID], a
;> PlaySound(music)
	jp PlaySound

;@ path: home/trainers
FemaleTrainerList::
	db OPP_LASS
	db OPP_JR_TRAINER_F
	db OPP_BEAUTY
	db OPP_COOLTRAINER_F
	db -1 ; end

;@ path: home/trainers
EvilTrainerList::
	db OPP_UNUSED_JUGGLER
	db OPP_GAMBLER
	db OPP_ROCKER
	db OPP_JUGGLER
	db OPP_CHIEF
	db OPP_SCIENTIST
	db OPP_GIOVANNI
	db OPP_ROCKET
	db -1 ; end
; checks if the player's coordinates match an arrow movement tile's coordinates
; and if so, decodes the RLE movement data
; b = player Y
; c = player X
;@ path: home/map_objects
;@ def DecodeArrowMovementRLE(list: hl, y: b, x: c)
;@ Look for the player's position (y, x) in a list of 4-byte entries (Y, X, pointer to a run-length encoded
;@ list of buttons) ending with $FF. On a match, unpack the buttons into the simulated joypad states, which
;@ then push the player along (the arrow tiles of the Rocket Hideout and Viridian Gym).
;@ test: list = rand_ram(24); mem[list + 4 * rand(0, 4)] = 0xFF
DecodeArrowMovementRLE::
;> while True:
;>     entry_y = mem[list]
	ld a, [hli]
;>     if entry_y == 0xFF:
;>         return
	cp $ff
	ret z ; no match in the list
;>     if entry_y == y and mem[list + 1] == x:
	cp b
	jr nz, .nextArrowMovementTileEntry1
	ld a, [hli]
	cp c
	jr nz, .nextArrowMovementTileEntry2
;>         count = DecodeRLEList(addr(wSimulatedJoypadStatesEnd), mem16[list + 2])
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wSimulatedJoypadStatesEnd
	call DecodeRLEList
;>         wSimulatedJoypadStatesIndex = u8(count - 1)
	dec a
	ld [wSimulatedJoypadStatesIndex], a
;>         return
	ret
.nextArrowMovementTileEntry1
;>     list += 4
	inc hl
.nextArrowMovementTileEntry2
	inc hl
	inc hl
	jr DecodeArrowMovementRLE

;@ path: home/map_objects
;@ def TextScript_ItemStoragePC(saved=None)
;@ The player's own PC: save the screen and run PlayerPC, then close the text box (saved: the ROM bank
;@ DisplayTextID left on the stack).
;@ test: skip runs the PC menu, which waits for the player
TextScript_ItemStoragePC::
;> SaveScreenTilesToBuffer2()
;> return BankswitchAndContinue(BANK(PlayerPC), PlayerPC, saved)
	call SaveScreenTilesToBuffer2
	ld b, BANK(PlayerPC)
	ld hl, PlayerPC
	jr BankswitchAndContinue

;@ path: home/map_objects
;@ def TextScript_BillsPC(saved=None)
;@ Bill's PC (the Pokémon storage system): save the screen and run BillsPC_, then close the text box.
;@ test: skip runs the PC menu, which waits for the player
TextScript_BillsPC::
;> SaveScreenTilesToBuffer2()
;> return BankswitchAndContinue(BANK(BillsPC_), BillsPC_, saved)
	call SaveScreenTilesToBuffer2
	ld b, BANK(BillsPC_)
	ld hl, BillsPC_
	jr BankswitchAndContinue

;@ path: home/map_objects
;@ def TextScript_GameCornerPrizeMenu(saved=None)
;@ The Celadon Game Corner prize counter (CeladonPrizeMenu), then close the text box.
;@ test: skip runs the prize menu, which waits for the player
TextScript_GameCornerPrizeMenu::
;> return BankswitchAndContinue(BANK(CeladonPrizeMenu), CeladonPrizeMenu, saved)
	ld b, BANK(CeladonPrizeMenu)
	ld hl, CeladonPrizeMenu
;@ path: home/map_objects
;@ def BankswitchAndContinue(bank: b, func: hl, saved=None)
;@ Run func in ROM bank `bank`, then keep the text box open while A is held and close it.
;@ test: skip runs a menu, which waits for the player
BankswitchAndContinue::
;> Bankswitch(bank, func)
;> return HoldTextDisplayOpen(saved)
	call Bankswitch
	jp HoldTextDisplayOpen        ; continue to main text-engine function

;@ path: home/map_objects
;@ def TextScript_PokemonCenterPC(saved=None)
;@ A Pokémon Center PC (ActivatePC), then close the text box.
;@ test: skip runs the PC menu, which waits for the player
TextScript_PokemonCenterPC::
;> return BankswitchAndContinue(BANK(ActivatePC), ActivatePC, saved)
	ld b, BANK(ActivatePC)
	ld hl, ActivatePC
	jr BankswitchAndContinue

;@ path: home/map_objects
;@ def StartSimulatingJoypadStates()
;@ Start moving the player by the simulated joypad states (a scripted walk) instead of the buttons.
StartSimulatingJoypadStates::
;> wOverrideSimulatedJoypadStatesMask = 0
	xor a
	ld [wOverrideSimulatedJoypadStatesMask], a
;> mem[addr(wSpritePlayerStateData2MovementByte1)] = 0
	ld [wSpritePlayerStateData2MovementByte1], a
;> wStatusFlags5 = wStatusFlags5 | 1 << BIT_SCRIPTED_MOVEMENT_STATE
	ld hl, wStatusFlags5
	set BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ret

;@ path: home/map_objects
;@ def IsItemInBag(item: b) -> zero
;@ Zero flag if the bag holds no `item` (the Silph Scope, for the ghosts in Pokémon Tower).
IsItemInBag::
; given an item_id in b
; set zero flag if item isn't in player's bag
; else reset zero flag
; related to Pokémon Tower and ghosts
;> Predef((GetQuantityOfItemInBagPredef - PredefPointers) // 3)    # GetQuantityOfItemInBag
;> return not b    # the quantity it leaves in b
	ld a, (GetQuantityOfItemInBagPredef - PredefPointers) / 3
	call Predef
	ld a, b
	and a
	ret

;@ path: home/map_objects
;@ def DisplayPokedex(mon: a)
;@ Show the Pokédex entry of species number `mon` (_DisplayPokedex).
;@ test: skip waits for the player to close the entry
DisplayPokedex::
;> wPokedexNum = mon
	ld [wPokedexNum], a
;> _DisplayPokedex()
;> set_rom_bank(hLoadedROMBank)        # a far call returns to the bank in hLoadedROMBank
	ld b, BANK(_DisplayPokedex)
	ld hl, _DisplayPokedex
	jp Bankswitch

;@ path: home/map_objects
;@ def SetSpriteFacingDirectionAndDelay()
;@ Turn sprite hSpriteIndex to hSpriteFacingDirection, then wait 6 frames.
SetSpriteFacingDirectionAndDelay::
;> SetSpriteFacingDirection()
;> DelayFrames(6)
	call SetSpriteFacingDirection
	ld c, 6
	jp DelayFrames

;@ path: home/map_objects
;@ def SetSpriteFacingDirection() -> hl
;@ Turn sprite hSpriteIndex to hSpriteFacingDirection; hl points at its facing direction byte.
;@ test: hSpriteIndex = rand(0, 15)
SetSpriteFacingDirection::
;> hSpriteDataOffset = SPRITESTATEDATA1_FACINGDIRECTION
	ld a, SPRITESTATEDATA1_FACINGDIRECTION
	ldh [hSpriteDataOffset], a
;> p = GetPointerWithinSpriteStateData1()
	call GetPointerWithinSpriteStateData1
;> mem[p] = hSpriteFacingDirection
	ldh a, [hSpriteFacingDirection]
	ld [hl], a
;> return p
	ret

;@ path: home/map_objects
;@ def SetSpriteImageIndexAfterSettingFacingDirection(ptr: hl, index: a)
;@ With ptr at a sprite's facing direction byte, set its picture index (7 bytes before) to `index`.
;@ test: ptr = rand_ram(16, 0xC010)
SetSpriteImageIndexAfterSettingFacingDirection::
;> mem[ptr + SPRITESTATEDATA1_IMAGEINDEX - SPRITESTATEDATA1_FACINGDIRECTION] = index
	ld de, SPRITESTATEDATA1_IMAGEINDEX - SPRITESTATEDATA1_FACINGDIRECTION
	add hl, de
	ld [hl], a
	ret

; tests if the player's coordinates are in a specified array
; INPUT:
; hl = address of array
; OUTPUT:
; [wCoordIndex] = if there is match, the matching array index
; sets carry if the coordinates are in the array, clears carry if not
;@ path: home/map_objects
;@ def ArePlayerCoordsInArray(array: hl) -> carry
;@ CheckCoords with the player's position.
;@ test: array = rand_ram(40); mem[array + 2 * rand(0, 15)] = 0xFF
ArePlayerCoordsInArray::
;> return CheckCoords(array, wYCoord, wXCoord)
	ld a, [wYCoord]
	ld b, a
	ld a, [wXCoord]
	ld c, a
	; fallthrough

;@ path: home/map_objects
;@ def CheckCoords(array: hl, y: b, x: c) -> carry
;@ Carry if (y, x) is in a list of Y, X pairs ending with $FF; wCoordIndex then counts the pairs up to and
;@ including the match (1 for the first).
;@ test: array = rand_ram(40); mem[array + 2 * rand(0, 15)] = 0xFF
CheckCoords::
;> mem[addr(wCoordIndex)] = 0
	xor a
	ld [wCoordIndex], a
;> while True:
;>     entry_y = mem[array]
.loop
	ld a, [hli]
;>     array += 1
;>     if entry_y == 0xFF:             # the end of the list
	cp $ff ; reached terminator?
	jr z, .notInArray
;>@nf         return False
;>     mem[addr(wCoordIndex)] = u8(mem[addr(wCoordIndex)] + 1)
	push hl
	ld hl, wCoordIndex
	inc [hl]
	pop hl
; compare Y coord
;>     if entry_y != y:
	cp b
	jr z, .compareXCoord
;>         array += 1                  # skip its x
	inc hl
;>         continue
	jr .loop
.compareXCoord
;>     entry_x = mem[array]
;>     array += 1
	ld a, [hli]
;>     if entry_x == x:
	cp c
	jr nz, .loop
; in array
;>         return True
	scf
	ret
.notInArray
;=@nf
	and a
	ret

; tests if a boulder's coordinates are in a specified array
; INPUT:
; hl = address of array
; [hSpriteIndex] = index of boulder sprite
; OUTPUT:
; [wCoordIndex] = if there is match, the matching array index
; sets carry if the coordinates are in the array, clears carry if not
;@ path: home/map_objects
;@ def CheckBoulderCoords(array: hl) -> carry
;@ CheckCoords with the map position of boulder sprite hSpriteIndex.
;@ test: hSpriteIndex = rand(0, 15); array = rand_ram(40); mem[array + 2 * rand(0, 15)] = 0xFF
CheckBoulderCoords::
;> # (array kept on the stack)
	push hl
;> p = addr(wSpritePlayerStateData2MapY) + swap(hSpriteIndex)   # the boulder's map position
	ld hl, wSpritePlayerStateData2MapY
	ldh a, [hSpriteIndex]
	swap a
	ld d, $0
	ld e, a
	add hl, de
;> y = u8(mem[p] - 4)                  # sprite positions are 4 more
	ld a, [hli]
	sub $4 ; because sprite coordinates are offset by 4
	ld b, a
;> x = u8(mem[p + 1] - 4)
	ld a, [hl]
	sub $4 ; because sprite coordinates are offset by 4
	ld c, a
;> return CheckCoords(array, y, x)
	pop hl
	jp CheckCoords

;@ path: home/map_objects
;@ def GetPointerWithinSpriteStateData1() -> hl
;@ The address of byte hSpriteDataOffset of sprite hSpriteIndex's record in wSpriteStateData1.
;@ test: hSpriteIndex = rand(0, 15); hSpriteDataOffset = rand(0, 15)
GetPointerWithinSpriteStateData1::
;> return _GetPointerWithinSpriteStateData(addr(wSpriteStateData1) >> 8)
	ld h, HIGH(wSpriteStateData1)
	jr _GetPointerWithinSpriteStateData

;@ path: home/map_objects
;@ def GetPointerWithinSpriteStateData2() -> hl
;@ The address of byte hSpriteDataOffset of sprite hSpriteIndex's record in wSpriteStateData2.
;@ test: hSpriteIndex = rand(0, 15); hSpriteDataOffset = rand(0, 15)
GetPointerWithinSpriteStateData2::
;> return _GetPointerWithinSpriteStateData(addr(wSpriteStateData2) >> 8)
	ld h, HIGH(wSpriteStateData2)

;@ path: home/map_objects
;@ def _GetPointerWithinSpriteStateData(high: h) -> hl
;@ Byte hSpriteDataOffset of sprite hSpriteIndex's 16-byte record in the 256-byte table at high * $100.
;@ test: hSpriteIndex = rand(0, 15); hSpriteDataOffset = rand(0, 15)
_GetPointerWithinSpriteStateData:
;> off = hSpriteDataOffset
	ldh a, [hSpriteDataOffset]
	ld b, a
;> return high << 8 | u8(swap(hSpriteIndex) + off)   # 16 bytes per sprite
	ldh a, [hSpriteIndex]
	swap a
	add b
	ld l, a
	ret

; decodes a $ff-terminated RLEncoded list
; each entry is a pair of bytes <byte value> <repetitions>
; the final $ff will be replicated in the output list and a contains the number of bytes written
; de: input list
; hl: output list
;@ path: home/map_objects
;@ def DecodeRLEList(dest: hl, src: de) -> a
;@ Unpack a run-length encoded list (value, count pairs ending with $FF) to dest, with the $FF at the end;
;@ returns the number of bytes written.
;@ test: src = rand_ram(80); n = rand(0, 6); [mem.__setitem__(src + 2 * i, rand(0, 0xFE)) for i in range(n)]; [mem.__setitem__(src + 2 * i + 1, rand(1, 8)) for i in range(n)]; mem[src + 2 * n] = 0xFF; dest = src + 16
DecodeRLEList::
;> wRLEByteCount = 0
	xor a
	ld [wRLEByteCount], a     ; count written bytes here
.listLoop
;> while mem[src] != 0xFF:
	ld a, [de]
	cp $ff
	jr z, .endOfList
;>     value = mem[src]
;>     hRLEByteValue = value
	ldh [hRLEByteValue], a ; store byte value to be written
;>     count = mem[src + 1]
	inc de
	ld a, [de]
	ld b, $0
	ld c, a                      ; number of bytes to be written
;>     wRLEByteCount = u8(wRLEByteCount + count)
	ld a, [wRLEByteCount]
	add c
	ld [wRLEByteCount], a     ; update total number of written bytes
;>     dest = FillMemory(dest, count, value)
	ldh a, [hRLEByteValue]
	call FillMemory              ; write a c-times to output
;>     src += 2
	inc de
	jr .listLoop
.endOfList
;> mem[dest] = 0xFF
	ld a, $ff
	ld [hl], a                   ; write final $ff
;> return u8(wRLEByteCount + 1)
	ld a, [wRLEByteCount]
	inc a                        ; include sentinel in counting
	ret

; sets movement byte 1 for sprite [hSpriteIndex] to $FE and byte 2 to [hSpriteMovementByte2]
;@ path: home/map_objects
;@ def SetSpriteMovementBytesToFE()
;@ Set sprite hSpriteIndex's movement byte 1 to $FE and movement byte 2 to hSpriteMovementByte2. Keeps hl.
;@ test: hSpriteIndex = rand(1, 15)
SetSpriteMovementBytesToFE::
;> # (hl kept on the stack)
	push hl
;> mem[GetSpriteMovementByte1Pointer()] = 0xFE
	call GetSpriteMovementByte1Pointer
	ld [hl], $fe
;> mem[GetSpriteMovementByte2Pointer()] = hSpriteMovementByte2
	call GetSpriteMovementByte2Pointer
	ldh a, [hSpriteMovementByte2]
	ld [hl], a
;> # (hl comes back off the stack)
	pop hl
	ret

; sets both movement bytes for sprite [hSpriteIndex] to $FF
;@ path: home/map_objects
;@ def SetSpriteMovementBytesToFF()
;@ Make sprite hSpriteIndex stand still: movement byte 1 STAY, movement byte 2 NONE. Keeps hl.
;@ test: hSpriteIndex = rand(1, 15)
SetSpriteMovementBytesToFF::
;> # (hl kept on the stack)
	push hl
;> mem[GetSpriteMovementByte1Pointer()] = STAY
	call GetSpriteMovementByte1Pointer
	ld [hl], STAY
;> mem[GetSpriteMovementByte2Pointer()] = NONE
	call GetSpriteMovementByte2Pointer
	ld [hl], NONE
;> # (hl comes back off the stack)
	pop hl
	ret

; returns the sprite movement byte 1 pointer for sprite [hSpriteIndex] in hl
;@ path: home/map_objects
;@ def GetSpriteMovementByte1Pointer() -> hl
;@ The address of sprite hSpriteIndex's movement byte 1 (byte 6 of its record in wSpriteStateData2).
;@ test: hSpriteIndex = rand(0, 15)
GetSpriteMovementByte1Pointer::
;> return addr(wSpriteStateData2) & 0xFF00 | u8(swap(hSpriteIndex) + 6)
	ld h, HIGH(wSpriteStateData2)
	ldh a, [hSpriteIndex]
	swap a
	add 6
	ld l, a
	ret

; returns the sprite movement byte 2 pointer for sprite [hSpriteIndex] in hl
;@ path: home/map_objects
;@ def GetSpriteMovementByte2Pointer() -> hl
;@ The address of sprite hSpriteIndex's movement byte 2 in wMapSpriteData (two bytes per sprite, from
;@ sprite 1). Keeps de.
;@ test: hSpriteIndex = rand(1, 15)
GetSpriteMovementByte2Pointer::
;> # (de kept on the stack)
	push de
;> p = addr(wMapSpriteData)
	ld hl, wMapSpriteData
;> p += u8(2 * u8(hSpriteIndex - 1))  # two bytes per sprite, from sprite 1
	ldh a, [hSpriteIndex]
	dec a
	add a
	ld d, 0
	ld e, a
	add hl, de
;> # (de comes back off the stack)
	pop de
;> return p
	ret
;@ path: home/trainers2
;@ def GetTrainerInformation()
;@ Get ready to battle a trainer: their name, and from wTrainerClass the picture and the base prize money. In a
;@ link battle the other player is shown with Red's picture.
GetTrainerInformation::
;> GetTrainerName()
	call GetTrainerName
;> if wLinkState == 0:
	ld a, [wLinkState]
	and a
	jr nz, .linkBattle
;>     BankswitchHome(BANK(TrainerPicAndMoneyPointers))
	ld a, BANK(TrainerPicAndMoneyPointers)
	call BankswitchHome
;>     p = AddNTimes(TrainerPicAndMoneyPointers, 5, (wTrainerClass - 1) & 0xFF)
	ld a, [wTrainerClass]
	dec a
	ld hl, TrainerPicAndMoneyPointers
	ld bc, $5
	call AddNTimes
;>     copy(addr(wTrainerPicPointer), p, 2)
	ld de, wTrainerPicPointer
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
;>     copy(addr(wTrainerBaseMoney), p + 2, 2)
	ld de, wTrainerBaseMoney
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
;>     return BankswitchBack()
	jp BankswitchBack
;> else:
.linkBattle
;>     mem16[addr(wTrainerPicPointer)] = RedPicFront
	ld hl, wTrainerPicPointer
	ld de, RedPicFront
	ld [hl], e
	inc hl
	ld [hl], d
	ret

;@ path: home/trainers2
;@ def GetTrainerName()
;@ Put the opponent's name into wTrainerName (the code for this sits in another bank).
GetTrainerName::
;> GetTrainerName_()
;> set_rom_bank(hLoadedROMBank)    # a far call returns to the bank in hLoadedROMBank
	ld b, BANK(GetTrainerName_)
	ld hl, GetTrainerName_
	jp Bankswitch
;@ def HasEnoughMoney() -> (carry, zero)
;@ Compare the player's money with the 3-byte BCD price in hMoney: carry if it is less, zero if it is the same.
HasEnoughMoney::
; Check if the player has at least as much
; money as the 3-byte BCD value at hMoney.
;> return StringCmp(wPlayerMoney, hMoney, 3)
	ld de, wPlayerMoney
	ld hl, hMoney
	ld c, 3
	jp StringCmp

;@ def HasEnoughCoins() -> (carry, zero)
;@ Compare the player's Game Corner coins with the 2-byte BCD amount in hCoins: carry if fewer, zero if the same.
HasEnoughCoins::
; Check if the player has at least as many
; coins as the 2-byte BCD value at hCoins.
;> return StringCmp(wPlayerCoins, hCoins, 2)
	ld de, wPlayerCoins
	ld hl, hCoins
	ld c, 2
	jp StringCmp
;@ def BankswitchHome(bank: a)
;@ Switch ROM bank `bank` in, remembering the bank that was in for BankswitchBack.
;@ path: system/banks
BankswitchHome::
; switches to bank # in a
; Only use this when in the home bank!
;> wBankswitchHomeTemp = bank
	ld [wBankswitchHomeTemp], a
;> wBankswitchHomeSavedROMBank = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	ld [wBankswitchHomeSavedROMBank], a
	ld a, [wBankswitchHomeTemp]
;> hLoadedROMBank = bank
;> set_rom_bank(bank)
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret

;@ def BankswitchBack()
;@ Switch back to the bank BankswitchHome saved.
;@ path: system/banks
BankswitchBack::
; returns from BankswitchHome
;> hLoadedROMBank = wBankswitchHomeSavedROMBank
;> set_rom_bank(wBankswitchHomeSavedROMBank)
	ld a, [wBankswitchHomeSavedROMBank]
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret

;@ path: home/bankswitch
;@ def Bankswitch(bank: b, func: hl)
;@ Call the function at func in ROM bank `bank`, then switch the bank that was in back in. The way code
;@ outside the home bank calls code in another bank.
;@ test: skip calls whatever function hl points at
Bankswitch::
; self-contained bankswitch, use this when not in the home bank
; switches to the bank in b
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = bank
;> set_rom_bank(bank)
	ld a, b
	ldh [hLoadedROMBank], a
	ld [rROMB], a
;> call(func)
	ld bc, .Return
	push bc
	jp hl
.Return
;> hLoadedROMBank = saved
;> set_rom_bank(saved)
	pop bc
	ld a, b
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret
; displays yes/no choice
; yes -> set carry
;@ path: home/yes_no
;@ def YesNoChoice()
;@ Ask YES / NO in a box at the right of the screen, keeping what was under it to put back afterwards.
YesNoChoice::
;> SaveScreenTilesToBuffer1()
	call SaveScreenTilesToBuffer1
;> InitYesNoTextBoxParameters()  # the box at tile (14, 7), 8 x 15
	call InitYesNoTextBoxParameters
;> DisplayYesNoChoice()
	jr DisplayYesNoChoice

;@ path: home/yes_no
;@ def TwoOptionMenu()
;@ Draw the two-option menu wTwoOptionMenuID at tile (14, 7), without saving the screen first. Unused.
TwoOptionMenu:: ; unreferenced
;> wTextBoxID = TWO_OPTION_MENU
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
;> InitYesNoTextBoxParameters()
	call InitYesNoTextBoxParameters
;> DisplayTextBoxID()
	jp DisplayTextBoxID

;@ path: home/yes_no
;@ def InitYesNoTextBoxParameters() -> (hl, bc)
;@ Set up a YES / NO menu box at tile (14, 7): the menu kind, its position and its size (b = 8, c = 15).
InitYesNoTextBoxParameters::
;> wTwoOptionMenuID = YES_NO_MENU
;> return (coord(14, 7), 8 << 8 | 15)
	xor a ; YES_NO_MENU
	ld [wTwoOptionMenuID], a
	ld hl, (7) * SCREEN_WIDTH + (14) + wTileMap
	ld bc, ((8) & $ff) << 8 + ((15) & $ff)
	ret

;@ path: home/yes_no
;@ def YesNoChoicePokeCenter()
;@ The HEAL / CANCEL question of the Pokémon Center nurse.
YesNoChoicePokeCenter::
;> SaveScreenTilesToBuffer1()
	call SaveScreenTilesToBuffer1
;> wTwoOptionMenuID = HEAL_CANCEL_MENU
	ld a, HEAL_CANCEL_MENU
	ld [wTwoOptionMenuID], a
;> DisplayYesNoChoice()  # the box at tile (11, 6), 8 x 12
	ld hl, (6) * SCREEN_WIDTH + (11) + wTileMap
	ld bc, ((8) & $ff) << 8 + ((12) & $ff)
	jr DisplayYesNoChoice

;@ path: home/yes_no
;@ def WideYesNoChoice()
;@ A YES / NO question in a wider box. Unused.
WideYesNoChoice:: ; unreferenced
;> SaveScreenTilesToBuffer1()
	call SaveScreenTilesToBuffer1
;> wTwoOptionMenuID = WIDE_YES_NO_MENU
	ld a, WIDE_YES_NO_MENU
	ld [wTwoOptionMenuID], a
;> DisplayYesNoChoice()  # the box at tile (12, 7), 8 x 13
	ld hl, (7) * SCREEN_WIDTH + (12) + wTileMap
	ld bc, ((8) & $ff) << 8 + ((13) & $ff)

;@ path: home/yes_no
;@ def DisplayYesNoChoice()
;@ Show the two-option menu set up in hl (its corner) and bc (its size), wait for the answer, then put back
;@ the screen saved before it.
DisplayYesNoChoice::
;> wTextBoxID = TWO_OPTION_MENU
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
;> DisplayTextBoxID()
	call DisplayTextBoxID
;> LoadScreenTilesFromBuffer1()
	jp LoadScreenTilesFromBuffer1
; calculates the difference |a-b|, setting carry flag if a<b
;@ path: home/pathfinding
;@ def CalcDifference(x: a, y: b) -> (a, carry)
;@ |x - y|, with carry if y was the larger.
CalcDifference::
;> if x >= y:
;>     return (x - y, False)
	sub b
	ret nc
;> return (y - x, True)
	cpl
	add $1
	scf
	ret

;@ path: home/pathfinding
;@ def MoveSprite(moves: de)
;@ Give sprite hSpriteIndex a list of moves ending in -1 (it walks them later): marks its movement bytes $FF
;@ first, then MoveSprite_.
MoveSprite::
; move the sprite [hSpriteIndex] with the movement pointed to by de
; actually only copies the movement data to wNPCMovementDirections for later
;> SetSpriteMovementBytesToFF()
;> MoveSprite_(moves)
	call SetSpriteMovementBytesToFF
;@ path: home/pathfinding
;@ def MoveSprite_(moves: de)
;@ Copy the moves at `moves` (up to and including the -1) to wNPCMovementDirections, count them in
;@ wNPCNumScriptedSteps, and start the scripted NPC movement with the joypad ignored.
;@ test: moves = rand_ram(32); mem[moves + rand(0, 30)] = 0xFF
MoveSprite_::
;> # (hl and bc kept on the stack)
	push hl
	push bc
;> mem[GetSpriteMovementByte1Pointer()] = 0
	call GetSpriteMovementByte1Pointer
	xor a
	ld [hl], a
;> n = 0
	ld hl, wNPCMovementDirections
	ld c, 0

;>@lp while True:
.loop
;>     move = mem[moves + n]
;>     wNPCMovementDirections[n] = move
	ld a, [de]
	ld [hli], a
;>     n += 1
	inc de
	inc c
;>     if move == 0xFF:
;>         break
	cp -1 ; have we reached the end of the movement data?
	jr nz, .loop

;> wNPCNumScriptedSteps = n
	ld a, c
	ld [wNPCNumScriptedSteps], a ; number of steps taken

;> # (bc comes back off the stack)
	pop bc
;> wStatusFlags5 = wStatusFlags5 | 1 << BIT_SCRIPTED_NPC_MOVEMENT
	ld hl, wStatusFlags5
	set BIT_SCRIPTED_NPC_MOVEMENT, [hl]
;> # (hl comes back off the stack)
	pop hl
;> wOverrideSimulatedJoypadStatesMask = 0
	xor a
	ld [wOverrideSimulatedJoypadStatesMask], a
;> wSimulatedJoypadStatesEnd = 0
	ld [wSimulatedJoypadStatesEnd], a
;> wJoyIgnore = 0xFF
	dec a
	ld [wJoyIgnore], a
;> wUnusedOverrideSimulatedJoypadStatesIndex = 0xFF
	ld [wUnusedOverrideSimulatedJoypadStatesIndex], a
	ret

; divides [hDividend2] by [hDivisor2] and stores the quotient in [hQuotient2]
;@ path: home/pathfinding
;@ def DivideBytes()
;@ hQuotient2 = hDividend2 / hDivisor2 by repeated subtraction (0 if the divisor is 0).
;@ test: hDivisor2 = rand(0, 255); hDividend2 = rand(0, 255)
DivideBytes::
;> hQuotient2 = 0
	push hl
	ld hl, hQuotient2
	xor a
	ld [hld], a
;> if hDivisor2:
	ld a, [hld]
	and a
	jr z, .done
;>     rest = hDividend2
	ld a, [hli]
;>@sub     while True:
;>         rest -= hDivisor2
.loop
	sub [hl]
;>         if rest < 0:
;>             break
	jr c, .done
;>         hQuotient2 += 1
	inc hl
	inc [hl]
	dec hl
;=@sub
	jr .loop
.done
	pop hl
	ret
;@ path: home/load_font
;@ def LoadFontTilePatterns()
;@ Load the font (1 bit per pixel, doubled to 2) into vFont: at once with the LCD off, else a few tiles
;@ per VBlank.
LoadFontTilePatterns::
;> if not rLCDC & 1 << B_LCDC_ENABLE:  # the LCD is off: all at once
	ldh a, [rLCDC]
	bit B_LCDC_ENABLE, a
	jr nz, .on
; off
;>     return FarCopyDataDouble(BANK(FontGraphics), FontGraphics, vFont, FontGraphicsEnd - FontGraphics)
	ld hl, FontGraphics
	ld de, vFont
	ld bc, FontGraphicsEnd - FontGraphics
	ld a, BANK(FontGraphics)
	jp FarCopyDataDouble ; if LCD is off, transfer all at once
.on
;> return CopyVideoDataDouble(vFont, FontGraphics, BANK(FontGraphics), (FontGraphicsEnd - FontGraphics) // TILE_1BPP_SIZE)   # during VBlanks
	ld de, FontGraphics
	ld hl, vFont
	ld bc, ((BANK(FontGraphics)) & $ff) << 8 + (((FontGraphicsEnd - FontGraphics) / TILE_1BPP_SIZE) & $ff)
	jp CopyVideoDataDouble ; if LCD is on, transfer during V-blank

;@ path: home/load_font
;@ def LoadTextBoxTilePatterns()
;@ Load the text box border tiles to tile $60 on: at once with the LCD off, else during VBlanks.
LoadTextBoxTilePatterns::
;> if not rLCDC & 1 << B_LCDC_ENABLE:  # the LCD is off: all at once
	ldh a, [rLCDC]
	bit B_LCDC_ENABLE, a
	jr nz, .on
; off
;>     return FarCopyData2(BANK(TextBoxGraphics), TextBoxGraphics, vChars2 + 0x60 * TILE_SIZE, TextBoxGraphicsEnd - TextBoxGraphics)
	ld hl, TextBoxGraphics
	ld de, vChars2 + TILE_SIZE * $60
	ld bc, TextBoxGraphicsEnd - TextBoxGraphics
	ld a, BANK(TextBoxGraphics)
	jp FarCopyData2 ; if LCD is off, transfer all at once
.on
;> return CopyVideoData(vChars2 + 0x60 * TILE_SIZE, TextBoxGraphics, BANK(TextBoxGraphics), (TextBoxGraphicsEnd - TextBoxGraphics) // TILE_SIZE)
	ld de, TextBoxGraphics
	ld hl, vChars2 + TILE_SIZE * $60
	ld bc, ((BANK(TextBoxGraphics)) & $ff) << 8 + (((TextBoxGraphicsEnd - TextBoxGraphics) / TILE_SIZE) & $ff)
	jp CopyVideoData ; if LCD is on, transfer during V-blank

;@ path: home/load_font
;@ def LoadHpBarAndStatusTilePatterns()
;@ Load the HP bar and status tiles to tile $62 on: at once with the LCD off, else during VBlanks.
LoadHpBarAndStatusTilePatterns::
;> if not rLCDC & 1 << B_LCDC_ENABLE:  # the LCD is off: all at once
	ldh a, [rLCDC]
	bit B_LCDC_ENABLE, a
	jr nz, .on
; off
;>     return FarCopyData2(BANK(HpBarAndStatusGraphics), HpBarAndStatusGraphics, vChars2 + 0x62 * TILE_SIZE, HpBarAndStatusGraphicsEnd - HpBarAndStatusGraphics)
	ld hl, HpBarAndStatusGraphics
	ld de, vChars2 + TILE_SIZE * $62
	ld bc, HpBarAndStatusGraphicsEnd - HpBarAndStatusGraphics
	ld a, BANK(HpBarAndStatusGraphics)
	jp FarCopyData2 ; if LCD is off, transfer all at once
.on
;> return CopyVideoData(vChars2 + 0x62 * TILE_SIZE, HpBarAndStatusGraphics, BANK(HpBarAndStatusGraphics), (HpBarAndStatusGraphicsEnd - HpBarAndStatusGraphics) // TILE_SIZE)
	ld de, HpBarAndStatusGraphics
	ld hl, vChars2 + TILE_SIZE * $62
	ld bc, ((BANK(HpBarAndStatusGraphics)) & $ff) << 8 + (((HpBarAndStatusGraphicsEnd - HpBarAndStatusGraphics) / TILE_SIZE) & $ff)
	jp CopyVideoData ; if LCD is on, transfer during V-blank
;@ path: home/tilemap
;@ def FillMemory(dest: hl, count: bc, value: a) -> hl
;@ Set count bytes from dest to value. Returns dest just past them.
;@ test: count = rand(1, 200); dest = rand_ram(200)
FillMemory::
; Fill bc bytes at hl with a.
;> # (de kept on the stack)
	push de
;>@f fill(dest, value, count)
	ld d, a
.loop
;=@f
	ld a, d
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .loop
;> # (de comes back off the stack)
	pop de
;> return dest + count
	ret

;@ path: home/tilemap
;@ def UncompressSpriteFromDE(bank: a, src: de)
;@ Decompress the picture at src in ROM bank `bank` into the sprite buffers.
UncompressSpriteFromDE::
; Decompress pic at a:de.
;> wSpriteInputPtr[0] = lo(src)
;> wSpriteInputPtr[1] = hi(src)
	ld hl, wSpriteInputPtr
	ld [hl], e
	inc hl
	ld [hl], d
;> UncompressSpriteData(bank)
	jp UncompressSpriteData

;@ path: home/tilemap
;@ def SaveScreenTilesToBuffer2()
;@ Back the screen's tiles (wTileMap) up into wTileMapBackup2.
SaveScreenTilesToBuffer2::
;> CopyData(coord(0, 0), wTileMapBackup2, SCREEN_AREA)
	ld hl, (0) * SCREEN_WIDTH + (0) + wTileMap
	ld de, wTileMapBackup2
	ld bc, SCREEN_AREA
	call CopyData
	ret

;@ path: home/tilemap
;@ def LoadScreenTilesFromBuffer2()
;@ Put the tiles saved in wTileMapBackup2 back on the screen and turn the automatic BG map transfer on.
LoadScreenTilesFromBuffer2::
;> LoadScreenTilesFromBuffer2DisableBGTransfer()
	call LoadScreenTilesFromBuffer2DisableBGTransfer
;> hAutoBGTransferEnabled = 1
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	ret

; loads screen tiles stored in wTileMapBackup2 but leaves hAutoBGTransferEnabled disabled
;@ path: home/tilemap
;@ def LoadScreenTilesFromBuffer2DisableBGTransfer()
;@ Copy wTileMapBackup2 back to wTileMap with the automatic BG map transfer off (it stays off).
LoadScreenTilesFromBuffer2DisableBGTransfer::
;> hAutoBGTransferEnabled = 0
	xor a
	ldh [hAutoBGTransferEnabled], a
;> CopyData(wTileMapBackup2, coord(0, 0), SCREEN_AREA)
	ld hl, wTileMapBackup2
	ld de, (0) * SCREEN_WIDTH + (0) + wTileMap
	ld bc, SCREEN_AREA
	call CopyData
	ret

;@ path: home/tilemap
;@ def SaveScreenTilesToBuffer1()
;@ Back the screen's tiles up into wTileMapBackup.
SaveScreenTilesToBuffer1::
;> CopyData(coord(0, 0), wTileMapBackup, SCREEN_AREA)
	ld hl, (0) * SCREEN_WIDTH + (0) + wTileMap
	ld de, wTileMapBackup
	ld bc, SCREEN_AREA
	jp CopyData

;@ path: home/tilemap
;@ def LoadScreenTilesFromBuffer1()
;@ Put the tiles saved in wTileMapBackup back on the screen; the BG map transfer is off meanwhile, so no
;@ half-copied screen is shown.
LoadScreenTilesFromBuffer1::
;> hAutoBGTransferEnabled = 0
	xor a
	ldh [hAutoBGTransferEnabled], a
;> CopyData(wTileMapBackup, coord(0, 0), SCREEN_AREA)
	ld hl, wTileMapBackup
	ld de, (0) * SCREEN_WIDTH + (0) + wTileMap
	ld bc, SCREEN_AREA
	call CopyData
;> hAutoBGTransferEnabled = 1
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	ret
;@ path: home/delay
;@ def DelayFrames(frames: c)
;@ Wait `frames` frames (256 for 0).
DelayFrames::
; wait c frames
;> for _ in range(frames or 256):
;>     DelayFrame()
	call DelayFrame
	dec c
	jr nz, DelayFrames
	ret

;@ path: home/delay
;@ def PlaySoundWaitForCurrent(sound: a)
;@ Let the current sound effect finish, then play `sound`.
PlaySoundWaitForCurrent::
;> WaitForSoundToFinish()
	push af
	call WaitForSoundToFinish
	pop af
;> PlaySound(sound)
	jp PlaySound

; Wait for sound to finish playing
;@ path: home/delay
;@ def WaitForSoundToFinish()
;@ Wait until the sound effect channels 5, 6 and 8 are silent (the sound engine runs from an interrupt and
;@ clears them). Returns at once while the low-health alarm is sounding.
;@ test: skip waits for the sound engine, which runs from an interrupt
WaitForSoundToFinish::
;> if wLowHealthAlarm & 0x80:          # the low-health alarm is sounding
;>     return
	ld a, [wLowHealthAlarm]
	and $80
	ret nz
;>@busy while wChannelSoundIDs[CHAN5] | wChannelSoundIDs[CHAN6] | wChannelSoundIDs[CHAN8]:
;>     wait_vblank_flag()              # the sound engine runs in the VBlank interrupt
	push hl
.waitLoop
	ld hl, wChannelSoundIDs + CHAN5
	xor a
	or [hl]
;=@busy
	inc hl
	or [hl]
	inc hl
	inc hl
	or [hl]
	jr nz, .waitLoop
;> return
	pop hl
	ret
;@ path: home/names2
NamePointers::
; entries correspond to *_NAME constants
	dw MonsterNames
	dw MoveNames
	dw UnusedBadgeNames
	dw ItemNames
	dw wPartyMonOT ; player's OT names list
	dw wEnemyMonOT ; enemy's OT names list
	dw TrainerNames

;@ path: home/names2
;@ def GetName()
;@ Copy name number wNameListIndex (counting from 1) of list wNameListType, found in bank wPredefBank, to
;@ wNameBuffer. Pokémon names have a fixed length; the other lists are '@'-terminated names one after another.
;@ Any index from HM01 up gives a TM/HM name, whatever the list.
;@ test: wNameListType = rng.choice([1, 2, 3, 4, 7]); wNameListIndex = rand(1, 20); wPredefBank = rand(1, 0x2C)
GetName::
; arguments:
; [wNameListIndex] = which name
; [wNameListType] = which list
; [wPredefBank] = bank of list
;
; returns pointer to name in de
;> wNamedObjectIndex = wNameListIndex
	ld a, [wNameListIndex]
	ld [wNamedObjectIndex], a

	; TM names are separate from item names.
	; BUG: This applies to all names instead of just items.
;> # (the build checks that the Pokémon, move and trainer lists stay below HM01)
	ASSERT NUM_POKEMON_INDEXES < HM01, \
		"A bug in GetName will get TM/HM names for Pokémon above ${x:HM01}."
	ASSERT NUM_ATTACKS < HM01, \
		"A bug in GetName will get TM/HM names for moves above ${x:HM01}."
	ASSERT NUM_TRAINERS < HM01, \
		"A bug in GetName will get TM/HM names for trainers above ${x:HM01}."
;> if wNameListIndex >= HM01:          # for any list, not just items
;>     return GetMachineName()
	cp HM01
	jp nc, GetMachineName

;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
	push hl
	push bc
	push de
;> if wNameListType == MONSTER_NAME:   # fixed-length names
	ld a, [wNameListType]
	dec a
	jr nz, .otherEntries
	; 1 = MONSTER_NAME
;>     name = GetMonName()
	call GetMonName
;>     ptr = name + NAME_LENGTH
	ld hl, NAME_LENGTH
	add hl, de
	ld e, l
	ld d, h
	jr .gotPtr
.otherEntries
	; 2-7 = other names
;> else:
;>     hLoadedROMBank = wPredefBank
	ld a, [wPredefBank]
	ldh [hLoadedROMBank], a
;>     set_rom_bank(wPredefBank)
	ld [rROMB], a
;>@off     offset = u8(wNameListType - 1) * 2
	ld a, [wNameListType]
	dec a
	add a
	ld d, 0
	ld e, a
;=@off
	jr nc, .skip
	inc d
.skip
;>     entry = NamePointers + offset
	ld hl, NamePointers
	add hl, de
;>     mem[addr(hSwapTemp) + 1] = mem[entry]   # the list's address goes through hSwapTemp
	ld a, [hli]
	ldh [hSwapTemp + 1], a
;>     hSwapTemp = mem[entry + 1]
	ld a, [hl]
	ldh [hSwapTemp], a
;>     table = hSwapTemp << 8 | mem[addr(hSwapTemp) + 1]
	ldh a, [hSwapTemp]
	ld h, a
	ldh a, [hSwapTemp + 1]
	ld l, a
;>     count = 0
	ld a, [wNameListIndex]
	ld b, a ; wanted entry
	ld c, 0 ; entry counter
;>     while True:
;>         name = table
.nextName
	ld d, h
	ld e, l
;>@char         while mem[table] != 0x50:   # a name ends with '@'
;>             table += 1
.nextChar
	ld a, [hli]
	cp '@'
	jr nz, .nextChar
;>         table += 1
;>         count = u8(count + 1)
	inc c
;>         if count == wNameListIndex:
;>             break
	ld a, b
	cp c
	jr nz, .nextName
;>     CopyData(name, wNameBuffer, NAME_BUFFER_LENGTH)
	ld h, d
	ld l, e
	ld de, wNameBuffer
	ld bc, NAME_BUFFER_LENGTH
	call CopyData
;>     ptr = wNameBuffer + NAME_BUFFER_LENGTH
.gotPtr
;> wUnusedNamePointer[0] = lo(ptr)
	ld a, e
	ld [wUnusedNamePointer], a
;> wUnusedNamePointer[1] = hi(ptr)
	ld a, d
	ld [wUnusedNamePointer + 1], a
;> hLoadedROMBank = saved
	pop de
	pop bc
	pop hl
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret
;@ path: home/item_price
;@ def GetItemPrice() -> de
;@ The price of item wCurItem as a 3-byte BCD number in hItemPrice, from the item price list (wItemPrices points
;@ to it); TMs and HMs get theirs from GetMachinePrice. Returns de = hItemPrice.
GetItemPrice::
; Stores item's price as BCD at hItemPrice (3 bytes)
; Input: [wCurItem] = item id
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> bank = 0x0F if wListMenuID == MOVESLISTMENU else BANK(ItemPrices)
	ld a, [wListMenuID]
	cp MOVESLISTMENU
	ld a, BANK(ItemPrices)
	jr nz, .ok
	ld a, $f ; hardcoded Bank
.ok
;> hLoadedROMBank = bank
	ldh [hLoadedROMBank], a
;> set_rom_bank(bank)
	ld [rROMB], a
;> p = mem16[addr(wItemPrices)]
	ld hl, wItemPrices
	ld a, [hli]
	ld h, [hl]
	ld l, a
;> if wCurItem < HM01:
	ld a, [wCurItem]
	cp HM01
	jr nc, .getTMPrice
;>     p = (p + 3 * (wCurItem or 256)) & 0xFFFF    # just past this item's 3 bytes
	ld bc, $3
.loop
	add hl, bc
	dec a
	jr nz, .loop
;>     hItemPrice[2] = mem[p - 1]
	dec hl
	ld a, [hld]
	ldh [hItemPrice + 2], a
;>     hItemPrice[1] = mem[p - 2]
	ld a, [hld]
	ldh [hItemPrice + 1], a
;>     hItemPrice[0] = mem[p - 3]
	ld a, [hl]
	ldh [hItemPrice], a
	jr .done
;> else:
.getTMPrice
;>     hLoadedROMBank = BANK(GetMachinePrice)
	ld a, BANK(GetMachinePrice)
	ldh [hLoadedROMBank], a
;>     set_rom_bank(BANK(GetMachinePrice))
	ld [rROMB], a
;>     GetMachinePrice()
	call GetMachinePrice
.done
;> result = addr(hItemPrice)
	ld de, hItemPrice
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
;> return result
	ret
; copies a string from de to wStringBuffer
;@ def CopyToStringBuffer(src: de) -> hl
;@ Copy the @-terminated string at src to wStringBuffer.
;@ test: src = rand_ram(24); n = rand(0, 20); [mem.__setitem__(src + i, rand(0, 0x4F)) for i in range(n)]; mem[src + n] = 0x50
CopyToStringBuffer::
;> return CopyString(src, wStringBuffer)
	ld hl, wStringBuffer
	; fall through

; copies a string from de to hl
;@ def CopyString(src: de, dest: hl) -> hl
;@ Copy the string at src to dest, up to and including its '@' terminator (the byte $50). Returns dest just past it.
;@ test: src = rand_ram(48); dest = src + 24; n = rand(0, 20); [mem.__setitem__(src + i, rand(0, 0x4F)) for i in range(n)]; mem[src + n] = 0x50
CopyString::
;>@lp while True:
;>     c = mem[src]
;>     src += 1
	ld a, [de]
	inc de
;>     mem[dest] = c
;>     dest += 1
	ld [hli], a
;>     if c == 0x50:
;>         return dest
	cp '@'
	jr nz, CopyString
	ret
;@ path: home/joypad2
;@ def JoypadLowSensitivity()
;@ Read the joypad into hJoy5 with key repeat: a new press comes through at once, a key that stays down repeats
;@ after half a second, then every 5 frames. hJoy7 = 0 reports only new presses, else all held keys; with
;@ hJoy6 = 0 held A and B never repeat.
JoypadLowSensitivity::
;> Joypad()
	call Joypad
;> hJoy5 = hJoyHeld if hJoy7 else hJoyPressed
	ldh a, [hJoy7] ; flag
	and a ; get all currently pressed buttons or only newly pressed buttons?
	ldh a, [hJoyPressed] ; newly pressed buttons
	jr z, .storeButtonState
	ldh a, [hJoyHeld] ; all currently pressed buttons
.storeButtonState
	ldh [hJoy5], a
;> if hJoyPressed:
	ldh a, [hJoyPressed] ; newly pressed buttons
	and a ; have any buttons been newly pressed since last check?
	jr z, .noNewlyPressedButtons
; newly pressed buttons
;>     hFrameCounter = 30                      # half a second before a held key repeats
;>     return
	ld a, 30 ; half a second delay
	ldh [hFrameCounter], a
	ret
.noNewlyPressedButtons
;> if hFrameCounter:
	ldh a, [hFrameCounter]
	and a ; is the delay over?
	jr z, .delayOver
; delay not over
;>     hJoy5 = 0                               # still waiting: report no keys
;>     return
	xor a
	ldh [hJoy5], a ; report no buttons as pressed
	ret
.delayOver
; if [hJoy6] = 0 and A or B is pressed, report no buttons as pressed
;> if hJoyHeld & (PAD_A | PAD_B) and not hJoy6:
	ldh a, [hJoyHeld]
	and PAD_A | PAD_B
	jr z, .setShortDelay
	ldh a, [hJoy6] ; flag
	and a
	jr nz, .setShortDelay
;>     hJoy5 = 0
	xor a
	ldh [hJoy5], a
.setShortDelay
;> hFrameCounter = 5
	ld a, 5 ; 1/12 of a second delay
	ldh [hFrameCounter], a
	ret

;@ path: home/joypad2
;@ def WaitForTextScrollButtonPress()
;@ Blink the down arrow at the corner of the text box (and the player's sprite on the Town Map) until A or B
;@ is pressed.
;@ test: skip waits for a button press
WaitForTextScrollButtonPress::
;> saved1, saved2 = hDownArrowBlinkCount1, hDownArrowBlinkCount2
	ldh a, [hDownArrowBlinkCount1]
	push af
	ldh a, [hDownArrowBlinkCount2]
	push af
;> hDownArrowBlinkCount1 = 0
	xor a
	ldh [hDownArrowBlinkCount1], a
;> hDownArrowBlinkCount2 = 6
	ld a, $6
	ldh [hDownArrowBlinkCount2], a
.loop
;> while True:
;>     if wTownMapSpriteBlinkingEnabled:
	push hl
	ld a, [wTownMapSpriteBlinkingEnabled]
	and a
	jr z, .skipAnimation
;>         TownMapSpriteBlinkingAnimation()
	call TownMapSpriteBlinkingAnimation
.skipAnimation
;>     HandleDownArrowBlinkTiming(coord(18, 16))
	ld hl, (16) * SCREEN_WIDTH + (18) + wTileMap
	call HandleDownArrowBlinkTiming
	pop hl
;>     JoypadLowSensitivity()
	call JoypadLowSensitivity
;>     predef(CableClub_Run)
	ld a, (CableClub_RunPredef - PredefPointers) / 3
	call Predef
;>     if hJoy5 & (PAD_A | PAD_B):
;>         break
	ldh a, [hJoy5]
	and PAD_A | PAD_B
	jr z, .loop
;> hDownArrowBlinkCount2 = saved2
;> hDownArrowBlinkCount1 = saved1
	pop af
	ldh [hDownArrowBlinkCount2], a
	pop af
	ldh [hDownArrowBlinkCount1], a
	ret

; (unless in link battle) waits for A or B being pressed and outputs the scrolling sound effect
;@ path: home/joypad2
;@ def ManualTextScroll()
;@ Wait for A or B, then play the button sound. In a link battle nobody presses anything: wait 65 frames.
;@ test: skip waits for a button press
ManualTextScroll::
;> if wLinkState != LINK_STATE_BATTLING:
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr z, .inLinkBattle
;>     WaitForTextScrollButtonPress()
	call WaitForTextScrollButtonPress
;>     return PlaySound(SFX_PRESS_AB)
	ld a, SFX_PRESS_AB
	jp PlaySound
.inLinkBattle
;> return DelayFrames(65)
	ld c, 65
	jp DelayFrames
; function to do multiplication
; all values are big endian
; INPUT
; FF96-FF98 =  multiplicand
; FF99 = multiplier
; OUTPUT
; FF95-FF98 = product
;@ def Multiply()
;@ hProduct = hMultiplicand * hMultiplier (big-endian), keeping hl and bc: _Multiply in its own bank, through callfar.
Multiply::
;> _Multiply()                         # in its own bank
	push hl
	push bc
	ld hl, _Multiply
	ld b, BANK(_Multiply)
	call Bankswitch
;> set_rom_bank(hLoadedROMBank)        # Bankswitch switches back
	pop bc
	pop hl
	ret

; function to do division
; all values are big endian
; INPUT
; FF95-FF98 = dividend
; FF99 = divisor
; b = number of bytes in the dividend (starting from FF95)
; OUTPUT
; FF95-FF98 = quotient
; FF99 = remainder
;@ def Divide(nbytes: b)
;@ hQuotient = hDividend / hDivisor, remainder in hRemainder (big-endian), keeping hl, de and bc: _Divide in its
;@ own bank, through homecall.
Divide::
;> saved = hLoadedROMBank
	push hl
	push de
	push bc
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(_Divide)
	ld a, BANK(_Divide)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(_Divide))
	ld [rROMB], a
;> _Divide(nbytes)
	call _Divide
;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	pop bc
	pop de
	pop hl
	ret
;@ path: home/print_text
;@ def PrintLetterDelay()
;@ The pause after each letter while text prints: none if text delay is off; otherwise until hFrameCounter
;@ (counted down by VBlank) runs out, one frame or the text speed option. Holding A or B cuts it short.
;@ test: skip waits for the VBlank interrupt to count hFrameCounter down
PrintLetterDelay::
;> if wStatusFlags5 >> BIT_NO_TEXT_DELAY & 1:
;>     return
	ld a, [wStatusFlags5]
	bit BIT_NO_TEXT_DELAY, a
	ret nz
;> if not wLetterPrintingDelayFlags >> BIT_TEXT_DELAY & 1:
;>     return
	ld a, [wLetterPrintingDelayFlags]
	bit BIT_TEXT_DELAY, a
	ret z
;> if wLetterPrintingDelayFlags >> BIT_FAST_TEXT_DELAY & 1:
	push hl
	push de
	push bc
	ld a, [wLetterPrintingDelayFlags]
	bit BIT_FAST_TEXT_DELAY, a
	jr z, .waitOneFrame
;>     hFrameCounter = wOptions & 0xF  # the text speed option
	ld a, [wOptions]
	and $f
	ldh [hFrameCounter], a
	jr .checkButtons
.waitOneFrame
;> else:
;>     hFrameCounter = 1
	ld a, 1
	ldh [hFrameCounter], a
.checkButtons
;> while True:
;>     Joypad()
	call Joypad
;>     if hJoyHeld & (PAD_A | PAD_B):  # held down: no more waiting
	ldh a, [hJoyHeld]
; check A button
	bit B_PAD_A, a
	jr z, .checkBButton
	jr .endWait
.checkBButton
	bit B_PAD_B, a
	jr z, .buttonsNotPressed
.endWait
;>         DelayFrame()
	call DelayFrame
;>@r1         return
	jr .done
.buttonsNotPressed ; if neither A nor B is pressed
;>     if hFrameCounter == 0:
;>@r2         return
	ldh a, [hFrameCounter]
	and a
	jr nz, .checkButtons
;>@wait     wait_vblank_flag()             # the VBlank interrupt counts hFrameCounter down
.done
;=@r1
;=@r2
	pop bc
	pop de
	pop hl
	ret
; Copies [hl, bc) to [de, de + bc - hl).
; In other words, the source data is from hl up to but not including bc,
; and the destination is de.
;@ path: home/move_mon
;@ def CopyDataUntil(src: hl, dest: de, end: bc)
;@ Copy bytes from src to dest until src reaches end.
;@ test: src = rand_ram(32); end = src + rand(1, 30); dest = rand_ram(32)
CopyDataUntil::
;>@lp while True:
;>     mem[dest] = mem[src]
;>     src += 1
	ld a, [hli]
	ld [de], a
;>     dest += 1
	inc de
;>     if hi(src) != hi(end):
;>         continue
	ld a, h
	cp b
	jr nz, CopyDataUntil
;>     if lo(src) != lo(end):
;>         continue
	ld a, l
	cp c
	jr nz, CopyDataUntil
;>     return
	ret

; Function to remove a pokemon from the party or the current box.
; wWhichPokemon determines the pokemon.
; [wRemoveMonFromBox] == 0 specifies the party.
; [wRemoveMonFromBox] != 0 specifies the current box.
;@ path: home/move_mon
;@ def RemovePokemon()
;@ Remove Pokémon wWhichPokemon from the party (wRemoveMonFromBox 0) or the current box (_RemovePokemon).
;@ test: skip the work is done (and tested) in _RemovePokemon
RemovePokemon::
;> _RemovePokemon()
;> set_rom_bank(hLoadedROMBank)    # a far call returns to the bank in hLoadedROMBank
	ld hl, _RemovePokemon
	ld b, BANK(_RemovePokemon)
	jp Bankswitch

;@ path: home/move_mon
;@ def AddPartyMon() -> carry
;@ Add a new Pokémon to a party (_AddPartyMon); no carry if the party is full. Keeps hl, de, bc.
;@ test: skip the work is done (and tested) in _AddPartyMon
AddPartyMon::
;> # (the registers are saved on the stack)
	push hl
	push de
	push bc
;> added = _AddPartyMon()
;> set_rom_bank(hLoadedROMBank)        # a far call returns to the bank in hLoadedROMBank
	ld b, BANK(_AddPartyMon)
	ld hl, _AddPartyMon
	call Bankswitch
;> # (the registers come back off the stack)
	pop bc
	pop de
	pop hl
;> return added
	ret

; calculates all 5 stats of current mon and writes them to [de]
;@ path: home/move_mon
;@ def CalcStats(dest: de, use_exp: b, exp: hl)
;@ Work out all five stats of the current Pokémon (CalcStat) and store them at dest, two bytes each, high
;@ byte first.
;@ test: wCurEnemyLevel = rand(1, 100); dest = rand_ram(10); exp = rand_ram(16); [mem.__setitem__(exp + 2 * i + 1, 0) for i in range(5)]
CalcStats::
;> stat = 0
	ld c, $0
;>@lp while True:                      # the stats 1 to NUM_STATS
.statsLoop
;>     stat += 1
	inc c
;>     CalcStat(stat, use_exp, exp)
	call CalcStat
;>     mem[dest] = hMultiplicand[1]
	ldh a, [hMultiplicand+1]
	ld [de], a
;>     mem[dest + 1] = hMultiplicand[2]
	inc de
	ldh a, [hMultiplicand+2]
	ld [de], a
;>     dest += 2
	inc de
;>     if stat == NUM_STATS:
;>         return
	ld a, c
	cp NUM_STATS
	jr nz, .statsLoop
	ret

; calculates stat c of current mon
; c: stat to calc (HP=1,Atk=2,Def=3,Spd=4,Spc=5)
; b: consider stat exp?
; hl: base ptr to stat exp values ([hl + 2*c - 1] and [hl + 2*c])
;@ path: home/move_mon
;@ def CalcStat(stat: c, use_exp: b, exp: hl)
;@ Work out stat `stat` (1 HP, 2 Attack, 3 Defense, 4 Speed, 5 Special) of a Pokémon at level
;@ wCurEnemyLevel, with the base stats in wMonHeader and the stat experience (big-endian) and DVs in the
;@ Pokémon record whose stat experience starts at exp + 1. The result goes to hMultiplicand + 1 and + 2,
;@ high byte first:
;@ ((base + DV) * 2 + ceil(sqrt(stat experience)) / 4) * level / 100 + 5, for HP + level + 10, at most
;@ 999. The stat experience counts only with use_exp set. The HP DV is made of the lowest bits of the
;@ other four. Keeps hl, de, bc.
;@ test: wCurEnemyLevel = rand(1, 100); stat = rand(1, 5); exp = rand_ram(16)
CalcStat::
;> # (the registers are saved on the stack)
	push hl
	push de
	push bc
;> use = use_exp
	ld a, b
	ld d, a
;> # (exp kept on the stack)
	push hl
;> base = mem[addr(wMonHeader) + stat]
;> bonus = 0
	ld hl, wMonHeader
	ld b, $0
	add hl, bc
	ld a, [hl]          ; read base value of stat
	ld e, a
;> # (exp comes back off the stack, and stays there)
	pop hl
	push hl
;> if use:
	sla c
	ld a, d
	and a
	jr z, .statExpDone  ; consider stat exp?
;>     p = exp + 2 * stat              # the stat experience's low byte; the high byte before it
	add hl, bc          ; skip to corresponding stat exp value
;>@se     while True:                 # the smallest bonus whose square reaches the stat experience
.statExpLoop            ; calculates ceil(Sqrt(stat exp)) in b
;>         hMultiplicand[0] = 0
	xor a
	ldh [hMultiplicand], a
;>         hMultiplicand[1] = 0
	ldh [hMultiplicand+1], a
;>         bonus += 1
	inc b               ; increment current stat exp bonus
;>         if bonus == 0xFF:
;>             break
	ld a, b
	cp $ff
	jr z, .statExpDone
;>         hMultiplicand[2] = bonus
	ldh [hMultiplicand+2], a
;>         hMultiplier = bonus
	ldh [hMultiplier], a
;>         Multiply()
	call Multiply
;>         low = hProduct[3] - mem[p]  # the low bytes first
	ld a, [hld]
	ld d, a
	ldh a, [hProduct + 3]
	sub d
;>         below = (hProduct[2] << 8 | hProduct[3]) < (mem[p - 1] << 8 | mem[p])   # with the low bytes' borrow
	ld a, [hli]
	ld d, a
	ldh a, [hProduct + 2]
	sbc d               ; test if (current stat exp bonus)^2 < stat exp
;>         if not below:
;>             break
	jr c, .statExpLoop
.statExpDone
;> dvs = exp + MON_DVS - (MON_HP_EXP - 1)   # (exp comes back off the stack)
	srl c
	pop hl
	push bc
	ld bc, MON_DVS - (MON_HP_EXP - 1)
	add hl, bc
	pop bc
;>@ad atk_def = mem[dvs]
;>@ss spd_spc = mem[dvs + 1]
;> if stat == 2:
	ld a, c
	cp $2
	jr z, .getAttackIV
;>@a2     dv = atk_def >> 4
;> elif stat == 3:
	cp $3
	jr z, .getDefenseIV
;>@a3     dv = atk_def & 0xF
;> elif stat == 4:
	cp $4
	jr z, .getSpeedIV
;>@a4     dv = spd_spc >> 4
;> elif stat == 5:
	cp $5
	jr z, .getSpecialIV
;>@a5     dv = spd_spc & 0xF
; get HP IV
;> else:                               # HP: the lowest bits of the other four
;>     # (bc kept on the stack)
	push bc
;>     dv = atk_def >> 4 & 1
	ld a, [hl]  ; Atk IV
	swap a
	and $1
;>     dv <<= 3
	sla a
	sla a
	sla a
	ld b, a
;>     dv |= (atk_def & 1) << 2
	ld a, [hli] ; Def IV
	and $1
	sla a
	sla a
	add b
	ld b, a
;>     dv |= (spd_spc >> 4 & 1) << 1
	ld a, [hl] ; Spd IV
	swap a
	and $1
	sla a
	add b
	ld b, a
;>     dv |= spd_spc & 1
	ld a, [hl] ; Spc IV
	and $1
	add b      ; HP IV: LSB of the other 4 IVs
;>     # (bc comes back off the stack)
	pop bc
	jr .calcStatFromIV
.getAttackIV
;=@a2
	ld a, [hl]
	swap a
	and $f
	jr .calcStatFromIV
.getDefenseIV
;=@a3
	ld a, [hl]
	and $f
	jr .calcStatFromIV
.getSpeedIV
;=@a4
	inc hl
	ld a, [hl]
	swap a
	and $f
	jr .calcStatFromIV
.getSpecialIV
;=@a5
	inc hl
	ld a, [hl]
	and $f
.calcStatFromIV
;> value = base + dv
	ld d, $0
	add e
	ld e, a
	jr nc, .noCarry
	inc d                     ; de = Base + IV
.noCarry
;> value *= 2
	sla e
	rl d                      ; de = (Base + IV) * 2
;> bonus >>= 2
	srl b
	srl b                     ; b = ceil(Sqrt(stat exp)) / 4
;> value += bonus
	ld a, b
	add e
	jr nc, .noCarry2
	inc d                     ; de = (Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4
.noCarry2
;> hMultiplicand[2] = lo(value)
	ldh [hMultiplicand+2], a
;> hMultiplicand[1] = hi(value)
	ld a, d
	ldh [hMultiplicand+1], a
;> hMultiplicand[0] = 0
	xor a
	ldh [hMultiplicand], a
;> hMultiplier = wCurEnemyLevel
	ld a, [wCurEnemyLevel]
	ldh [hMultiplier], a
;> Multiply()
	call Multiply            ; ((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level
;> hDividend[0] = hMultiplicand[0]    # the product, one byte up (the variables overlap)
	ldh a, [hMultiplicand]
	ldh [hDividend], a
;> hDividend[1] = hMultiplicand[1]
	ldh a, [hMultiplicand+1]
	ldh [hDividend+1], a
;> hDividend[2] = hMultiplicand[2]
	ldh a, [hMultiplicand+2]
	ldh [hDividend+2], a
;> hDivisor = 100
	ld a, $64
	ldh [hDivisor], a
;> Divide(3)
	ld a, $3
	ld b, a
	call Divide             ; (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100
;> add = 5                             # the last addition for the other stats
;> if stat == 1:                       # HP: + level first, and 10 instead of 5
	ld a, c
	cp $1
	ld a, 5 ; + 5 for non-HP stat
	jr nz, .notHPStat
;>     total = hMultiplicand[2] + wCurEnemyLevel
	ld a, [wCurEnemyLevel]
	ld b, a
	ldh a, [hMultiplicand+2]
	add b
;>     hMultiplicand[2] = u8(total)
	ldh [hMultiplicand+2], a
;>     if total > 0xFF:
	jr nc, .noCarry3
;>         hMultiplicand[1] = u8(hMultiplicand[1] + 1)
	ldh a, [hMultiplicand+1]
	inc a
	ldh [hMultiplicand+1], a ; HP: (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100 + Level
.noCarry3
;>     add = 10
	ld a, 10 ; +10 for HP stat
.notHPStat
;> total = hMultiplicand[2] + add
	ld b, a
	ldh a, [hMultiplicand+2]
	add b
;> hMultiplicand[2] = u8(total)
	ldh [hMultiplicand+2], a
;> if total > 0xFF:
	jr nc, .noCarry4
;>     hMultiplicand[1] = u8(hMultiplicand[1] + 1)
	ldh a, [hMultiplicand+1]
	inc a                    ; non-HP: (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100 + 5
	ldh [hMultiplicand+1], a ; HP: (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100 + Level + 10
.noCarry4
;> if hMultiplicand[1] > hi(MAX_STAT_VALUE):   # more than 999?
	ldh a, [hMultiplicand+1] ; check for overflow (>999)
	cp HIGH(MAX_STAT_VALUE) + 1
	jr nc, .overflow
;>@c1     cap = True
;> elif hMultiplicand[1] < hi(MAX_STAT_VALUE):
	cp HIGH(MAX_STAT_VALUE)
	jr c, .noOverflow
;>@c2     cap = False
;> else:
;>     cap = hMultiplicand[2] > lo(MAX_STAT_VALUE)
	ldh a, [hMultiplicand+2]
	cp LOW(MAX_STAT_VALUE) + 1
	jr c, .noOverflow
.overflow
;>@cap if cap:
;>     hMultiplicand[1] = hi(MAX_STAT_VALUE)
	ld a, HIGH(MAX_STAT_VALUE) ; overflow: cap at 999
	ldh [hMultiplicand+1], a
;>     hMultiplicand[2] = lo(MAX_STAT_VALUE)
	ld a, LOW(MAX_STAT_VALUE)
	ldh [hMultiplicand+2], a
.noOverflow
;> # (the registers come back off the stack)
	pop bc
	pop de
	pop hl
	ret

;@ path: home/move_mon
;@ def AddEnemyMonToPlayerParty() -> carry
;@ Put the caught enemy Pokémon into the party, or the box if the party is full (_AddEnemyMonToPlayerParty).
;@ test: skip the work is done (and tested) in _AddEnemyMonToPlayerParty
AddEnemyMonToPlayerParty::
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(_AddEnemyMonToPlayerParty)
	ld a, BANK(_AddEnemyMonToPlayerParty)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(_AddEnemyMonToPlayerParty))
	ld [rROMB], a
;> result = _AddEnemyMonToPlayerParty()
	call _AddEnemyMonToPlayerParty
;> hLoadedROMBank = saved
	pop bc
	ld a, b
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
;> return result
	ret

;@ path: home/move_mon
;@ def MoveMon() -> carry
;@ Move a Pokémon between the party, the current box and the day care (_MoveMon).
;@ test: skip the work is done (and tested) in _MoveMon
MoveMon::
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> hLoadedROMBank = BANK(_MoveMon)
	ld a, BANK(_MoveMon)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(_MoveMon))
	ld [rROMB], a
;> result = _MoveMon()
	call _MoveMon
;> hLoadedROMBank = saved
	pop bc
	ld a, b
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
;> return result
	ret
; skips a text entries, each of size NAME_LENGTH (like trainer name, OT name, rival name, ...)
; hl: base pointer, will be incremented by NAME_LENGTH * a
;@ def SkipFixedLengthTextEntries(ptr: hl, n: a) -> hl
;@ Step past n names of NAME_LENGTH bytes each.
SkipFixedLengthTextEntries::
;> if not n:
;>     return ptr
	and a
	ret z
;>@sk ptr += n * NAME_LENGTH
	ld bc, NAME_LENGTH
.skipLoop
;=@sk
	add hl, bc
	dec a
	jr nz, .skipLoop
;> return ptr
	ret

;@ def AddNTimes(ptr: hl, step: bc, n: a) -> hl
;@ Add step to ptr n times: the address of entry n in a table of step-byte entries.
AddNTimes::
; add bc to hl a times
;> return ptr + n * step
	and a
	ret z
.loop
	add hl, bc
	dec a
	jr nz, .loop
	ret
;@ def StringCmp(s1: de, s2: hl, count: c) -> (carry, zero)
;@ Compare count bytes, most significant first (big-endian numbers or text): zero if all are equal, otherwise
;@ carry if s1 is the smaller at the first byte that differs.
;@ test: count = rand(1, 8); s1 = rand_ram(8); s2 = rand_ram(8)
;@ test: [mem.__setitem__(s2 + i, mem[s1 + i]) for i in range(rand(0, count))]
StringCmp::
;>@lp for i in range(count):
;>     if mem[s1 + i] != mem[s2 + i]:
;>         return (mem[s1 + i] < mem[s2 + i], False)
	ld a, [de]
	cp [hl]
	ret nz
;=@lp
	inc de
	inc hl
	dec c
	jr nz, StringCmp
;> return (False, True)
	ret
;@ path: home/oam
;@ def WriteOAMBlock(index: a, y: b, x: c, src: de)
;@ Write a 16 x 16 pixel object as four sprites into shadow OAM block `index` (four entries each), top left
;@ at (x, y): tile and attribute pairs come from src, in the order top left, top right, bottom left, bottom
;@ right.
;@ test: index = rand(0, 9); src = rand_ram(8)
WriteOAMBlock::
;> oam = hi(wShadowOAM) << 8 | swap(index)
	ld h, HIGH(wShadowOAM)
	swap a ; multiply by 16
	ld l, a
;>@lp for dy, dx in ((0, 0), (0, 8), (8, 0), (8, 8)):   # the entry code below, once per corner
	call .writeOneEntry ; upper left
;=@lp
	push bc
	ld a, 8
	add c
	ld c, a
	call .writeOneEntry ; upper right
;=@lp
	pop bc
	ld a, 8
	add b
	ld b, a
	call .writeOneEntry ; lower left
;=@lp
	ld a, 8
	add c
	ld c, a
	                      ; lower right
.writeOneEntry
;>     mem[oam] = u8(y + dy)
	ld [hl], b ; Y coordinate
	inc hl
;>     mem[oam + 1] = u8(x + dx)
	ld [hl], c ; X coordinate
	inc hl
;>     mem[oam + 2] = mem[src]
	ld a, [de] ; tile number
	inc de
	ld [hli], a
;>     mem[oam + 3] = mem[src + 1]
	ld a, [de] ; attribute
	inc de
	ld [hli], a
;>@o4     oam += 4
;>@s2     src += 2
	ret
;@ path: home/window
;@ def HandleMenuInput(row: hl = 0) -> a
;@ Wait for a menu key with the party menu's Pokémon animation off; returns the keys pressed.
HandleMenuInput::
;> wPartyMenuAnimMonEnabled = 0
;> return HandleMenuInput_(row)
	xor a
	ld [wPartyMenuAnimMonEnabled], a

;@ path: home/window
;@ def HandleMenuInput_(row: hl = 0) -> a
;@ Wait for the keys of a menu (HandleMenuInput): Up and Down move wCurrentMenuItem (wrapping around if
;@ wMenuWrappingEnabled), the shaking party Pokémon and the blinking '▼' go on while waiting. Returns the keys
;@ pressed as soon as one of wMenuWatchedKeys is among them (or Up / Down tried to leave the menu, with
;@ wMenuWatchMovingOutOfBounds); A and B make a sound. With wMenuJoypadPollCount 1 it returns 0 if no key is
;@ pressed; any other count waits for a key (the count is never counted down).
;@ test: skip waits for the player
HandleMenuInput_::
;> saved1 = hDownArrowBlinkCount1      # (both kept on the stack)
	ldh a, [hDownArrowBlinkCount1]
	push af
;> saved2 = hDownArrowBlinkCount2
	ldh a, [hDownArrowBlinkCount2]
	push af ; save existing values on stack
;> hDownArrowBlinkCount1 = 0
	xor a
	ldh [hDownArrowBlinkCount1], a ; blinking down arrow timing value 1
;> hDownArrowBlinkCount2 = 6
	ld a, 6
	ldh [hDownArrowBlinkCount2], a ; blinking down arrow timing value 2
;>@outer while True:
;>     wAnimCounter = 0
.loop1
	xor a
	ld [wAnimCounter], a ; counter for pokemon shaking animation
;>     PlaceMenuCursor(row)
	call PlaceMenuCursor
;>     Delay3()
	call Delay3
;>@inner     while True:
;>         # (row kept on the stack)
.loop2
	push hl
;>         if wPartyMenuAnimMonEnabled:   # a Pokémon menu: the selected one shakes
	ld a, [wPartyMenuAnimMonEnabled]
	and a ; is it a pokemon selection menu?
	jr z, .getJoypadState
	; shake mini sprite of selected pokemon
;>             AnimatePartyMon()
	ld b, BANK(AnimatePartyMon)
	ld hl, AnimatePartyMon
	call Bankswitch
.getJoypadState
;>         # (row comes back off the stack)
	pop hl
;>         JoypadLowSensitivity()
	call JoypadLowSensitivity
;>         if hJoy5:
;>             break
	ldh a, [hJoy5]
	and a ; was a key pressed?
	jr nz, .keyPressed
;>         # (row kept on the stack)
	push hl
	; coordinates of blinking down arrow in some menus
;>         HandleDownArrowBlinkTiming(coord(18, 11))
	ld hl, (11) * SCREEN_WIDTH + (18) + wTileMap
	call HandleDownArrowBlinkTiming ; blink down arrow (if any)
;>         # (row comes back off the stack)
	pop hl
;>         if wMenuJoypadPollCount == 1:  # no key: give up waiting
	ld a, [wMenuJoypadPollCount]
	dec a
	jr z, .giveUpWaiting
;=@inner
	jr .loop2
.giveUpWaiting
; if a key wasn't pressed within the specified number of checks
;>             hDownArrowBlinkCount2 = saved2
	pop af
	ldh [hDownArrowBlinkCount2], a
;>             hDownArrowBlinkCount1 = saved1
	pop af
	ldh [hDownArrowBlinkCount1], a ; restore previous values
;>             wMenuWrappingEnabled = 0
	xor a
	ld [wMenuWrappingEnabled], a ; disable menu wrapping
;>             return 0
	ret
.keyPressed
;>     wCheckFor180DegreeTurn = 0
	xor a
	ld [wCheckFor180DegreeTurn], a
;>     keys = hJoy5
	ldh a, [hJoy5]
	ld b, a
;>@oob     out_of_bounds = False
;>     if keys & PAD_UP:
	bit B_PAD_UP, a
	jr z, .checkIfDownPressed
; Up pressed
;>         if wCurrentMenuItem:
	ld a, [wCurrentMenuItem] ; selected menu item
	and a ; already at the top of the menu?
	jr z, .alreadyAtTop
; not at top
;>             wCurrentMenuItem -= 1
	dec a
	ld [wCurrentMenuItem], a ; move selected menu item up one space
	jr .checkOtherKeys
.alreadyAtTop
;>         elif wMenuWrappingEnabled:
	ld a, [wMenuWrappingEnabled]
	and a ; is wrapping around enabled?
	jr z, .noWrappingAround
;>             wCurrentMenuItem = wMaxMenuItem   # round to the bottom
	ld a, [wMaxMenuItem]
	ld [wCurrentMenuItem], a ; wrap to the bottom of the menu
	jr .checkOtherKeys
.checkIfDownPressed
;>         else:
;>@ob1             out_of_bounds = True
;>     elif keys & PAD_DOWN:
	bit B_PAD_DOWN, a
	jr z, .checkOtherKeys
; Down pressed
;>         nxt = u8(wCurrentMenuItem + 1)
	ld a, [wCurrentMenuItem]
	inc a
	ld c, a
;>         if wMaxMenuItem < nxt:      # already at the bottom
	ld a, [wMaxMenuItem]
	cp c
	jr nc, .notAtBottom
; already at bottom
;>             if wMenuWrappingEnabled:
	ld a, [wMenuWrappingEnabled]
	and a ; is wrapping around enabled?
	jr z, .noWrappingAround
;>                 nxt = 0             # round to the top
	ld c, $00 ; wrap from bottom to top
;>             else:
;>@ob2                 out_of_bounds = True
;>@nob         if not out_of_bounds:
;>             wCurrentMenuItem = nxt
.notAtBottom
	ld a, c
	ld [wCurrentMenuItem], a
.checkOtherKeys
;>@oo     if out_of_bounds and wMenuWatchMovingOutOfBounds:
;>         pass                        # the menu wants to know: return
;>     elif not wMenuWatchedKeys & keys:
;>         continue
	ld a, [wMenuWatchedKeys]
	and b ; does the menu care about any of the pressed keys?
	jp z, .loop1
.checkIfAButtonOrBButtonPressed
;>     if hJoy5 & (PAD_A | PAD_B):
	ldh a, [hJoy5]
	and PAD_A | PAD_B
	jr z, .skipPlayingSound
; A or B pressed
;>         # (row kept on the stack)
	push hl
;>         quiet = wMiscFlags >> BIT_NO_MENU_BUTTON_SOUND & 1
	ld hl, wMiscFlags
	bit BIT_NO_MENU_BUTTON_SOUND, [hl]
;>         # (row comes back off the stack)
	pop hl
;>         if not quiet:
	jr nz, .skipPlayingSound
;>             PlaySound(0x90)         # SFX_PRESS_AB
	ld a, SFX_PRESS_AB
	call PlaySound
.skipPlayingSound
;>     hDownArrowBlinkCount2 = saved2
	pop af
	ldh [hDownArrowBlinkCount2], a
;>     hDownArrowBlinkCount1 = saved1
	pop af
	ldh [hDownArrowBlinkCount1], a ; restore previous values
;>     wMenuWrappingEnabled = 0
	xor a
	ld [wMenuWrappingEnabled], a ; disable menu wrapping
;>     return hJoy5
	ldh a, [hJoy5]
	ret
.noWrappingAround
;=@oo
	ld a, [wMenuWatchMovingOutOfBounds]
	and a ; should we return if the user tried to go past the top or bottom?
	jr z, .checkOtherKeys
	jr .checkIfAButtonOrBButtonPressed

;@ path: home/window
;@ def PlaceMenuCursor(row: hl)
;@ Move the menu arrow '▶' from the previous menu item to wCurrentMenuItem: put back the tile the arrow hid at
;@ the old place, save the tile at the new place, then draw the arrow there. Items are one or two rows apart.
;@ The top item is at (wTopMenuItemX, wTopMenuItemY); with Y = 0 the row is not computed but taken from hl
;@ (the callers have it at the top of wTileMap).
;@ test: row = wTileMap + rand(0, 40); wTopMenuItemY = rand(0, 10); wTopMenuItemX = rand(0, 19); wLastMenuItem = rand(0, 7); wCurrentMenuItem = rand(0, 7)
PlaceMenuCursor::
;> if wTopMenuItemY:
	ld a, [wTopMenuItemY]
	and a ; is the y coordinate 0?
	jr z, .adjustForXCoord
;>@r     row = coord(0, 0) + wTopMenuItemY * SCREEN_WIDTH
	ld hl, (0) * SCREEN_WIDTH + (0) + wTileMap
	ld bc, SCREEN_WIDTH
.topMenuItemLoop
;=@r
	add hl, bc
	dec a
	jr nz, .topMenuItemLoop
.adjustForXCoord
;> top = u16(row + wTopMenuItemX)
	ld a, [wTopMenuItemX]
	ld b, 0
	ld c, a
	add hl, bc
;> # (top kept on the stack)
	push hl
;>@o0 old = top
;> if wLastMenuItem:
	ld a, [wLastMenuItem]
	and a ; was the previous menu id 0?
	jr z, .checkForArrow1
;>     # (the count kept on the stack)
	push af
;>     step = SCREEN_WIDTH if hUILayoutFlags >> BIT_DOUBLE_SPACED_MENU & 1 else SCREEN_WIDTH * 2
	ldh a, [hUILayoutFlags]
	bit BIT_DOUBLE_SPACED_MENU, a
	jr z, .doubleSpaced1
	ld bc, SCREEN_WIDTH
	jr .getOldMenuItemScreenPosition
.doubleSpaced1
	ld bc, SCREEN_WIDTH * 2
.getOldMenuItemScreenPosition
;>     # (the count comes back off the stack)
	pop af
;>     old = u16(top + wLastMenuItem * step)
.oldMenuItemLoop
	add hl, bc
	dec a
	jr nz, .oldMenuItemLoop
.checkForArrow1
;> if mem[old] == 0xED:                 # '▶'
	ld a, [hl]
	cp '▶' ; was an arrow next to the previously selected menu item?
	jr nz, .skipClearingArrow
; clear arrow
;>     mem[old] = wTileBehindCursor
	ld a, [wTileBehindCursor]
	ld [hl], a
.skipClearingArrow
;> # (top comes back off the stack)
	pop hl
;>@c0 cur = top
;> if wCurrentMenuItem:
	ld a, [wCurrentMenuItem]
	and a
	jr z, .checkForArrow2
;>     # (the count kept on the stack)
	push af
;>     step = SCREEN_WIDTH if hUILayoutFlags >> BIT_DOUBLE_SPACED_MENU & 1 else SCREEN_WIDTH * 2
	ldh a, [hUILayoutFlags]
	bit BIT_DOUBLE_SPACED_MENU, a
	jr z, .doubleSpaced2
	ld bc, SCREEN_WIDTH
	jr .getCurrentMenuItemScreenPosition
.doubleSpaced2
	ld bc, SCREEN_WIDTH * 2
.getCurrentMenuItemScreenPosition
;>     # (the count comes back off the stack)
	pop af
;>     cur = u16(top + wCurrentMenuItem * step)
.currentMenuItemLoop
	add hl, bc
	dec a
	jr nz, .currentMenuItemLoop
.checkForArrow2
;> if mem[cur] != 0xED:
	ld a, [hl]
	cp '▶' ; has the right arrow already been placed?
	jr z, .skipSavingTile ; if so, don't lose the saved tile
;>     wTileBehindCursor = mem[cur]
	ld [wTileBehindCursor], a ; save tile before overwriting with right arrow
.skipSavingTile
;> mem[cur] = 0xED
	ld a, '▶' ; place right arrow
	ld [hl], a
;> wMenuCursorLocation[0] = lo(cur)
	ld a, l
	ld [wMenuCursorLocation], a
;> wMenuCursorLocation[1] = hi(cur)
	ld a, h
	ld [wMenuCursorLocation + 1], a
;> wLastMenuItem = wCurrentMenuItem
	ld a, [wCurrentMenuItem]
	ld [wLastMenuItem], a
	ret

; This is used to mark a menu cursor other than the one currently being
; manipulated. In the case of submenus, this is used to show the location of
; the menu cursor in the parent menu. In the case of swapping items in list,
; this is used to mark the item that was first chosen to be swapped.
;@ path: home/window
;@ def PlaceUnfilledArrowMenuCursor(keep: a) -> a
;@ Draw a hollow arrow '▷' where the menu cursor is (wMenuCursorLocation), leaving a as it was.
;@ test: t = wTileMap + rand(0, 359); mem[wMenuCursorLocation] = t & 0xFF; mem[wMenuCursorLocation + 1] = t >> 8
PlaceUnfilledArrowMenuCursor::
;> # (keep held aside)
	ld b, a
;> p = wMenuCursorLocation[0] | wMenuCursorLocation[1] << 8
	ld a, [wMenuCursorLocation]
	ld l, a
	ld a, [wMenuCursorLocation + 1]
	ld h, a
;> mem[p] = 0xEC                       # '▷'
	ld [hl], '▷'
;> return keep
	ld a, b
	ret

; Replaces the menu cursor with a blank space.
;@ path: home/window
;@ def EraseMenuCursor()
;@ Replace the menu cursor with a blank tile.
;@ test: t = wTileMap + rand(0, 359); mem[wMenuCursorLocation] = t & 0xFF; mem[wMenuCursorLocation + 1] = t >> 8
EraseMenuCursor::
;> mem[wMenuCursorLocation[0] | wMenuCursorLocation[1] << 8] = 0x7F  # ' '
	ld a, [wMenuCursorLocation]
	ld l, a
	ld a, [wMenuCursorLocation + 1]
	ld h, a
	ld [hl], ' '
	ret

; This toggles a blinking down arrow at hl on and off after a delay has passed.
; This is often called even when no blinking is occurring.
; The reason is that most functions that call this initialize hDownArrowBlinkCount1 to 0.
; The effect is that if the tile at hl is initialized with a down arrow,
; this function will toggle that down arrow on and off, but if the tile isn't
; initialized with a down arrow, this function does nothing.
; That allows this to be called without worrying about if a down arrow should
; be blinking.
;@ path: home/window
;@ def HandleDownArrowBlinkTiming(tile: hl)
;@ Blink the '▼' that says "press A to go on" at tile: two counters time how long it stays on and off. The
;@ arrow is only turned back on if the counters run, so a tile without an arrow is left alone.
;@ test: tile = wTileMap + rand(0, 359); mem[tile] = rng.choice([0xEE, 0x7F, rand(0, 255)])
;@ test: hDownArrowBlinkCount1 = rand(0, 2); hDownArrowBlinkCount2 = rand(0, 2)
HandleDownArrowBlinkTiming::
;> if mem[tile] == 0xEE:                # '▼' showing
	ld a, [hl]
	ld b, a
	ld a, '▼'
	cp b
	jr nz, .downArrowOff
.downArrowOn
;>     hDownArrowBlinkCount1 = u8(hDownArrowBlinkCount1 - 1)
	ldh a, [hDownArrowBlinkCount1]
	dec a
	ldh [hDownArrowBlinkCount1], a
;>     if hDownArrowBlinkCount1:
;>         return
	ret nz
;>     hDownArrowBlinkCount2 = u8(hDownArrowBlinkCount2 - 1)
	ldh a, [hDownArrowBlinkCount2]
	dec a
	ldh [hDownArrowBlinkCount2], a
;>     if hDownArrowBlinkCount2:
;>         return
	ret nz
;>     mem[tile] = 0x7F                # ' '
	ld a, ' '
	ld [hl], a
;>     hDownArrowBlinkCount1 = 0xFF
	ld a, $ff
	ldh [hDownArrowBlinkCount1], a
;>     hDownArrowBlinkCount2 = 6
	ld a, $06
	ldh [hDownArrowBlinkCount2], a
;>     return
	ret
.downArrowOff
;> if hDownArrowBlinkCount1 == 0:
;>     return
	ldh a, [hDownArrowBlinkCount1]
	and a
	ret z
;> hDownArrowBlinkCount1 -= 1
	dec a
	ldh [hDownArrowBlinkCount1], a
;> if hDownArrowBlinkCount1:
;>     return
	ret nz
;> hDownArrowBlinkCount1 = 0xFF
	dec a
	ldh [hDownArrowBlinkCount1], a
;> hDownArrowBlinkCount2 = u8(hDownArrowBlinkCount2 - 1)
	ldh a, [hDownArrowBlinkCount2]
	dec a
	ldh [hDownArrowBlinkCount2], a
;> if hDownArrowBlinkCount2:
;>     return
	ret nz
;> hDownArrowBlinkCount2 = 6
	ld a, $06
	ldh [hDownArrowBlinkCount2], a
;> mem[tile] = 0xEE
	ld a, '▼'
	ld [hl], a
	ret

; The following code either enables or disables the automatic drawing of
; text boxes by DisplayTextID. Both functions cause DisplayTextID to wait
; for a button press after displaying text (unless [wEnteringCableClub] is set).

;@ path: home/window
;@ def EnableAutoTextBoxDrawing()
;@ Let DisplayTextID draw a text box by itself again.
EnableAutoTextBoxDrawing::
;> AutoTextBoxDrawingCommon(0)
	xor a
	jr AutoTextBoxDrawingCommon

;@ path: home/window
;@ def DisableAutoTextBoxDrawing()
;@ Stop DisplayTextID from drawing a text box by itself (for text that draws its own).
DisableAutoTextBoxDrawing::
;> AutoTextBoxDrawingCommon(1 << BIT_NO_AUTO_TEXT_BOX)
	ld a, 1 << BIT_NO_AUTO_TEXT_BOX

;@ path: home/window
;@ def AutoTextBoxDrawingCommon(control: a)
;@ Set wAutoTextBoxDrawingControl, and make DisplayTextID wait for a button press after the text.
AutoTextBoxDrawingCommon::
;> wAutoTextBoxDrawingControl = control
;> wDoNotWaitForButtonPressAfterDisplayingText = 0
	ld [wAutoTextBoxDrawingControl], a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a ; make DisplayTextID wait for button press
	ret

;@ path: home/window
;@ def PrintText(text: hl)
;@ Open the message box at the bottom of the screen and print text into it.
PrintText::
; Print text hl at (1, 14).
;> # (text kept on the stack)
	push hl
;> wTextBoxID = MESSAGE_BOX
	ld a, MESSAGE_BOX
	ld [wTextBoxID], a
;> DisplayTextBoxID()
	call DisplayTextBoxID
;> UpdateSprites()
	call UpdateSprites
;> Delay3()
	call Delay3
;> PrintText_NoCreatingTextBox(text)
	pop hl
;@ path: home/window
;@ def PrintText_NoCreatingTextBox(text: hl)
;@ Print text starting at tile (1, 14), in a message box that is already there.
PrintText_NoCreatingTextBox::
;> TextCommandProcessor(text, coord(1, 14))
	ld bc, (14) * SCREEN_WIDTH + (1) + wTileMap
	jp TextCommandProcessor
;@ path: home/print_num
;@ def PrintNumber(src: de, dest: hl, flags: b, digits: c) -> hl
;@ Print the big-endian number at src (1, 2 or 3 bytes: flags & $F) as `digits` decimal digits (2 to 7) at
;@ dest. Each digit is found by subtracting its power of ten as often as it goes, on three bytes in HRAM.
;@ Flag bit 7: print leading zeroes; bit 6: left-aligned (no space for left-out zeroes). Returns dest just past
;@ the last digit.
;@ test: size = rng.choice([1, 2, 3]); flags = size | rand(0, 3) << 6; digits = rand(2, 7); src = rand_ram(3); dest = wTileMap + rand(0, 300); value = rand(0, min(256 ** size, 10 ** digits) - 1); [mem.__setitem__(src + i, value >> 8 * (size - 1 - i) & 0xFF) for i in range(size)]
PrintNumber::
; Print the c-digit, b-byte value at de.
; Allows 2 to 7 digits. For 1-digit numbers, add
; the value to char "0" instead of calling PrintNumber.
; Flags LEADING_ZEROES and LEFT_ALIGN can be given
; in bits 7 and 6 of b respectively.
;>@al N, P, S = hNumToPrint, hPowerOf10, hSavedNumToPrint
;> # (bc kept on the stack)
	push bc
;> hPastLeadingZeros = 0
	xor a
	ldh [hPastLeadingZeros], a
;> hNumToPrint[0] = 0
	ldh [hNumToPrint], a
;> hNumToPrint[1] = 0
	ldh [hNumToPrint + 1], a
;> size = flags & 0xF
	ld a, b
	and $f
;> if size == 1:
	cp 1
	jr z, .byte
;>@b1     hNumToPrint[2] = mem[src]
;> elif size == 2:
	cp 2
	jr z, .word
;>@w1     hNumToPrint[1] = mem[src]
;>@w2     hNumToPrint[2] = mem[src + 1]
;> else:
;>     hNumToPrint[0] = mem[src]
.long
	ld a, [de]
	ldh [hNumToPrint], a
	inc de
;>     hNumToPrint[1] = mem[src + 1]
	ld a, [de]
	ldh [hNumToPrint + 1], a
	inc de
;>     hNumToPrint[2] = mem[src + 2]
	ld a, [de]
	ldh [hNumToPrint + 2], a
	jr .start

.word
;=@w1
	ld a, [de]
	ldh [hNumToPrint + 1], a
	inc de
;=@w2
	ld a, [de]
	ldh [hNumToPrint + 2], a
	jr .start

.byte
;=@b1
	ld a, [de]
	ldh [hNumToPrint + 2], a

.start
;> # (src kept on the stack)
	push de

;> # (flags and digits moved over to other registers)
	ld d, b
	ld a, c
	ld b, a
	xor a
	ld c, a
	ld a, b

;>@pw powers = [1000000, 100000, 10000, 1000, 100]   # the places before the tens
;> if digits == 2:
	cp 2
	jr z, .tens
;>@p2     powers = []
;> elif digits == 3:
	cp 3
	jr z, .hundreds
;>@p3     powers = powers[4:]
;> elif digits == 4:
	cp 4
	jr z, .thousands
;>@p4     powers = powers[3:]
;> elif digits == 5:
	cp 5
	jr z, .ten_thousands
;>@p5     powers = powers[2:]
;> elif digits == 6:
	cp 6
	jr z, .hundred_thousands
;>@p6     powers = powers[1:]


; millions
;> for power in powers:                # written out once per place; the digit code below is shared
;>@h0     hPowerOf10[0] = power >> 16 & 0xFF
;>@h1     hPowerOf10[1] = power >> 8 & 0xFF
;>@h2     hPowerOf10[2] = power & 0xFF
;>@c0     count = 0                   # .PrintDigit: subtract the power as often as it goes, on three bytes
;>@wl     while True:
;>@s0         S[0] = N[0]             # the bytes changed are saved, to be put back on an underflow
;>@u0         if N[0] < P[0]:
;>@u0b             break
;>@m0         N[0] -= P[0]
;>@s1         S[1] = N[1]
;>@if1         if N[1] < P[1]:        # borrow from N[0]
;>@z1             if N[0] == 0:
;>@r1                 N[0] = S[0]
;>@bk1                 break
;>@d1             N[0] -= 1
;>@m1         N[1] = u8(N[1] - P[1])
;>@s2         S[2] = N[2]
;>@if2         if N[2] < P[2]:        # borrow from N[1], or from N[0] through it
;>@z2             if N[1] == 0:
;>@z3                 if N[0] == 0:
;>@r2                     N[1] = S[1]
;>@r1b                     N[0] = S[0]
;>@b2                     break
;>@d2                 N[0] -= 1
;>@d3             N[1] = u8(N[1] - 1)
;>@m2         N[2] = u8(N[2] - P[2])
;>@cn         count = u8(count + 1)
;>@pz     if hPastLeadingZeros | count == 0:   # still a leading zero (.PrintLeadingZero)
;>@pz0         if flags >> BIT_LEADING_ZEROES & 1:
;>@pz1             mem[dest] = 0xF6        # '0'
;>@el     else:
;>@pd1         mem[dest] = u8(0xF6 + count)    # '0' + count
;>@pd2         hPastLeadingZeros = u8(0xF6 + count)
;>@nx     if flags >> BIT_LEADING_ZEROES & 1 or not flags >> BIT_LEFT_ALIGN & 1 or hPastLeadingZeros:   # .NextDigit
;>@inc         dest += 1               # the next place, unless zeroes are still left out of a left-aligned number
	ld a, 1000000 / $10000 % $100
	ldh [hPowerOf10 + 0], a
;=@h1
	ld a, 1000000 / $100   % $100
	ldh [hPowerOf10 + 1], a
;=@h2
	ld a, 1000000 / $1     % $100
	ldh [hPowerOf10 + 2], a
;=@c0
	call .PrintDigit
;=@nx
	call .NextDigit
.hundred_thousands
;=@h0
	ld a, 100000 / $10000 % $100
	ldh [hPowerOf10 + 0], a
;=@h1
	ld a, 100000 / $100   % $100
	ldh [hPowerOf10 + 1], a
;=@h2
	ld a, 100000 / $1     % $100
	ldh [hPowerOf10 + 2], a
;=@c0
	call .PrintDigit
;=@nx
	call .NextDigit
.ten_thousands
;=@h0
	xor a
	ldh [hPowerOf10 + 0], a
;=@h1
	ld a, 10000 / $100   % $100
	ldh [hPowerOf10 + 1], a
;=@h2
	ld a, 10000 / $1     % $100
	ldh [hPowerOf10 + 2], a
;=@c0
	call .PrintDigit
;=@nx
	call .NextDigit
.thousands
;=@h0
	xor a
	ldh [hPowerOf10 + 0], a
;=@h1
	ld a, 1000 / $100   % $100
	ldh [hPowerOf10 + 1], a
;=@h2
	ld a, 1000 / $1     % $100
	ldh [hPowerOf10 + 2], a
;=@c0
	call .PrintDigit
;=@nx
	call .NextDigit
.hundreds
;=@h0
	xor a
	ldh [hPowerOf10 + 0], a
;=@h1
	xor a
	ldh [hPowerOf10 + 1], a
;=@h2
	ld a, 100 / $1     % $100
	ldh [hPowerOf10 + 2], a
;=@c0
	call .PrintDigit
;=@nx
	call .NextDigit

.tens
;> tens = 0
	ld c, 0
;> ones = N[2]                         # what is left: below 100
	ldh a, [hNumToPrint + 2]
;>@md while ones >= 10:
.mod
	cp 10
	jr c, .ok
;>     ones -= 10
	sub 10
;>     tens += 1
	inc c
;=@md
	jr .mod
.ok

;> hPastLeadingZeros |= tens
	ld b, a
	ldh a, [hPastLeadingZeros]
	or c
	ldh [hPastLeadingZeros], a
;> if hPastLeadingZeros == 0:
	jr nz, .past
;>     if flags >> BIT_LEADING_ZEROES & 1:
;>         mem[dest] = 0xF6            # '0'
	call .PrintLeadingZero
	jr .next
;> else:
;>     mem[dest] = u8(0xF6 + tens)
.past
	ld a, '0'
	add c
	ld [hl], a
.next

;> if flags >> BIT_LEADING_ZEROES & 1 or not flags >> BIT_LEFT_ALIGN & 1 or hPastLeadingZeros:
;>     dest += 1
	call .NextDigit
; ones
;> mem[dest] = u8(0xF6 + ones)         # the last digit always shows
	ld a, '0'
	add b
	ld [hli], a
;> # (src, one byte back, and bc come back off the stack)
	pop de
	dec de
	pop bc
;> return dest + 1
	ret

.PrintDigit:
; Divide by the current decimal place.
; Print the quotient, and keep the modulus.
;=@c0
	ld c, 0
.loop
;=@s0
	ldh a, [hPowerOf10]
	ld b, a
	ldh a, [hNumToPrint]
	ldh [hSavedNumToPrint], a
;=@u0
	cp b
	jr c, .underflow0
;=@m0
	sub b
	ldh [hNumToPrint], a
;=@s1
	ldh a, [hPowerOf10 + 1]
	ld b, a
	ldh a, [hNumToPrint + 1]
	ldh [hSavedNumToPrint + 1], a
;=@if1
	cp b
	jr nc, .noborrow1

;=@z1
	ldh a, [hNumToPrint]
	or 0
	jr z, .underflow1
;=@d1
	dec a
	ldh [hNumToPrint], a
	ldh a, [hNumToPrint + 1]
.noborrow1

;=@m1
	sub b
	ldh [hNumToPrint + 1], a
;=@s2
	ldh a, [hPowerOf10 + 2]
	ld b, a
	ldh a, [hNumToPrint + 2]
	ldh [hSavedNumToPrint + 2], a
;=@if2
	cp b
	jr nc, .noborrow2

;=@z2
	ldh a, [hNumToPrint + 1]
	and a
	jr nz, .borrowed

;=@z3
	ldh a, [hNumToPrint]
	and a
	jr z, .underflow2
;=@d2
	dec a
	ldh [hNumToPrint], a
	xor a
.borrowed

;=@d3
	dec a
	ldh [hNumToPrint + 1], a
	ldh a, [hNumToPrint + 2]
.noborrow2
;=@m2
	sub b
	ldh [hNumToPrint + 2], a
;=@cn
	inc c
	jr .loop

.underflow2
;=@r2
	ldh a, [hSavedNumToPrint + 1]
	ldh [hNumToPrint + 1], a
.underflow1
;=@r1
	ldh a, [hSavedNumToPrint]
	ldh [hNumToPrint], a
.underflow0
;=@pz
	ldh a, [hPastLeadingZeros]
	or c
	jr z, .PrintLeadingZero

;=@pd1
	ld a, '0'
	add c
	ld [hl], a
;=@pd2
	ldh [hPastLeadingZeros], a
	ret

.PrintLeadingZero:
;=@pz0
	bit BIT_LEADING_ZEROES, d
	ret z
;=@pz1
	ld [hl], '0'
	ret

.NextDigit:
; Increment unless the number is left-aligned,
; leading zeroes are not printed, and no digits
; have been printed yet.
;=@nx
	bit BIT_LEADING_ZEROES, d
	jr nz, .inc
	bit BIT_LEFT_ALIGN, d
	jr z, .inc
	ldh a, [hPastLeadingZeros]
	and a
;=@nx
	ret z
.inc
;=@inc
	inc hl
	ret
;@ path: home/array2
;@ def CallFunctionInTable(index: a, table: hl)
;@ Call entry `index` of the table of function addresses at table; keeps hl and bc.
;@ test: skip calls whatever the table entry points at
CallFunctionInTable::
; Call function a in jumptable hl.
; de is not preserved.
;> # (the registers are saved on the stack)
	push hl
	push de
	push bc
;> entry = table + 2 * index
	add a
	ld d, 0
	ld e, a
	add hl, de
;> func = mem16[entry]
	ld a, [hli]
	ld h, [hl]
	ld l, a
;> call(func)
	ld de, .returnAddress
	push de
	jp hl
.returnAddress
;> # (the registers come back off the stack)
	pop bc
	pop de
	pop hl
	ret

;@ path: home/array2
;@ def IsInArray(value: a, array: hl, stride: de) -> (b, hl, carry)
;@ Look for value in a list of stride-byte entries ending with -1 ($FF). Carry if it is there; b is its
;@ index and hl points at it.
;@ test: stride = rand(1, 4); array = rand_ram(64); mem[array + stride * rand(0, 15)] = 0xFF
IsInArray::
; Search an array at hl for the value in a.
; Entry size is de bytes.
; Return count b and carry if found.
;> return IsInRestOfArray(value, array, stride, 0)
	ld b, 0

;@ path: home/array2
;@ def IsInRestOfArray(value: a, array: hl, stride: de, index: b) -> (b, hl, carry)
;@ IsInArray from entry `index` on: array points at that entry.
;@ test: stride = rand(1, 4); array = rand_ram(64); mem[array + stride * rand(0, 15)] = 0xFF
IsInRestOfArray::
;> while True:
	ld c, a
.loop
;>     entry = mem[array]
	ld a, [hl]
;>     if entry == 0xFF:
;>         return (index, array, False)
	cp -1
	jr z, .notfound
;>     if entry == value:
;>         return (index, array, True)
	cp c
	jr z, .found
;>     index = u8(index + 1)
	inc b
;>     array += stride
	add hl, de
	jr .loop

.notfound
	and a
	ret

.found
	scf
	ret
;@ path: home/palettes
;@ def RestoreScreenTilesAndReloadTilePatterns()
;@ Come back to the map from a menu: the map's sprites, the screen saved in wTileMapBackup2, the text box
;@ tiles and the palettes.
RestoreScreenTilesAndReloadTilePatterns::
;> ClearSprites()
	call ClearSprites
;> wUpdateSpritesEnabled = 1
	ld a, $1
	ld [wUpdateSpritesEnabled], a
;> ReloadMapSpriteTilePatterns()
	call ReloadMapSpriteTilePatterns
;> LoadScreenTilesFromBuffer2()
	call LoadScreenTilesFromBuffer2
;> LoadTextBoxTilePatterns()
	call LoadTextBoxTilePatterns
;> RunDefaultPaletteCommand()
	call RunDefaultPaletteCommand
;> Delay3()
	jr Delay3

;@ path: home/palettes
;@ def GBPalWhiteOutWithDelay3()
;@ Turn every palette white and wait three frames.
GBPalWhiteOutWithDelay3::
;> GBPalWhiteOut()
;> Delay3()
	call GBPalWhiteOut

;@ path: home/palettes
;@ def Delay3()
;@ Wait three frames: the BG map is copied to VRAM a third at a time, so this lets a whole screen arrive.
Delay3::
; The bg map is updated each frame in thirds.
; Wait three frames to let the bg map fully update.
;> DelayFrames(3)
	ld c, 3
	jp DelayFrames

;@ path: home/palettes
;@ def GBPalNormal()
;@ The normal palettes: BG shades 3 2 1 0, object palette 0 shades 3 1 0 0.
GBPalNormal::
; Reset BGP and OBP0.
;> rBGP = 0b11100100
;> rOBP0 = 0b11010000
	ld a, %11100100 ; 3210
	ldh [rBGP], a
	ld a, %11010000 ; 3100
	ldh [rOBP0], a
	ret

;@ path: home/palettes
;@ def GBPalWhiteOut()
;@ Turn all three palettes white.
GBPalWhiteOut::
; White out all palettes.
;> rBGP = 0
	xor a
	ldh [rBGP], a
;> rOBP0 = 0
	ldh [rOBP0], a
;> rOBP1 = 0
	ldh [rOBP1], a
	ret

;@ path: home/palettes
;@ def RunDefaultPaletteCommand()
;@ Set the Super Game Boy palettes for the current screen (SET_PAL_DEFAULT).
;@ test: wDefaultPaletteCommand = rand(0, SET_PAL_TRAINER_CARD)
RunDefaultPaletteCommand::
;> RunPaletteCommand(SET_PAL_DEFAULT)
	ld b, SET_PAL_DEFAULT
;@ path: home/palettes
;@ def RunPaletteCommand(command: b)
;@ Send Super Game Boy palette command `command`; nothing happens on a plain Game Boy.
;@ test: command = rand(0, SET_PAL_TRAINER_CARD)
RunPaletteCommand::
;> if not wOnSGB:
;>     return
	ld a, [wOnSGB]
	and a
	ret z
;> predef(_RunPaletteCommand, bc=command << 8)
;> set_rom_bank(hLoadedROMBank)    # a far call returns to the bank in hLoadedROMBank
	ld a, (_RunPaletteCommandPredef - PredefPointers) / 3
	jp Predef

;@ path: home/palettes
;@ def GetHealthBarColor(length: e, dest: hl)
;@ The colour of an HP bar `length` pixels long, stored at dest: 0 green from 27 pixels, 1 yellow from
;@ 10, 2 red below.
GetHealthBarColor::
; Return at hl the palette of
; an HP bar e pixels long.
;> if length >= 27:
;>     mem[dest] = 0
	ld a, e
	cp 27
	ld d, 0 ; green
	jr nc, .gotColor
;> elif length >= 10:
;>     mem[dest] = 1
	cp 10
	inc d ; yellow
	jr nc, .gotColor
;> else:
;>     mem[dest] = 2
	inc d ; red
.gotColor
	ld [hl], d
	ret
; Copy the current map's sprites' tile patterns to VRAM again after they have
; been overwritten by other tile patterns.
;@ path: home/reload_sprites
;@ def ReloadMapSpriteTilePatterns()
;@ Load the tiles of the map's people and of the player again after a menu or battle has overwritten them,
;@ then the font, and update the sprites.
ReloadMapSpriteTilePatterns::
;> saved = wFontLoaded                 # (kept on the stack)
	ld hl, wFontLoaded
	ld a, [hl]
	push af
;> wFontLoaded = saved & ~(1 << BIT_FONT_LOADED)
	res BIT_FONT_LOADED, [hl]
	push hl
;> wSpriteSetID = 0
	xor a
	ld [wSpriteSetID], a
;> DisableLCD()
	call DisableLCD
;> InitMapSprites()
;> set_rom_bank(hLoadedROMBank)        # a far call returns to the bank in hLoadedROMBank
	ld b, BANK(InitMapSprites)
	ld hl, InitMapSprites
	call Bankswitch
;> EnableLCD()
	call EnableLCD
;> wFontLoaded = saved
	pop hl
	pop af
	ld [hl], a
;> LoadPlayerSpriteGraphics()
	call LoadPlayerSpriteGraphics
;> LoadFontTilePatterns()
	call LoadFontTilePatterns
;> UpdateSprites()
	jp UpdateSprites
;@ path: home/give
;@ def GiveItem(item: b, quantity: c) -> carry
;@ Put `quantity` of `item` into the bag and its name into wStringBuffer. No carry if the bag is full.
GiveItem::
; Give player quantity c of item b,
; and copy the item's name to wStringBuffer.
; Return carry on success.
;> wNamedObjectIndex = item
	ld a, b
	ld [wNamedObjectIndex], a
;> wCurItem = item
	ld [wCurItem], a
;> wItemQuantity = quantity
	ld a, c
	ld [wItemQuantity], a
;> if not AddItemToInventory(addr(wNumBagItems)):
;>     return False
	ld hl, wNumBagItems
	call AddItemToInventory
	ret nc
;> CopyToStringBuffer(GetItemName())
	call GetItemName
	call CopyToStringBuffer
;> return True
	scf
	ret

;@ path: home/give
;@ def GivePokemon(species: b, level: c) -> carry
;@ Give the player a `species` Pokemon at `level`: into the party, or the PC box if the party is full.
GivePokemon::
; Give the player monster b at level c.
;> wCurPartySpecies = species
	ld a, b
	ld [wCurPartySpecies], a
;> wCurEnemyLevel = level
	ld a, c
	ld [wCurEnemyLevel], a
;> wMonDataLocation = PLAYER_PARTY_DATA
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
;> result = _GivePokemon()
;> set_rom_bank(hLoadedROMBank)        # a far call returns to the bank in hLoadedROMBank
	ld b, BANK(_GivePokemon)
	ld hl, _GivePokemon
	jp Bankswitch
;> return result
;@ path: home/random
;@ def Random(carry_in: carry = False) -> a
;@ The next random number (Random_ in its own bank updates hRandomAdd and hRandomSub); keeps hl, de and bc.
Random::
; Return a random number in a.
; For battles, use BattleRandom.
;> # (the registers are saved on the stack)
	push hl
	push de
	push bc
;> Random_(carry_in)
;> set_rom_bank(hLoadedROMBank)        # a far call returns to the bank in hLoadedROMBank
	ld b, BANK(Random_)
	ld hl, Random_
	call Bankswitch
;> result = hRandomAdd
	ldh a, [hRandomAdd]
;> # (the registers come back off the stack)
	pop bc
	pop de
	pop hl
;> return result
	ret
;@ path: home/predef
;@ def Predef(id: a, saved_hl: hl = 0, saved_de: de = 0, saved_bc: bc = 0)
;@ Call predefined function `id` from the table in GetPredefPointer, in its own bank. GetPredefPointer saves
;@ hl, de and bc, so the function gets its arguments back with GetPredefRegisters.
;@ test: skip calls whatever function the predef table names
Predef::
; Call predefined function a.
; To preserve other registers, have the
; destination call GetPredefRegisters.

	; Save the predef id for GetPredefPointer.
;> wPredefID = id
	ld [wPredefID], a

	; A hack for LoadDestinationWarpPosition.
	; See LoadTilesetHeader (predef $19).
;> wPredefParentBank = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	ld [wPredefParentBank], a

;> saved = hLoadedROMBank              # (kept on the stack)
	push af
;> hLoadedROMBank = BANK(GetPredefPointer)
	ld a, BANK(GetPredefPointer)
	ldh [hLoadedROMBank], a
;> set_rom_bank(BANK(GetPredefPointer))
	ld [rROMB], a

;> func = GetPredefPointer(saved_hl, saved_de, saved_bc)
	call GetPredefPointer

;> hLoadedROMBank = wPredefBank
	ld a, [wPredefBank]
	ldh [hLoadedROMBank], a
;> set_rom_bank(wPredefBank)
	ld [rROMB], a

;> call(func)
	ld de, .done
	push de
	jp hl
.done

;> hLoadedROMBank = saved
	pop af
	ldh [hLoadedROMBank], a
;> set_rom_bank(saved)
	ld [rROMB], a
	ret

;@ path: home/predef
;@ def GetPredefRegisters() -> (hl, de, bc)
;@ The hl, de and bc a predef was called with (saved big-endian by GetPredefPointer).
GetPredefRegisters::
; Restore the contents of register pairs
; when GetPredefPointer was called.
;> hl = wPredefHL[0] << 8 | wPredefHL[1]
	ld a, [wPredefHL]
	ld h, a
	ld a, [wPredefHL + 1]
	ld l, a
;> de = wPredefDE[0] << 8 | wPredefDE[1]
	ld a, [wPredefDE]
	ld d, a
	ld a, [wPredefDE + 1]
	ld e, a
;> bc = wPredefBC[0] << 8 | wPredefBC[1]
	ld a, [wPredefBC]
	ld b, a
	ld a, [wPredefBC + 1]
	ld c, a
;> return (hl, de, bc)
	ret
;@ path: home/hidden_events
;@ def UpdateCinnabarGymGateTileBlocks()
;@ Redraw the Cinnabar Gym's gates (UpdateCinnabarGymGateTileBlocks_, in its own bank).
UpdateCinnabarGymGateTileBlocks::
;> UpdateCinnabarGymGateTileBlocks_()
;> set_rom_bank(hLoadedROMBank)    # a far call returns to the bank in hLoadedROMBank
	ld b, BANK(UpdateCinnabarGymGateTileBlocks_)
	ld hl, UpdateCinnabarGymGateTileBlocks_
	jp Bankswitch

;@ path: home/hidden_events
;@ def CheckForHiddenEventOrBookshelfOrCardKeyDoor()
;@ With A held, look for a hidden event in front of the player and run its function, or else a bookshelf.
;@ hItemAlreadyFound is 0 if something was found and run, $FF if not.
;@ test: skip runs the hidden event's function through a pointer
CheckForHiddenEventOrBookshelfOrCardKeyDoor::
;> saved = hLoadedROMBank
	ldh a, [hLoadedROMBank]
	push af
;> if hJoyHeld & 1 << B_PAD_A:
	ldh a, [hJoyHeld]
	bit B_PAD_A, a
	jr z, .nothingFound
; A button is pressed
;>     set_rom_bank(BANK(CheckForHiddenEvent))
	ld a, BANK(CheckForHiddenEvent)
	ld [rROMB], a
;>     hLoadedROMBank = BANK(CheckForHiddenEvent)
	ldh [hLoadedROMBank], a
;>     func = CheckForHiddenEvent()             # the event's function, in hl
	call CheckForHiddenEvent
;>     if not hDidntFindAnyHiddenEvent:
	ldh a, [hDidntFindAnyHiddenEvent]
	and a
	jr nz, .hiddenEventNotFound
;>         set_rom_bank(wHiddenEventFunctionRomBank)
	ld a, [wHiddenEventFunctionRomBank]
	ld [rROMB], a
;>         hLoadedROMBank = wHiddenEventFunctionRomBank
	ldh [hLoadedROMBank], a
;>         call(func)                           # returns to .returnAddress
	ld de, .returnAddress
	push de
	jp hl
.returnAddress
;>         found = 0
	xor a
	jr .done
;>     else:
.hiddenEventNotFound
;>         PrintBookshelfText()                 # a bookshelf, poster or card key door in front?
;>         set_rom_bank(hLoadedROMBank)         # (Bankswitch switches back)
	ld b, BANK(PrintBookshelfText)
	ld hl, PrintBookshelfText
	call Bankswitch
;>         if hInteractedWithBookshelf == 0:    # 0: it printed something
;>             found = 0
	ldh a, [hInteractedWithBookshelf]
	and a
	jr z, .done
;>         else:
;>             found = 0xFF
;> else:
;>     found = 0xFF
.nothingFound
	ld a, $ff
.done
;> hItemAlreadyFound = found
	ldh [hItemAlreadyFound], a
;> set_rom_bank(saved)
	pop af
	ld [rROMB], a
;> hLoadedROMBank = saved
	ldh [hLoadedROMBank], a
	ret
;@ path: home/predef_text
;@ def PrintPredefTextID(id: a)
;@ Show one of the shared texts in TextPredefs (number id) as if it were a text of the current map.
PrintPredefTextID::
;> hTextID = id
	ldh [hTextID], a
;> SetMapTextPointer(TextPredefs)
	ld hl, TextPredefs
	call SetMapTextPointer
;> wTextPredefFlag |= 1 << BIT_TEXT_PREDEF
	ld hl, wTextPredefFlag
	set BIT_TEXT_PREDEF, [hl]
;> DisplayTextID()
	call DisplayTextID
;> RestoreMapTextPointer()

;@ path: home/predef_text
;@ def RestoreMapTextPointer()
;@ Put back the map's text pointer that SetMapTextPointer saved.
RestoreMapTextPointer::
;> wCurMapTextPtr[0] = hSavedMapTextPtr[0]
;> wCurMapTextPtr[1] = hSavedMapTextPtr[1]
	ld hl, wCurMapTextPtr
	ldh a, [hSavedMapTextPtr]
	ld [hli], a
	ldh a, [hSavedMapTextPtr + 1]
	ld [hl], a
	ret

;@ path: home/predef_text
;@ def SetMapTextPointer(texts: hl)
;@ Point wCurMapTextPtr at another list of texts for a while, saving the map's own in hSavedMapTextPtr.
SetMapTextPointer::
;> hSavedMapTextPtr[0] = wCurMapTextPtr[0]
	ld a, [wCurMapTextPtr]
	ldh [hSavedMapTextPtr], a
;> hSavedMapTextPtr[1] = wCurMapTextPtr[1]
	ld a, [wCurMapTextPtr + 1]
	ldh [hSavedMapTextPtr + 1], a
;> wCurMapTextPtr[0] = lo(texts)
	ld a, l
	ld [wCurMapTextPtr], a
;> wCurMapTextPtr[1] = hi(texts)
	ld a, h
	ld [wCurMapTextPtr + 1], a
	ret


;@ path: home/predef_text
TextPredefs::
	; 01
CardKeySuccessText_id::
	dw CardKeySuccessText
	; 02
CardKeyFailText_id::
	dw CardKeyFailText
	; 03
RedBedroomPCText_id::
	dw RedBedroomPCText
	; 04
RedBedroomSNESText_id::
	dw RedBedroomSNESText
	; 05
PushStartText_id::
	dw PushStartText
	; 06
SaveOptionText_id::
	dw SaveOptionText
	; 07
StrengthsAndWeaknessesText_id::
	dw StrengthsAndWeaknessesText
	; 08
OakLabEmailText_id::
	dw OakLabEmailText
	; 09
AerodactylFossilText_id::
	dw AerodactylFossilText
	; 0A
Route15UpstairsBinocularsText_id::
	dw Route15UpstairsBinocularsText
	; 0B
KabutopsFossilText_id::
	dw KabutopsFossilText
	; 0C
GymStatueText1_id::
	dw GymStatueText1
	; 0D
GymStatueText2_id::
	dw GymStatueText2
	; 0E
BookcaseText_id::
	dw BookcaseText
	; 0F
ViridianCityPokecenterBenchGuyText_id::
	dw ViridianCityPokecenterBenchGuyText
	; 10
PewterCityPokecenterBenchGuyText_id::
	dw PewterCityPokecenterBenchGuyText
	; 11
CeruleanCityPokecenterBenchGuyText_id::
	dw CeruleanCityPokecenterBenchGuyText
	; 12
LavenderCityPokecenterBenchGuyText_id::
	dw LavenderCityPokecenterBenchGuyText
	; 13
VermilionCityPokecenterBenchGuyText_id::
	dw VermilionCityPokecenterBenchGuyText
	; 14
CeladonCityPokecenterBenchGuyText_id::
	dw CeladonCityPokecenterBenchGuyText
	; 15
CeladonCityHotelText_id::
	dw CeladonCityHotelText
	; 16
FuchsiaCityPokecenterBenchGuyText_id::
	dw FuchsiaCityPokecenterBenchGuyText
	; 17
CinnabarIslandPokecenterBenchGuyText_id::
	dw CinnabarIslandPokecenterBenchGuyText
	; 18
SaffronCityPokecenterBenchGuyText_id::
	dw SaffronCityPokecenterBenchGuyText
	; 19
MtMoonPokecenterBenchGuyText_id::
	dw MtMoonPokecenterBenchGuyText
	; 1A
RockTunnelPokecenterBenchGuyText_id::
	dw RockTunnelPokecenterBenchGuyText
	; 1B XXX unused
UnusedBenchGuyText1_id::
	dw UnusedBenchGuyText1
	; 1C XXX unused
UnusedBenchGuyText2_id::
	dw UnusedBenchGuyText2
	; 1D XXX unused
UnusedBenchGuyText3_id::
	dw UnusedBenchGuyText3
	; 1E XXX unused
UnusedPredefText_id::
	dw UnusedPredefText
	; 1F
PokemonCenterPCText_id::
	dw PokemonCenterPCText
	; 20
ViridianSchoolNotebook_id::
	dw ViridianSchoolNotebook
	; 21
ViridianSchoolBlackboard_id::
	dw ViridianSchoolBlackboard
	; 22
JustAMomentText_id::
	dw JustAMomentText
	; 23
OpenBillsPCText_id::
	dw OpenBillsPCText
	; 24
FoundHiddenItemText_id::
	dw FoundHiddenItemText
	; 25 XXX unused
HiddenItemBagFullText_id::
	dw HiddenItemBagFullText
	; 26
VermilionGymTrashText_id::
	dw VermilionGymTrashText
	; 27
IndigoPlateauHQText_id::
	dw IndigoPlateauHQText
	; 28
GameCornerOutOfOrderText_id::
	dw GameCornerOutOfOrderText
	; 29
GameCornerOutToLunchText_id::
	dw GameCornerOutToLunchText
	; 2A
GameCornerSomeonesKeysText_id::
	dw GameCornerSomeonesKeysText
	; 2B
FoundHiddenCoinsText_id::
	dw FoundHiddenCoinsText
	; 2C
DroppedHiddenCoinsText_id::
	dw DroppedHiddenCoinsText
	; 2D
BillsHouseMonitorText_id::
	dw BillsHouseMonitorText
	; 2E
BillsHouseInitiatedText_id::
	dw BillsHouseInitiatedText
	; 2F
BillsHousePokemonList_id::
	dw BillsHousePokemonList
	; 30
MagazinesText_id::
	dw MagazinesText
	; 31
CinnabarGymQuiz_id::
	dw CinnabarGymQuiz
	; 32
GameCornerNoCoinsText_id::
	dw GameCornerNoCoinsText
	; 33
GameCornerCoinCaseText_id::
	dw GameCornerCoinCaseText
	; 34
LinkCableHelp_id::
	dw LinkCableHelp
	; 35
TMNotebook_id::
	dw TMNotebook
	; 36
FightingDojoText_id::
	dw FightingDojoText
	; 37
EnemiesOnEverySideText_id::
	dw EnemiesOnEverySideText
	; 38
WhatGoesAroundComesAroundText_id::
	dw WhatGoesAroundComesAroundText
	; 39
NewBicycleText_id::
	dw NewBicycleText
	; 3A
IndigoPlateauStatues_id::
	dw IndigoPlateauStatues
	; 3B
VermilionGymTrashSuccessText1_id::
	dw VermilionGymTrashSuccessText1
	; 3C XXX unused
VermilionGymTrashSuccessText2_id::
	dw VermilionGymTrashSuccessText2
	; 3D
VermilionGymTrashSuccessText3_id::
	dw VermilionGymTrashSuccessText3
	; 3E
VermilionGymTrashFailText_id::
	dw VermilionGymTrashFailText
	; 3F
TownMapText_id::
	dw TownMapText
	; 40
BookOrSculptureText_id::
	dw BookOrSculptureText
	; 41
ElevatorText_id::
	dw ElevatorText
	; 42
PokemonStuffText_id::
	dw PokemonStuffText
