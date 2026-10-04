; Pseudo-OAM flags used by game logic
	; 0
DEF BIT_END_OF_OAM_DATA EQU 0
	; 1
DEF BIT_SPRITE_UNDER_GRASS EQU 1

; Used in SpriteFacingAndAnimationTable (see data/sprites/facings.asm)
DEF FACING_END  EQU 1 << BIT_END_OF_OAM_DATA
DEF UNDER_GRASS EQU 1 << BIT_SPRITE_UNDER_GRASS
