; ---[ PLAYER INPUT ]---
; Updates player velocity according to input from player

PlayerInput:
    ; Signal controller for read
    LDA #1
    STA PLAYER1_CTRL
    LDA #0
    STA PLAYER1_CTRL

    ; Read controller, sequence is as follows:
    ; A, B, Select, Start, Up, Down, Left, Right
    
    ; -[CHECK A BUTTON]-
    LDA PLAYER1_CTRL ; A
    AND #1
    BEQ :+ ; not pushed
        LDA falling
        BEQ :+
        LDA #TRUE
        STA falling
        JSR PlayBounceSound
        LDA #%11110000
        STA y_velocity
    :

    ; -[CHECK B BUTTON]-
        LDX #FALSE
        LDA PLAYER1_CTRL ; B
        AND #1
        BEQ @end_check_b
            LDX #TRUE
        @end_check_b:
        STX boosting

        LDA PLAYER1_CTRL ; Select
        LDA PLAYER1_CTRL ; Start
        LDA PLAYER1_CTRL ; Up
        LDA PLAYER1_CTRL ; Down

    ; -[CHECK LEFT BUTTON]-
        LDA PLAYER1_CTRL ; Left
        AND #1
        BEQ @right_button ; not pushed, moving on
            LDX x_velocity
            DEX
            TAX
            JSR AbsoluteValue
            CMP #MAX_VELOCITY
            BCS :+
                LDX x_velocity
                DEX
                STX x_velocity
            :
    
    ; -[CHECK RIGHT BUTTON]-
    @right_button:
        LDA PLAYER1_CTRL ; Right
        AND #1
        BEQ @end_of_task
            LDX x_velocity
            INX
            TAX
            JSR AbsoluteValue
            CMP #MAX_VELOCITY
            BCS :+
                LDX x_velocity
                INX
                STX x_velocity
            :

@end_of_task:
