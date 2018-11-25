
\\ VGM Player module
\\ Include file
\\ Define ZP and constant vars only in here
\\ Customized version for Prince Of Persia 
\\       VGMs are exported as raw files, 50Hz packets, no header block
\\       VGM music is compressed using exomizer raw -c -m 256 <file.raw> -o <file.exo>
\\       VGM sfx are not compressed.

_ENABLE_AUDIO = TRUE				; enables output to sound chip (disable for silent testing/demo loop)
_ENABLE_VOLUME = FALSE
_ENABLE_SFX = FALSE
_ENABLE_BEATS = FALSE

\ ******************************************************************
\ *	Define global constants
\ ******************************************************************

VGM_MUSIC_BPM = 125
VGM_BEATS_PER_PATTERN = 8

VGM_FRAMES_PER_BEAT = 50 * (60.0 / VGM_MUSIC_BPM)
VGM_FRAMES_PER_PATTERN = VGM_FRAMES_PER_BEAT * VGM_BEATS_PER_PATTERN

\ ******************************************************************
\ *	Declare ZP variables
\ ******************************************************************

\\ Player vars
.vgm_player_ended			SKIP 1		; non-zero when player has reached end of tune

IF _ENABLE_SFX
.vgm_sfx_addr               SKIP 2      ; currently playing sfx memory address
ENDIF

IF _ENABLE_BEATS
.vgm_beat_frames            SKIP 1
.vgm_beat_counter           SKIP 1
.vgm_pattern_counter        SKIP 1
ENDIF
