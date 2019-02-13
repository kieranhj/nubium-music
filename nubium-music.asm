CPU 1

_ENABLE_LOOP = TRUE

VGM_ROM_SLOT = 4        ; defaults
VGM_DATA_ADDR = &A000   ; defaults
EXO_buffer = &900
EXO_table = &A00

MACRO SELECT_BANK
{
    LDA &F4
    PHA
    LDA vgm_data_bank   ;#VGM_ROM_SLOT
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

.vgm_data_addr      SKIP 2
.vgm_data_bank      SKIP 1
.vgm_loop_count     SKIP 1

INCLUDE "vgmplayer.h.asm"
INCLUDE "exomiser.h.asm"

.loop_pause         SKIP 1

ORG &2A00

.start

.init       JMP music_init
.play       JMP music_play
.pause      JMP music_pause
.deinit     JMP music_deinit

.music_init
{
    SELECT_BANK
    LDX vgm_data_addr       ;#LO(VGM_DATA_ADDR)
    LDY vgm_data_addr+1     ;#HI(VGM_DATA_ADDR)
    JSR vgm_init_stream
    RESTORE_BANK

    LDA #0
    STA loop_pause

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

    LDX loop_pause
    BNE pause_running

    LDX vgm_loop_count      ; N vsyncs before loop
    BEQ still_playing       ; 0=don't loop

    .pause_running
    DEX
    STX loop_pause
    BNE still_playing

    \\ Reboot our player
    LDX vgm_data_addr       ;#LO(VGM_DATA_ADDR)
    LDY vgm_data_addr+1     ;#HI(VGM_DATA_ADDR)
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

;PUTFILE "music/Sonic The Hedgehog - 16 - Marble Zone (unused).raw.exo", "MUSIC", &A000, 0
PUTFILE "music/exo/Lemmings - 10 - Dance of the Reed-Flutes.raw.exo", "MUSIC", &A000, 0
