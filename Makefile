.PHONY: all clean

####################################################################
# Definitions                                                      #
####################################################################
PROJECTNAME = breakout

CC       = ca65
LD       = ld65

RM       = rm -rf
SRC 	 = main.asm
L_SCRIPT = linker_config.cfg


####################################################################
# Rules                                                            #
####################################################################


# Default build is debug build
all: clean
all: $(PROJECTNAME).nes

# Create objects from asm source file
main.o: $(SRC)
	$(CC) $<

# Link
$(PROJECTNAME).nes: main.o
	$(LD) -o $(PROJECTNAME).nes -C $(L_SCRIPT) main.o

clean:
	$(RM) main.o

