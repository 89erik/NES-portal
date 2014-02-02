; ------------------------------------------------- ;
; ----------[ OBJECT ATTRIBUTE MEMORY ]------------ ;
; ------------------------------------------------- ;
; Contains the memory locations of the OAM, which 	;
; keep tracks of the sprites.						;
; ------------------------------------------------- ;	
	player_y:					.byte 0
	player_tile:				.byte 0
	player_attribute:			.byte 0
	player_x:					.byte 0

									 ;L  H
	p1_score_y:					.byte 0, 0
	p1_score_tile:				.byte 0, 0
	p1_score_attribute:			.byte 0, 0
	p1_score_x:					.byte 0, 0