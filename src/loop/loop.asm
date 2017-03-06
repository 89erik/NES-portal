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

    @reset_loop:
        LDA #FALSE
        STA v_blank_complete
        LDA #DONT_KNOW
        STA falling

    JSR IncrementCounters
    JSR ControllerInput
    JSR MovePlayer
    ;JSR PlayNoRemorse

    JMP MainLoop

