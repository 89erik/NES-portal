.include "data/constants.inc"
.include "data/sound_constants.inc"

; Exporting global variables/names. TODO: move to separate file
.export v_blank_complete
.export sub_routine_arg1
.export sub_routine_arg2
.export sub_routine_tmp
.export fp

.export IncrementOffset
.export brick_to_update_high_addrs
.export brick_to_update_low_addrs
.export brick_x
.export brick_y
.export bricks_to_update
.export first_brick_to_update
.export last_brick_to_update
.export n_bricks
.export player_attribute
.export player_tile
.export ppu_ctrl_1
.export score
.export score_tile

.export scroll
.export brick_present
.export brick_tile

.segment "INES"
    .byte "NES",$1A,1,1,1
    ;      012   3  4 5 6
    ; http://wiki.nesdev.com/w/index.php/INES
    
.segment "VECTORS"
    .word V_blank   ; Non-maskable interrupt (used by V-Blank)
    .word Start     ; Initial program counter value
    .word No_op     ; IRQ (not used)

.segment "GFX"
    .incbin "data/sprites.chr"      ; Graphics for moving things (binary file)
    .incbin "data/background.chr"   ; Graphics for background (binary file)
    
.segment "CODE"
        .include "tests/test_hooks.asm"
        .include "tests/advanced_test_hooks.asm"
        .include "src/lib/game.asm"
        .include "src/load_level.asm"
        .include "src/init/fill_background.asm"
        .include "src/start_screen.asm"
        .include "src/next_level.asm"
        .include "src/sound/sounds.asm"
        .include "src/loop/player_placement.asm"
    Start:
        .include "src/init/init.asm"        ; Initialization procedure
        .include "src/loop/loop.asm"        ; Physics to be performed per framerate
    No_op:
        RTI
    
.segment "ZERO_PAGE"
    .include "memory/ram.asm"               ; Variables in RAM
    
.segment "OAM"
    .include "memory/oam.asm"               ; Sprite memory
    
