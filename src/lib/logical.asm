.export TilesOverlap


.segment "CODE"
.include "data/constants.inc"


; Does tile A and B overlap? A = 0 : 1
; Tile A: regs (X, Y)
; Tile B: (sub_routine_arg1, sub_routine_arg2)
TilesOverlap:
    @check_horizontal_overlap:
        TXA
        SEC
        SBC sub_routine_arg1
        JSR AbsoluteValue
        CMP #8
        BCS @no_overlap
    @check_vertical_overlap:
        TYA
        SEC
        SBC sub_routine_arg2
        JSR AbsoluteValue
        CMP #8
        BCS @no_overlap

    @overlap:
        LDA #TRUE
        RTS
    @no_overlap:
        LDA #FALSE
        RTS
