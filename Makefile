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

SRC = \
main.asm \
src/v_blank.asm \
src/lib/architectural.asm \
src/lib/graphical.asm \
build/no_remorse.asm \
build/bounce_sound.asm

OBJECTS = $(addprefix $(BUILD_DIR)/, $(notdir $(SRC:.asm=.o)))

####################################################################
# Rules                                                            #
####################################################################


all: clean
all: $(BUILD_DIR)
all: $(PROJECTNAME).nes

$(BUILD_DIR):
	$(shell mkdir $(BUILD_DIR))


# Create asm source files from meta sources
$(BUILD_DIR)/%.asm: metasrc/%.json
	$(PREPROCESS) -o $@ $<

# Create objects from asm source file
%.o: %.asm
	$(CC) -U -I $(shell pwd) -o $(BUILD_DIR)/$(notdir $@) $<

# Link
$(PROJECTNAME).nes: $(SRC:.asm=.o)
	$(LD) -o $(PROJECTNAME).nes -C $(L_SCRIPT) $(OBJECTS)

clean:
	$(RM) main.o 
	$(RM) $(BUILD_DIR)

