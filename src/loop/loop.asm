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
    JSR WaitForVBlank
    
    @reset_loop:
        LDA #DONT_KNOW
        STA falling

    JSR IncrementCounters
    JSR ControllerInput
    JSR MovePlayer
    ;JSR PlayNoRemorse

    JMP MainLoop

