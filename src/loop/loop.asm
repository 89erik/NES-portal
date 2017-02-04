; ----------------------------------------------- ;
; -----------------[ MAIN LOOP ]----------------- ;
; ----------------------------------------------- ;
; This part of the code runs once after every     ;
; V-blank and performs the physics of moving the  ;
; player according to input and vectors. This     ;
; loop repeats with the excact same frequency as  ;
; the PPU framerate.                              ;
; ----------------------------------------------- ;


MainLoop:
    LDA v_blank_complete
    BNE MainLoop

    LDA #FALSE
    STA v_blank_complete

    .include "src/loop/increment_counters.asm"

    ; Loop procedures
    .include "src/loop/controller_input.asm"
    JSR MovePlayer
    ;JSR PlayNoRemorse
    JMP MainLoop

