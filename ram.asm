; Used in wram.asm










SECTION "VRAM", VRAM

UNION
; generic
	vChars0:: ds $80 * TILE_SIZE
	vChars1:: ds $80 * TILE_SIZE
	vChars2:: ds $80 * TILE_SIZE
vBGMap0:: ds TILEMAP_AREA
vBGMap1:: ds TILEMAP_AREA

NEXTU
; battle/menu
	vSprites::  ds $80 * TILE_SIZE
	vFont::     ds $80 * TILE_SIZE
	vFrontPic:: ds PIC_SIZE * TILE_SIZE
	vBackPic::  ds PIC_SIZE * TILE_SIZE

NEXTU
; overworld
	vNPCSprites::  ds $80 * TILE_SIZE
	vNPCSprites2:: ds $80 * TILE_SIZE
	vTileset::     ds $80 * TILE_SIZE

NEXTU
; title
	ds $80 * TILE_SIZE
	vTitleLogo::  ds $80 * TILE_SIZE
	ds PIC_SIZE * TILE_SIZE
	vTitleLogo2:: ds 30 * TILE_SIZE

ENDU

ENDSECTION
SECTION "Audio RAM", WRAM0

wUnusedMusicByte:: db

wSoundID:: db

; bit 7: whether sound has been muted
; all bits: whether the effective is active
; Store 1 to activate effect (any value in the range [1, 127] works).
; All audio is muted and music is paused. Sfx continues playing until it
; ends normally.
; Store 0 to resume music.
wMuteAudioAndPauseMusic:: db

wDisableChannelOutputWhenSfxEnds:: db

wStereoPanning:: db

wSavedVolume:: db

wChannelCommandPointers:: ds NUM_CHANNELS * 2
wChannelReturnAddresses:: ds NUM_CHANNELS * 2

wChannelSoundIDs:: ds NUM_CHANNELS

wChannelFlags1:: ds NUM_CHANNELS
wChannelFlags2:: ds NUM_CHANNELS

wChannelDutyCycles:: ds NUM_CHANNELS
wChannelDutyCyclePatterns:: ds NUM_CHANNELS

; reloaded at the beginning of a note. counts down until the vibrato begins.
wChannelVibratoDelayCounters:: ds NUM_CHANNELS
wChannelVibratoExtents:: ds NUM_CHANNELS
; high nybble is rate (counter reload value) and low nybble is counter.
; time between applications of vibrato.
wChannelVibratoRates:: ds NUM_CHANNELS
wChannelFrequencyLowBytes:: ds NUM_CHANNELS
; delay of the beginning of the vibrato from the start of the note
wChannelVibratoDelayCounterReloadValues:: ds NUM_CHANNELS

wChannelPitchSlideLengthModifiers:: ds NUM_CHANNELS
wChannelPitchSlideFrequencySteps:: ds NUM_CHANNELS
wChannelPitchSlideFrequencyStepsFractionalPart:: ds NUM_CHANNELS
wChannelPitchSlideCurrentFrequencyFractionalPart:: ds NUM_CHANNELS
wChannelPitchSlideCurrentFrequencyHighBytes:: ds NUM_CHANNELS
wChannelPitchSlideCurrentFrequencyLowBytes:: ds NUM_CHANNELS
wChannelPitchSlideTargetFrequencyHighBytes:: ds NUM_CHANNELS
wChannelPitchSlideTargetFrequencyLowBytes:: ds NUM_CHANNELS

; Note delays are stored as 16-bit fixed-point numbers where the integer part
; is 8 bits and the fractional part is 8 bits.
wChannelNoteDelayCounters:: ds NUM_CHANNELS
wChannelLoopCounters:: ds NUM_CHANNELS
wChannelNoteSpeeds:: ds NUM_CHANNELS
wChannelNoteDelayCountersFractionalPart:: ds NUM_CHANNELS

wChannelOctaves:: ds NUM_CHANNELS
; also includes fade for hardware channels that support it
wChannelVolumes:: ds NUM_CHANNELS

wMusicWaveInstrument:: db
wSfxWaveInstrument:: db
wMusicTempo:: dw
wSfxTempo:: dw
wSfxHeaderPointer:: dw

wNewSoundID:: db

wAudioROMBank:: db
wAudioSavedROMBank:: db

wFrequencyModifier:: db
wTempoModifier:: db

	ds 13


SECTION "Sprite State Data", WRAM0

wSpriteDataStart::

