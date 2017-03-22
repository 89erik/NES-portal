.export V_blank

.segment "CODE" 
.include "data/constants.inc"

; ---[ V-BLANK INTERRUPT ]---
V_blank:
    PHA             ; Preserve A
    TXA
    PHA             ; Preserve X
    TYA
    PHA             ; Preserve Y
    
    LDA PPU_STATUS  ; Clear adress part latch

    ; -[UPDATE PALETTE]-
    LDA #PALETTE_VRAM_PAGE
    STA PPU_ADDRESS
    LDA palette_offset
    STA PPU_ADDRESS
    LDA palette_value
    STA PPU_VALUE

    ; -[UPDATE PPU CONTROL REGISTERS]-
    LDA ppu_ctrl_1
    STA PPU_CTRL_1      
    
    ; -[DMA OAM UPDATE]-
    LDA #$00
    STA SPR_RAM_ADDRESS
    LDA #$07                ; OAM page, defined in linker_config.cfg
    STA SPR_RAM_DMA
    
    ; -[UPDATE BACKGROUND]-
    LDA first_brick_to_update
    CMP last_brick_to_update
    BEQ @end_update_background
        JSR @update_background
    @end_update_background:
            
    ; -[SET SCROLL]-
    LDA scroll
    STA PPU_SCROLL
    LDA #0
    STA PPU_SCROLL

    ; -[PREPARE FOR RETURN]-
    LDA #TRUE
    STA v_blank_complete

    PLA
    TAY             ; Retrieve Y
    PLA
    TAX             ; Retrieve X
    PLA             ; Retrieve A
    RTI             ; ReTurn from Interrupt


    @update_background:
        @set_ppu_address:
            LDX first_brick_to_update
            LDA brick_to_update_high_addrs, X
            STA PPU_ADDRESS
            LDA brick_to_update_low_addrs, X
            STA PPU_ADDRESS
        @store_tile_to_ppu:
            LDA bricks_to_update, X
            TAX                     ; X <- bricks_to_update[i]
            LDA brick_tile, X
            STA PPU_VALUE
        @increase_index:
            LDX first_brick_to_update
            INX                     ; X <- i+1
            STX first_brick_to_update
        RTS
