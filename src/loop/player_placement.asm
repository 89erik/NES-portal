MovePlayer:
    @perform_movement:
        LDA player_x
        CLC
        ADC x_velocity
        STA player_x

        LDA player_y
        CLC
        ADC y_velocity
        STA player_y

        LDA x_velocity
        JSR SignedDecrease
        STA x_velocity

    JSR PlayerCollision
    BNE @no_collisions
    @collision:
        LDA player_x
        SEC
        SBC x_velocity
        STA player_x

        LDA player_y
        SEC
        SBC y_velocity
        STA player_y

        LDA #0
        STA y_velocity
        STA x_velocity
        JMP @done; we have stopped all movement, and can return

    @no_collisions:
        JSR PlayerFalling
        BEQ @falling
        @not_falling:
            LDA #0
            STA y_velocity
            JMP @done
        @falling:
            LDA y_velocity
            JSR SignedIsNegative
            BEQ @execute_gravity
            LDA y_velocity
            CMP #MAX_FALLING_VELOCITY
            BCS @done
            @execute_gravity:
                LDA gravity_counter
                BNE @done
                    LDA y_velocity
                    BNE :+ ; velocity is zero
                        LDA #1
                        STA y_velocity
                        JMP @done
                    :
                    JSR SignedIsNegative
                    BEQ @upwards
                    @downwards:
                        LDA y_velocity
                        ASL
                        STA y_velocity
                        JMP @done
                    @upwards:
                        LDA y_velocity
                        JSR ASR
                        STA y_velocity

    @done:
        RTS

PlayerFalling:
    LDA falling
    CMP #DONT_KNOW
    BEQ :+
        LDA falling
        RTS
    :

    LDY player_y
    INY
    STY player_y
    JSR PlayerCollision
    LDY player_y
    DEY
    STY player_y
    CMP #FALSE
    BEQ @true
    @false:
        LDA #FALSE
        JMP @endif
    @true:
        LDA #TRUE
    @endif:
    STA falling
    RTS


; Has player collided into brick? TRUE : FALSE
PlayerCollision:
    LDY #0

    @loop_header:
        CPY n_bricks
        BCS @end_of_loop
    @loop_body:
        LDA brick_x, Y
        LDX #SPRITE_SIZE
        JSR Multiply
        STA sub_routine_arg1
        LDA brick_y, Y
        LDX #SPRITE_SIZE
        JSR Multiply
        STA sub_routine_arg2
        @save_index:
            TYA
            PHA
        LDX player_x
        LDY player_y
        JSR TilesOverlap
        BEQ @found_collision
        @loop_maintenance:
            PLA
            TAY
            INY
        JMP @loop_header
    
    @end_of_loop:
        LDA #FALSE
        RTS
    @found_collision:
        PLA ; stack still contains loop index
        LDA #TRUE
        RTS
