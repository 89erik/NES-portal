.export DisablePpuRendering
.export EnablePpuRendering
.export DrawScore
.export DrawLevel
.export UpdateBackgroundTile
.export WaitForBackgroundDraw
.export ResetColor

.segment "CODE"
.include "data/constants.inc"

DisablePpuRendering:
    LDA #0
    STA PPU_CTRL_1
    STA PPU_CTRL_2
    RTS

EnablePpuRendering:
    LDA #%10010000 ; V-Blank interrupt ON, Sprite size = 8x8, Nametable 0
    STA ppu_ctrl_1 ; BG tiles = $1000, Spr tiles = $0000, PPU adr inc = 1B
    STA PPU_CTRL_1
    LDA #%00011110
    STA PPU_CTRL_2
    RTS

; Draws/updates the current score on screen
DrawScore:
    LDA score
    LDY #4 ; Offset for high digit
    CMP #10
    BCS @p1_two_digits
    @p1_one_digit:
        CLC
        ADC #SPRITE_NUMBERS_OFFSET
        STA score_tile ; low digit
        LDA #SPRITE_NUMBERS_OFFSET
        STA score_tile, Y ; high digit
        
        RTS
    @p1_two_digits:
        JSR @split_digits
        
        CLC
        ADC #SPRITE_NUMBERS_OFFSET
        STA score_tile ; low digit
        
        TXA
        CLC
        ADC #SPRITE_NUMBERS_OFFSET
        STA score_tile, Y ; high digit
        
        RTS
        
    ; Input:    A = two-digit input
    ; Output:   X = high digit
    ;           A = low digit
    @split_digits:
        LDX #0
        @check_again:
            INX 
            SEC
            SBC #10
            CMP #10
            BCS @check_again
        RTS

; Queues all bricks of the currently loaded level to
; be updated by the V-blank.
; A = write to next nametable? (TRUE/FALSE)
DrawLevel:
    STA sub_routine_arg1
    LDY #0 ; Tile index
    @loop:
        LDA sub_routine_arg1
        PHA
        TAX ; X <- write to next nametable?
        TYA ; A <- tile index
		PHA ; Preserve Y
        JSR UpdateBackgroundTile
		PLA
		TAY ; Retrieve Y
        PLA
        STA sub_routine_arg1
        INY
        CPY n_bricks
        BCC @loop
    STY last_brick_to_update
    RTS

; Adds tile to the list of background tiles to be updated,
; indexed by A. Also calculates PPU addresses to take a load
; off the V-Blank routine.
; A = background tile index
; X = write to next nametable? (TRUE/FALSE)
UpdateBackgroundTile:
    TAY
    TXA
    PHA     ; Stack = X
    TYA
    PHA     ; Stack = A, X
    LDA first_brick_to_update
    CMP last_brick_to_update
    BNE @end_equality_check
        LDA #0
        STA first_brick_to_update
        STA last_brick_to_update
    @end_equality_check:

    @add_tile_to_list:
        PLA
        LDX last_brick_to_update
        STA bricks_to_update, X

    @calculate_ppu_address:
        LDX last_brick_to_update
        LDA bricks_to_update, X
        TAX                     ; X <- bricks_to_update[i]
        LDA brick_x, X          ; A <- brick_x[X]
        PHA                     ; push(brick_x[X])
        LDA brick_y, X          ; A <- brick_y[X]
        STA sub_routine_arg1
        LDA #NAME_TABLE_WIDTH
        STA sub_routine_arg2
        @multiply_rows:
            JSR MultiplyLong        ; XY <- brick_y[X] * NAME_TABLE_WIDTH
        @add_column:
            PLA                     ; A <- pull(brick_y[X])
            JSR AccumulateLong
        @add_name_table_offset:
            PLA
            BNE @current
            @next:
                LDA ppu_ctrl_1
                AND #%00000001
                BEQ @use_nametable2
                JMP @use_nametable1
            @current:
                LDA ppu_ctrl_1
                AND #%00000001
                BEQ @use_nametable1
                JMP @use_nametable2
                
            @use_nametable1:
                LDA #NAMETABLE1_H
                JMP @end_set_nametable
            @use_nametable2:
                LDA #NAMETABLE2_H
            @end_set_nametable:
            
            STA sub_routine_arg1
            LDA #NAMETABLES_L
            STA sub_routine_arg2
            JSR AddLong
        @store_addresses:
            TXA
            LDX last_brick_to_update
            STA brick_to_update_high_addrs, X
            TYA
            STA brick_to_update_low_addrs, X
        INX
        STX last_brick_to_update
    RTS

WaitForBackgroundDraw:
    LDA first_brick_to_update
    CMP last_brick_to_update
    BNE WaitForBackgroundDraw
    RTS

; Reverts the last updated color to its original value
ResetColor:
    LDX palette_offset
    LDA palette_rom, X
    STA palette_value
    RTS
