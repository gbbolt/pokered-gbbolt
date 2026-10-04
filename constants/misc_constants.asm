; Boolean checks
DEF FALSE EQU 0
DEF TRUE  EQU 1

; flag operations
	; 0
DEF FLAG_RESET EQU 0
	; 1
DEF FLAG_SET EQU 1
	; 2
DEF FLAG_TEST EQU 2

; input
DEF NO_INPUT EQU 0

; SGB command MLT_REQ can be used to detect SGB hardware
DEF JOYP_SGB_MLT_REQ EQU %00000011