; data for all sprites on the current map
; holds info for 16 sprites with $10 bytes each
wSpriteStateData1::
; struct fields:
; - 0: picture ID (fixed, loaded at map init)
; - 1: movement status (0: uninitialized, 1: ready, 2: delayed, 3: moving)
; - 2: sprite image index (changed on update, $ff if off screen, includes facing direction, progress in walking animation and a sprite-specific offset)
; - 3: Y screen position delta (-1,0 or 1; added to Y pixels on each walking animation update)
; - 4: Y screen position (in pixels, always 4 pixels above grid which makes sprites appear to be in the center of a tile)
; - 5: X screen position delta (-1,0 or 1; added to field X pixels on each walking animation update)
; - 6: X screen position (in pixels, snaps to grid if not currently walking)
; - 7: intra-animation-frame counter (counting upwards to 4 until animation frame counter is incremented)
; - 8: animation frame counter (increased every 4 updates, hold four states (totalling to 16 walking frames)
; - 9: facing direction ($0: down, $4: up, $8: left, $c: right)
; - A: adjusted Y coordinate
; - B: adjusted X coordinate
; - C: direction of collision
; - D
; - E
; - F
wSpritePlayerStateData1::
	; player is struct 0
wSpritePlayerStateData1PictureID::
	db
wSpritePlayerStateData1MovementStatus::
	db
wSpritePlayerStateData1ImageIndex::
	db
wSpritePlayerStateData1YStepVector::
	db
wSpritePlayerStateData1YPixels::
	db
wSpritePlayerStateData1XStepVector::
	db
wSpritePlayerStateData1XPixels::
	db
wSpritePlayerStateData1IntraAnimFrameCounter::
	db
wSpritePlayerStateData1AnimFrameCounter::
	db
wSpritePlayerStateData1FacingDirection::
	db
wSpritePlayerStateData1YAdjusted::
	db
wSpritePlayerStateData1XAdjusted::
	db
wSpritePlayerStateData1CollisionData::
	db
	ds 3
wSpritePlayerStateData1End::
; wSprite01StateData1 - wSprite15StateData1
wSprite01StateData1::
wSprite01StateData1PictureID::
	db
wSprite01StateData1MovementStatus::
	db
wSprite01StateData1ImageIndex::
	db
wSprite01StateData1YStepVector::
	db
wSprite01StateData1YPixels::
	db
wSprite01StateData1XStepVector::
	db
wSprite01StateData1XPixels::
	db
wSprite01StateData1IntraAnimFrameCounter::
	db
wSprite01StateData1AnimFrameCounter::
	db
wSprite01StateData1FacingDirection::
	db
wSprite01StateData1YAdjusted::
	db
wSprite01StateData1XAdjusted::
	db
wSprite01StateData1CollisionData::
	db
	ds 3
wSprite01StateData1End::
wSprite02StateData1::
wSprite02StateData1PictureID::
	db
wSprite02StateData1MovementStatus::
	db
wSprite02StateData1ImageIndex::
	db
wSprite02StateData1YStepVector::
	db
wSprite02StateData1YPixels::
	db
wSprite02StateData1XStepVector::
	db
wSprite02StateData1XPixels::
	db
wSprite02StateData1IntraAnimFrameCounter::
	db
wSprite02StateData1AnimFrameCounter::
	db
wSprite02StateData1FacingDirection::
	db
wSprite02StateData1YAdjusted::
	db
wSprite02StateData1XAdjusted::
	db
wSprite02StateData1CollisionData::
	db
	ds 3
wSprite02StateData1End::
wSprite03StateData1::
wSprite03StateData1PictureID::
	db
wSprite03StateData1MovementStatus::
	db
wSprite03StateData1ImageIndex::
	db
wSprite03StateData1YStepVector::
	db
wSprite03StateData1YPixels::
	db
wSprite03StateData1XStepVector::
	db
wSprite03StateData1XPixels::
	db
wSprite03StateData1IntraAnimFrameCounter::
	db
wSprite03StateData1AnimFrameCounter::
	db
wSprite03StateData1FacingDirection::
	db
wSprite03StateData1YAdjusted::
	db
wSprite03StateData1XAdjusted::
	db
wSprite03StateData1CollisionData::
	db
	ds 3
wSprite03StateData1End::
wSprite04StateData1::
wSprite04StateData1PictureID::
	db
wSprite04StateData1MovementStatus::
	db
wSprite04StateData1ImageIndex::
	db
wSprite04StateData1YStepVector::
	db
wSprite04StateData1YPixels::
	db
wSprite04StateData1XStepVector::
	db
wSprite04StateData1XPixels::
	db
wSprite04StateData1IntraAnimFrameCounter::
	db
wSprite04StateData1AnimFrameCounter::
	db
wSprite04StateData1FacingDirection::
	db
wSprite04StateData1YAdjusted::
	db
wSprite04StateData1XAdjusted::
	db
wSprite04StateData1CollisionData::
	db
	ds 3
wSprite04StateData1End::
wSprite05StateData1::
wSprite05StateData1PictureID::
	db
wSprite05StateData1MovementStatus::
	db
wSprite05StateData1ImageIndex::
	db
wSprite05StateData1YStepVector::
	db
wSprite05StateData1YPixels::
	db
wSprite05StateData1XStepVector::
	db
wSprite05StateData1XPixels::
	db
wSprite05StateData1IntraAnimFrameCounter::
	db
wSprite05StateData1AnimFrameCounter::
	db
wSprite05StateData1FacingDirection::
	db
wSprite05StateData1YAdjusted::
	db
wSprite05StateData1XAdjusted::
	db
wSprite05StateData1CollisionData::
	db
	ds 3
wSprite05StateData1End::
wSprite06StateData1::
wSprite06StateData1PictureID::
	db
wSprite06StateData1MovementStatus::
	db
wSprite06StateData1ImageIndex::
	db
wSprite06StateData1YStepVector::
	db
wSprite06StateData1YPixels::
	db
wSprite06StateData1XStepVector::
	db
wSprite06StateData1XPixels::
	db
wSprite06StateData1IntraAnimFrameCounter::
	db
wSprite06StateData1AnimFrameCounter::
	db
wSprite06StateData1FacingDirection::
	db
wSprite06StateData1YAdjusted::
	db
wSprite06StateData1XAdjusted::
	db
wSprite06StateData1CollisionData::
	db
	ds 3
wSprite06StateData1End::
wSprite07StateData1::
wSprite07StateData1PictureID::
	db
wSprite07StateData1MovementStatus::
	db
wSprite07StateData1ImageIndex::
	db
wSprite07StateData1YStepVector::
	db
wSprite07StateData1YPixels::
	db
wSprite07StateData1XStepVector::
	db
wSprite07StateData1XPixels::
	db
wSprite07StateData1IntraAnimFrameCounter::
	db
wSprite07StateData1AnimFrameCounter::
	db
wSprite07StateData1FacingDirection::
	db
wSprite07StateData1YAdjusted::
	db
wSprite07StateData1XAdjusted::
	db
wSprite07StateData1CollisionData::
	db
	ds 3
wSprite07StateData1End::
wSprite08StateData1::
wSprite08StateData1PictureID::
	db
wSprite08StateData1MovementStatus::
	db
wSprite08StateData1ImageIndex::
	db
wSprite08StateData1YStepVector::
	db
wSprite08StateData1YPixels::
	db
wSprite08StateData1XStepVector::
	db
wSprite08StateData1XPixels::
	db
wSprite08StateData1IntraAnimFrameCounter::
	db
wSprite08StateData1AnimFrameCounter::
	db
wSprite08StateData1FacingDirection::
	db
wSprite08StateData1YAdjusted::
	db
wSprite08StateData1XAdjusted::
	db
wSprite08StateData1CollisionData::
	db
	ds 3
wSprite08StateData1End::
wSprite09StateData1::
wSprite09StateData1PictureID::
	db
wSprite09StateData1MovementStatus::
	db
wSprite09StateData1ImageIndex::
	db
wSprite09StateData1YStepVector::
	db
wSprite09StateData1YPixels::
	db
wSprite09StateData1XStepVector::
	db
wSprite09StateData1XPixels::
	db
wSprite09StateData1IntraAnimFrameCounter::
	db
wSprite09StateData1AnimFrameCounter::
	db
wSprite09StateData1FacingDirection::
	db
wSprite09StateData1YAdjusted::
	db
wSprite09StateData1XAdjusted::
	db
wSprite09StateData1CollisionData::
	db
	ds 3
wSprite09StateData1End::
wSprite10StateData1::
wSprite10StateData1PictureID::
	db
wSprite10StateData1MovementStatus::
	db
wSprite10StateData1ImageIndex::
	db
wSprite10StateData1YStepVector::
	db
wSprite10StateData1YPixels::
	db
wSprite10StateData1XStepVector::
	db
wSprite10StateData1XPixels::
	db
wSprite10StateData1IntraAnimFrameCounter::
	db
wSprite10StateData1AnimFrameCounter::
	db
wSprite10StateData1FacingDirection::
	db
wSprite10StateData1YAdjusted::
	db
wSprite10StateData1XAdjusted::
	db
wSprite10StateData1CollisionData::
	db
	ds 3
wSprite10StateData1End::
wSprite11StateData1::
wSprite11StateData1PictureID::
	db
wSprite11StateData1MovementStatus::
	db
wSprite11StateData1ImageIndex::
	db
wSprite11StateData1YStepVector::
	db
wSprite11StateData1YPixels::
	db
wSprite11StateData1XStepVector::
	db
wSprite11StateData1XPixels::
	db
wSprite11StateData1IntraAnimFrameCounter::
	db
wSprite11StateData1AnimFrameCounter::
	db
wSprite11StateData1FacingDirection::
	db
wSprite11StateData1YAdjusted::
	db
wSprite11StateData1XAdjusted::
	db
wSprite11StateData1CollisionData::
	db
	ds 3
wSprite11StateData1End::
wSprite12StateData1::
wSprite12StateData1PictureID::
	db
wSprite12StateData1MovementStatus::
	db
wSprite12StateData1ImageIndex::
	db
wSprite12StateData1YStepVector::
	db
wSprite12StateData1YPixels::
	db
wSprite12StateData1XStepVector::
	db
wSprite12StateData1XPixels::
	db
wSprite12StateData1IntraAnimFrameCounter::
	db
wSprite12StateData1AnimFrameCounter::
	db
wSprite12StateData1FacingDirection::
	db
wSprite12StateData1YAdjusted::
	db
wSprite12StateData1XAdjusted::
	db
wSprite12StateData1CollisionData::
	db
	ds 3
wSprite12StateData1End::
wSprite13StateData1::
wSprite13StateData1PictureID::
	db
wSprite13StateData1MovementStatus::
	db
wSprite13StateData1ImageIndex::
	db
wSprite13StateData1YStepVector::
	db
wSprite13StateData1YPixels::
	db
wSprite13StateData1XStepVector::
	db
wSprite13StateData1XPixels::
	db
wSprite13StateData1IntraAnimFrameCounter::
	db
wSprite13StateData1AnimFrameCounter::
	db
wSprite13StateData1FacingDirection::
	db
wSprite13StateData1YAdjusted::
	db
wSprite13StateData1XAdjusted::
	db
wSprite13StateData1CollisionData::
	db
	ds 3
wSprite13StateData1End::
wSprite14StateData1::
wSprite14StateData1PictureID::
	db
wSprite14StateData1MovementStatus::
	db
wSprite14StateData1ImageIndex::
	db
wSprite14StateData1YStepVector::
	db
wSprite14StateData1YPixels::
	db
wSprite14StateData1XStepVector::
	db
wSprite14StateData1XPixels::
	db
wSprite14StateData1IntraAnimFrameCounter::
	db
wSprite14StateData1AnimFrameCounter::
	db
wSprite14StateData1FacingDirection::
	db
wSprite14StateData1YAdjusted::
	db
wSprite14StateData1XAdjusted::
	db
wSprite14StateData1CollisionData::
	db
	ds 3
wSprite14StateData1End::
wSprite15StateData1::
wSprite15StateData1PictureID::
	db
wSprite15StateData1MovementStatus::
	db
wSprite15StateData1ImageIndex::
	db
wSprite15StateData1YStepVector::
	db
wSprite15StateData1YPixels::
	db
wSprite15StateData1XStepVector::
	db
wSprite15StateData1XPixels::
	db
wSprite15StateData1IntraAnimFrameCounter::
	db
wSprite15StateData1AnimFrameCounter::
	db
wSprite15StateData1FacingDirection::
	db
wSprite15StateData1YAdjusted::
	db
wSprite15StateData1XAdjusted::
	db
wSprite15StateData1CollisionData::
	db
	ds 3
wSprite15StateData1End::

; more data for all sprites on the current map
; holds info for 16 sprites with $10 bytes each
wSpriteStateData1End::
wSpriteStateData2::
; struct fields:
; - 0: walk animation counter (counting from $10 backwards when moving)
; - 1:
; - 2: Y displacement (initialized at 8, supposed to keep moving sprites from moving too far, but bugged)
; - 3: X displacement (initialized at 8, supposed to keep moving sprites from moving too far, but bugged)
; - 4: Y position (in 2x2 tile grid steps, topmost 2x2 tile has value 4)
; - 5: X position (in 2x2 tile grid steps, leftmost 2x2 tile has value 4)
; - 6: movement byte 1 (determines whether a sprite can move, $ff:not moving, $fe:random movements, others unknown)
; - 7: (?) (set to $80 when in grass, else $0; may be used to draw grass above the sprite)
; - 8: delay until next movement (counted downwards, movement status is set to ready if reached 0)
; - 9: original facing direction (backed up by DisplayTextIDInit, restored by CloseTextDisplay)
; - A
; - B
; - C
; - D: picture ID
; - E: sprite image base offset (in video ram, player always has value 1, used to compute sprite image index)
; - F
wSpritePlayerStateData2::
	; player is struct 0
wSpritePlayerStateData2WalkAnimationCounter::
	db
	ds 1
wSpritePlayerStateData2YDisplacement::
	db
wSpritePlayerStateData2XDisplacement::
	db
wSpritePlayerStateData2MapY::
	db
wSpritePlayerStateData2MapX::
	db
wSpritePlayerStateData2MovementByte1::
	db
wSpritePlayerStateData2GrassPriority::
	db
wSpritePlayerStateData2MovementDelay::
	db
wSpritePlayerStateData2OrigFacingDirection::
	db
	ds 3
wSpritePlayerStateData2PictureID::
	db
wSpritePlayerStateData2ImageBaseOffset::
	db
	ds 1
wSpritePlayerStateData2End::
; wSprite01StateData2 - wSprite15StateData2
wSprite01StateData2::
wSprite01StateData2WalkAnimationCounter::
	db
	ds 1
wSprite01StateData2YDisplacement::
	db
wSprite01StateData2XDisplacement::
	db
wSprite01StateData2MapY::
	db
wSprite01StateData2MapX::
	db
wSprite01StateData2MovementByte1::
	db
wSprite01StateData2GrassPriority::
	db
wSprite01StateData2MovementDelay::
	db
wSprite01StateData2OrigFacingDirection::
	db
	ds 3
wSprite01StateData2PictureID::
	db
wSprite01StateData2ImageBaseOffset::
	db
	ds 1
wSprite01StateData2End::
wSprite02StateData2::
wSprite02StateData2WalkAnimationCounter::
	db
	ds 1
wSprite02StateData2YDisplacement::
	db
wSprite02StateData2XDisplacement::
	db
wSprite02StateData2MapY::
	db
wSprite02StateData2MapX::
	db
wSprite02StateData2MovementByte1::
	db
wSprite02StateData2GrassPriority::
	db
wSprite02StateData2MovementDelay::
	db
wSprite02StateData2OrigFacingDirection::
	db
	ds 3
wSprite02StateData2PictureID::
	db
wSprite02StateData2ImageBaseOffset::
	db
	ds 1
wSprite02StateData2End::
wSprite03StateData2::
wSprite03StateData2WalkAnimationCounter::
	db
	ds 1
wSprite03StateData2YDisplacement::
	db
wSprite03StateData2XDisplacement::
	db
wSprite03StateData2MapY::
	db
wSprite03StateData2MapX::
	db
wSprite03StateData2MovementByte1::
	db
wSprite03StateData2GrassPriority::
	db
wSprite03StateData2MovementDelay::
	db
wSprite03StateData2OrigFacingDirection::
	db
	ds 3
wSprite03StateData2PictureID::
	db
wSprite03StateData2ImageBaseOffset::
	db
	ds 1
wSprite03StateData2End::
wSprite04StateData2::
wSprite04StateData2WalkAnimationCounter::
	db
	ds 1
wSprite04StateData2YDisplacement::
	db
wSprite04StateData2XDisplacement::
	db
wSprite04StateData2MapY::
	db
wSprite04StateData2MapX::
	db
wSprite04StateData2MovementByte1::
	db
wSprite04StateData2GrassPriority::
	db
wSprite04StateData2MovementDelay::
	db
wSprite04StateData2OrigFacingDirection::
	db
	ds 3
wSprite04StateData2PictureID::
	db
wSprite04StateData2ImageBaseOffset::
	db
	ds 1
wSprite04StateData2End::
wSprite05StateData2::
wSprite05StateData2WalkAnimationCounter::
	db
	ds 1
wSprite05StateData2YDisplacement::
	db
wSprite05StateData2XDisplacement::
	db
wSprite05StateData2MapY::
	db
wSprite05StateData2MapX::
	db
wSprite05StateData2MovementByte1::
	db
wSprite05StateData2GrassPriority::
	db
wSprite05StateData2MovementDelay::
	db
wSprite05StateData2OrigFacingDirection::
	db
	ds 3
wSprite05StateData2PictureID::
	db
wSprite05StateData2ImageBaseOffset::
	db
	ds 1
wSprite05StateData2End::
wSprite06StateData2::
wSprite06StateData2WalkAnimationCounter::
	db
	ds 1
wSprite06StateData2YDisplacement::
	db
wSprite06StateData2XDisplacement::
	db
wSprite06StateData2MapY::
	db
wSprite06StateData2MapX::
	db
wSprite06StateData2MovementByte1::
	db
wSprite06StateData2GrassPriority::
	db
wSprite06StateData2MovementDelay::
	db
wSprite06StateData2OrigFacingDirection::
	db
	ds 3
wSprite06StateData2PictureID::
	db
wSprite06StateData2ImageBaseOffset::
	db
	ds 1
wSprite06StateData2End::
wSprite07StateData2::
wSprite07StateData2WalkAnimationCounter::
	db
	ds 1
wSprite07StateData2YDisplacement::
	db
wSprite07StateData2XDisplacement::
	db
wSprite07StateData2MapY::
	db
wSprite07StateData2MapX::
	db
wSprite07StateData2MovementByte1::
	db
wSprite07StateData2GrassPriority::
	db
wSprite07StateData2MovementDelay::
	db
wSprite07StateData2OrigFacingDirection::
	db
	ds 3
wSprite07StateData2PictureID::
	db
wSprite07StateData2ImageBaseOffset::
	db
	ds 1
wSprite07StateData2End::
wSprite08StateData2::
wSprite08StateData2WalkAnimationCounter::
	db
	ds 1
wSprite08StateData2YDisplacement::
	db
wSprite08StateData2XDisplacement::
	db
wSprite08StateData2MapY::
	db
wSprite08StateData2MapX::
	db
wSprite08StateData2MovementByte1::
	db
wSprite08StateData2GrassPriority::
	db
wSprite08StateData2MovementDelay::
	db
wSprite08StateData2OrigFacingDirection::
	db
	ds 3
wSprite08StateData2PictureID::
	db
wSprite08StateData2ImageBaseOffset::
	db
	ds 1
wSprite08StateData2End::
wSprite09StateData2::
wSprite09StateData2WalkAnimationCounter::
	db
	ds 1
wSprite09StateData2YDisplacement::
	db
wSprite09StateData2XDisplacement::
	db
wSprite09StateData2MapY::
	db
wSprite09StateData2MapX::
	db
wSprite09StateData2MovementByte1::
	db
wSprite09StateData2GrassPriority::
	db
wSprite09StateData2MovementDelay::
	db
wSprite09StateData2OrigFacingDirection::
	db
	ds 3
wSprite09StateData2PictureID::
	db
wSprite09StateData2ImageBaseOffset::
	db
	ds 1
wSprite09StateData2End::
wSprite10StateData2::
wSprite10StateData2WalkAnimationCounter::
	db
	ds 1
wSprite10StateData2YDisplacement::
	db
wSprite10StateData2XDisplacement::
	db
wSprite10StateData2MapY::
	db
wSprite10StateData2MapX::
	db
wSprite10StateData2MovementByte1::
	db
wSprite10StateData2GrassPriority::
	db
wSprite10StateData2MovementDelay::
	db
wSprite10StateData2OrigFacingDirection::
	db
	ds 3
wSprite10StateData2PictureID::
	db
wSprite10StateData2ImageBaseOffset::
	db
	ds 1
wSprite10StateData2End::
wSprite11StateData2::
wSprite11StateData2WalkAnimationCounter::
	db
	ds 1
wSprite11StateData2YDisplacement::
	db
wSprite11StateData2XDisplacement::
	db
wSprite11StateData2MapY::
	db
wSprite11StateData2MapX::
	db
wSprite11StateData2MovementByte1::
	db
wSprite11StateData2GrassPriority::
	db
wSprite11StateData2MovementDelay::
	db
wSprite11StateData2OrigFacingDirection::
	db
	ds 3
wSprite11StateData2PictureID::
	db
wSprite11StateData2ImageBaseOffset::
	db
	ds 1
wSprite11StateData2End::
wSprite12StateData2::
wSprite12StateData2WalkAnimationCounter::
	db
	ds 1
wSprite12StateData2YDisplacement::
	db
wSprite12StateData2XDisplacement::
	db
wSprite12StateData2MapY::
	db
wSprite12StateData2MapX::
	db
wSprite12StateData2MovementByte1::
	db
wSprite12StateData2GrassPriority::
	db
wSprite12StateData2MovementDelay::
	db
wSprite12StateData2OrigFacingDirection::
	db
	ds 3
wSprite12StateData2PictureID::
	db
wSprite12StateData2ImageBaseOffset::
	db
	ds 1
wSprite12StateData2End::
wSprite13StateData2::
wSprite13StateData2WalkAnimationCounter::
	db
	ds 1
wSprite13StateData2YDisplacement::
	db
wSprite13StateData2XDisplacement::
	db
wSprite13StateData2MapY::
	db
wSprite13StateData2MapX::
	db
wSprite13StateData2MovementByte1::
	db
wSprite13StateData2GrassPriority::
	db
wSprite13StateData2MovementDelay::
	db
wSprite13StateData2OrigFacingDirection::
	db
	ds 3
wSprite13StateData2PictureID::
	db
wSprite13StateData2ImageBaseOffset::
	db
	ds 1
wSprite13StateData2End::
wSprite14StateData2::
wSprite14StateData2WalkAnimationCounter::
	db
	ds 1
wSprite14StateData2YDisplacement::
	db
wSprite14StateData2XDisplacement::
	db
wSprite14StateData2MapY::
	db
wSprite14StateData2MapX::
	db
wSprite14StateData2MovementByte1::
	db
wSprite14StateData2GrassPriority::
	db
wSprite14StateData2MovementDelay::
	db
wSprite14StateData2OrigFacingDirection::
	db
	ds 3
wSprite14StateData2PictureID::
	db
wSprite14StateData2ImageBaseOffset::
	db
	ds 1
wSprite14StateData2End::
wSprite15StateData2::
wSprite15StateData2WalkAnimationCounter::
	db
	ds 1
wSprite15StateData2YDisplacement::
	db
wSprite15StateData2XDisplacement::
	db
wSprite15StateData2MapY::
	db
wSprite15StateData2MapX::
	db
wSprite15StateData2MovementByte1::
	db
wSprite15StateData2GrassPriority::
	db
wSprite15StateData2MovementDelay::
	db
wSprite15StateData2OrigFacingDirection::
	db
	ds 3
wSprite15StateData2PictureID::
	db
wSprite15StateData2ImageBaseOffset::
	db
	ds 1
wSprite15StateData2End::
wSpriteStateData2End::

; The high byte of a pointer to anywhere within wSpriteStateData1 can be incremented
; to reach within wSpriteStateData2, and vice-versa for decrementing.
ASSERT HIGH(wSpriteStateData1) + 1 == HIGH(wSpriteStateData2)
ASSERT LOW(wSpriteStateData1) == 0 && LOW(wSpriteStateData2) == 0

wSpriteDataEnd::


SECTION "OAM Buffer", WRAM0

; buffer for OAM data. Copied to OAM by DMA
wShadowOAM::
; wShadowOAMSprite00 - wShadowOAMSprite39
wShadowOAMSprite00::
wShadowOAMSprite00YCoord::
	db
wShadowOAMSprite00XCoord::
	db
wShadowOAMSprite00TileID::
	db
wShadowOAMSprite00Attributes::
	db
wShadowOAMSprite01::
wShadowOAMSprite01YCoord::
	db
wShadowOAMSprite01XCoord::
	db
wShadowOAMSprite01TileID::
	db
wShadowOAMSprite01Attributes::
	db
wShadowOAMSprite02::
wShadowOAMSprite02YCoord::
	db
wShadowOAMSprite02XCoord::
	db
wShadowOAMSprite02TileID::
	db
wShadowOAMSprite02Attributes::
	db
wShadowOAMSprite03::
wShadowOAMSprite03YCoord::
	db
wShadowOAMSprite03XCoord::
	db
wShadowOAMSprite03TileID::
	db
wShadowOAMSprite03Attributes::
	db
wShadowOAMSprite04::
wShadowOAMSprite04YCoord::
	db
wShadowOAMSprite04XCoord::
	db
wShadowOAMSprite04TileID::
	db
wShadowOAMSprite04Attributes::
	db
wShadowOAMSprite05::
wShadowOAMSprite05YCoord::
	db
wShadowOAMSprite05XCoord::
	db
wShadowOAMSprite05TileID::
	db
wShadowOAMSprite05Attributes::
	db
wShadowOAMSprite06::
wShadowOAMSprite06YCoord::
	db
wShadowOAMSprite06XCoord::
	db
wShadowOAMSprite06TileID::
	db
wShadowOAMSprite06Attributes::
	db
wShadowOAMSprite07::
wShadowOAMSprite07YCoord::
	db
wShadowOAMSprite07XCoord::
	db
wShadowOAMSprite07TileID::
	db
wShadowOAMSprite07Attributes::
	db
wShadowOAMSprite08::
wShadowOAMSprite08YCoord::
	db
wShadowOAMSprite08XCoord::
	db
wShadowOAMSprite08TileID::
	db
wShadowOAMSprite08Attributes::
	db
wShadowOAMSprite09::
wShadowOAMSprite09YCoord::
	db
wShadowOAMSprite09XCoord::
	db
wShadowOAMSprite09TileID::
	db
wShadowOAMSprite09Attributes::
	db
wShadowOAMSprite10::
wShadowOAMSprite10YCoord::
	db
wShadowOAMSprite10XCoord::
	db
wShadowOAMSprite10TileID::
	db
wShadowOAMSprite10Attributes::
	db
wShadowOAMSprite11::
wShadowOAMSprite11YCoord::
	db
wShadowOAMSprite11XCoord::
	db
wShadowOAMSprite11TileID::
	db
wShadowOAMSprite11Attributes::
	db
wShadowOAMSprite12::
wShadowOAMSprite12YCoord::
	db
wShadowOAMSprite12XCoord::
	db
wShadowOAMSprite12TileID::
	db
wShadowOAMSprite12Attributes::
	db
wShadowOAMSprite13::
wShadowOAMSprite13YCoord::
	db
wShadowOAMSprite13XCoord::
	db
wShadowOAMSprite13TileID::
	db
wShadowOAMSprite13Attributes::
	db
wShadowOAMSprite14::
wShadowOAMSprite14YCoord::
	db
wShadowOAMSprite14XCoord::
	db
wShadowOAMSprite14TileID::
	db
wShadowOAMSprite14Attributes::
	db
wShadowOAMSprite15::
wShadowOAMSprite15YCoord::
	db
wShadowOAMSprite15XCoord::
	db
wShadowOAMSprite15TileID::
	db
wShadowOAMSprite15Attributes::
	db
wShadowOAMSprite16::
wShadowOAMSprite16YCoord::
	db
wShadowOAMSprite16XCoord::
	db
wShadowOAMSprite16TileID::
	db
wShadowOAMSprite16Attributes::
	db
wShadowOAMSprite17::
wShadowOAMSprite17YCoord::
	db
wShadowOAMSprite17XCoord::
	db
wShadowOAMSprite17TileID::
	db
wShadowOAMSprite17Attributes::
	db
wShadowOAMSprite18::
wShadowOAMSprite18YCoord::
	db
wShadowOAMSprite18XCoord::
	db
wShadowOAMSprite18TileID::
	db
wShadowOAMSprite18Attributes::
	db
wShadowOAMSprite19::
wShadowOAMSprite19YCoord::
	db
wShadowOAMSprite19XCoord::
	db
wShadowOAMSprite19TileID::
	db
wShadowOAMSprite19Attributes::
	db
wShadowOAMSprite20::
wShadowOAMSprite20YCoord::
	db
wShadowOAMSprite20XCoord::
	db
wShadowOAMSprite20TileID::
	db
wShadowOAMSprite20Attributes::
	db
wShadowOAMSprite21::
wShadowOAMSprite21YCoord::
	db
wShadowOAMSprite21XCoord::
	db
wShadowOAMSprite21TileID::
	db
wShadowOAMSprite21Attributes::
	db
wShadowOAMSprite22::
wShadowOAMSprite22YCoord::
	db
wShadowOAMSprite22XCoord::
	db
wShadowOAMSprite22TileID::
	db
wShadowOAMSprite22Attributes::
	db
wShadowOAMSprite23::
wShadowOAMSprite23YCoord::
	db
wShadowOAMSprite23XCoord::
	db
wShadowOAMSprite23TileID::
	db
wShadowOAMSprite23Attributes::
	db
wShadowOAMSprite24::
wShadowOAMSprite24YCoord::
	db
wShadowOAMSprite24XCoord::
	db
wShadowOAMSprite24TileID::
	db
wShadowOAMSprite24Attributes::
	db
wShadowOAMSprite25::
wShadowOAMSprite25YCoord::
	db
wShadowOAMSprite25XCoord::
	db
wShadowOAMSprite25TileID::
	db
wShadowOAMSprite25Attributes::
	db
wShadowOAMSprite26::
wShadowOAMSprite26YCoord::
	db
wShadowOAMSprite26XCoord::
	db
wShadowOAMSprite26TileID::
	db
wShadowOAMSprite26Attributes::
	db
wShadowOAMSprite27::
wShadowOAMSprite27YCoord::
	db
wShadowOAMSprite27XCoord::
	db
wShadowOAMSprite27TileID::
	db
wShadowOAMSprite27Attributes::
	db
wShadowOAMSprite28::
wShadowOAMSprite28YCoord::
	db
wShadowOAMSprite28XCoord::
	db
wShadowOAMSprite28TileID::
	db
wShadowOAMSprite28Attributes::
	db
wShadowOAMSprite29::
wShadowOAMSprite29YCoord::
	db
wShadowOAMSprite29XCoord::
	db
wShadowOAMSprite29TileID::
	db
wShadowOAMSprite29Attributes::
	db
wShadowOAMSprite30::
wShadowOAMSprite30YCoord::
	db
wShadowOAMSprite30XCoord::
	db
wShadowOAMSprite30TileID::
	db
wShadowOAMSprite30Attributes::
	db
wShadowOAMSprite31::
wShadowOAMSprite31YCoord::
	db
wShadowOAMSprite31XCoord::
	db
wShadowOAMSprite31TileID::
	db
wShadowOAMSprite31Attributes::
	db
wShadowOAMSprite32::
wShadowOAMSprite32YCoord::
	db
wShadowOAMSprite32XCoord::
	db
wShadowOAMSprite32TileID::
	db
wShadowOAMSprite32Attributes::
	db
wShadowOAMSprite33::
wShadowOAMSprite33YCoord::
	db
wShadowOAMSprite33XCoord::
	db
wShadowOAMSprite33TileID::
	db
wShadowOAMSprite33Attributes::
	db
wShadowOAMSprite34::
wShadowOAMSprite34YCoord::
	db
wShadowOAMSprite34XCoord::
	db
wShadowOAMSprite34TileID::
	db
wShadowOAMSprite34Attributes::
	db
wShadowOAMSprite35::
wShadowOAMSprite35YCoord::
	db
wShadowOAMSprite35XCoord::
	db
wShadowOAMSprite35TileID::
	db
wShadowOAMSprite35Attributes::
	db
wShadowOAMSprite36::
wShadowOAMSprite36YCoord::
	db
wShadowOAMSprite36XCoord::
	db
wShadowOAMSprite36TileID::
	db
wShadowOAMSprite36Attributes::
	db
wShadowOAMSprite37::
wShadowOAMSprite37YCoord::
	db
wShadowOAMSprite37XCoord::
	db
wShadowOAMSprite37TileID::
	db
wShadowOAMSprite37Attributes::
	db
wShadowOAMSprite38::
wShadowOAMSprite38YCoord::
	db
wShadowOAMSprite38XCoord::
	db
wShadowOAMSprite38TileID::
	db
wShadowOAMSprite38Attributes::
	db
wShadowOAMSprite39::
wShadowOAMSprite39YCoord::
	db
wShadowOAMSprite39XCoord::
	db
wShadowOAMSprite39TileID::
	db
wShadowOAMSprite39Attributes::
	db
wShadowOAMEnd::


SECTION "Tilemap", WRAM0

; buffer for tiles that are visible on screen (20 columns by 18 rows)
wTileMap:: ds SCREEN_AREA

; This union spans 480 bytes.
UNION
; buffer for temporarily saving and restoring current screen's tiles
; (e.g. if menus are drawn on top)
wTileMapBackup:: ds SCREEN_AREA

NEXTU
; buffer for the blocks surrounding the player (6 columns by 5 rows of 4x4-tile blocks)
wSurroundingTiles:: ds SURROUNDING_WIDTH * SURROUNDING_HEIGHT

NEXTU
; buffer for temporarily saving and restoring shadow OAM
wShadowOAMBackup::
; wShadowOAMBackupSprite00 - wShadowOAMBackupSprite39
wShadowOAMBackupSprite00::
wShadowOAMBackupSprite00YCoord::
	db
wShadowOAMBackupSprite00XCoord::
	db
wShadowOAMBackupSprite00TileID::
	db
wShadowOAMBackupSprite00Attributes::
	db
wShadowOAMBackupSprite01::
wShadowOAMBackupSprite01YCoord::
	db
wShadowOAMBackupSprite01XCoord::
	db
wShadowOAMBackupSprite01TileID::
	db
wShadowOAMBackupSprite01Attributes::
	db
wShadowOAMBackupSprite02::
wShadowOAMBackupSprite02YCoord::
	db
wShadowOAMBackupSprite02XCoord::
	db
wShadowOAMBackupSprite02TileID::
	db
wShadowOAMBackupSprite02Attributes::
	db
wShadowOAMBackupSprite03::
wShadowOAMBackupSprite03YCoord::
	db
wShadowOAMBackupSprite03XCoord::
	db
wShadowOAMBackupSprite03TileID::
	db
wShadowOAMBackupSprite03Attributes::
	db
wShadowOAMBackupSprite04::
wShadowOAMBackupSprite04YCoord::
	db
wShadowOAMBackupSprite04XCoord::
	db
wShadowOAMBackupSprite04TileID::
	db
wShadowOAMBackupSprite04Attributes::
	db
wShadowOAMBackupSprite05::
wShadowOAMBackupSprite05YCoord::
	db
wShadowOAMBackupSprite05XCoord::
	db
wShadowOAMBackupSprite05TileID::
	db
wShadowOAMBackupSprite05Attributes::
	db
wShadowOAMBackupSprite06::
wShadowOAMBackupSprite06YCoord::
	db
wShadowOAMBackupSprite06XCoord::
	db
wShadowOAMBackupSprite06TileID::
	db
wShadowOAMBackupSprite06Attributes::
	db
wShadowOAMBackupSprite07::
wShadowOAMBackupSprite07YCoord::
	db
wShadowOAMBackupSprite07XCoord::
	db
wShadowOAMBackupSprite07TileID::
	db
wShadowOAMBackupSprite07Attributes::
	db
wShadowOAMBackupSprite08::
wShadowOAMBackupSprite08YCoord::
	db
wShadowOAMBackupSprite08XCoord::
	db
wShadowOAMBackupSprite08TileID::
	db
wShadowOAMBackupSprite08Attributes::
	db
wShadowOAMBackupSprite09::
wShadowOAMBackupSprite09YCoord::
	db
wShadowOAMBackupSprite09XCoord::
	db
wShadowOAMBackupSprite09TileID::
	db
wShadowOAMBackupSprite09Attributes::
	db
wShadowOAMBackupSprite10::
wShadowOAMBackupSprite10YCoord::
	db
wShadowOAMBackupSprite10XCoord::
	db
wShadowOAMBackupSprite10TileID::
	db
wShadowOAMBackupSprite10Attributes::
	db
wShadowOAMBackupSprite11::
wShadowOAMBackupSprite11YCoord::
	db
wShadowOAMBackupSprite11XCoord::
	db
wShadowOAMBackupSprite11TileID::
	db
wShadowOAMBackupSprite11Attributes::
	db
wShadowOAMBackupSprite12::
wShadowOAMBackupSprite12YCoord::
	db
wShadowOAMBackupSprite12XCoord::
	db
wShadowOAMBackupSprite12TileID::
	db
wShadowOAMBackupSprite12Attributes::
	db
wShadowOAMBackupSprite13::
wShadowOAMBackupSprite13YCoord::
	db
wShadowOAMBackupSprite13XCoord::
	db
wShadowOAMBackupSprite13TileID::
	db
wShadowOAMBackupSprite13Attributes::
	db
wShadowOAMBackupSprite14::
wShadowOAMBackupSprite14YCoord::
	db
wShadowOAMBackupSprite14XCoord::
	db
wShadowOAMBackupSprite14TileID::
	db
wShadowOAMBackupSprite14Attributes::
	db
wShadowOAMBackupSprite15::
wShadowOAMBackupSprite15YCoord::
	db
wShadowOAMBackupSprite15XCoord::
	db
wShadowOAMBackupSprite15TileID::
	db
wShadowOAMBackupSprite15Attributes::
	db
wShadowOAMBackupSprite16::
wShadowOAMBackupSprite16YCoord::
	db
wShadowOAMBackupSprite16XCoord::
	db
wShadowOAMBackupSprite16TileID::
	db
wShadowOAMBackupSprite16Attributes::
	db
wShadowOAMBackupSprite17::
wShadowOAMBackupSprite17YCoord::
	db
wShadowOAMBackupSprite17XCoord::
	db
wShadowOAMBackupSprite17TileID::
	db
wShadowOAMBackupSprite17Attributes::
	db
wShadowOAMBackupSprite18::
wShadowOAMBackupSprite18YCoord::
	db
wShadowOAMBackupSprite18XCoord::
	db
wShadowOAMBackupSprite18TileID::
	db
wShadowOAMBackupSprite18Attributes::
	db
wShadowOAMBackupSprite19::
wShadowOAMBackupSprite19YCoord::
	db
wShadowOAMBackupSprite19XCoord::
	db
wShadowOAMBackupSprite19TileID::
	db
wShadowOAMBackupSprite19Attributes::
	db
wShadowOAMBackupSprite20::
wShadowOAMBackupSprite20YCoord::
	db
wShadowOAMBackupSprite20XCoord::
	db
wShadowOAMBackupSprite20TileID::
	db
wShadowOAMBackupSprite20Attributes::
	db
wShadowOAMBackupSprite21::
wShadowOAMBackupSprite21YCoord::
	db
wShadowOAMBackupSprite21XCoord::
	db
wShadowOAMBackupSprite21TileID::
	db
wShadowOAMBackupSprite21Attributes::
	db
wShadowOAMBackupSprite22::
wShadowOAMBackupSprite22YCoord::
	db
wShadowOAMBackupSprite22XCoord::
	db
wShadowOAMBackupSprite22TileID::
	db
wShadowOAMBackupSprite22Attributes::
	db
wShadowOAMBackupSprite23::
wShadowOAMBackupSprite23YCoord::
	db
wShadowOAMBackupSprite23XCoord::
	db
wShadowOAMBackupSprite23TileID::
	db
wShadowOAMBackupSprite23Attributes::
	db
wShadowOAMBackupSprite24::
wShadowOAMBackupSprite24YCoord::
	db
wShadowOAMBackupSprite24XCoord::
	db
wShadowOAMBackupSprite24TileID::
	db
wShadowOAMBackupSprite24Attributes::
	db
wShadowOAMBackupSprite25::
wShadowOAMBackupSprite25YCoord::
	db
wShadowOAMBackupSprite25XCoord::
	db
wShadowOAMBackupSprite25TileID::
	db
wShadowOAMBackupSprite25Attributes::
	db
wShadowOAMBackupSprite26::
wShadowOAMBackupSprite26YCoord::
	db
wShadowOAMBackupSprite26XCoord::
	db
wShadowOAMBackupSprite26TileID::
	db
wShadowOAMBackupSprite26Attributes::
	db
wShadowOAMBackupSprite27::
wShadowOAMBackupSprite27YCoord::
	db
wShadowOAMBackupSprite27XCoord::
	db
wShadowOAMBackupSprite27TileID::
	db
wShadowOAMBackupSprite27Attributes::
	db
wShadowOAMBackupSprite28::
wShadowOAMBackupSprite28YCoord::
	db
wShadowOAMBackupSprite28XCoord::
	db
wShadowOAMBackupSprite28TileID::
	db
wShadowOAMBackupSprite28Attributes::
	db
wShadowOAMBackupSprite29::
wShadowOAMBackupSprite29YCoord::
	db
wShadowOAMBackupSprite29XCoord::
	db
wShadowOAMBackupSprite29TileID::
	db
wShadowOAMBackupSprite29Attributes::
	db
wShadowOAMBackupSprite30::
wShadowOAMBackupSprite30YCoord::
	db
wShadowOAMBackupSprite30XCoord::
	db
wShadowOAMBackupSprite30TileID::
	db
wShadowOAMBackupSprite30Attributes::
	db
wShadowOAMBackupSprite31::
wShadowOAMBackupSprite31YCoord::
	db
wShadowOAMBackupSprite31XCoord::
	db
wShadowOAMBackupSprite31TileID::
	db
wShadowOAMBackupSprite31Attributes::
	db
wShadowOAMBackupSprite32::
wShadowOAMBackupSprite32YCoord::
	db
wShadowOAMBackupSprite32XCoord::
	db
wShadowOAMBackupSprite32TileID::
	db
wShadowOAMBackupSprite32Attributes::
	db
wShadowOAMBackupSprite33::
wShadowOAMBackupSprite33YCoord::
	db
wShadowOAMBackupSprite33XCoord::
	db
wShadowOAMBackupSprite33TileID::
	db
wShadowOAMBackupSprite33Attributes::
	db
wShadowOAMBackupSprite34::
wShadowOAMBackupSprite34YCoord::
	db
wShadowOAMBackupSprite34XCoord::
	db
wShadowOAMBackupSprite34TileID::
	db
wShadowOAMBackupSprite34Attributes::
	db
wShadowOAMBackupSprite35::
wShadowOAMBackupSprite35YCoord::
	db
wShadowOAMBackupSprite35XCoord::
	db
wShadowOAMBackupSprite35TileID::
	db
wShadowOAMBackupSprite35Attributes::
	db
wShadowOAMBackupSprite36::
wShadowOAMBackupSprite36YCoord::
	db
wShadowOAMBackupSprite36XCoord::
	db
wShadowOAMBackupSprite36TileID::
	db
wShadowOAMBackupSprite36Attributes::
	db
wShadowOAMBackupSprite37::
wShadowOAMBackupSprite37YCoord::
	db
wShadowOAMBackupSprite37XCoord::
	db
wShadowOAMBackupSprite37TileID::
	db
wShadowOAMBackupSprite37Attributes::
	db
wShadowOAMBackupSprite38::
wShadowOAMBackupSprite38YCoord::
	db
wShadowOAMBackupSprite38XCoord::
	db
wShadowOAMBackupSprite38TileID::
	db
wShadowOAMBackupSprite38Attributes::
	db
wShadowOAMBackupSprite39::
wShadowOAMBackupSprite39YCoord::
	db
wShadowOAMBackupSprite39XCoord::
	db
wShadowOAMBackupSprite39TileID::
	db
wShadowOAMBackupSprite39Attributes::
	db
wShadowOAMBackupEnd::

NEXTU
; list of indexes to patch with SERIAL_NO_DATA_BYTE after transfer
wSerialPartyMonsPatchList:: ds 200

; list of indexes to patch with SERIAL_NO_DATA_BYTE after transfer
wSerialEnemyMonsPatchList:: ds 200
ENDU


SECTION "Overworld Map", WRAM0

; This union spans 1300 bytes.
UNION
wOverworldMap:: ds 1300
wOverworldMapEnd::

NEXTU
	wTempPic:: ds PIC_SIZE * TILE_SIZE
ENDU


SECTION "WRAM", WRAM0

; the tiles of the row or column to be redrawn by RedrawRowOrColumn
wRedrawRowOrColumnSrcTiles:: ds SCREEN_WIDTH * 2

; coordinates of the position of the cursor for the top menu item (id 0)
wTopMenuItemY:: db
wTopMenuItemX:: db

; the id of the currently selected menu item
; the top item has id 0, the one below that has id 1, etc.
; note that the "top item" means the top item currently visible on the screen
; add this value to [wListScrollOffset] to get the item's position within the list
wCurrentMenuItem:: db

; the tile that was behind the menu cursor's current location
wTileBehindCursor:: db

; id of the bottom menu item
wMaxMenuItem:: db

; bit mask of keys that the menu will respond to
wMenuWatchedKeys:: db

; id of previously selected menu item
wLastMenuItem:: db

; It is mainly used by the party menu to remember the cursor position while the
; menu isn't active.
; It is also used to remember the cursor position of mon lists (for the
; withdraw/deposit/release actions) in Bill's PC so that it doesn't get lost
; when you choose a mon from the list and a sub-menu is shown. It's reset when
; you return to the main Bill's PC menu.
wPartyAndBillsPCSavedMenuItem:: db

; It is used by the bag list to remember the cursor position while the menu
; isn't active.
wBagSavedMenuItem:: db

; It is used by the start menu to remember the cursor position while the menu
; isn't active.
; The battle menu uses it so that the cursor position doesn't get lost when
; a sub-menu is shown. It's reset at the start of each battle.
wBattleAndStartSavedMenuItem:: db

wPlayerMoveListIndex:: db

; index in party of currently battling mon
wPlayerMonNumber:: db

; the address of the menu cursor's current location within wTileMap
wMenuCursorLocation:: dw

	ds 2

; how many times should HandleMenuInput poll the joypad state before it returns?
wMenuJoypadPollCount:: db

; id of menu item selected for swapping (counts from 1) (0 means that no menu item has been selected for swapping)
wMenuItemToSwap:: db

; offset of the current top menu item from the beginning of the list
; keeps track of what section of the list is on screen
wListScrollOffset:: db

; If non-zero, then when wrapping is disabled and the player tries to go past
; the top or bottom of the menu, return from HandleMenuInput. This is useful for
; menus that have too many items to display at once on the screen because it
; allows the caller to scroll the entire menu up or down when this happens.
wMenuWatchMovingOutOfBounds:: db

wTradeCenterPointerTableIndex:: db

	ds 1

; destination pointer for text output
; this variable is written to, but is never read from
wTextDest:: dw

; if non-zero, skip waiting for a button press after displaying text in DisplayTextID
wDoNotWaitForButtonPressAfterDisplayingText:: db

; This union spans 12 bytes.
UNION
; the received menu selection is stored twice
wLinkMenuSelectionReceiveBuffer:: dw
	ds 3
; the menu selection byte is stored twice before sending
wLinkMenuSelectionSendBuffer:: dw
	ds 3
wEnteringCableClub::
wLinkTimeoutCounter:: db

NEXTU
; temporary nybble used by Serial_ExchangeNybble
wSerialExchangeNybbleTempReceiveData::
; the final received nybble is stored here by Serial_SyncAndExchangeNybble
wSerialSyncAndExchangeNybbleReceiveData:: db
; the final received nybble is stored here by Serial_ExchangeNybble
wSerialExchangeNybbleReceiveData:: db
	ds 3
; this nybble is sent when using Serial_SyncAndExchangeNybble or Serial_ExchangeNybble
wSerialExchangeNybbleSendData:: db
	ds 4
wUnknownSerialCounter:: dw
ENDU

; $00 = player mons
; $01 = enemy mons
wWhichTradeMonSelectionMenu::
; 0 = player's party
; 1 = enemy party
; 2 = current box
; 3 = daycare
; 4 = in-battle mon
;
; AddPartyMon uses it slightly differently.
; If the lower nybble is 0, the mon is added to the player's party, else the enemy's.
; If the entire value is 0, then the player is allowed to name the mon.
wMonDataLocation:: db

; set to 1 if you can go from the bottom to the top or top to bottom of a menu
; set to 0 if you can't go past the top or bottom of the menu
wMenuWrappingEnabled:: db

; whether to check for 180-degree turn (0 = don't, 1 = do)
wCheckFor180DegreeTurn:: db

	ds 1

wToggleableObjectIndex:: db

wPredefID:: db
wPredefHL:: dw
wPredefDE:: dw
wPredefBC:: dw

wTrainerHeaderFlagBit:: db

	ds 1

; which NPC movement script pointer is being used
; 0 if an NPC movement script is not running
wNPCMovementScriptPointerTableNum:: db

; ROM bank of current NPC movement script
wNPCMovementScriptBank:: db

	ds 2

; This union spans 180 bytes.
UNION
wVermilionDockTileMapBuffer:: ds 5 * TILEMAP_WIDTH + SCREEN_WIDTH
wVermilionDockTileMapBufferEnd::

NEXTU
wOaksAideRewardItemName:: ds ITEM_NAME_LENGTH

NEXTU
wElevatorWarpMaps:: ds 11 * 2

NEXTU
; List of bag items that has been filtered to a certain type of items,
; such as drinks or fossils.
wFilteredBagItems:: ds 4

NEXTU
; Saved copy of OAM for the first frame of the animation to make it easy to
; flip back from the second frame.
wMonPartySpritesSavedOAM:: ds OBJ_SIZE * 4 * PARTY_LENGTH

NEXTU
wTrainerCardBlkPacket:: ds $40

NEXTU
wHallOfFame:: ds HOF_TEAM

NEXTU
wNPCMovementDirections:: ds 180

NEXTU
wDexRatingNumMonsSeen:: db
wDexRatingNumMonsOwned:: db
wDexRatingText:: db

NEXTU
; If a random number greater than this value is generated, then the player is
; allowed to have three 7 symbols or bar symbols line up.
; So, this value is actually the chance of NOT entering that mode.
; If the slot is lucky, it equals 250, giving a 5/256 (~2%) chance.
; Otherwise, it equals 253, giving a 2/256 (~0.8%) chance.
wSlotMachineSevenAndBarModeChance:: db
	ds 2
; ROM back to return to when the player is done with the slot machine
wSlotMachineSavedROMBank:: db
	ds 166
wLuckySlotHiddenEventIndex:: db

NEXTU
; values between 0-6. Shake screen horizontally, shake screen vertically, blink Pokemon...
wAnimationType:: db
	ds 29
wAnimPalette:: db

NEXTU
	ds 60
; temporary buffer when swapping party mon data
wSwitchPartyMonTempBuffer:: ds PARTYMON_STRUCT_LENGTH

NEXTU
	ds 120
; this is the end of the joypad states
; the list starts above this address and extends downwards in memory until here
; overloaded with below labels
wSimulatedJoypadStatesEnd::

NEXTU
wUnusedFlag::
wBoostExpByExpAll:: db

	ds 59

wNPCMovementDirections2:: ds 10
; used in Pallet Town scripted movement
wNumStepsToTake:: db

	ds 48

wRLEByteCount:: db

wParentMenuItem::
; 0 = not added
; 1 = added
wAddedToParty::
; 1 flag for each party member indicating whether it can evolve
; The purpose of these flags is to track which mons levelled up during the
; current battle at the end of the battle when evolution occurs.
; Other methods of evolution simply set it by calling TryEvolvingMon.
wMiscBattleData::
wCanEvolveFlags:: db

wForceEvolution:: db

; if [wAILayer2Encouragement] != 1, the second AI layer is not applied
wAILayer2Encouragement:: db

	ds 1

; current HP of player and enemy substitutes
wPlayerSubstituteHP:: db
wEnemySubstituteHP:: db

; used for TestBattle (unused in non-debug builds)
wTestBattlePlayerSelectedMove:: db

	ds 1

; 0=regular, 1=mimic, 2=above message box (relearn, heal pp..)
wMoveMenuType:: db

wPlayerSelectedMove:: db
wEnemySelectedMove:: db

wLinkBattleRandomNumberListIndex:: db

; number of times remaining that AI action can occur
wAICount:: db

	ds 2

wEnemyMoveListIndex:: db

; The enemy mon's HP when it was switched in or when the current player mon
; was switched in, which was more recent.
; It's used to determine the message to print when switching out the player mon.
wLastSwitchInEnemyMonHP:: dw

; total amount of money made using Pay Day during the current battle
wTotalPayDayMoney:: ds 3

wSafariEscapeFactor:: db
wSafariBaitFactor:: db

	ds 1

wTransformedEnemyMonOriginalDVs:: dw

wMonIsDisobedient:: db

wPlayerDisabledMoveNumber:: db
wEnemyDisabledMoveNumber:: db

; When running in the scope of HandlePlayerMonFainted, it equals 1.
; When running in the scope of HandleEnemyMonFainted, it equals 0.
wInHandlePlayerMonFainted:: db

wPlayerUsedMove:: db
wEnemyUsedMove:: db

wEnemyMonMinimized:: db

wMoveDidntMiss:: db

; flags that indicate which party members have fought the current enemy mon
wPartyFoughtCurrentEnemyFlags::
	ds ((PARTY_LENGTH) + 7) / 8

; Whether the low health alarm has been disabled due to the player winning the
; battle.
wLowHealthAlarmDisabled:: db

wPlayerMonMinimized:: db

	ds 13

UNION
; the amount of damage accumulated by the enemy while biding
wEnemyBideAccumulatedDamage:: dw
NEXTU
; number of hits by enemy in attacks like Double Slap, etc.
wEnemyNumHits:: db
ENDU

	ds 8
wMiscBattleDataEnd::
ENDU

; This union spans 39 bytes.
UNION
wInGameTradeGiveMonSpecies:: db
wInGameTradeTextPointerTablePointer:: dw
wInGameTradeTextPointerTableIndex:: db
wInGameTradeGiveMonName:: ds NAME_LENGTH
wInGameTradeReceiveMonName:: ds NAME_LENGTH
wInGameTradeMonNick:: ds NAME_LENGTH
wInGameTradeReceiveMonSpecies:: db

NEXTU
wPlayerMonUnmodifiedLevel:: db
wPlayerMonUnmodifiedMaxHP:: dw
wPlayerMonUnmodifiedAttack:: dw
wPlayerMonUnmodifiedDefense:: dw
wPlayerMonUnmodifiedSpeed:: dw
wPlayerMonUnmodifiedSpecial:: dw

; stat modifiers for the player's current pokemon
; value can range from 1 - 13 ($1 to $D)
; 7 is normal
wPlayerMonStatMods::
wPlayerMonAttackMod:: db
wPlayerMonDefenseMod:: db
wPlayerMonSpeedMod:: db
wPlayerMonSpecialMod:: db
wPlayerMonAccuracyMod:: db
wPlayerMonEvasionMod:: db
	ds 2
wPlayerMonStatModsEnd::

	ds 1

wEnemyMonUnmodifiedLevel:: db
wEnemyMonUnmodifiedMaxHP:: dw
wEnemyMonUnmodifiedAttack:: dw
wEnemyMonUnmodifiedDefense:: dw
wEnemyMonUnmodifiedSpeed:: dw
wEnemyMonUnmodifiedSpecial:: dw

; stat modifiers for the enemy's current pokemon
; value can range from 1 - 13 ($1 to $D)
; 7 is normal
wEnemyMonStatMods::
wEnemyMonAttackMod:: db
wEnemyMonDefenseMod:: db
wEnemyMonSpeedMod:: db
wEnemyMonSpecialMod:: db
wEnemyMonAccuracyMod:: db
wEnemyMonEvasionMod:: db
	ds 2
wEnemyMonStatModsEnd::

NEXTU
	ds 30
wEngagedTrainerClass:: db
wEngagedTrainerSet:: db
ENDU

	ds 1

wNPCMovementDirections2Index::
wUnusedLinkMenuByte::
; number of items in wFilteredBagItems list
wFilteredBagItemsCount:: db

; the next simulated joypad state is at wSimulatedJoypadStatesEnd plus this value minus 1
; 0 if the joypad state is not being simulated
wSimulatedJoypadStatesIndex:: db
; written to but nothing ever reads it
wUnusedSimulatedJoypadStatesMask:: db
; written to but nothing ever reads it
wUnusedOverrideSimulatedJoypadStatesIndex:: db
; mask indicating which real button presses can override simulated ones
; XXX is it ever not 0?
wOverrideSimulatedJoypadStatesMask:: db

	ds 1

; This union spans 30 bytes.
UNION
wTradedPlayerMonSpecies:: db
wTradedEnemyMonSpecies:: db
	ds 2
wTradedPlayerMonOT:: ds NAME_LENGTH
wTradedPlayerMonOTID:: dw
wTradedEnemyMonOT:: ds NAME_LENGTH
wTradedEnemyMonOTID:: dw

NEXTU
wTradingWhichPlayerMon:: db
wTradingWhichEnemyMon:: db
wNameOfPlayerMonToBeTraded:: ds NAME_LENGTH

NEXTU
; one byte for each falling object
wFallingObjectsMovementData:: ds 20

NEXTU
; array of the number of mons in each box
wBoxMonCounts:: ds NUM_BOXES

NEXTU
wPriceTemp:: ds 3 ; BCD

NEXTU
; the current mon's field moves
wFieldMoves:: ds NUM_MOVES
wNumFieldMoves:: db
wFieldMovesLeftmostXCoord:: db
wLastFieldMoveID:: db ; unused

NEXTU
wBoxNumString:: ds 3

NEXTU
; 0 = upper half (Y < 9)
; 1 = lower half (Y >= 9)
wBattleTransitionCircleScreenQuadrantY:: db
wBattleTransitionCircleScreenQuadrantX:: db

NEXTU
; after 1 row/column has been copied, the offset to the next one to copy from
wBattleTransitionCopyTilesOffset:: dw

NEXTU
; counts down from 7 so that every time 7 more tiles of the spiral have been
; placed, the tile map buffer is copied to VRAM so that progress is visible
wInwardSpiralUpdateScreenCounter:: db
	ds 9
; 0 = outward, 1 = inward
wBattleTransitionSpiralDirection:: db

NEXTU
; multiplied by 16 to get the number of times to go right by 2 pixels
wSSAnneSmokeDriftAmount:: db
; 0 = left half (X < 10)
; 1 = right half (X >= 10)
wSSAnneSmokeX:: db

NEXTU
wHoFMonSpecies::
wHoFTeamIndex:: db
wHoFPartyMonIndex:: db
wHoFMonLevel:: db
; 0 = mon, 1 = player
wHoFMonOrPlayer:: db
wHoFTeamIndex2:: db
wHoFTeamNo:: db

NEXTU
wRivalStarterTemp:: db
wRivalStarterBallSpriteIndex:: db

NEXTU
wFlyAnimUsingCoordList:: db
; $ff sentinel values at each end
wFlyLocationsList:: ds NUM_CITY_MAPS + 2

NEXTU
wWhichTownMapLocation:: db
wFlyAnimCounter:: db
wFlyAnimBirdSpriteImageIndex:: db

NEXTU
	ds 1
; difference in X between the next ball and the current one
wHUDPokeballGfxOffsetX:: db
wHUDGraphicsTiles::
wHUDUnusedTopTile:: db
wHUDCornerTile:: db
wHUDTriangleTile:: db
wHUDGraphicsTilesEnd::

NEXTU
; the level of the mon at the time it entered day care
wDayCareStartLevel:: db
wDayCareNumLevelsGrown:: db
wDayCareTotalCost:: dw ; BCD
wDayCarePerLevelCost:: dw ; BCD (always $100)

NEXTU
; which wheel the player is trying to stop
; 0 = none, 1 = wheel 1, 2 = wheel 2, 3 or greater = wheel 3
wStoppingWhichSlotMachineWheel:: db
wSlotMachineWheel1Offset:: db
wSlotMachineWheel2Offset:: db
wSlotMachineWheel3Offset:: db
; the OAM tile number of the upper left corner of the winning symbol minus 2
wSlotMachineWinningSymbol::
wSlotMachineWheel1BottomTile:: db
wSlotMachineWheel1MiddleTile:: db
wSlotMachineWheel1TopTile:: db
wSlotMachineWheel2BottomTile:: db
wSlotMachineWheel2MiddleTile:: db
wSlotMachineWheel2TopTile:: db
wSlotMachineWheel3BottomTile:: db
wSlotMachineWheel3MiddleTile:: db
wSlotMachineWheel3TopTile:: db
wPayoutCoins:: dw
; These flags are set randomly and control when the wheels stop.
; bit 6: allow the player to win in general
; bit 7: allow the player to win with 7 or bar (plus the effect of bit 6)
wSlotMachineFlags:: db
; wheel 1 can "slip" while this is non-zero
wSlotMachineWheel1SlipCounter:: db
; wheel 2 can "slip" while this is non-zero
wSlotMachineWheel2SlipCounter:: db
; The remaining number of times wheel 3 will roll down a symbol until a match is
; found, when winning is enabled. It's initialized to 4 each bet.
wSlotMachineRerollCounter:: db
; how many coins the player bet on the slot machine (1 to 3)
wSlotMachineBet:: db

NEXTU
wCanPlaySlots:: db
	ds 8
; temporary variable used to add payout amount to the player's coins
wTempCoins1:: dw
	ds 2
; temporary variable used to subtract the bet amount from the player's coins
wTempCoins2:: dw

NEXTU
wHiddenEventFunctionArgument:: db
wHiddenEventFunctionRomBank:: db
wHiddenEventIndex:: db
wHiddenEventY:: db
wHiddenItemOrCoinsIndex::
wHiddenEventX:: db

NEXTU
wPlayerSpinInPlaceAnimFrameDelay:: db
wPlayerSpinInPlaceAnimFrameDelayDelta:: db
wPlayerSpinInPlaceAnimFrameDelayEndValue:: db
wPlayerSpinInPlaceAnimSoundID:: db
	ds 6
	db ; temporary space used when wFacingDirectionList is rotated
; used when spinning the player's sprite
wFacingDirectionList:: ds 4
	ds 3
wSavedPlayerScreenY:: db
wSavedPlayerFacingDirection:: db

NEXTU
wPlayerSpinWhileMovingUpOrDownAnimDeltaY:: db
wPlayerSpinWhileMovingUpOrDownAnimMaxY:: db
wPlayerSpinWhileMovingUpOrDownAnimFrameDelay:: db

NEXTU
wTrainerSpriteOffset:: db
wTrainerEngageDistance:: db
wTrainerFacingDirection:: db
wTrainerScreenY:: db
wTrainerScreenX:: db

NEXTU
wTrainerInfoTextBoxWidthPlus1:: db
wTrainerInfoTextBoxWidth:: db
wTrainerInfoTextBoxNextRowOffset:: db

NEXTU
wOptionsTextSpeedCursorX:: db
wOptionsBattleAnimCursorX:: db
wOptionsBattleStyleCursorX:: db
wOptionsCancelCursorX:: db

NEXTU
; tile ID of the badge number being drawn
wBadgeNumberTile:: db
; first tile ID of the name being drawn
wBadgeNameTile:: db
; a list of the first tile IDs of each badge or face (depending on whether the
; badge is owned) to be drawn on the trainer screen
; the byte after the list gets read when shifting back one byte
wBadgeOrFaceTiles:: ds NUM_BADGES + 1
	ds 1
; temporary list created when displaying the badges on the trainer screen
; one byte for each badge; 0 = not obtained, 1 = obtained
wTempObtainedBadgesBooleans:: ds NUM_BADGES

NEXTU
wUnusedCreditsByte:: db
; the number of credits mons that have been displayed so far
wNumCreditsMonsDisplayed:: db

NEXTU
	ds 1
	db ; temporary space used when wJigglypuffFacingDirections is rotated
wJigglypuffFacingDirections:: ds 4

NEXTU
	ds 16
; $3d = tree tile, $52 = grass tile
wCutTile:: db
	ds 2
; 0 = cut animation, 1 = boulder dust animation
wWhichAnimationOffsets:: db

NEXTU
	ds 18
; the index of the sprite the emotion bubble is to be displayed above
wEmotionBubbleSpriteIndex:: db
wWhichEmotionBubble:: db

NEXTU
wChangeBoxSavedMapTextPointer:: dw

NEXTU
wSavedY::
wTempSCX::
; which entry from TradeMons to select
wWhichTrade::
wDexMaxSeenMon::
wPPRestoreItem::
wWereAnyMonsAsleep::
wNumShakes::
wWhichBadge::
wTitleMonSpecies::
wPlayerCharacterOAMTile::
; the number of small stars OAM entries to move down
wMoveDownSmallStarsOAMCount::
wChargeMoveNum::
wCoordIndex::
wSwappedMenuItem::
; 0 = no bite
; 1 = bite
; 2 = no fish on map
wRodResponse::
	db
ENDU

; 0 = neither
; 1 = warp pad
; 2 = hole
wStandingOnWarpPadOrHole::
wOAMBaseTile::
wGymTrashCanIndex:: db

wSymmetricSpriteOAMAttributes:: db

wMonPartySpriteSpecies:: db

; in the trade animation, the mon that leaves the left gameboy
wLeftGBMonSpecies:: db

; in the trade animation, the mon that leaves the right gameboy
wRightGBMonSpecies:: db

wMiscFlags:: db

	ds 9

; This has overlapping related uses.
; When the player tries to use an item or use certain field moves, 0 is stored
; when the attempt fails and 1 is stored when the attempt succeeds.
; In addition, some items store 2 for certain types of failures, but this
; cannot happen in battle.
; In battle, a non-zero value indicates the player has taken their turn using
; something other than a move (e.g. using an item or switching pokemon).
; So, when an item is successfully used in battle, this value becomes non-zero
; and the player is not allowed to make a move and the two uses are compatible.
wActionResultOrTookBattleTurn:: db

; Set buttons are ignored.
wJoyIgnore:: db

; size of downscaled mon pic used in pokeball entering/exiting animation
; $00 = 5×5
; $01 = 3×3
wDownscaledMonSize::
; FormatMovesString stores the number of moves minus one here
wNumMovesMinusOne:: db

; This union spans 20 bytes.
UNION
; storage buffer for various name strings
wNameBuffer:: ds NAME_BUFFER_LENGTH

NEXTU
; data copied from Moves for one move
wMoveData:: ds MOVE_LENGTH
wPPUpCountAndMaxPP:: db

NEXTU
; amount of money made from one use of Pay Day
wPayDayMoney:: ds 3

NEXTU
; evolution data for one mon
wEvoDataBuffer:: ds NUM_EVOS_IN_BUFFER * 4 + 1 ; enough for Eevee's three 4-byte evolutions and 0 terminator
wEvoDataBufferEnd::

NEXTU
wBattleMenuCurrentPP:: db
	ds 3
wStatusScreenCurrentPP:: db
	ds 6
; list of normal max PP (without PP up) values
wNormalMaxPPList:: ds NUM_MOVES
ENDU

; This union spans 360 bytes.
UNION
; second buffer for temporarily saving and restoring current screen's tiles (e.g. if menus are drawn on top)
wTileMapBackup2:: ds SCREEN_AREA
NEXTU
; buffer for transferring the random number list generated by the other gameboy
wSerialOtherGameboyRandomNumberListBlock:: ds $11
ENDU

; This union spans 30 bytes.
UNION
; Temporary storage area
wBuffer:: ds 30

NEXTU
wEvoOldSpecies:: db
wEvoNewSpecies:: db
wEvoMonTileOffset:: db
wEvoCancelled:: db

NEXTU
wNamingScreenNameLength:: db
; non-zero when the player has chosen to submit the name
wNamingScreenSubmitName:: db
; 0 = upper case
; 1 = lower case
wAlphabetCase:: db
	ds 1
wNamingScreenLetter:: db

NEXTU
wChangeMonPicEnemyTurnSpecies:: db
wChangeMonPicPlayerTurnSpecies:: db

NEXTU
wHPBarMaxHP:: dw
wHPBarOldHP:: dw
wHPBarNewHP:: dw
wHPBarDelta:: db
wHPBarTempHP:: dw
	ds 11
wHPBarHPDifference:: dw

NEXTU
; lower nybble is x, upper nybble is y
wTownMapCoords::
; whether WriteMonMoves is being used to make a mon learn moves from day care
; non-zero if so
wLearningMovesFromDayCare::
	db

	ds 27

; the item that the AI used
wAIItem:: db
wUsedItemOnWhichPokemon:: db
ENDU

; sound ID during battle animations
wAnimSoundID:: db

; used as a storage value for the bank to return to after a BankswitchHome (bankswitch in homebank)
wBankswitchHomeSavedROMBank:: db

; used as a temp storage value for the bank to switch to
wBankswitchHomeTemp:: db

; 0 = nothing bought or sold in pokemart
; 1 = bought or sold something in pokemart
; this value is not used for anything
wBoughtOrSoldItemInMart:: db

; $00 - win
; $01 - lose
; $02 - draw
wBattleResult:: db

; bit 0: if set, prevents DisplayTextID from automatically drawing a text box
wAutoTextBoxDrawingControl:: db

; used in some overworld scripts to vary scripted movement
wSavedCoordIndex::
wOakWalkedToPlayer::
wNextSafariZoneGateScript:: db

; used in CheckForTilePairCollisions2 to store the tile the player is on
wTilePlayerStandingOn:: db

wNPCNumScriptedSteps:: db

; which script function within the pointer table indicated by
; wNPCMovementScriptPointerTableNum
wNPCMovementScriptFunctionNum:: db

; bit 0: set when printing a text predef so that DisplayTextID doesn't switch
;        to the current map's bank
wTextPredefFlag:: db

wPredefParentBank:: db

wSpriteIndex:: db

; movement byte 2 of current sprite
wCurSpriteMovement2:: db

	ds 2

; sprite offset of sprite being controlled by NPC movement script
wNPCMovementScriptSpriteOffset:: db

wScriptedNPCWalkCounter:: db

	ds 1

; always 0 since full CGB support was not implemented
wOnCGB:: db

; if running on SGB, it's 1, else it's 0
wOnSGB:: db

wDefaultPaletteCommand:: db

UNION
wPlayerHPBarColor:: db
NEXTU
; species of the mon whose palette is used for the whole screen
wWholeScreenPaletteMonSpecies:: db
ENDU

wEnemyHPBarColor:: db

; 0: green
; 1: yellow
; 2: red
wPartyMenuHPBarColors:: ds PARTY_LENGTH

wStatusScreenHPBarColor:: db

	ds 7

wCopyingSGBTileData::
wWhichPartyMenuHPBar::
wPalPacket::
	db

; This union spans 49 bytes.
UNION
wPartyMenuBlkPacket:: ds $30

NEXTU
	ds 29
; storage buffer for various strings
wStringBuffer:: ds NAME_BUFFER_LENGTH

NEXTU
	ds 29
; the total amount of exp a mon gained
wExpAmountGained:: dw
wGainBoostedExp:: db
ENDU

wGymCityName:: ds GYM_CITY_LENGTH

wGymLeaderName:: ds NAME_LENGTH

wItemList:: ds 16

wListPointer:: dw

; used to store pointers, but never read
wUnusedNamePointer:: dw

wItemPrices:: dw

wCurPartySpecies::
wCurItem::
wCurListMenuItem::
	db

; which pokemon you selected
wWhichPokemon:: db

; if non-zero, then print item prices when displaying lists
wPrintItemPrices:: db

; type of HP bar
; $00 = enemy HUD in battle
; $01 = player HUD in battle / status screen
; $02 = party menu
wHPBarType::
; ID used by DisplayListMenuID
wListMenuID:: db

; if non-zero, RemovePokemon will remove the mon from the current box,
; else it will remove the mon from the party
wRemoveMonFromBox::
; 0 = move from box to party
; 1 = move from party to box
; 2 = move from daycare to party
; 3 = move from party to daycare
wMoveMonType:: db

wItemQuantity:: db

wMaxItemQuantity:: db

; LoadMonData copies mon data here
wLoadedMon::
wLoadedMonSpecies::
	db
wLoadedMonHP::
	dw
wLoadedMonBoxLevel::
	db
wLoadedMonStatus::
	db
wLoadedMonType::
wLoadedMonType1::
	db
wLoadedMonType2::
	db
wLoadedMonCatchRate::
	db
wLoadedMonMoves::
	ds NUM_MOVES
wLoadedMonOTID::
	dw
wLoadedMonExp::
	ds 3
wLoadedMonHPExp::
	dw
wLoadedMonAttackExp::
	dw
wLoadedMonDefenseExp::
	dw
wLoadedMonSpeedExp::
	dw
wLoadedMonSpecialExp::
	dw
wLoadedMonDVs::
	dw
wLoadedMonPP::
	ds NUM_MOVES
wLoadedMonLevel::
	db
wLoadedMonStats::
wLoadedMonMaxHP::
	dw
wLoadedMonAttack::
	dw
wLoadedMonDefense::
	dw
wLoadedMonSpeed::
	dw
wLoadedMonSpecial::
	dw

; bit 0: The space in VRAM that is used to store walk animation tile patterns
;        for the player and NPCs is in use for font tile patterns.
;        This means that NPC movement must be disabled.
; The other bits are unused.
wFontLoaded:: db

; walk animation counter
wWalkCounter:: db

; background tile number in front of the player (either 1 or 2 steps ahead)
wTileInFrontOfPlayer:: db

; The desired fade counter reload value is stored here prior to calling
; PlaySound in order to cause the current music to fade out before the new
; music begins playing. Storing 0 causes no fade out to occur and the new music
; to begin immediately.
; This variable has another use related to fade-out, as well. PlaySound stores
; the sound ID of the music that should be played after the fade-out is finished
; in this variable. FadeOutAudio checks if it's non-zero every V-Blank and
; fades out the current audio if it is. Once it has finished fading out the
; audio, it zeroes this variable and starts playing the sound ID stored in it.
wAudioFadeOutControl:: db

wAudioFadeOutCounterReloadValue:: db

wAudioFadeOutCounter:: db

; This is used to determine whether the default music is already playing when
; attempting to play the default music (in order to avoid restarting the same
; music) and whether the music has already been stopped when attempting to
; fade out the current music (so that the new music can be begin immediately
; instead of waiting).
; It sometimes contains the sound ID of the last music played, but it may also
; contain $ff (if the music has been stopped) or 0 (because some routines zero
; it in order to prevent assumptions from being made about the current state of
; the music).
wLastMusicSoundID:: db

; $00 = causes sprites to be hidden and the value to change to $ff
; $01 = enabled
; $ff = disabled
; other values aren't used
wUpdateSpritesEnabled:: db

wEnemyMoveNum:: db
wEnemyMoveEffect:: db
wEnemyMovePower:: db
wEnemyMoveType:: db
wEnemyMoveAccuracy:: db
wEnemyMoveMaxPP:: db
wPlayerMoveNum:: db
wPlayerMoveEffect:: db
wPlayerMovePower:: db
wPlayerMoveType:: db
wPlayerMoveAccuracy:: db
wPlayerMoveMaxPP:: db

wEnemyMonSpecies2:: db
wBattleMonSpecies2:: db

wEnemyMonNick:: ds NAME_LENGTH

wEnemyMon::
wEnemyMonSpecies::
	db
wEnemyMonHP::
	dw
wEnemyMonPartyPos::
wEnemyMonBoxLevel::
	db
wEnemyMonStatus::
	db
wEnemyMonType::
wEnemyMonType1::
	db
wEnemyMonType2::
	db
wEnemyMonCatchRate::
	db
wEnemyMonMoves::
	ds NUM_MOVES
wEnemyMonDVs::
	dw
wEnemyMonLevel::
	db
wEnemyMonStats::
wEnemyMonMaxHP::
	dw
wEnemyMonAttack::
	dw
wEnemyMonDefense::
	dw
wEnemyMonSpeed::
	dw
wEnemyMonSpecial::
	dw
wEnemyMonPP::
	ds NUM_MOVES

wEnemyMonBaseStats:: ds NUM_STATS
wEnemyMonActualCatchRate:: db
wEnemyMonBaseExp:: db

wBattleMonNick:: ds NAME_LENGTH
wBattleMon::
wBattleMonSpecies::
	db
wBattleMonHP::
	dw
wBattleMonPartyPos::
wBattleMonBoxLevel::
	db
wBattleMonStatus::
	db
wBattleMonType::
wBattleMonType1::
	db
wBattleMonType2::
	db
wBattleMonCatchRate::
	db
wBattleMonMoves::
	ds NUM_MOVES
wBattleMonDVs::
	dw
wBattleMonLevel::
	db
wBattleMonStats::
wBattleMonMaxHP::
	dw
wBattleMonAttack::
	dw
wBattleMonDefense::
	dw
wBattleMonSpeed::
	dw
wBattleMonSpecial::
	dw
wBattleMonPP::
	ds NUM_MOVES

wTrainerClass:: db

	ds 1

wTrainerPicPointer:: dw

	ds 1

UNION
wTempMoveNameBuffer:: ds MOVE_NAME_LENGTH
NEXTU
; The name of the mon that is learning a move.
wLearnMoveMonName:: ds NAME_LENGTH
ENDU

	ds 2

; money received after battle = base money × level of last enemy mon
wTrainerBaseMoney:: dw ; BCD

wToggleableObjectCounter:: db

	ds 1

; 13 bytes for the letters of the opposing trainer
; the name is terminated with $50 with possible
; unused trailing letters
wTrainerName:: ds 13

; lost battle, this is -1
; no battle, this is 0
; wild battle, this is 1
; trainer battle, this is 2
wIsInBattle:: db

; flags that indicate which party members should be be given exp when GainExperience is called
wPartyGainExpFlags::
	ds ((PARTY_LENGTH) + 7) / 8

; in a wild battle, this is the species of pokemon
; in a trainer battle, this is the trainer class + OPP_ID_OFFSET
wCurOpponent:: db

; in normal battle, this is 0
; in old man battle, this is 1
; in safari battle, this is 2
wBattleType:: db

; bits 0-6: Effectiveness
   ;  $0 = immune
   ;  $5 = not very effective
   ;  $a = neutral
   ; $14 = super-effective
; bit 7: STAB
wDamageMultipliers:: db

; which entry in LoneAttacks to use
; it's actually the same thing as ^
wLoneAttackNo::
wGymLeaderNo:: db
; which instance of [youngster, lass, etc] is this?
wTrainerNo:: db

; $00 = normal attack
; $01 = critical hit
; $02 = successful OHKO
; $ff = failed OHKO
wCriticalHitOrOHKO:: db

wMoveMissed:: db

wBattleStatusData::
; always 0
wPlayerStatsToDouble:: db
; always 0
wPlayerStatsToHalve:: db

wPlayerBattleStatus1:: db
wPlayerBattleStatus2:: db
wPlayerBattleStatus3:: db

; always 0
wEnemyStatsToDouble:: db
; always 0
wEnemyStatsToHalve:: db

wEnemyBattleStatus1:: db
wEnemyBattleStatus2:: db
wEnemyBattleStatus3:: db

; when the player is attacking multiple times, the number of attacks left
wPlayerNumAttacksLeft:: db

wPlayerConfusedCounter:: db

wPlayerToxicCounter:: db

; high nibble: which move is disabled (1-4)
; low nibble: disable turns left
wPlayerDisabledMove:: db

	ds 1

; when the enemy is attacking multiple times, the number of attacks left
wEnemyNumAttacksLeft:: db

wEnemyConfusedCounter:: db

wEnemyToxicCounter:: db

; high nibble: which move is disabled (1-4)
; low nibble: disable turns left
wEnemyDisabledMove:: db

	ds 1

UNION
; the amount of damage accumulated by the player while biding
wPlayerBideAccumulatedDamage:: dw
NEXTU
; number of hits by player in attacks like Double Slap, etc.
wPlayerNumHits:: db
NEXTU
wUnknownSerialCounter2:: dw
ENDU

	ds 2
wBattleStatusDataEnd::

; non-zero when an item or move that allows escape from battle was used
wEscapedFromBattle:: db

UNION
wAmountMoneyWon:: ds 3 ; BCD
NEXTU
wObjectToHide:: db
wObjectToShow:: db
ENDU

; the map you will start at when the debug bit is set
wDefaultMap::
wMenuItemOffset::
; ID number of the current battle animation
wAnimationID:: db

wNamingScreenType::
wPartyMenuTypeOrMessageID::
; temporary storage for the number of tiles in a tileset
wTempTilesetNumTiles:: db

; used by the pokemart code to save the existing value of wListScrollOffset
; so that it can be restored when the player is done with the pokemart NPC
wSavedListScrollOffset:: db

	ds 2

; base coordinates of frame block
wBaseCoordX:: db
wBaseCoordY:: db

; low health alarm counter/enable
; high bit = enable, others = timer to cycle frequencies
wLowHealthAlarm:: db

; counts how many tiles of the current frame block have been drawn
wFBTileCounter:: db

wMovingBGTilesCounter2:: db

; duration of each frame of the current subanimation in terms of screen refreshes
wSubAnimFrameDelay:: db
; counts the number of subentries left in the current subanimation
wSubAnimCounter:: db

; 1 = no save file or save file is corrupted
; 2 = save file exists and no corruption has been detected
wSaveFileStatus:: db

; number of tiles in current battle animation frame block
wNumFBTiles:: db

; This union spans 2 bytes.
UNION
wSpiralBallsBaseY:: db
wSpiralBallsBaseX:: db

NEXTU
; bits 0-6: index into FallingObjects_DeltaXs array (0 - 8)
; bit 7: direction; 0 = right, 1 = left
wFallingObjectMovementByte:: db
wNumFallingObjects:: db

NEXTU
wFlashScreenLongCounter::
wNumShootingBalls::
; $01 if mon is moving from left gameboy to right gameboy; $00 if vice versa
wTradedMonMovingRight::
wOptionsInitialized::
wNewSlotMachineBallTile::
; how much to add to the X/Y coord
wCoordAdjustmentAmount::
wUnusedWaterDropletsByte::
	db

wSlideMonDelay::
; generic counter variable for various animations
wAnimCounter::
; controls what transformations are applied to the subanimation
; 01: flip horizontally and vertically
; 02: flip horizontally and translate downwards 40 pixels
; 03: translate base coordinates of frame blocks, but don't change their internal coordinates or flip their tiles
; 04: reverse the subanimation
wSubAnimTransform::
	db
ENDU

wEndBattleWinTextPointer:: dw
wEndBattleLoseTextPointer:: dw
	ds 2
wEndBattleTextRomBank:: db

	ds 1

; the address _of the address_ of the current subanimation entry
wSubAnimAddrPtr:: dw

UNION
; the address of the current subentry of the current subanimation
wSubAnimSubEntryAddr:: dw
NEXTU
; If non-zero, the allow matches flag is always set.
; There is a 1/256 (~0.4%) chance that this value will be set to 60, which is
; the only way it can increase. Winning certain payout amounts will decrement it
; or zero it.
wSlotMachineAllowMatchesCounter:: db
ENDU

	ds 2

wOutwardSpiralTileMapPointer:: db

wPartyMenuAnimMonEnabled::
; non-zero when enabled. causes nest locations to blink on and off.
; the town selection cursor will blink regardless of what this value is
wTownMapSpriteBlinkingEnabled::
wUnusedMoveAnimByte:: db

; current destination address in OAM for frame blocks (big endian)
wFBDestAddr:: dw

; controls how the frame blocks are put together to form frames
; specifically, after finishing drawing the frame block, the frame block's mode determines what happens
; 00: clean OAM buffer and delay
; 02: move onto the next frame block with no delay and no cleaning OAM buffer
; 03: delay, but don't clean OAM buffer
; 04: delay, without cleaning OAM buffer, and do not advance [wFBDestAddr], so that the next frame block will overwrite this one
wFBMode:: db

; 0 = small
; 1 = big
wLinkCableAnimBulgeToggle::
wIntroNidorinoBaseTile::
wOutwardSpiralCurrentDirection::
wDropletTile::
wNewTileBlockID::
wWhichBattleAnimTileset::
; 0 = left
; 1 = right
wSquishMonCurrentDirection::
; the tile ID of the leftmost tile in the bottom row in AnimationSlideMonUp_
wSlideMonUpBottomRowLeftTile::
	db

wDisableVBlankWYUpdate:: db ; if non-zero, don't update WY during V-blank

wSpriteCurPosX:: db
wSpriteCurPosY:: db
wSpriteWidth:: db
wSpriteHeight:: db
; current input byte
wSpriteInputCurByte:: db
; bit offset of last read input bit
wSpriteInputBitCounter:: db

; determines where in the output byte the two bits are placed. Each byte contains four columns (2bpp data)
; 3 -> XX000000   1st column
; 2 -> 00XX0000   2nd column
; 1 -> 0000XX00   3rd column
; 0 -> 000000XX   4th column
wSpriteOutputBitOffset:: db

; bit 0 determines used buffer (0 -> sSpriteBuffer1, 1 -> sSpriteBuffer2)
; bit 1 loading last sprite chunk? (there are at most 2 chunks per load operation)
wSpriteLoadFlags:: db
wSpriteUnpackMode:: db
wSpriteFlipped:: db

; pointer to next input byte
wSpriteInputPtr:: dw
; pointer to current output byte
wSpriteOutputPtr:: dw
; used to revert pointer for different bit offsets
wSpriteOutputPtrCached:: dw
; pointer to differential decoding table (assuming initial value 0)
wSpriteDecodeTable0Ptr:: dw
; pointer to differential decoding table (assuming initial value 1)
wSpriteDecodeTable1Ptr:: dw

; input for GetMonHeader
wCurSpecies::
; input for GetName
wNameListIndex:: db
wNameListType:: db

wPredefBank:: db

wMonHeader::
; In the ROM base stats data structure, this is the dex number, but it is
; overwritten with the internal index number after the header is copied to WRAM.
wMonHIndex:: db
wMonHBaseStats::
wMonHBaseHP:: db
wMonHBaseAttack:: db
wMonHBaseDefense:: db
wMonHBaseSpeed:: db
wMonHBaseSpecial:: db
wMonHTypes::
wMonHType1:: db
wMonHType2:: db
wMonHCatchRate:: db
wMonHBaseEXP:: db
wMonHSpriteDim:: db
wMonHFrontSprite:: dw
wMonHBackSprite:: dw
wMonHMoves:: ds NUM_MOVES
wMonHGrowthRate:: db
wMonHLearnset::
	ds ((NUM_TMS + NUM_HMS) + 7) / 8
	ds 1
wMonHeaderEnd::

; saved at the start of a battle and then written back at the end of the battle
wSavedTileAnimations:: db

	ds 2

wDamage:: dw

	ds 2

wRepelRemainingSteps:: db

; list of moves for FormatMovesString
wMoves:: ds NUM_MOVES

wMoveNum:: db

; concatenated move name list where intermediate '@' are replaced with '<NEXT>'
wMovesString:: ds NUM_MOVES * MOVE_NAME_LENGTH

wUnusedCurMapTilesetCopy:: db

; wWalkBikeSurfState is sometimes copied here, but it doesn't seem to be used for anything
wWalkBikeSurfStateCopy:: db

; the type of list for InitList to init
wInitListType:: db

; 0 if no mon was captured
wCapturedMonSpecies:: db

; Non-zero when the first player mon and enemy mon haven't been sent out yet.
; It prevents the game from asking if the player wants to choose another mon
; when the enemy sends out their first mon and suppresses the "no will to fight"
; message when the game searches for the first non-fainted mon in the party,
; which will be the first mon sent out.
wFirstMonsNotOutYet:: db

wNamedObjectIndex::
wTempByteValue::
wNumSetBits::
wTypeEffectiveness::
wMoveType::
wPokedexNum::
wTempTMHM::
wUsingPPUp::
wMaxPP::
wMoveGrammar::
; 0 for player, non-zero for enemy
wCalculateWhoseStats::
wPokeBallCaptureCalcTemp::
; lower nybble: number of shakes
; upper nybble: number of animations to play
wPokeBallAnimData::
	db

; When this value is non-zero, the player isn't allowed to exit the party menu
; by pressing B and not choosing a mon.
wForcePlayerToChooseMon:: db

; number of times the player has tried to run from battle
wNumRunAttempts:: db

wEvolutionOccurred:: db

wVBlankSavedROMBank:: db

	ds 1

wIsKeyItem:: db

wTextBoxID:: db

; bit 5: set when maps first load; can be reset to re-run a script
; bit 6: set when maps first load; can be reset to re-run a script (used less often than bit 5)
; bit 7: set when using an elevator map's menu; triggers the shaking animation
wCurrentMapScriptFlags:: db

wCurEnemyLevel:: db

; pointer to list of items terminated by $FF
wItemListPointer:: dw

; number of entries in a list
wListCount:: db

wLinkState:: db

wTwoOptionMenuID:: db

; the id of the menu item the player ultimately chose
wChosenMenuItem::
; non-zero when the whole party has fainted due to out-of-battle poison damage
wOutOfBattleBlackout:: db

; the way the user exited a menu
; for list menus and the buy/sell/quit menu:
; $01 = the user pressed A to choose a menu item
; $02 = the user pressed B to cancel
; for two-option menus:
; $01 = the user pressed A with the first menu item selected
; $02 = the user pressed B or pressed A with the second menu item selected
wMenuExitMethod:: db

; the size is always 6, so they didn't need a variable in RAM for this
wDungeonWarpDataEntrySize::
; 0 = museum guy
; 1 = gym guy
wWhichPewterGuy::
; there are 3 windows, from 0 to 2
wWhichPrizeWindow::
; a horizontal or vertical gate block
wGymGateTileBlock:: db

wSavedSpriteScreenY:: db
wSavedSpriteScreenX:: db
wSavedSpriteMapY:: db
wSavedSpriteMapX:: db

	ds 5

wWhichPrize:: db

; counts downward each frame
; when it hits 0, BIT_DISABLE_JOYPAD of wStatusFlags5 is reset
wIgnoreInputCounter:: db

; counts down once every step
wStepCounter:: db

; after a battle, you have at least 3 steps before a random battle can occur
wNumberOfNoRandomBattleStepsLeft:: db

wPrize1:: db
wPrize2:: db
wPrize3:: db

	ds 1

; This union spans 17 bytes.
UNION
wSerialRandomNumberListBlock:: ds $11

NEXTU
wPrize1Price:: dw
wPrize2Price:: dw
wPrize3Price:: dw

	ds 1

; shared list of 9 random numbers, indexed by wLinkBattleRandomNumberListIndex
wLinkBattleRandomNumberList:: ds 10
ENDU

wSerialPlayerDataBlock:: ; ds $1a8

; When a real item is being used, this is 0.
; When a move is acting as an item, this is the ID of the item it's acting as.
; For example, out-of-battle Dig is executed using a fake Escape Rope item. In
; that case, this would be ESCAPE_ROPE.
wPseudoItemID:: db

wUnusedAlreadyOwnedFlag:: db

	ds 2

wEvoStoneItemID:: db

wSavedNPCMovementDirections2Index:: db

wPlayerName:: ds NAME_LENGTH


SECTION "Party Data", WRAM0

wPartyDataStart::

wPartyCount:: db
wPartySpecies:: ds PARTY_LENGTH + 1

wPartyMons::
; wPartyMon1 - wPartyMon6
wPartyMon1::
wPartyMon1Species::
	db
wPartyMon1HP::
	dw
wPartyMon1BoxLevel::
	db
wPartyMon1Status::
	db
wPartyMon1Type::
wPartyMon1Type1::
	db
wPartyMon1Type2::
	db
wPartyMon1CatchRate::
	db
wPartyMon1Moves::
	ds NUM_MOVES
wPartyMon1OTID::
	dw
wPartyMon1Exp::
	ds 3
wPartyMon1HPExp::
	dw
wPartyMon1AttackExp::
	dw
wPartyMon1DefenseExp::
	dw
wPartyMon1SpeedExp::
	dw
wPartyMon1SpecialExp::
	dw
wPartyMon1DVs::
	dw
wPartyMon1PP::
	ds NUM_MOVES
wPartyMon1Level::
	db
wPartyMon1Stats::
wPartyMon1MaxHP::
	dw
wPartyMon1Attack::
	dw
wPartyMon1Defense::
	dw
wPartyMon1Speed::
	dw
wPartyMon1Special::
	dw
wPartyMon2::
wPartyMon2Species::
	db
wPartyMon2HP::
	dw
wPartyMon2BoxLevel::
	db
wPartyMon2Status::
	db
wPartyMon2Type::
wPartyMon2Type1::
	db
wPartyMon2Type2::
	db
wPartyMon2CatchRate::
	db
wPartyMon2Moves::
	ds NUM_MOVES
wPartyMon2OTID::
	dw
wPartyMon2Exp::
	ds 3
wPartyMon2HPExp::
	dw
wPartyMon2AttackExp::
	dw
wPartyMon2DefenseExp::
	dw
wPartyMon2SpeedExp::
	dw
wPartyMon2SpecialExp::
	dw
wPartyMon2DVs::
	dw
wPartyMon2PP::
	ds NUM_MOVES
wPartyMon2Level::
	db
wPartyMon2Stats::
wPartyMon2MaxHP::
	dw
wPartyMon2Attack::
	dw
wPartyMon2Defense::
	dw
wPartyMon2Speed::
	dw
wPartyMon2Special::
	dw
wPartyMon3::
wPartyMon3Species::
	db
wPartyMon3HP::
	dw
wPartyMon3BoxLevel::
	db
wPartyMon3Status::
	db
wPartyMon3Type::
wPartyMon3Type1::
	db
wPartyMon3Type2::
	db
wPartyMon3CatchRate::
	db
wPartyMon3Moves::
	ds NUM_MOVES
wPartyMon3OTID::
	dw
wPartyMon3Exp::
	ds 3
wPartyMon3HPExp::
	dw
wPartyMon3AttackExp::
	dw
wPartyMon3DefenseExp::
	dw
wPartyMon3SpeedExp::
	dw
wPartyMon3SpecialExp::
	dw
wPartyMon3DVs::
	dw
wPartyMon3PP::
	ds NUM_MOVES
wPartyMon3Level::
	db
wPartyMon3Stats::
wPartyMon3MaxHP::
	dw
wPartyMon3Attack::
	dw
wPartyMon3Defense::
	dw
wPartyMon3Speed::
	dw
wPartyMon3Special::
	dw
wPartyMon4::
wPartyMon4Species::
	db
wPartyMon4HP::
	dw
wPartyMon4BoxLevel::
	db
wPartyMon4Status::
	db
wPartyMon4Type::
wPartyMon4Type1::
	db
wPartyMon4Type2::
	db
wPartyMon4CatchRate::
	db
wPartyMon4Moves::
	ds NUM_MOVES
wPartyMon4OTID::
	dw
wPartyMon4Exp::
	ds 3
wPartyMon4HPExp::
	dw
wPartyMon4AttackExp::
	dw
wPartyMon4DefenseExp::
	dw
wPartyMon4SpeedExp::
	dw
wPartyMon4SpecialExp::
	dw
wPartyMon4DVs::
	dw
wPartyMon4PP::
	ds NUM_MOVES
wPartyMon4Level::
	db
wPartyMon4Stats::
wPartyMon4MaxHP::
	dw
wPartyMon4Attack::
	dw
wPartyMon4Defense::
	dw
wPartyMon4Speed::
	dw
wPartyMon4Special::
	dw
wPartyMon5::
wPartyMon5Species::
	db
wPartyMon5HP::
	dw
wPartyMon5BoxLevel::
	db
wPartyMon5Status::
	db
wPartyMon5Type::
wPartyMon5Type1::
	db
wPartyMon5Type2::
	db
wPartyMon5CatchRate::
	db
wPartyMon5Moves::
	ds NUM_MOVES
wPartyMon5OTID::
	dw
wPartyMon5Exp::
	ds 3
wPartyMon5HPExp::
	dw
wPartyMon5AttackExp::
	dw
wPartyMon5DefenseExp::
	dw
wPartyMon5SpeedExp::
	dw
wPartyMon5SpecialExp::
	dw
wPartyMon5DVs::
	dw
wPartyMon5PP::
	ds NUM_MOVES
wPartyMon5Level::
	db
wPartyMon5Stats::
wPartyMon5MaxHP::
	dw
wPartyMon5Attack::
	dw
wPartyMon5Defense::
	dw
wPartyMon5Speed::
	dw
wPartyMon5Special::
	dw
wPartyMon6::
wPartyMon6Species::
	db
wPartyMon6HP::
	dw
wPartyMon6BoxLevel::
	db
wPartyMon6Status::
	db
wPartyMon6Type::
wPartyMon6Type1::
	db
wPartyMon6Type2::
	db
wPartyMon6CatchRate::
	db
wPartyMon6Moves::
	ds NUM_MOVES
wPartyMon6OTID::
	dw
wPartyMon6Exp::
	ds 3
wPartyMon6HPExp::
	dw
wPartyMon6AttackExp::
	dw
wPartyMon6DefenseExp::
	dw
wPartyMon6SpeedExp::
	dw
wPartyMon6SpecialExp::
	dw
wPartyMon6DVs::
	dw
wPartyMon6PP::
	ds NUM_MOVES
wPartyMon6Level::
	db
wPartyMon6Stats::
wPartyMon6MaxHP::
	dw
wPartyMon6Attack::
	dw
wPartyMon6Defense::
	dw
wPartyMon6Speed::
	dw
wPartyMon6Special::
	dw

wPartyMonOT::
; wPartyMon1OT - wPartyMon6OT
wPartyMon1OT::
	ds NAME_LENGTH
wPartyMon2OT::
	ds NAME_LENGTH
wPartyMon3OT::
	ds NAME_LENGTH
wPartyMon4OT::
	ds NAME_LENGTH
wPartyMon5OT::
	ds NAME_LENGTH
wPartyMon6OT::
	ds NAME_LENGTH

wPartyMonNicks::
; wPartyMon1Nick - wPartyMon6Nick
wPartyMon1Nick::
	ds NAME_LENGTH
wPartyMon2Nick::
	ds NAME_LENGTH
wPartyMon3Nick::
	ds NAME_LENGTH
wPartyMon4Nick::
	ds NAME_LENGTH
wPartyMon5Nick::
	ds NAME_LENGTH
wPartyMon6Nick::
	ds NAME_LENGTH
wPartyMonNicksEnd::

wPartyDataEnd::


SECTION "Main Data", WRAM0

wMainDataStart::

wPokedexOwned::
	ds ((NUM_POKEMON) + 7) / 8
wPokedexOwnedEnd::

wPokedexSeen::
	ds ((NUM_POKEMON) + 7) / 8
wPokedexSeenEnd::

wNumBagItems:: db
; item, quantity
wBagItems:: ds BAG_ITEM_CAPACITY * 2 + 1

wPlayerMoney:: ds 3 ; BCD

wRivalName:: ds NAME_LENGTH

wOptions:: db

wObtainedBadges::
	ds ((NUM_BADGES) + 7) / 8

wUnusedObtainedBadges:: db

wLetterPrintingDelayFlags:: db

wPlayerID:: dw

wMapMusicSoundID:: db
wMapMusicROMBank:: db

; offset subtracted from FadePal4 to get the background and object palettes for the current map
; normally, it is 0. it is 6 when Flash is needed, causing FadePal2 to be used instead of FadePal4
wMapPalOffset:: db

wCurMap:: db

; pointer to the upper left corner of the current view in the tile block map
wCurrentTileBlockMapViewPointer:: dw

; player's position on the current map
wYCoord:: db
wXCoord:: db

; player's position (by block)
wYBlockCoord:: db
wXBlockCoord:: db

wLastMap:: db
wUnusedLastMapWidth:: db

wCurMapHeader::
wCurMapTileset:: db
wCurMapHeight:: db
wCurMapWidth:: db
wCurMapDataPtr:: dw
wCurMapTextPtr:: dw
wCurMapScriptPtr:: dw
wCurMapConnections:: db
wCurMapHeaderEnd::

wNorthConnectionHeader::
wNorthConnectedMap::
	db
wNorthConnectionStripSrc::
	dw
wNorthConnectionStripDest::
	dw
wNorthConnectionStripLength::
	db
wNorthConnectedMapWidth::
	db
wNorthConnectedMapYAlignment::
	db
wNorthConnectedMapXAlignment::
	db
wNorthConnectedMapViewPointer::
	dw
wNorthConnectionHeaderEnd::
wSouthConnectionHeader::
wSouthConnectedMap::
	db
wSouthConnectionStripSrc::
	dw
wSouthConnectionStripDest::
	dw
wSouthConnectionStripLength::
	db
wSouthConnectedMapWidth::
	db
wSouthConnectedMapYAlignment::
	db
wSouthConnectedMapXAlignment::
	db
wSouthConnectedMapViewPointer::
	dw
wSouthConnectionHeaderEnd::
wWestConnectionHeader::
wWestConnectedMap::
	db
wWestConnectionStripSrc::
	dw
wWestConnectionStripDest::
	dw
wWestConnectionStripLength::
	db
wWestConnectedMapWidth::
	db
wWestConnectedMapYAlignment::
	db
wWestConnectedMapXAlignment::
	db
wWestConnectedMapViewPointer::
	dw
wWestConnectionHeaderEnd::
wEastConnectionHeader::
wEastConnectedMap::
	db
wEastConnectionStripSrc::
	dw
wEastConnectionStripDest::
	dw
wEastConnectionStripLength::
	db
wEastConnectedMapWidth::
	db
wEastConnectedMapYAlignment::
	db
wEastConnectedMapXAlignment::
	db
wEastConnectedMapViewPointer::
	dw

; sprite set for the current map (11 sprite picture ID's)
wEastConnectionHeaderEnd::
wSpriteSet:: ds SPRITE_SET_LENGTH
; sprite set ID for the current map
wSpriteSetID:: db

wObjectDataPointerTemp:: dw

	ds 2

; the tile shown outside the boundaries of the map
wMapBackgroundTile:: db

; number of warps in current map (up to MAX_WARP_EVENTS)
wNumberOfWarps:: db

; current map warp entries
wWarpEntries:: ds MAX_WARP_EVENTS * 4 ; Y, X, warp ID, map ID

; if $ff, the player's coordinates are not updated when entering the map
wDestinationWarpID:: db

	ds 128

; number of signs in the current map (up to MAX_BG_EVENTS)
wNumSigns:: db

wSignCoords:: ds MAX_BG_EVENTS * 2 ; Y, X
wSignTextIDs:: ds MAX_BG_EVENTS

; number of sprites on the current map (up to MAX_OBJECT_EVENTS)
wNumSprites:: db

; these two variables track the X and Y offset in blocks from the last special warp used
; they don't seem to be used for anything
wYOffsetSinceLastSpecialWarp:: db
wXOffsetSinceLastSpecialWarp:: db

wMapSpriteData:: ds MAX_OBJECT_EVENTS * 2 ; movement byte 2, text ID
wMapSpriteExtraData:: ds MAX_OBJECT_EVENTS * 2 ; trainer class/item ID, trainer set ID

; map height in 2x2 meta-tiles
wCurrentMapHeight2:: db

; map width in 2x2 meta-tiles
wCurrentMapWidth2:: db

; the address of the upper left corner of the visible portion of the BG tile map in VRAM
wMapViewVRAMPointer:: dw

; In the comments for the player direction variables below, "moving" refers to
; both walking and changing facing direction without taking a step.

; if the player is moving, the current direction
; if the player is not moving, zero
; map scripts write to this in order to change the player's facing direction
wPlayerMovingDirection:: db

; the direction in which the player was moving before the player last stopped
wPlayerLastStopDirection:: db

; if the player is moving, the current direction
; if the player is not moving, the last the direction in which the player moved
wPlayerDirection:: db

wTilesetBank:: db

; maps blocks (4x4 tiles) to tiles
wTilesetBlocksPtr:: dw

wTilesetGfxPtr:: dw

; list of all walkable tiles
wTilesetCollisionPtr:: dw

wTilesetTalkingOverTiles:: ds 3

wGrassTile:: db

	ds 4

wNumBoxItems:: db
; item, quantity
wBoxItems:: ds PC_ITEM_CAPACITY * 2 + 1

; bits 0-6: box number
; bit 7: whether the player has changed boxes before
wCurrentBoxNum:: db

	ds 1

; number of HOF teams
wNumHoFTeams:: db

wUnusedMapVariable:: db

wPlayerCoins:: dw ; BCD

; bit array of toggleable objects; bit set = toggled off
wToggleableObjectFlags::
	ds (($100) + 7) / 8
wToggleableObjectFlagsEnd::

	ds 7

; saved copy of SPRITESTATEDATA1_IMAGEINDEX (used for sprite facing/anim)
wSavedSpriteImageIndex:: db

; each entry consists of 2 bytes
; * the sprite ID (depending on the current map)
; * the toggleable object index (global, used for wToggleableObjectFlags)
; terminated with $FF
wToggleableObjectList:: ds 16 * 2 + 1

	ds 1

wGameProgressFlags::
wOaksLabCurScript:: db
wPalletTownCurScript:: db
	ds 1
wBluesHouseCurScript:: db
wViridianCityCurScript:: db
	ds 2
wPewterCityCurScript:: db
wRoute3CurScript:: db
wRoute4CurScript:: db
	ds 1
wViridianGymCurScript:: db
wPewterGymCurScript:: db
wCeruleanGymCurScript:: db
wVermilionGymCurScript:: db
wCeladonGymCurScript:: db
wRoute6CurScript:: db
wRoute8CurScript:: db
wRoute24CurScript:: db
wRoute25CurScript:: db
wRoute9CurScript:: db
wRoute10CurScript:: db
wMtMoon1FCurScript:: db
wMtMoonB2FCurScript:: db
wSSAnne1FRoomsCurScript:: db
wSSAnne2FRoomsCurScript:: db
wRoute22CurScript:: db
	ds 1
wRedsHouse2FCurScript:: db
wViridianMartCurScript:: db
wRoute22GateCurScript:: db
wCeruleanCityCurScript:: db
	ds 7
wSSAnneBowCurScript:: db
wViridianForestCurScript:: db
wMuseum1FCurScript:: db
wRoute13CurScript:: db
wRoute14CurScript:: db
wRoute17CurScript:: db
wRoute19CurScript:: db
wRoute21CurScript:: db
wSafariZoneGateCurScript:: db
wRockTunnelB1FCurScript:: db
wRockTunnel1FCurScript:: db
	ds 1
wRoute11CurScript:: db
wRoute12CurScript:: db
wRoute15CurScript:: db
wRoute16CurScript:: db
wRoute18CurScript:: db
wRoute20CurScript:: db
wSSAnneB1FRoomsCurScript:: db
wVermilionCityCurScript:: db
wPokemonTower2FCurScript:: db
wPokemonTower3FCurScript:: db
wPokemonTower4FCurScript:: db
wPokemonTower5FCurScript:: db
wPokemonTower6FCurScript:: db
wPokemonTower7FCurScript:: db
wRocketHideoutB1FCurScript:: db
wRocketHideoutB2FCurScript:: db
wRocketHideoutB3FCurScript:: db
wRocketHideoutB4FCurScript:: db
	ds 1
wRoute6GateCurScript:: db
wRoute8GateCurScript:: db
	ds 1
wCinnabarIslandCurScript:: db
wPokemonMansion1FCurScript:: db
	ds 1
wPokemonMansion2FCurScript:: db
wPokemonMansion3FCurScript:: db
wPokemonMansionB1FCurScript:: db
wVictoryRoad2FCurScript:: db
wVictoryRoad3FCurScript:: db
	ds 1
wFightingDojoCurScript:: db
wSilphCo2FCurScript:: db
wSilphCo3FCurScript:: db
wSilphCo4FCurScript:: db
wSilphCo5FCurScript:: db
wSilphCo6FCurScript:: db
wSilphCo7FCurScript:: db
wSilphCo8FCurScript:: db
wSilphCo9FCurScript:: db
wHallOfFameCurScript:: db
wChampionsRoomCurScript:: db
wLoreleisRoomCurScript:: db
wBrunosRoomCurScript:: db
wAgathasRoomCurScript:: db
wCeruleanCaveB1FCurScript:: db
wVictoryRoad1FCurScript:: db
	ds 1
wLancesRoomCurScript:: db
	ds 4
wSilphCo10FCurScript:: db
wSilphCo11FCurScript:: db
	ds 1
wFuchsiaGymCurScript:: db
wSaffronGymCurScript:: db
	ds 1
wCinnabarGymCurScript:: db
wGameCornerCurScript:: db
wRoute16Gate1FCurScript:: db
wBillsHouseCurScript:: db
wRoute5GateCurScript:: db
wPowerPlantCurScript:: ; overload
wRoute7GateCurScript:: db
	ds 1
wSSAnne2FCurScript:: db
wSeafoamIslandsB3FCurScript:: db
wRoute23CurScript:: db
wSeafoamIslandsB4FCurScript:: db
wRoute18Gate1FCurScript:: db
	ds 78
wGameProgressFlagsEnd::

	ds 56

wObtainedHiddenItemsFlags::
	ds ((MAX_HIDDEN_ITEMS) + 7) / 8

wObtainedHiddenCoinsFlags::
	ds ((MAX_HIDDEN_COINS) + 7) / 8

; $00 = walking
; $01 = biking
; $02 = surfing
wWalkBikeSurfState:: db

	ds 10

wTownVisitedFlag::
	ds ((NUM_CITY_MAPS) + 7) / 8

; starts at 502
wSafariSteps:: dw

; item given to cinnabar lab
wFossilItem:: db
; mon that will result from the item
wFossilMon:: db

	ds 2

; trainer classes start at OPP_ID_OFFSET
wEnemyMonOrTrainerClass:: db

wPlayerJumpingYScreenCoordsIndex:: db

wRivalStarter:: db

	ds 1

wPlayerStarter:: db

; sprite index of the boulder the player is trying to push
wBoulderSpriteIndex:: db

wLastBlackoutMap:: db

; destination map (for certain types of special warps, not ordinary walking)
wDestinationMap:: db

; initialized to $ff, but nothing ever reads it
wUnusedPlayerDataByte:: db

; used to store the tile in front of the boulder when trying to push a boulder
; also used to store the result of the collision check ($ff for a collision and $00 for no collision)
wTileInFrontOfBoulderAndBoulderCollisionResult:: db

; destination map for dungeon warps
wDungeonWarpDestinationMap:: db

; which dungeon warp within the source map was used
wWhichDungeonWarp:: db

wUnusedCardKeyGateID:: db

	ds 8

wStatusFlags1:: db
	ds 1
wBeatGymFlags:: db ; redundant because it matches wObtainedBadges
	ds 1
wStatusFlags2:: db
wCableClubDestinationMap::
wStatusFlags3:: db
wStatusFlags4:: db
	ds 1
wStatusFlags5:: db
	ds 1
wStatusFlags6:: db
wStatusFlags7:: db
wElite4Flags:: db
	ds 1
wMovementFlags:: db

wCompletedInGameTradeFlags:: dw

	ds 2

wWarpedFromWhichWarp:: db
wWarpedFromWhichMap:: db

	ds 2

wCardKeyDoorY:: db
wCardKeyDoorX:: db

	ds 2

wFirstLockTrashCanIndex:: db
wSecondLockTrashCanIndex:: db

	ds 2

wEventFlags::
	ds ((NUM_EVENTS) + 7) / 8

; This union spans 293 bytes.
UNION
wGrassRate:: db
wGrassMons:: ds WILDDATA_LENGTH - 1

	ds 8

wWaterRate:: db
wWaterMons:: ds WILDDATA_LENGTH - 1

NEXTU
; linked game's trainer name
wLinkEnemyTrainerName:: ds NAME_LENGTH

	ds 1

wSerialEnemyDataBlock:: ; ds $1a8

	ds 9

wEnemyPartyCount:: db
wEnemyPartySpecies:: ds PARTY_LENGTH + 1

wEnemyMons::
; wEnemyMon1 - wEnemyMon6
wEnemyMon1::
wEnemyMon1Species::
	db
wEnemyMon1HP::
	dw
wEnemyMon1BoxLevel::
	db
wEnemyMon1Status::
	db
wEnemyMon1Type::
wEnemyMon1Type1::
	db
wEnemyMon1Type2::
	db
wEnemyMon1CatchRate::
	db
wEnemyMon1Moves::
	ds NUM_MOVES
wEnemyMon1OTID::
	dw
wEnemyMon1Exp::
	ds 3
wEnemyMon1HPExp::
	dw
wEnemyMon1AttackExp::
	dw
wEnemyMon1DefenseExp::
	dw
wEnemyMon1SpeedExp::
	dw
wEnemyMon1SpecialExp::
	dw
wEnemyMon1DVs::
	dw
wEnemyMon1PP::
	ds NUM_MOVES
wEnemyMon1Level::
	db
wEnemyMon1Stats::
wEnemyMon1MaxHP::
	dw
wEnemyMon1Attack::
	dw
wEnemyMon1Defense::
	dw
wEnemyMon1Speed::
	dw
wEnemyMon1Special::
	dw
wEnemyMon2::
wEnemyMon2Species::
	db
wEnemyMon2HP::
	dw
wEnemyMon2BoxLevel::
	db
wEnemyMon2Status::
	db
wEnemyMon2Type::
wEnemyMon2Type1::
	db
wEnemyMon2Type2::
	db
wEnemyMon2CatchRate::
	db
wEnemyMon2Moves::
	ds NUM_MOVES
wEnemyMon2OTID::
	dw
wEnemyMon2Exp::
	ds 3
wEnemyMon2HPExp::
	dw
wEnemyMon2AttackExp::
	dw
wEnemyMon2DefenseExp::
	dw
wEnemyMon2SpeedExp::
	dw
wEnemyMon2SpecialExp::
	dw
wEnemyMon2DVs::
	dw
wEnemyMon2PP::
	ds NUM_MOVES
wEnemyMon2Level::
	db
wEnemyMon2Stats::
wEnemyMon2MaxHP::
	dw
wEnemyMon2Attack::
	dw
wEnemyMon2Defense::
	dw
wEnemyMon2Speed::
	dw
wEnemyMon2Special::
	dw
wEnemyMon3::
wEnemyMon3Species::
	db
wEnemyMon3HP::
	dw
wEnemyMon3BoxLevel::
	db
wEnemyMon3Status::
	db
wEnemyMon3Type::
wEnemyMon3Type1::
	db
wEnemyMon3Type2::
	db
wEnemyMon3CatchRate::
	db
wEnemyMon3Moves::
	ds NUM_MOVES
wEnemyMon3OTID::
	dw
wEnemyMon3Exp::
	ds 3
wEnemyMon3HPExp::
	dw
wEnemyMon3AttackExp::
	dw
wEnemyMon3DefenseExp::
	dw
wEnemyMon3SpeedExp::
	dw
wEnemyMon3SpecialExp::
	dw
wEnemyMon3DVs::
	dw
wEnemyMon3PP::
	ds NUM_MOVES
wEnemyMon3Level::
	db
wEnemyMon3Stats::
wEnemyMon3MaxHP::
	dw
wEnemyMon3Attack::
	dw
wEnemyMon3Defense::
	dw
wEnemyMon3Speed::
	dw
wEnemyMon3Special::
	dw
wEnemyMon4::
wEnemyMon4Species::
	db
wEnemyMon4HP::
	dw
wEnemyMon4BoxLevel::
	db
wEnemyMon4Status::
	db
wEnemyMon4Type::
wEnemyMon4Type1::
	db
wEnemyMon4Type2::
	db
wEnemyMon4CatchRate::
	db
wEnemyMon4Moves::
	ds NUM_MOVES
wEnemyMon4OTID::
	dw
wEnemyMon4Exp::
	ds 3
wEnemyMon4HPExp::
	dw
wEnemyMon4AttackExp::
	dw
wEnemyMon4DefenseExp::
	dw
wEnemyMon4SpeedExp::
	dw
wEnemyMon4SpecialExp::
	dw
wEnemyMon4DVs::
	dw
wEnemyMon4PP::
	ds NUM_MOVES
wEnemyMon4Level::
	db
wEnemyMon4Stats::
wEnemyMon4MaxHP::
	dw
wEnemyMon4Attack::
	dw
wEnemyMon4Defense::
	dw
wEnemyMon4Speed::
	dw
wEnemyMon4Special::
	dw
wEnemyMon5::
wEnemyMon5Species::
	db
wEnemyMon5HP::
	dw
wEnemyMon5BoxLevel::
	db
wEnemyMon5Status::
	db
wEnemyMon5Type::
wEnemyMon5Type1::
	db
wEnemyMon5Type2::
	db
wEnemyMon5CatchRate::
	db
wEnemyMon5Moves::
	ds NUM_MOVES
wEnemyMon5OTID::
	dw
wEnemyMon5Exp::
	ds 3
wEnemyMon5HPExp::
	dw
wEnemyMon5AttackExp::
	dw
wEnemyMon5DefenseExp::
	dw
wEnemyMon5SpeedExp::
	dw
wEnemyMon5SpecialExp::
	dw
wEnemyMon5DVs::
	dw
wEnemyMon5PP::
	ds NUM_MOVES
wEnemyMon5Level::
	db
wEnemyMon5Stats::
wEnemyMon5MaxHP::
	dw
wEnemyMon5Attack::
	dw
wEnemyMon5Defense::
	dw
wEnemyMon5Speed::
	dw
wEnemyMon5Special::
	dw
wEnemyMon6::
wEnemyMon6Species::
	db
wEnemyMon6HP::
	dw
wEnemyMon6BoxLevel::
	db
wEnemyMon6Status::
	db
wEnemyMon6Type::
wEnemyMon6Type1::
	db
wEnemyMon6Type2::
	db
wEnemyMon6CatchRate::
	db
wEnemyMon6Moves::
	ds NUM_MOVES
wEnemyMon6OTID::
	dw
wEnemyMon6Exp::
	ds 3
wEnemyMon6HPExp::
	dw
wEnemyMon6AttackExp::
	dw
wEnemyMon6DefenseExp::
	dw
wEnemyMon6SpeedExp::
	dw
wEnemyMon6SpecialExp::
	dw
wEnemyMon6DVs::
	dw
wEnemyMon6PP::
	ds NUM_MOVES
wEnemyMon6Level::
	db
wEnemyMon6Stats::
wEnemyMon6MaxHP::
	dw
wEnemyMon6Attack::
	dw
wEnemyMon6Defense::
	dw
wEnemyMon6Speed::
	dw
wEnemyMon6Special::
	dw

ENDU

wEnemyMonOT::
; wEnemyMon1OT - wEnemyMon6OT
wEnemyMon1OT::
	ds NAME_LENGTH
wEnemyMon2OT::
	ds NAME_LENGTH
wEnemyMon3OT::
	ds NAME_LENGTH
wEnemyMon4OT::
	ds NAME_LENGTH
wEnemyMon5OT::
	ds NAME_LENGTH
wEnemyMon6OT::
	ds NAME_LENGTH

wEnemyMonNicks::
; wEnemyMon1Nick - wEnemyMon6Nick
wEnemyMon1Nick::
	ds NAME_LENGTH
wEnemyMon2Nick::
	ds NAME_LENGTH
wEnemyMon3Nick::
	ds NAME_LENGTH
wEnemyMon4Nick::
	ds NAME_LENGTH
wEnemyMon5Nick::
	ds NAME_LENGTH
wEnemyMon6Nick::
	ds NAME_LENGTH

wTrainerHeaderPtr:: dw

	ds 6

; the trainer the player must face after getting a wrong answer in the Cinnabar
; gym quiz
wOpponentAfterWrongAnswer:: db

; index of current map script, mostly used as index for function pointer array
; mostly copied from map-specific map script pointer and written back later
wCurMapScript:: db

	ds 7

wPlayTimeHours:: db
wPlayTimeMaxed:: db
wPlayTimeMinutes:: db
wPlayTimeSeconds:: db
wPlayTimeFrames:: db

wSafariZoneGameOver:: db

wNumSafariBalls:: db

; 0 if no pokemon is in the daycare
; 1 if pokemon is in the daycare
wDayCareInUse:: db

wDayCareMonName:: ds NAME_LENGTH
wDayCareMonOT::   ds NAME_LENGTH

wDayCareMon::
wDayCareMonSpecies::
	db
wDayCareMonHP::
	dw
wDayCareMonBoxLevel::
	db
wDayCareMonStatus::
	db
wDayCareMonType::
wDayCareMonType1::
	db
wDayCareMonType2::
	db
wDayCareMonCatchRate::
	db
wDayCareMonMoves::
	ds NUM_MOVES
wDayCareMonOTID::
	dw
wDayCareMonExp::
	ds 3
wDayCareMonHPExp::
	dw
wDayCareMonAttackExp::
	dw
wDayCareMonDefenseExp::
	dw
wDayCareMonSpeedExp::
	dw
wDayCareMonSpecialExp::
	dw
wDayCareMonDVs::
	dw
wDayCareMonPP::
	ds NUM_MOVES

wMainDataEnd::


SECTION "Current Box Data", WRAM0

wBoxDataStart::

wBoxCount:: db
wBoxSpecies:: ds MONS_PER_BOX + 1

wBoxMons::
; wBoxMon1 - wBoxMon20
wBoxMon1::
wBoxMon1Species::
	db
wBoxMon1HP::
	dw
wBoxMon1BoxLevel::
	db
wBoxMon1Status::
	db
wBoxMon1Type::
wBoxMon1Type1::
	db
wBoxMon1Type2::
	db
wBoxMon1CatchRate::
	db
wBoxMon1Moves::
	ds NUM_MOVES
wBoxMon1OTID::
	dw
wBoxMon1Exp::
	ds 3
wBoxMon1HPExp::
	dw
wBoxMon1AttackExp::
	dw
wBoxMon1DefenseExp::
	dw
wBoxMon1SpeedExp::
	dw
wBoxMon1SpecialExp::
	dw
wBoxMon1DVs::
	dw
wBoxMon1PP::
	ds NUM_MOVES
wBoxMon2::
wBoxMon2Species::
	db
wBoxMon2HP::
	dw
wBoxMon2BoxLevel::
	db
wBoxMon2Status::
	db
wBoxMon2Type::
wBoxMon2Type1::
	db
wBoxMon2Type2::
	db
wBoxMon2CatchRate::
	db
wBoxMon2Moves::
	ds NUM_MOVES
wBoxMon2OTID::
	dw
wBoxMon2Exp::
	ds 3
wBoxMon2HPExp::
	dw
wBoxMon2AttackExp::
	dw
wBoxMon2DefenseExp::
	dw
wBoxMon2SpeedExp::
	dw
wBoxMon2SpecialExp::
	dw
wBoxMon2DVs::
	dw
wBoxMon2PP::
	ds NUM_MOVES
wBoxMon3::
wBoxMon3Species::
	db
wBoxMon3HP::
	dw
wBoxMon3BoxLevel::
	db
wBoxMon3Status::
	db
wBoxMon3Type::
wBoxMon3Type1::
	db
wBoxMon3Type2::
	db
wBoxMon3CatchRate::
	db
wBoxMon3Moves::
	ds NUM_MOVES
wBoxMon3OTID::
	dw
wBoxMon3Exp::
	ds 3
wBoxMon3HPExp::
	dw
wBoxMon3AttackExp::
	dw
wBoxMon3DefenseExp::
	dw
wBoxMon3SpeedExp::
	dw
wBoxMon3SpecialExp::
	dw
wBoxMon3DVs::
	dw
wBoxMon3PP::
	ds NUM_MOVES
wBoxMon4::
wBoxMon4Species::
	db
wBoxMon4HP::
	dw
wBoxMon4BoxLevel::
	db
wBoxMon4Status::
	db
wBoxMon4Type::
wBoxMon4Type1::
	db
wBoxMon4Type2::
	db
wBoxMon4CatchRate::
	db
wBoxMon4Moves::
	ds NUM_MOVES
wBoxMon4OTID::
	dw
wBoxMon4Exp::
	ds 3
wBoxMon4HPExp::
	dw
wBoxMon4AttackExp::
	dw
wBoxMon4DefenseExp::
	dw
wBoxMon4SpeedExp::
	dw
wBoxMon4SpecialExp::
	dw
wBoxMon4DVs::
	dw
wBoxMon4PP::
	ds NUM_MOVES
wBoxMon5::
wBoxMon5Species::
	db
wBoxMon5HP::
	dw
wBoxMon5BoxLevel::
	db
wBoxMon5Status::
	db
wBoxMon5Type::
wBoxMon5Type1::
	db
wBoxMon5Type2::
	db
wBoxMon5CatchRate::
	db
wBoxMon5Moves::
	ds NUM_MOVES
wBoxMon5OTID::
	dw
wBoxMon5Exp::
	ds 3
wBoxMon5HPExp::
	dw
wBoxMon5AttackExp::
	dw
wBoxMon5DefenseExp::
	dw
wBoxMon5SpeedExp::
	dw
wBoxMon5SpecialExp::
	dw
wBoxMon5DVs::
	dw
wBoxMon5PP::
	ds NUM_MOVES
wBoxMon6::
wBoxMon6Species::
	db
wBoxMon6HP::
	dw
wBoxMon6BoxLevel::
	db
wBoxMon6Status::
	db
wBoxMon6Type::
wBoxMon6Type1::
	db
wBoxMon6Type2::
	db
wBoxMon6CatchRate::
	db
wBoxMon6Moves::
	ds NUM_MOVES
wBoxMon6OTID::
	dw
wBoxMon6Exp::
	ds 3
wBoxMon6HPExp::
	dw
wBoxMon6AttackExp::
	dw
wBoxMon6DefenseExp::
	dw
wBoxMon6SpeedExp::
	dw
wBoxMon6SpecialExp::
	dw
wBoxMon6DVs::
	dw
wBoxMon6PP::
	ds NUM_MOVES
wBoxMon7::
wBoxMon7Species::
	db
wBoxMon7HP::
	dw
wBoxMon7BoxLevel::
	db
wBoxMon7Status::
	db
wBoxMon7Type::
wBoxMon7Type1::
	db
wBoxMon7Type2::
	db
wBoxMon7CatchRate::
	db
wBoxMon7Moves::
	ds NUM_MOVES
wBoxMon7OTID::
	dw
wBoxMon7Exp::
	ds 3
wBoxMon7HPExp::
	dw
wBoxMon7AttackExp::
	dw
wBoxMon7DefenseExp::
	dw
wBoxMon7SpeedExp::
	dw
wBoxMon7SpecialExp::
	dw
wBoxMon7DVs::
	dw
wBoxMon7PP::
	ds NUM_MOVES
wBoxMon8::
wBoxMon8Species::
	db
wBoxMon8HP::
	dw
wBoxMon8BoxLevel::
	db
wBoxMon8Status::
	db
wBoxMon8Type::
wBoxMon8Type1::
	db
wBoxMon8Type2::
	db
wBoxMon8CatchRate::
	db
wBoxMon8Moves::
	ds NUM_MOVES
wBoxMon8OTID::
	dw
wBoxMon8Exp::
	ds 3
wBoxMon8HPExp::
	dw
wBoxMon8AttackExp::
	dw
wBoxMon8DefenseExp::
	dw
wBoxMon8SpeedExp::
	dw
wBoxMon8SpecialExp::
	dw
wBoxMon8DVs::
	dw
wBoxMon8PP::
	ds NUM_MOVES
wBoxMon9::
wBoxMon9Species::
	db
wBoxMon9HP::
	dw
wBoxMon9BoxLevel::
	db
wBoxMon9Status::
	db
wBoxMon9Type::
wBoxMon9Type1::
	db
wBoxMon9Type2::
	db
wBoxMon9CatchRate::
	db
wBoxMon9Moves::
	ds NUM_MOVES
wBoxMon9OTID::
	dw
wBoxMon9Exp::
	ds 3
wBoxMon9HPExp::
	dw
wBoxMon9AttackExp::
	dw
wBoxMon9DefenseExp::
	dw
wBoxMon9SpeedExp::
	dw
wBoxMon9SpecialExp::
	dw
wBoxMon9DVs::
	dw
wBoxMon9PP::
	ds NUM_MOVES
wBoxMon10::
wBoxMon10Species::
	db
wBoxMon10HP::
	dw
wBoxMon10BoxLevel::
	db
wBoxMon10Status::
	db
wBoxMon10Type::
wBoxMon10Type1::
	db
wBoxMon10Type2::
	db
wBoxMon10CatchRate::
	db
wBoxMon10Moves::
	ds NUM_MOVES
wBoxMon10OTID::
	dw
wBoxMon10Exp::
	ds 3
wBoxMon10HPExp::
	dw
wBoxMon10AttackExp::
	dw
wBoxMon10DefenseExp::
	dw
wBoxMon10SpeedExp::
	dw
wBoxMon10SpecialExp::
	dw
wBoxMon10DVs::
	dw
wBoxMon10PP::
	ds NUM_MOVES
wBoxMon11::
wBoxMon11Species::
	db
wBoxMon11HP::
	dw
wBoxMon11BoxLevel::
	db
wBoxMon11Status::
	db
wBoxMon11Type::
wBoxMon11Type1::
	db
wBoxMon11Type2::
	db
wBoxMon11CatchRate::
	db
wBoxMon11Moves::
	ds NUM_MOVES
wBoxMon11OTID::
	dw
wBoxMon11Exp::
	ds 3
wBoxMon11HPExp::
	dw
wBoxMon11AttackExp::
	dw
wBoxMon11DefenseExp::
	dw
wBoxMon11SpeedExp::
	dw
wBoxMon11SpecialExp::
	dw
wBoxMon11DVs::
	dw
wBoxMon11PP::
	ds NUM_MOVES
wBoxMon12::
wBoxMon12Species::
	db
wBoxMon12HP::
	dw
wBoxMon12BoxLevel::
	db
wBoxMon12Status::
	db
wBoxMon12Type::
wBoxMon12Type1::
	db
wBoxMon12Type2::
	db
wBoxMon12CatchRate::
	db
wBoxMon12Moves::
	ds NUM_MOVES
wBoxMon12OTID::
	dw
wBoxMon12Exp::
	ds 3
wBoxMon12HPExp::
	dw
wBoxMon12AttackExp::
	dw
wBoxMon12DefenseExp::
	dw
wBoxMon12SpeedExp::
	dw
wBoxMon12SpecialExp::
	dw
wBoxMon12DVs::
	dw
wBoxMon12PP::
	ds NUM_MOVES
wBoxMon13::
wBoxMon13Species::
	db
wBoxMon13HP::
	dw
wBoxMon13BoxLevel::
	db
wBoxMon13Status::
	db
wBoxMon13Type::
wBoxMon13Type1::
	db
wBoxMon13Type2::
	db
wBoxMon13CatchRate::
	db
wBoxMon13Moves::
	ds NUM_MOVES
wBoxMon13OTID::
	dw
wBoxMon13Exp::
	ds 3
wBoxMon13HPExp::
	dw
wBoxMon13AttackExp::
	dw
wBoxMon13DefenseExp::
	dw
wBoxMon13SpeedExp::
	dw
wBoxMon13SpecialExp::
	dw
wBoxMon13DVs::
	dw
wBoxMon13PP::
	ds NUM_MOVES
wBoxMon14::
wBoxMon14Species::
	db
wBoxMon14HP::
	dw
wBoxMon14BoxLevel::
	db
wBoxMon14Status::
	db
wBoxMon14Type::
wBoxMon14Type1::
	db
wBoxMon14Type2::
	db
wBoxMon14CatchRate::
	db
wBoxMon14Moves::
	ds NUM_MOVES
wBoxMon14OTID::
	dw
wBoxMon14Exp::
	ds 3
wBoxMon14HPExp::
	dw
wBoxMon14AttackExp::
	dw
wBoxMon14DefenseExp::
	dw
wBoxMon14SpeedExp::
	dw
wBoxMon14SpecialExp::
	dw
wBoxMon14DVs::
	dw
wBoxMon14PP::
	ds NUM_MOVES
wBoxMon15::
wBoxMon15Species::
	db
wBoxMon15HP::
	dw
wBoxMon15BoxLevel::
	db
wBoxMon15Status::
	db
wBoxMon15Type::
wBoxMon15Type1::
	db
wBoxMon15Type2::
	db
wBoxMon15CatchRate::
	db
wBoxMon15Moves::
	ds NUM_MOVES
wBoxMon15OTID::
	dw
wBoxMon15Exp::
	ds 3
wBoxMon15HPExp::
	dw
wBoxMon15AttackExp::
	dw
wBoxMon15DefenseExp::
	dw
wBoxMon15SpeedExp::
	dw
wBoxMon15SpecialExp::
	dw
wBoxMon15DVs::
	dw
wBoxMon15PP::
	ds NUM_MOVES
wBoxMon16::
wBoxMon16Species::
	db
wBoxMon16HP::
	dw
wBoxMon16BoxLevel::
	db
wBoxMon16Status::
	db
wBoxMon16Type::
wBoxMon16Type1::
	db
wBoxMon16Type2::
	db
wBoxMon16CatchRate::
	db
wBoxMon16Moves::
	ds NUM_MOVES
wBoxMon16OTID::
	dw
wBoxMon16Exp::
	ds 3
wBoxMon16HPExp::
	dw
wBoxMon16AttackExp::
	dw
wBoxMon16DefenseExp::
	dw
wBoxMon16SpeedExp::
	dw
wBoxMon16SpecialExp::
	dw
wBoxMon16DVs::
	dw
wBoxMon16PP::
	ds NUM_MOVES
wBoxMon17::
wBoxMon17Species::
	db
wBoxMon17HP::
	dw
wBoxMon17BoxLevel::
	db
wBoxMon17Status::
	db
wBoxMon17Type::
wBoxMon17Type1::
	db
wBoxMon17Type2::
	db
wBoxMon17CatchRate::
	db
wBoxMon17Moves::
	ds NUM_MOVES
wBoxMon17OTID::
	dw
wBoxMon17Exp::
	ds 3
wBoxMon17HPExp::
	dw
wBoxMon17AttackExp::
	dw
wBoxMon17DefenseExp::
	dw
wBoxMon17SpeedExp::
	dw
wBoxMon17SpecialExp::
	dw
wBoxMon17DVs::
	dw
wBoxMon17PP::
	ds NUM_MOVES
wBoxMon18::
wBoxMon18Species::
	db
wBoxMon18HP::
	dw
wBoxMon18BoxLevel::
	db
wBoxMon18Status::
	db
wBoxMon18Type::
wBoxMon18Type1::
	db
wBoxMon18Type2::
	db
wBoxMon18CatchRate::
	db
wBoxMon18Moves::
	ds NUM_MOVES
wBoxMon18OTID::
	dw
wBoxMon18Exp::
	ds 3
wBoxMon18HPExp::
	dw
wBoxMon18AttackExp::
	dw
wBoxMon18DefenseExp::
	dw
wBoxMon18SpeedExp::
	dw
wBoxMon18SpecialExp::
	dw
wBoxMon18DVs::
	dw
wBoxMon18PP::
	ds NUM_MOVES
wBoxMon19::
wBoxMon19Species::
	db
wBoxMon19HP::
	dw
wBoxMon19BoxLevel::
	db
wBoxMon19Status::
	db
wBoxMon19Type::
wBoxMon19Type1::
	db
wBoxMon19Type2::
	db
wBoxMon19CatchRate::
	db
wBoxMon19Moves::
	ds NUM_MOVES
wBoxMon19OTID::
	dw
wBoxMon19Exp::
	ds 3
wBoxMon19HPExp::
	dw
wBoxMon19AttackExp::
	dw
wBoxMon19DefenseExp::
	dw
wBoxMon19SpeedExp::
	dw
wBoxMon19SpecialExp::
	dw
wBoxMon19DVs::
	dw
wBoxMon19PP::
	ds NUM_MOVES
wBoxMon20::
wBoxMon20Species::
	db
wBoxMon20HP::
	dw
wBoxMon20BoxLevel::
	db
wBoxMon20Status::
	db
wBoxMon20Type::
wBoxMon20Type1::
	db
wBoxMon20Type2::
	db
wBoxMon20CatchRate::
	db
wBoxMon20Moves::
	ds NUM_MOVES
wBoxMon20OTID::
	dw
wBoxMon20Exp::
	ds 3
wBoxMon20HPExp::
	dw
wBoxMon20AttackExp::
	dw
wBoxMon20DefenseExp::
	dw
wBoxMon20SpeedExp::
	dw
wBoxMon20SpecialExp::
	dw
wBoxMon20DVs::
	dw
wBoxMon20PP::
	ds NUM_MOVES

wBoxMonOT::
; wBoxMon1OT - wBoxMon20OT
wBoxMon1OT::
	ds NAME_LENGTH
wBoxMon2OT::
	ds NAME_LENGTH
wBoxMon3OT::
	ds NAME_LENGTH
wBoxMon4OT::
	ds NAME_LENGTH
wBoxMon5OT::
	ds NAME_LENGTH
wBoxMon6OT::
	ds NAME_LENGTH
wBoxMon7OT::
	ds NAME_LENGTH
wBoxMon8OT::
	ds NAME_LENGTH
wBoxMon9OT::
	ds NAME_LENGTH
wBoxMon10OT::
	ds NAME_LENGTH
wBoxMon11OT::
	ds NAME_LENGTH
wBoxMon12OT::
	ds NAME_LENGTH
wBoxMon13OT::
	ds NAME_LENGTH
wBoxMon14OT::
	ds NAME_LENGTH
wBoxMon15OT::
	ds NAME_LENGTH
wBoxMon16OT::
	ds NAME_LENGTH
wBoxMon17OT::
	ds NAME_LENGTH
wBoxMon18OT::
	ds NAME_LENGTH
wBoxMon19OT::
	ds NAME_LENGTH
wBoxMon20OT::
	ds NAME_LENGTH

wBoxMonNicks::
; wBoxMon1Nick - wBoxMon20Nick
wBoxMon1Nick::
	ds NAME_LENGTH
wBoxMon2Nick::
	ds NAME_LENGTH
wBoxMon3Nick::
	ds NAME_LENGTH
wBoxMon4Nick::
	ds NAME_LENGTH
wBoxMon5Nick::
	ds NAME_LENGTH
wBoxMon6Nick::
	ds NAME_LENGTH
wBoxMon7Nick::
	ds NAME_LENGTH
wBoxMon8Nick::
	ds NAME_LENGTH
wBoxMon9Nick::
	ds NAME_LENGTH
wBoxMon10Nick::
	ds NAME_LENGTH
wBoxMon11Nick::
	ds NAME_LENGTH
wBoxMon12Nick::
	ds NAME_LENGTH
wBoxMon13Nick::
	ds NAME_LENGTH
wBoxMon14Nick::
	ds NAME_LENGTH
wBoxMon15Nick::
	ds NAME_LENGTH
wBoxMon16Nick::
	ds NAME_LENGTH
wBoxMon17Nick::
	ds NAME_LENGTH
wBoxMon18Nick::
	ds NAME_LENGTH
wBoxMon19Nick::
	ds NAME_LENGTH
wBoxMon20Nick::
	ds NAME_LENGTH
wBoxMonNicksEnd::

wBoxDataEnd::


SECTION "Stack", WRAM0

; the stack grows downward
	ds $100 - 1
wStack:: db

ENDSECTION
SECTION "Sprite Buffers", SRAM

sSpriteBuffer0:: ds SPRITEBUFFERSIZE
sSpriteBuffer1:: ds SPRITEBUFFERSIZE
sSpriteBuffer2:: ds SPRITEBUFFERSIZE

	ds $100

sHallOfFame:: ds HOF_TEAM * HOF_TEAM_CAPACITY


SECTION "Save Data", SRAM

	ds $598

sGameData::
sPlayerName::  ds NAME_LENGTH
sMainData::    ds wMainDataEnd - wMainDataStart
sSpriteData::  ds wSpriteDataEnd - wSpriteDataStart
sPartyData::   ds wPartyDataEnd - wPartyDataStart
sCurBoxData::  ds wBoxDataEnd - wBoxDataStart
sTileAnimations:: db
sGameDataEnd::
sMainDataCheckSum:: db


; The PC boxes will not fit into one SRAM bank,
; so they use multiple SECTIONs

SECTION "Saved Boxes 1", SRAM

; sBox1 - sBox6
sBox1::
	ds wBoxDataEnd - wBoxDataStart
sBox2::
	ds wBoxDataEnd - wBoxDataStart
sBox3::
	ds wBoxDataEnd - wBoxDataStart
sBox4::
	ds wBoxDataEnd - wBoxDataStart
sBox5::
	ds wBoxDataEnd - wBoxDataStart
sBox6::
	ds wBoxDataEnd - wBoxDataStart
sBank2AllBoxesChecksum:: db
sBank2IndividualBoxChecksums:: ds 6

SECTION "Saved Boxes 2", SRAM

; sBox7 - sBox12
sBox7::
	ds wBoxDataEnd - wBoxDataStart
sBox8::
	ds wBoxDataEnd - wBoxDataStart
sBox9::
	ds wBoxDataEnd - wBoxDataStart
sBox10::
	ds wBoxDataEnd - wBoxDataStart
sBox11::
	ds wBoxDataEnd - wBoxDataStart
sBox12::
	ds wBoxDataEnd - wBoxDataStart
sBank3AllBoxesChecksum:: db
sBank3IndividualBoxChecksums:: ds 6

; All 12 boxes fit within 2 SRAM banks

ENDSECTION
SECTION "HRAM", HRAM

; Initialized to 16.
; Decremented each input iteration if the player
; presses the reset sequence (A+B+SEL+START).
; Soft reset when 0 is reached.
hSoftReset:: db

UNION
hBaseTileID:: ; base tile ID to which offsets are added
hDexWeight::
hWarpDestinationMap::
hOAMTile::
hROMBankTemp::
hPreviousTileset::
hRLEByteValue::
	db

hTextID:: ; DisplayTextID's argument
hPartyMonIndex::
	db

hVRAMSlot::
	db

hFourTileSpriteCount::
hHalveItemPrices::
	db

NEXTU
hItemPrice:: ds 3 ; BCD number

NEXTU
hSlideAmount:: db

; the total number of tiles being shifted each time the pic slides by one tile
hSlidingRegionSize:: db

; -1 = left
;  0 = right
hSlideDirection:: db

NEXTU
hSpriteInterlaceCounter::
hSpriteWidth::  db ; in tiles
hSpriteHeight:: db ; in tiles
hSpriteOffset:: db

NEXTU
; counters for blinking down arrow
hDownArrowBlinkCount1:: db
hDownArrowBlinkCount2:: db

NEXTU
hMapStride::
hEastWestConnectedMapWidth::
hNorthSouthConnectionStripWidth::
	db
hMapWidth::
hNorthSouthConnectedMapWidth::
	db

NEXTU
hSpriteDataOffset:: db
hSpriteIndex:: db
hSpriteImageIndex::
hSpriteFacingDirection::
hSpriteMovementByte2::
	db

NEXTU
	ds 2
hLoadSpriteTemp1:: db
hLoadSpriteTemp2:: db

NEXTU
	ds 2
hEnemySpeed:: dw
ENDU

UNION
hSpriteOffset2:: db
hOAMBufferOffset:: db
hSpriteScreenX:: db
hSpriteScreenY:: db

NEXTU
hCollidingSpriteOffset:: db
hCollidingSpriteTempYValue:: db
hCollidingSpriteTempXValue:: db
hCollidingSpriteAdjustedDistance:: db
ENDU

hTilePlayerStandingOn:: db

hSpritePriority:: db

UNION
; Multiplication and division variables are meant
; to overlap for back-to-back usage. Big endian.
UNION
	ds 1
hMultiplicand:: ds 3
hMultiplier:: db
	ds 1
hMultiplyBuffer:: ds 4
NEXTU
hProduct:: ds 4
NEXTU
hDividend:: ds 4
hDivisor:: db
hDivideBuffer:: ds 5
NEXTU
hQuotient:: ds 4
hRemainder:: db
ENDU

NEXTU
; PrintNumber (big endian).
hPastLeadingZeros:: db ; last char printed
hNumToPrint:: ds 3
hPowerOf10:: ds 3
hSavedNumToPrint:: ds 3

NEXTU
hNPCMovementDirections2Index::
hNPCSpriteOffset::
; distance in steps between NPC and player
hNPCPlayerYDistance::
	db
hNPCPlayerXDistance::
	db
hFindPathNumSteps:: db
; bit 0: set when the end of the path's Y coordinate matches the target's
; bit 1: set when the end of the path's X coordinate matches the target's
; When both bits are set, the end of the path is at the target's position
; (i.e. the path has been found).
hFindPathFlags:: db
hFindPathYProgress:: db
hFindPathXProgress:: db
; 0 = from player to NPC
; 1 = from NPC to player
hNPCPlayerRelativePosPerspective:: db
	ds 1
; bit 0:
; 0 = target is to the south or aligned
; 1 = target is to the north
; bit 1:
; 0 = target is to the east or aligned
; 1 = target is to the west
hNPCPlayerRelativePosFlags:: db

NEXTU
hSwapItemID:: db
hSwapItemQuantity:: db

NEXTU
hSignCoordPointer:: dw

NEXTU
	ds 1
hMutateWY:: db
hMutateWX:: db

NEXTU
; temp value used when swapping bytes or words
hSwapTemp:: db
hExperience:: ds 3 ; big endian
ENDU

UNION
hMoney:: ds 3 ; BCD number
NEXTU
; some code zeroes this for no reason when writing a coin amount
hUnusedCoinsByte:: db
hCoins:: dw ; BCD number
ENDU

hDivideBCDDivisor::
hDivideBCDQuotient::
	ds 3 ; BCD number
hDivideBCDBuffer::
	ds 3 ; BCD number

	ds 1

hSerialReceivedNewData:: db
; $01 = using external clock
; $02 = using internal clock
; $ff = establishing connection
hSerialConnectionStatus:: db
hSerialIgnoringInitialData:: db
hSerialSendData:: db
hSerialReceiveData:: db

; these values are copied to rSCX, rSCY, and rWY during V-blank
hSCX:: db
hSCY:: db
hWY::  db

hJoyLast::     db
hJoyReleased:: db
hJoyPressed::  db
hJoyHeld::     db
hJoy5::        db
hJoy6::        db
hJoy7::        db

hLoadedROMBank:: db
hSavedROMBank::  db

; is automatic background transfer during V-blank enabled?
; if nonzero, yes
; if zero, no
hAutoBGTransferEnabled:: db

; 00 = top third of background
; 01 = middle third of background
; 02 = bottom third of background
hAutoBGTransferPortion:: db

; the destination address of the automatic background transfer
hAutoBGTransferDest:: dw

hRedrawMapViewRowOffset:: db

; temporary storage for stack pointer during memory transfers that use pop
; to increase speed
hSPTemp:: dw

; source address for VBlankCopyBgMap function
; the first byte doubles as the byte that enabled the transfer.
; if it is 0, the transfer is disabled
; if it is not 0, the transfer is enabled
; this means that XX00 is not a valid source address
hVBlankCopyBGSource:: dw

; destination address for VBlankCopyBgMap function
hVBlankCopyBGDest:: dw

; number of rows for VBlankCopyBgMap to copy
hVBlankCopyBGNumRows:: db

; size of VBlankCopy transfer in 16-byte units
hVBlankCopySize:: db

; source address for VBlankCopy function
hVBlankCopySource:: dw

; destination address for VBlankCopy function
hVBlankCopyDest:: dw

; size of source data for VBlankCopyDouble in 8-byte units
hVBlankCopyDoubleSize:: db

; source address for VBlankCopyDouble function
hVBlankCopyDoubleSource:: dw

; destination address for VBlankCopyDouble function
hVBlankCopyDoubleDest:: dw

; controls whether a row or column of 2x2 tile blocks is redrawn in V-blank
; 00 = no redraw
; 01 = redraw column
; 02 = redraw row
hRedrawRowOrColumnMode:: db

hRedrawRowOrColumnDest:: dw

hRandomAdd:: db
hRandomSub:: db

hFrameCounter:: db ; decremented every V-blank (used for delays)

; V-blank sets this to 0 each time it runs.
; So, by setting it to a nonzero value and waiting for it to become 0 again,
; you can detect that the V-blank handler has run since then.
hVBlankOccurred:: db

; Controls which tiles are animated.
; 0 = no animations (breaks Surf)
; 1 = water tile $14 is animated
; 2 = water tile $14 and flower tile $03 are animated
hTileAnimations:: db

hMovingBGTilesCounter1:: db

	ds 1

hCurrentSpriteOffset:: db ; multiple of $10

UNION
hPlayerFacing:: db
hPlayerYCoord:: db
hPlayerXCoord:: db

NEXTU

; $00 = bag full
; $01 = got item
; $80 = didn't meet required number of owned mons
; $FF = player cancelled
hOaksAideResult::
hOaksAideRequirement:: ; required number of owned mons
	db
hOaksAideRewardItem:: db
hOaksAideNumMonsOwned:: db

NEXTU
hVendingMachineItem:: db
hVendingMachinePrice:: ds 3 ; BCD number

NEXTU
hGymGateIndex:: db
hGymGateAnswer:: db

NEXTU
hDexRatingNumMonsSeen:: db
hDexRatingNumMonsOwned:: db

NEXTU
hItemToRemoveID:: db
hItemToRemoveIndex:: db

NEXTU
hItemCounter::
hSavedCoordIndex::
hToggleableObjectIndex::
hGymTrashCanRandNumMask::
hInteractedWithBookshelf::
	db
ENDU

	ds 1

hBackupGymGateIndex::
hUnlockedSilphCoDoors::
	db

; the first tile ID in a sequence of tile IDs that increase by 1 each step
hStartTileID:: db

	ds 2

hNewPartyLength:: db

UNION
hDividend2:: db
hDivisor2::  db
hQuotient2:: db

NEXTU
hIsToggleableObjectOff:: db
ENDU

hMapROMBank:: db

hSpriteVRAMSlotAndFacing:: db

hCoordsInFrontOfPlayerMatch::
hSpriteAnimFrameCounter::
	db

UNION
hSpriteScreenYCoord:: db
hSpriteScreenXCoord:: db
hSpriteMapYCoord::    db
hSpriteMapXCoord::    db

NEXTU
hItemAlreadyFound:: db
	ds 2
hDidntFindAnyHiddenEvent:: db

NEXTU
	ds 1
hSavedMapTextPtr:: dw
	ds 1
ENDU

	ds 4

hWhoseTurn:: db ; 0 on player's turn, 1 on enemy's turn

hClearLetterPrintingDelayFlags:: db

	ds 1

; bit 0: draw HP fraction to the right of bar instead of below (for party menu)
; bit 1: menu is double spaced
; bit 2: text is single spaced
hUILayoutFlags:: db

hFieldMoveMonMenuTopMenuItemX:: db

hJoyInput:: db

hDisableJoypadPolling:: db

	ds 5

ENDSECTION
