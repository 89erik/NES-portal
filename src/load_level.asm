SetAndLoadLevel:
    LDA level
    CMP #0
    BEQ @start_screen
    CMP #1
    BEQ @l1
    CMP #2
    BEQ @l2
    LDA #UNDEFINED_LEVEL
    JMP Exception
    
    @start_screen:
        LDA #>start_screen_data
        LDX #1
        STA level_data, X
        LDA #<start_screen_data
        STA level_data
        
        JMP @end_case
    @l1:
        LDA #<level_1_data
        STA level_data
        LDA #>level_1_data
        LDX #1
        STA level_data, X
        
        JMP @end_case
    @l2:
        LDA #<level_2_data
        STA level_data
        LDA #>level_2_data
        LDX #1
        STA level_data, X
        
        JMP @end_case
    @end_case:
    
LoadLevel:
    LDX #0
    LDY #0
    
    @next_tile:
        LDA (<level_data), Y
        CMP #EOL
        BEQ @end_while
        STA brick_x, X
        INY
        LDA (<level_data), Y
        STA brick_y, X
        INY
        LDA (<level_data), Y
        STA brick_tile, X
        INY
        LDA #TRUE
        STA brick_present, X
        INX
        JMP @next_tile
    @end_while:
        
    STX n_bricks
    RTS
