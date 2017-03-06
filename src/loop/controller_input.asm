; ---[ PLAYER INPUT ]---
; Updates player velocity according to input from player

ControllerInput:
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
        JSR PlayerFalling
        BEQ :+
        JSR PlayBounceSound
        LDA #-20
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

    @determine_max_vertical_speed:
        LDA #MAX_VELOCITY
        STA tmp
        JSR PlayerFalling
        BNE :+
            LDA #MAX_VELOCITY
            STA tmp
        :

    ; -[CHECK LEFT BUTTON]-
        LDA PLAYER1_CTRL ; Left
        AND #1
        BEQ @right_button ; not pushed, moving on
            LDX x_velocity
            DEX
            DEX
            TAX
            JSR AbsoluteValue
            CMP tmp ; max velocity depending on whether player is falling
            BCS :+
                LDX x_velocity
                DEX
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
            INX
            TAX
            JSR AbsoluteValue
            CMP tmp ; max velocity depending on whether player is falling
            BCS :+
                LDX x_velocity
                INX
                INX
                STX x_velocity
            :

@end_of_task:
    RTS
