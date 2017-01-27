PlayerPlacement:

    @air_friction:
        LDA x_velocity
        BEQ :+
            JSR SignedDecrease
            STA x_velocity
        :
    @gravity:
        LDA falling
        BEQ :+
            LDA #0
            STA y_velocity
            JMP @end_gravity
        :
        LDA gravity_counter
        BNE @end_gravity
        @fall:
            LDA y_velocity
            BEQ @zero
            CMP #$FF
            BEQ @minus_one
            JSR SignedIsNegative
            BEQ @negative
            @positive:
                LDA y_velocity
                ASL
                JMP @end_case
            @zero:
                LDA #1
                JMP @end_case
            @minus_one:
                LDA #0
                JMP @end_case
            @negative:
                LDA y_velocity
                JSR ASR
            @end_case:
            STA y_velocity
        @enforce_max_falling_velocity:
            STA sub_routine_arg1
            LDA #MAX_FALLING_VELOCITY
            STA sub_routine_arg2
            JSR SignedComparison
            BCC :+
                LDA #MAX_FALLING_VELOCITY
                STA y_velocity
            :    
    @end_gravity:
        
    @move_player:
        LDX #0
        LDY #0
        @move_more:
            JSR @ApproachX
            JSR @ApproachY
            JSR CheckHitBrick
            BNE @no_hit
                LDA #FALSE
                STA falling
                JMP @end_approach_routines
            @no_hit:
            CPY y_velocity
            BNE @move_more
            CPX x_velocity
            BNE @move_more        
        JMP @end_approach_routines
        
            @ApproachX:
                CPX x_velocity
                BEQ @end_approach_x
                
                LDA x_velocity
                JSR SignedIsNegative
                BEQ @x_negative
                @x_positive:
                    TXA
                    LDX player_x
                    INX
                    STX player_x
                    TAX
                    INX
                    JMP @end_approach_x
                @x_negative:
                    TXA
                    LDX player_x
                    DEX
                    STX player_x
                    TAX
                    DEX
                @end_approach_x:
                    RTS
                    
            @ApproachY:
                CPY y_velocity
                BEQ @end_approach_y
                
                LDA y_velocity
                JSR SignedIsNegative
                BEQ @y_negative
                @y_positive:
                    TYA
                    LDY player_y
                    INY
                    STY player_y
                    TAY
                    INY
                    JMP @end_approach_y
                @y_negative:
                    TYA
                    LDY player_y
                    DEY
                    STY player_y
                    TAY
                    DEY
                @end_approach_y:
                    RTS
                    
        @stop:  LDA #$fa
                LDY #$fa
                LDX #$fa
                JMP @stop
        @end_approach_routines:   
    
    ; ---[ HIT ONE OF THE WALLS? ]---
    @check_x_edge:
        LDA player_x
        CMP #LEFT_WALL
        BCC @wall_hit
        CMP #RIGHT_WALL
        BCS @wall_hit
        JMP @check_y_edge

        @wall_hit:
            LDA #0
            STA x_velocity
            JSR PlayBounceSound
            JMP @end_of_task ; JMP to @check_y_edge?

        ; -[HIT ROOF OR FLOOR?]-
    @check_y_edge:
        LDA y_velocity
        JSR SignedIsNegative    ; Check if y-velocity is negative
        BEQ @ball_moves_upward

        @ball_moves_downward:
            LDA player_y
            CMP #RACKET_Y-SPRITE_SIZE
            BCS @past_racket ; greater or equal
            JMP @end_of_task  ; No hit
        
        @ball_moves_upward:
            LDA player_y
            CMP #ROOF            ; Hit roof
            BEQ @invert_y_velocity
			BCC @overhit
            CMP #FLOOR+1         ; Past roof, underflow
            BCS @overhit
            JMP @end_of_task     ; No hit
			@overhit:
				LDA #ROOF
				STA player_y
				JMP @invert_y_velocity
				

        @past_racket:
            ; Ball is below racket limit, reached floor yet?
            CMP #FLOOR+SPRITE_SIZE
            BCC @end_of_task ; Hit
                LDA #0
                STA y_velocity
                ;JSR RacketMiss   ; No hit
            JMP @end_of_task
            
        @invert_y_velocity:
            ; Bounce ball
            LDA #0
            SEC
            SBC y_velocity
            STA y_velocity
            JSR PlayBounceSound
            JMP @end_of_task

    @end_of_task:









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
    LDA PLAYER1_CTRL ; A

    AND #1
    BEQ @ignore_A_button ; not pushed
        LDA falling
        BEQ @ignore_A_button
        LDA #TRUE
        STA falling
        JSR PlayBounceSound
        LDA #%11110000
        STA y_velocity

    @ignore_A_button:
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
        BEQ @right_button
        LDA boosting
        BEQ @fast_l
        @slow_l:
            LDA x_velocity
            SEC
            SBC #RACKET_SPEED/2
            PHA
            JSR AbsoluteValue
            STA sub_routine_arg1
            LDA #MAX_VELOCITY
            STA sub_routine_arg2
            JSR SignedComparison
            BCS @set_max_speed_l
                PLA
                STA x_velocity
                JMP @end_speed_check_l
            @set_max_speed_l:
                PLA ; remove unused stack item
                LDA #0
                SEC
                SBC #MAX_VELOCITY
                STA x_velocity
                JMP @end_speed_check_l
        @fast_l:
            LDA x_velocity
            SEC
            SBC #RACKET_SPEED
        @end_speed_check_l:
        CMP #LEFT_WALL
        BCS @left_move_in_bounds
        LDA #LEFT_WALL
    @left_move_in_bounds:
        STA x_velocity
    @turn_player_left:
        LDA #PLAYER_TILE_LEFT
        STA player_tile

        JMP @end_of_task

    ; -[CHECK RIGHT BUTTON]-
    @right_button:
        LDA PLAYER1_CTRL ; Right
        AND #1
        BEQ @end_of_task

        LDA boosting
        BEQ @fast_r
        @slow_r:
            LDA x_velocity
            CLC
            ADC #RACKET_SPEED/2
            PHA
            STA sub_routine_arg1
            LDA #MAX_VELOCITY
            STA sub_routine_arg2
            JSR SignedComparison
            BCS @set_max_speed_r
                PLA
                STA x_velocity
                JMP @end_speed_check_r
            @set_max_speed_r:
                PLA ; remove unused stack item
                LDA #MAX_VELOCITY
                STA x_velocity
                JMP @end_speed_check_r
            
            JMP @end_speed_check_r
        @fast_r:
            LDA x_velocity
            CLC
            ADC #RACKET_SPEED
        @end_speed_check_r:
    @right_move_in_bounds:
        STA x_velocity
    @turn_player_right:
        LDA #PLAYER_TILE_RIGHT
        STA player_tile

    @end_of_task:
