StartScreen:
    LDA #0
    STA level
    JSR SetAndLoadLevel

    LDA #FALSE
    JSR @set_bricks_present
    
    LDX #1
    JSR Sleep
    
    LDA #2
    @update_loop_outer:
        PHA
        
        LDA #TRUE
        JSR @set_bricks_present
        JSR @update_screen

        LDA #FALSE
        JSR @set_bricks_present
        JSR @update_screen
        
        @loop_maintenance:
            PLA
            TAX
            DEX
            TXA
            BNE @update_loop_outer

    LDA #TRUE
    JSR @set_bricks_present
    JSR @update_screen
    
    JSR @wait_for_controller

    LDX #1
    JSR Sleep
    LDA #FALSE
    JSR @set_bricks_present
    JSR @update_screen
    RTS

@update_screen:
    LDX #0
    @update_loop_inner:
        LDY #0
        TXA
        PHA
        LDX #FALSE
        JSR UpdateBackgroundTile
        JSR WaitForBackgroundDraw
        PLA
        TAX
        INX
        CPX n_bricks
        BCC @update_loop_inner
    RTS

; All brick_present <- A
@set_bricks_present:
    LDX #0
    @loop:
        STA brick_present, X
        INX
        CPX n_bricks
        BCC @loop
    RTS

@wait_for_controller:

    ; Set color
    LDA #0
    STA color_index
    LDA #3
    STA color_length
    LDX #0
    LDA #$15
    STA color, X
    INX
    LDA #$3C
    STA color, X
    INX
    LDA #9
    STA color, X
    
    LDA #1
    STA palette_offset

    LDA #0
    PHA

    LDA #1
    STA color_counter
    @wait:
        LDX color_counter
        DEX
        STX color_counter
        BNE @end_color_update
            LDX #15
            STX color_counter
            PLA
            TAX
            LDA color, X
            STA palette_value
            INX
            CPX color_length
            BCC :+
                LDX #0
            :
            TXA
            PHA
        @end_color_update:
        JSR WaitForVBlank
        JSR ReadController
        BEQ @wait
    PLA
    JSR ResetColor

    RTS
   
