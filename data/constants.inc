
; ---[ SYSTEM ADRESSES ]---
PPU_CTRL_1              = $2000
PPU_CTRL_2              = $2001
PPU_STATUS              = $2002
SPR_RAM_ADDRESS         = $2003
SPR_RAM_VALUE           = $2004
PPU_SCROLL              = $2005
PPU_ADDRESS             = $2006
PPU_VALUE               = $2007

PLAYER1_CTRL            = $4016
PLAYER2_CTRL            = $4017

SPR_RAM_DMA             = $4014

APU_SQUARE_1_1          = $4000
APU_SQUARE_1_2          = $4001
APU_SQUARE_1_3          = $4002
APU_SQUARE_1_4          = $4003

APU_SQUARE_2_1          = $4004
APU_SQUARE_2_2          = $4005
APU_SQUARE_2_3          = $4006
APU_SQUARE_2_4          = $4007

APU_CTRL                = $4015
APU_FRAME_COUNTER       = $4017

NAME_TABLE_1            = $20
NAME_TABLE_2            = $24

NAME_TABLE_WIDTH        = $20

PALETTE_VRAM_PAGE       = $3F

; ---[ GAME CONSTANTS ]---
MAX_VELOCITY            = 2
MAX_FALLING_VELOCITY    = 4
JUMPING_VELOCITY        = 5

MAX_Y_VECTOR            = $0A
MIN_Y_VECTOR            = $05

RIGHT_WALL              = 250 - SPRITE_SIZE
LEFT_WALL               = 0   + SPRITE_SIZE
FLOOR                   = 232
ROOF                    = 0   + SPRITE_SIZE


INITIAL_SCORE           = 10

SCROLL_SPEED            = 8

TOKEN_FREQUENCY			= 2

; ---[ ARCHITECTURAL CONSTANTS ]---
LOWEST_SIGNED           = 128
HIGHEST_SIGNED          = 127
TRUE                    = 0
FALSE                   = 1
DONT_KNOW               = $ff
SPRITE_SIZE             = 8
TILES_X                 = 32
TILES_Y                 = 30

NAMETABLE1_H            = $20
NAMETABLE2_H            = $24
NAMETABLES_L            = $00

STACK_PAGE              = $01
EOL                     = $FF

; ---[ GRAPHIC CONSTANTS ]---
BG_COLOR                = $11

A_CHARACTER             = $0A
B_CHARACTER             = $0B
C_CHARACTER             = $0C
D_CHARACTER             = $0D
E_CHARACTER             = $0E
F_CHARACTER             = $0F
G_CHARACTER             = $10
H_CHARACTER             = $11
I_CHARACTER             = $12
J_CHARACTER             = $13
K_CHARACTER             = $14
L_CHARACTER             = $15
M_CHARACTER             = $16
N_CHARACTER             = $17
O_CHARACTER             = $18
P_CHARACTER             = $19
Q_CHARACTER             = $1A
R_CHARACTER             = $1B
S_CHARACTER             = $1C
T_CHARACTER             = $1D
U_CHARACTER             = $1E
V_CHARACTER             = $1F
W_CHARACTER             = $20
X_CHARACTER             = $21
Y_CHARACTER             = $22
Z_CHARACTER             = $23

; ---[ SPRITE TILES ]---
BLANK_SPRITE_TILE       = 0
PLAYER_TILE_RIGHT       = 9
PLAYER_TILE_LEFT        = 10

INCREASE_RACKET_TOKEN   = $05
DECREASE_RACKET_TOKEN   = $06
INCREASE_SPEED_TOKEN    = $07
DECREASE_SPEED_TOKEN    = $08


RACKET_ATTRIBUTE        = 0

SPRITE_NUMBERS_OFFSET   = $10

; ---[ BACKGROUND TILES ]---
WALL_TILE               = $30
BLANK_BG_TILE           = $FF

; ---[ ERROR CODES ]---
;VBLANK_TIMEOUT          = $01
UNDEFINED_LEVEL         = $02
