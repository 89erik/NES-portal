; ------------------------------------------------ ;
; ---------------[ INITIALIZATION ]--------------- ;
; ------------------------------------------------ ;
; The CPU starts here at boot. This part of the    ;
; code will set up the memory and PPU.             ;
; ------------------------------------------------ ;

; -[WAIT 2 FRAMES FOR PPU BOOT]-
:   LDA PPU_STATUS
    BPL :-
:   LDA PPU_STATUS
    BPL :-

; -[TURN OFF RENDERING]-
    JSR DisablePpuRendering

; -[LOAD PALETTE INTO VRAM]-
    LDA #PALETTE_VRAM_PAGE
    STA PPU_ADDRESS  ; PPU address = start of palette
    LDA #$00
    STA PPU_ADDRESS      
    
    LDX #0
    @load_palette:
        LDA palette_rom, X
        STA PPU_VALUE
        INX
        CPX #32
        BNE @load_palette
    LDA #$FF
    STA palette_offset ; avoids unintentional palette updates
    
; -[INIT STACK]-
    LDX #$FF
    TXS
    LDA #STACK_PAGE
    LDX #1
    STA fp, X

; -[INIT STATE VARIABLES]-
    LDA #0
    STA bg_color
    LDA #0
    STA x_velocity
    STA y_velocity
    LDA #INITIAL_SCORE
    STA score
    LDA #0
    STA first_brick_to_update
    STA last_brick_to_update
    LDA #0
    STA scroll
    STA music_index
    STA gravity_counter
    STA error_code
    JSR NoRemorseInitVariables
    
; -[INIT GAME-INDEPENDENT OAM DATA]-
    ; PLAYER 1 AND 2 SCORES 
        LDX #4 ; offset for high digit
        
        ; y pos
        LDA #32
        STA score_y          ; p1 low digit
        STA score_y, X       ; p1 high digit

        ; x pos
        LDA #32 
        STA score_x, X       ; p1 high digit
        LDA #40
        STA score_x          ; p1 low digit
        
        LDA #0 ; attribute byte
        STA score_attribute          ; p1 low digit
        STA score_attribute, X       ; p1 high digit

        ; Score initially invisible
        LDA #0
        STA score_tile    ; low digit
        STA score_tile, X ; high digit
    
    JSR FillBackground
    
; -[INIT PPU (ENABLES RENDERING)]-
    JSR EnablePpuRendering
    
; -[LAUNCH START SCREEN]-    
    JSR StartScreen

; -[LOAD LEVEL 1]-
    LDA #1
    STA level
    JSR SetAndLoadLevel
    LDA #FALSE
    JSR DrawLevel
    JSR DrawScore


; -[SHOW PLAYER]-
    LDA #PLAYER_TILE_LEFT
    STA player_tile
    LDA #%00000001; (Palette 1)
    STA player_attribute

    LDA #100
    STA player_x
    STA player_y

