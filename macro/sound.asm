.macro SET_SQUARE_NOTE frequency, count_index, channel
    ; Low part
    LDA #(((1789773 / (frequency * 16)) - 1) & $FF)
    STA $4002 + (4 * (channel -1))
    ; High part and count index
    LDA #((count_index << 3) & %11111000) | ((((1789773 / (frequency * 16)) - 1) >> 8) & %111)
    STA $4003 + (4 * (channel -1))
.endmacro

.macro case val
    CMP #val
    BNE :+
        JMP .ident(.sprintf("@s%d", val))
    :
.endmacro

.macro SKIP_IF_NOT val
    CMP #val
    BNE :+
.endmacro

