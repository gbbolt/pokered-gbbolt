; arguments: length [0, 7], pitch change [-7, 7]
; length: length of time between pitch shifts
;         sometimes used with a value >7 in which case the MSB is ignored
; pitch change: positive value means increase in pitch, negative value means decrease in pitch
;               small magnitude means quick change, large magnitude means slow change
;               in signed magnitude representation, so a value of 8 is the same as (negative) 0
	; $10
DEF pitch_sweep_cmd EQU $10


	; $20
DEF sfx_note_cmd EQU $20

; arguments: length [0, 15], volume [0, 15], fade [-7, 7], frequency
; fade: positive value means decrease in volume, negative value means increase in volume
;       small magnitude means quick change, large magnitude means slow change
;       in signed magnitude representation, so a value of 8 is the same as (negative) 0
DEF square_note_cmd EQU sfx_note_cmd ; $20

; arguments: length [0, 15], volume [0, 15], fade [-7, 7], frequency
; fade: positive value means decrease in volume, negative value means increase in volume
;       small magnitude means quick change, large magnitude means slow change
;       in signed magnitude representation, so a value of 8 is the same as (negative) 0
DEF noise_note_cmd EQU sfx_note_cmd ; $20

; arguments: pitch, length [1, 16]


; arguments: instrument [1, 19], length [1, 16]
	; $b0
DEF drum_note_cmd EQU $B0

; arguments: instrument, length [1, 16]
; like drum_note but one 1 byte instead of 2
; can only be used with instruments 1-10, excluding 2
; unused


; arguments: length [1, 16]
	; $c0
DEF rest_cmd EQU $C0


; arguments: speed [0, 15], volume [0, 15], fade [-7, 7]
; fade: positive value means decrease in volume, negative value means increase in volume
;       small magnitude means quick change, large magnitude means slow change
;       in signed magnitude representation, so a value of 8 is the same as (negative) 0
	; $d0
DEF note_type_cmd EQU $D0

; arguments: speed [0, 15]
DEF drum_speed_cmd EQU note_type_cmd ; $d0


; arguments: octave [1, 8]
	; $e0
DEF octave_cmd EQU $E0


; when enabled, effective frequency used is incremented by 1
	; $e8
DEF toggle_perfect_pitch_cmd EQU $E8

	; $e9

; arguments: delay [0, 255], depth [0, 15], rate [0, 15]
; delay: time delay until vibrato effect begins
; depth: amplitude of vibrato wave
; rate: frequency of vibrato wave
	; $ea
DEF vibrato_cmd EQU $EA

; arguments: length [1, 256], octave [1, 8], pitch
	; $eb
DEF pitch_slide_cmd EQU $EB

; arguments: duty cycle [0, 3] (12.5%, 25%, 50%, 75%)
	; $ec
DEF duty_cycle_cmd EQU $EC

; arguments: tempo [0, $ffff]
; used to calculate note delay counters
; so a smaller value means music plays faster
; ideally should be set to $100 or less to guarantee no overflow
; if larger than $100, large note speed or note length values might cause overflow
; stored in big endian
	; $ed
DEF tempo_cmd EQU $ED

; arguments: left output enable mask, right output enable mask
	; $ee
DEF stereo_panning_cmd EQU $EE

	; $ef
DEF unknownmusic0xef_cmd EQU $EF

; arguments: left master volume [0, 7], right master volume [0, 7]
	; $f0
DEF volume_cmd EQU $F0


; when enabled, the sfx data is interpreted as music data
	; $f8
DEF execute_music_cmd EQU $F8


; arguments: duty cycle 1, duty cycle 2, duty cycle 3, duty cycle 4
	; $fc
DEF duty_cycle_pattern_cmd EQU $FC

; arguments: address
	; $fd
DEF sound_call_cmd EQU $FD

; arguments: count, address
	; $fe
DEF sound_loop_cmd EQU $FE

	; $ff
DEF sound_ret_cmd EQU $FF
