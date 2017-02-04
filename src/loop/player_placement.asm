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
        STA x_velocity
        STA y_velocity
        JMP @done; we have stopped all movement, and can return

    @no_collisions:
    @is_player_falling:

        LDY player_y
        INY
        STY player_y
        JSR PlayerCollision
        LDY player_y
        DEY
        STY player_y
        CMP #FALSE
        BEQ @falling
        @not_falling:
            LDA #0
            STA x_velocity
            STA y_velocity
            JMP @done
        @falling:
            LDA y_velocity
            JSR AbsoluteValue
            CMP #MAX_FALLING_VELOCITY
            BCS @done
            @fall_faster:
                LDA y_velocity
                JSR SignedIncrease ; TODO increase exponentially
                STA y_velocity

    @done:
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
