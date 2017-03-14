MovePlayerRepeatedly:
    LDX #0
    @repeat:
        TXA
        PHA
        JSR MovePlayer
        PLA
        TAX
        INX
        CPX #100
        BCC @repeat
    RTS
