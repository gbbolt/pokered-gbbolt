; width of east/west connections
; height of north/south connections
DEF MAP_BORDER EQU 3

; connection directions
DEF EAST_F EQU 0
DEF WEST_F EQU 1
DEF SOUTH_F EQU 2
DEF NORTH_F EQU 3

; wCurMapConnections
	; 1
DEF EAST EQU 1
	; 2
DEF WEST EQU 2
	; 4
DEF SOUTH EQU 4
	; 8
DEF NORTH EQU 8

; wWarpEntries
DEF MAX_WARP_EVENTS EQU 32

; wNumSigns
DEF MAX_BG_EVENTS EQU 16

; wMapSpriteData
DEF MAX_OBJECT_EVENTS EQU 16

; flower and water tile animations
	; 0
DEF TILEANIM_NONE EQU 0
	; 1
DEF TILEANIM_WATER EQU 1
	; 2
DEF TILEANIM_WATER_FLOWER EQU 2
