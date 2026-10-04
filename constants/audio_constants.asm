; pitch
; Audio[1|2|3]_Pitches indexes (see audio/notes.asm)
	; 0
DEF C_ EQU 0
	; 1
DEF C# EQU 1
	; 2
DEF D_ EQU 2
	; 3
DEF D# EQU 3
	; 4
DEF E_ EQU 4
	; 5
DEF F_ EQU 5
	; 6
DEF F# EQU 6
	; 7
DEF G_ EQU 7
	; 8
DEF G# EQU 8
	; 9
DEF A_ EQU 9
	; A
DEF A# EQU $A
	; B
DEF B_ EQU $B
DEF NUM_NOTES EQU $C

; channel
; Audio[1|2|3]_HWChannelBaseAddresses, Audio[1|2|3]_HWChannelDisableMasks,
; and Audio[1|2|3]_HWChannelEnableMasks indexes (see audio/engine_[1|2|3].asm)
	; 0
DEF CHAN1 EQU 0
	; 1
DEF CHAN2 EQU 1
	; 2
DEF CHAN3 EQU 2
	; 3
DEF CHAN4 EQU 3
DEF NUM_MUSIC_CHANS EQU 4
	; 4
DEF CHAN5 EQU 4
	; 5
DEF CHAN6 EQU 5
	; 6
DEF CHAN7 EQU 6
	; 7
DEF CHAN8 EQU 7
DEF NUM_NOISE_CHANS EQU 4
DEF NUM_CHANNELS EQU 8

; HW sound channel register base addresses
DEF HW_CH1_BASE EQU LOW(rAUD1SWEEP)
DEF HW_CH2_BASE EQU LOW(rAUD2LEN) - 1
DEF HW_CH3_BASE EQU LOW(rAUD3ENA)
DEF HW_CH4_BASE EQU LOW(rAUD4LEN) - 1

; HW sound channel enable bit masks
DEF HW_CH1_ENABLE_MASK EQU %00010001
DEF HW_CH2_ENABLE_MASK EQU %00100010
DEF HW_CH3_ENABLE_MASK EQU %01000100
DEF HW_CH4_ENABLE_MASK EQU %10001000

; HW sound channel disable bit masks
DEF HW_CH1_DISABLE_MASK EQU (~HW_CH1_ENABLE_MASK & $ff)
DEF HW_CH2_DISABLE_MASK EQU (~HW_CH2_ENABLE_MASK & $ff)
DEF HW_CH3_DISABLE_MASK EQU (~HW_CH3_ENABLE_MASK & $ff)
DEF HW_CH4_DISABLE_MASK EQU (~HW_CH4_ENABLE_MASK & $ff)

	; 1
DEF REG_DUTY_SOUND_LEN EQU 1
	; 2
DEF REG_VOLUME_ENVELOPE EQU 2
	; 3
DEF REG_FREQUENCY_LO EQU 3

; wChannelFlags1 constants
	; 0 ; controlled by toggle_perfect_pitch command
DEF BIT_PERFECT_PITCH EQU 0
	; 1 ; if in sound call
DEF BIT_SOUND_CALL EQU 1
	; 2 ; if channel is the music noise channel or an SFX channel
DEF BIT_NOISE_OR_SFX EQU 2
	; 3 ; if the pitch is above or below normal (cycles)
DEF BIT_VIBRATO_DIRECTION EQU 3
	; 4 ; if pitch slide is active
DEF BIT_PITCH_SLIDE_ON EQU 4
	; 5 ; if the pitch slide frequency is decreasing (instead of increasing)
DEF BIT_PITCH_SLIDE_DECREASING EQU 5
	; 6 ; if rotating duty cycle
DEF BIT_ROTATE_DUTY_CYCLE EQU 6

; wChannelFlags2 constant (only has one flag)
DEF BIT_EXECUTE_MUSIC EQU 0 ; if in execute music

; wMuteAudioAndPauseMusic
DEF BIT_MUTE_AUDIO EQU 7

; wLowHealthAlarm
DEF BIT_LOW_HEALTH_ALARM EQU 7
DEF LOW_HEALTH_TIMER_MASK EQU %01111111
DEF DISABLE_LOW_HEALTH_ALARM EQU $ff
