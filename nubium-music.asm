CPU 1

_ENABLE_LOOP = TRUE

VGM_ROM_SLOT = 4
VGM_DATA_ADDR = &A000
EXO_buffer = &900
EXO_table = &A00

MACRO SELECT_BANK
{
    LDA &F4
    PHA
    LDA #VGM_ROM_SLOT
    STA &F4
    STA &FE30
}
ENDMACRO

MACRO RESTORE_BANK
{
    PLA
    STA &F4
    STA &FE30
}
ENDMACRO

ORG &90

INCLUDE "exomiser.h.asm"
INCLUDE "vgmplayer.h.asm"

ORG &2A00

.start

.init       JMP music_init
.play       JMP music_play
.pause      JMP music_pause
.deinit     JMP music_deinit

.music_init
{
    SELECT_BANK
    LDX #LO(VGM_DATA_ADDR)
    LDY #HI(VGM_DATA_ADDR)
    JSR vgm_init_stream
    RESTORE_BANK
    
    SEI
    LDA &220
    STA old_eventv+1
    LDA #LO(event_callback)
    STA &220
    LDA &221
    STA old_eventv+2
    LDA #HI(event_callback)
    STA &221
    CLI
    RTS
}

.music_deinit
{
    JSR music_pause

    SEI
    LDA old_eventv+1
    STA &220
    LDA old_eventv+2
    STA &221
    CLI
    RTS
}

.music_play
{
    LDA #14
    LDX #4
    JMP &FFf4
}

.music_pause
{
    LDA #13
    LDX #4
    JSR &FFf4

    JMP vgm_silence_psg
}

.event_callback
{
    PHP

    CMP #4
    BNE not_vsync

    PHA
    PHX
    PHY

    SELECT_BANK
    JSR vgm_poll_player

    IF _ENABLE_LOOP
    LDA vgm_player_ended
    BEQ still_playing

    \\ Reboot our player
    LDX #LO(VGM_DATA_ADDR)
    LDY #HI(VGM_DATA_ADDR)
    JSR vgm_init_stream

    .still_playing
    ENDIF
    RESTORE_BANK

    PLY
    PLX
    PLA

    .not_vsync
    PLP
}
\\
.old_eventv
JMP &FFFF

INCLUDE "exomiser.asm"
INCLUDE "vgmplayer.asm"

.end

SAVE "PLAYER", start, end, init

PUTFILE "music/Sonic The Hedgehog - 16 - Marble Zone (unused).raw.exo", "MUSIC", &A000, 0
