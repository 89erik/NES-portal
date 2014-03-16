SetAndLoadLevel:
    LDA level
    CMP #0
    BEQ @start_screen
    CMP #1
    BEQ @l1
    JMP @end_case
    
    @start_screen:
        LDA #>start_screen_data
        LDX #1
        STA level_data, X
        LDA #<start_screen_data
        STA level_data
        
        LDA start_screen_n_data
        STA level_n_data
        JMP @end_case
    @l1:
        LDA #<level_1_data
        STA level_data
        LDA #>level_1_data
        LDX #1
        STA level_data, X
        
        LDA level_1_n_data
        STA level_n_data
        JMP @end_case
    @end_case:

LoadLevel:
    LDX #0
    LDY #0
    
    CPX level_n_data
    BCS @end_while
    @next_tile:
        LDA (<level_data), Y
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
        CPX level_n_data
        BCC @next_tile
    @end_while:
        
    STX n_bricks
    RTS

DrawLevel:
    LDX #0
    STX first_brick_to_update
    STX last_brick_to_update
    @loop:
        TXA
        PHA
        JSR UpdateBackgroundTile
        PLA
        TAX
        INX
        CPX n_bricks
        BCC @loop
    STX last_brick_to_update
    RTS
