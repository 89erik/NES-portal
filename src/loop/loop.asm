; ----------------------------------------------- ;
; -----------------[ MAIN LOOP ]----------------- ;
; ----------------------------------------------- ;
; This part of the code runs once after every     ;
; V-blank and performs the physics of moving the  ;
; racket according to input, and the ball         ;
; according to its vectors. This loops repeats    ;
; with the excact same frequency as the PPU       ;
; framerate.                                      ;
; ----------------------------------------------- ;


MainLoop:
    LDA v_blank_complete
    BNE MainLoop
    
    LDA #FALSE
    STA v_blank_complete

    .include "src/loop/increment_counters.asm"

    ; Loop procedures
    .include "src/loop/player_placement.asm"          ; Places the player
    ;JSR PlayNoRemorse
    JMP MainLoop

    ; Subroutines
    .include "src/loop/check_hit_brick.asm"
