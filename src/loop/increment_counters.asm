IncrementCounters:
    LDX gravity_counter
    CPX #20
    BCC :+ 
        ; gravity_counter < 10
        INX
        JMP @endif
    :
        ; gravity_counter >= 10
        LDX #0
    @endif:
    STX gravity_counter
    RTS

