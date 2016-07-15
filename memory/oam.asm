; ------------------------------------------------- ;
; ----------[ OBJECT ATTRIBUTE MEMORY ]------------ ;
; ------------------------------------------------- ;
; Contains the memory locations of the OAM, which   ;
; keep tracks of the sprites.                       ;
; ------------------------------------------------- ;   
    
    player_y:                     .byte 0
    player_tile:                  .byte 0
    player_attribute:             .byte 0
    player_x:                     .byte 0

    score_y:                    .byte 0
    score_tile:                 .byte 0
    score_attribute:            .byte 0
    score_x:                    .byte 0
                                .byte 0,0,0,0   ; high digit

    token_y:                    .byte 0
    token_tile:                 .byte 0
    token_attribute:            .byte 0
    token_x:                    .byte 0
