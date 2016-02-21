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
$(PROJECTNAME).nes: main.o build/no_remorse.o src/lib/architectural.o src/lib/graphical.o
	$(LD) -o $(PROJECTNAME).nes -C $(L_SCRIPT) build/main.o build/no_remorse.o build/architectural.o build/graphical.o

clean:
	$(RM) main.o 
	$(RM) $(BUILD_DIR)

