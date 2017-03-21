; X <- X+1
; Y <- X*4
IncrementOffset:
    INX
    TXA
    ASL
    ASL
    TAY
    RTS 
    

; Dispenses a token from the brick given by X
; X = brick index
DispenseToken:
	TYA
	PHA ; Preserve Y
	
	TXA
	TAY ; Y <- X
	
	LDA brick_x, Y
	LDX #SPRITE_SIZE
	JSR Multiply
	STA token_x
	LDA brick_y, Y
	LDX #SPRITE_SIZE
	JSR Multiply
	STA token_y
	LDA #INCREASE_RACKET_TOKEN
	STA token_tile
	
	PLA
	TAY ; Retrieve Y
	RTS
