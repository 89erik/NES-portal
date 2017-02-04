TestMovePlayerAdvanced:
    JSR @test_move_player_advanced
    NOP ; arriving here marks termination of test
    
@test_move_player_advanced:
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
