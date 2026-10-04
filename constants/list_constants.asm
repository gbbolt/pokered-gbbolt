; list menu IDs
	; $00 ; PC pokemon withdraw/deposit lists
DEF PCPOKEMONLISTMENU EQU 0
	; $01 ; XXX where is this used?
DEF MOVESLISTMENU EQU 1
	; $02 ; Pokemart buy menu / Pokemart buy/sell choose quantity menu
DEF PRICEDITEMLISTMENU EQU 2
	; $03 ; Start menu Item menu / Pokemart sell menu
DEF ITEMLISTMENU EQU 3
	; $04 ; list of special "items" e.g. floor list in elevators / list of badges
DEF SPECIALLISTMENU EQU 4

; NamePointers indexes (see home/names2.asm)
	; 1
DEF MONSTER_NAME EQU 1
	; 2
DEF MOVE_NAME EQU 2
	; 3
DEF UNUSED_NAME EQU 3
	; 4
DEF ITEM_NAME EQU 4
	; 5
DEF PLAYEROT_NAME EQU 5
	; 6
DEF ENEMYOT_NAME EQU 6
	; 7
DEF TRAINER_NAME EQU 7

	; 1
DEF INIT_ENEMYOT_LIST EQU 1
	; 2
DEF INIT_BAG_ITEM_LIST EQU 2
	; 3
DEF INIT_OTHER_ITEM_LIST EQU 3
	; 4
DEF INIT_PLAYEROT_LIST EQU 4
	; 5
DEF INIT_MON_LIST EQU 5
