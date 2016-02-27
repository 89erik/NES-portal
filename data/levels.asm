.export levels_n
.export start_screen_data
.export level_1_data
.export level_2_data


.segment "DATA"
.include "data/constants.inc"

levels_n:     .byte 3

start_screen_data:
    .byte $0B, $0E, N_CHARACTER
    .byte $0C, $0E, E_CHARACTER
    .byte $0D, $0E, S_CHARACTER
    
    .byte $0F, $0E, P_CHARACTER
    .byte $10, $0E, O_CHARACTER
    .byte $11, $0E, R_CHARACTER
    .byte $12, $0E, T_CHARACTER
    .byte $13, $0E, A_CHARACTER
    .byte $14, $0E, L_CHARACTER
    .byte EOL 

level_1_data:
    .byte 0, 0, WALL_TILE
    .byte 0, 1, WALL_TILE
    .byte 0, 2, WALL_TILE
    .byte 0, 3, WALL_TILE
    .byte 0, 4, WALL_TILE
    .byte 0, 5, WALL_TILE
    .byte 0, 28, WALL_TILE
    .byte 1, 28, WALL_TILE
    .byte 2, 28, WALL_TILE
    .byte 3, 28, WALL_TILE
    .byte 4, 28, WALL_TILE
    .byte 5, 28, WALL_TILE
    .byte 6, 28, WALL_TILE
    .byte 7, 28, WALL_TILE
    .byte 8, 28, WALL_TILE
    .byte 9, 28, WALL_TILE
    .byte 10, 28, WALL_TILE
    .byte 11, 28, WALL_TILE
    .byte 12, 28, WALL_TILE
    .byte EOL 

level_2_data:
    .byte $0C, $0C, E_CHARACTER
    .byte $0D, $0C, R_CHARACTER
    .byte $0E, $0C, I_CHARACTER
    .byte $0F, $0C, K_CHARACTER
    
    .byte $0C, $0D, E_CHARACTER
    .byte $0D, $0D, R_CHARACTER
    .byte $0E, $0D, I_CHARACTER
    .byte $0F, $0D, K_CHARACTER

    .byte $0C, $0E, E_CHARACTER
    .byte $0D, $0E, R_CHARACTER
    .byte $0E, $0E, I_CHARACTER
    .byte $0F, $0E, K_CHARACTER
    .byte EOL 

