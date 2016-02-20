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

SRC 	 = main.asm guitarpro.asm


####################################################################
# Rules                                                            #
####################################################################


all: clean
all: $(BUILD_DIR)
all: $(PROJECTNAME).nes
all: build/no_remorse.asm

$(BUILD_DIR):
	$(shell mkdir $(BUILD_DIR))


# Create asm source files from meta sources
$(BUILD_DIR)/%.asm: metasrc/%.json
	$(PREPROCESS) -o $@ $<

# Create objects from asm source file
%.o: %.asm
	$(CC) -U $<

# Link
$(PROJECTNAME).nes: main.o build/no_remorse.o
	$(LD) -o $(PROJECTNAME).nes -C $(L_SCRIPT) main.o build/no_remorse.o

clean:
	$(RM) main.o 
	$(RM) $(BUILD_DIR)

