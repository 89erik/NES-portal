.PHONY: all clean

####################################################################
# Definitions                                                      #
####################################################################
PROJECTNAME = portal

CC       = ca65
LD       = ld65
PREPROCESS = preprocessor/preprocess.py

RM       = rm -rf
L_SCRIPT = linker_config.cfg

BUILD_DIR = build
DBG_OUTPUT = symbols.txt

SRC = \
	main.asm \
	src/v_blank.asm \
	src/lib/architectural.asm \
	src/lib/graphical.asm \
	src/lib/logical.asm \
	data/levels.asm \
	data/palette.asm

METASRC = \
	metasrc/no_remorse.json \
	metasrc/bounce_sound.json

CHILD_DEPS = \
	data/constans.inc \
	data/sound_constans.inc \
	memory/ram.asm \
	memory/oam.asm \
	src/lib/game.asm \
	src/load_level.asm \
	src/init/fill_background.asm \
	src/start_screen.asm \
	src/next_level.asm \
	src/sound/sounds.asm \
	src/init/init.asm \
	src/loop/loop.asm \
	src/loop/player_placement.asm \
	src/loop/check_hit_brick.asm 


OBJECTS = \
$(addprefix $(BUILD_DIR)/, $(notdir $(SRC:.asm=.o))) \
$(addprefix $(BUILD_DIR)/, $(notdir $(METASRC:.json=.o)))


SRC_PATHS = $(sort $(dir $(SRC)))
METASRC_PATHS = $(sort $(dir $(METASRC)))


vpath %.asm $(SRC_PATHS)
vpath %.json $(METASRC_PATHS)

####################################################################
# Rules                                                            #
####################################################################


all: clean
all: $(BUILD_DIR)
all: $(PROJECTNAME).nes
all: upload
all: execute_tests 

$(BUILD_DIR):
	$(shell mkdir $(BUILD_DIR))


# Create asm source files from meta sources
%.asm: %.json
	$(PREPROCESS) -o $@ $<

# Create objects from asm source file
build/%.o: %.asm 
	$(PREPROCESS) --src -o $(BUILD_DIR)/$(notdir $<) $<
	$(CC) --debug-info -U -I $(shell pwd) -o $(BUILD_DIR)/$(notdir $@) $(BUILD_DIR)/$(notdir $<)

# Link
$(PROJECTNAME).nes: $(OBJECTS)
	$(LD) --dbgfile $(DBG_OUTPUT) -o $(PROJECTNAME).nes -C $(L_SCRIPT) $(OBJECTS)

clean:
	$(RM) $(BUILD_DIR)

upload:
	#scp $(PROJECTNAME).nes erik@DESKTOP-3GLO7MM:
	cp $(PROJECTNAME).nes /media/sputnik/tmp

execute_tests:
	/bin/bash 6502_test_executor/execute_tests.sh tests
