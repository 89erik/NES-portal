.export WaitForVBlank
.export ReadController
.export Exception
.export Sleep


.segment "CODE"
.include "data/constants.inc"

WaitForVBlank:
    LDA v_blank_complete
    BNE WaitForVBlank
    LDA #FALSE
    STA v_blank_complete
    RTS

; Sleep for amount of frames given by X
Sleep:
    JSR WaitForVBlank
    DEX
    BNE Sleep
    RTS


; A <- bitmap of controller
ReadController:
    LDA #0
    STA sub_routine_tmp

    ; Signal controller for read
    LDA #1
    STA PLAYER1_CTRL
    LDA #0
    STA PLAYER1_CTRL

    ; Read controller, sequence is as follows:
    ; A, B, Select, Start, Up, Down, Left, Right
    LDA PLAYER1_CTRL ; A
    LDX #0
    JSR save_to_bitmap

    LDA PLAYER1_CTRL ; B
    LDX #1
    JSR save_to_bitmap

    LDA PLAYER1_CTRL ; Select
    LDX #2
    JSR save_to_bitmap

    LDA PLAYER1_CTRL ; Start
    LDX #3
    JSR save_to_bitmap

    LDA PLAYER1_CTRL ; Up
    LDX #4
    JSR save_to_bitmap

    LDA PLAYER1_CTRL ; Down
    LDX #5
    JSR save_to_bitmap

    LDA PLAYER1_CTRL ; Left
    LDX #6
    JSR save_to_bitmap

    LDA PLAYER1_CTRL ; Right
    LDX #7
    JSR save_to_bitmap

    RTS

    save_to_bitmap:
        AND #1
        CPX #0
        : 
            BEQ :+
                ASL A
                DEX
                JMP :-
        :
        ORA sub_routine_tmp
        STA sub_routine_tmp
        RTS


; Halts until player pushes either of these bottons:
; start, up, down, left, right
WaitForController:
    ; Signal controller for read
    LDA #1
    STA PLAYER1_CTRL
    LDA #0
    STA PLAYER1_CTRL
    
    ; Read controller, sequence is as follows:
    ; A, B, Select, Start, Up, Down, Left, Right
    LDA PLAYER1_CTRL ; A
    LDA PLAYER1_CTRL ; B
    LDA PLAYER1_CTRL ; Select
    LDA PLAYER1_CTRL ; Start
    AND #1
    BNE @stop_waiting
    LDA PLAYER1_CTRL ; Up
    AND #1
    BNE @stop_waiting
    LDA PLAYER1_CTRL ; Down
    AND #1
    BNE @stop_waiting
    LDA PLAYER1_CTRL ; Left
    AND #1
    BNE @stop_waiting
    LDA PLAYER1_CTRL ; Right
    AND #1
    BNE @stop_waiting
    JMP WaitForController
    
    @stop_waiting:
    RTS

Exception:
    STA error_code
    LDX #$FF
    LDY #$FF
    :
    JMP Exception
