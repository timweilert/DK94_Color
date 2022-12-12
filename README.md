# Donkey Kong '94

This is a disassembly of Donkey Kong '94 with changes to make it a Gameboy Color ROM using the Super Gameboy palettes

To set up the repository, see [**INSTALL.md**](INSTALL.md).

# Credits

- https://github.com/bailli/eDKit for the data compression code
- https://github.com/CelestialAmber/DKGBDisasm for the decompiled code

# Understanding the reverse engineer of DK94

As a part of understanding how this game is put together I did a walk through of the entire codebase. It's not a big game so it's kinda manageable.

# The Makefile  

Start with the end first: what does the Makefile do?

## Defines a few file variables:

	ROM := donkeykong.gb
	
Defines the actual ROM file that will be generated / sha checked, etc

	OBJS := main.o wram.o 
	
Object files for the main code and the working RAM

## Build tools

	ifeq (,$(shell which sha1sum))
	SHA1 := shasum
	else
	SHA1 := sha1sum
	endif

Checks to see if a blank entry is equal to the ouput of the command shell which sha1sum. If they are equal, use the shasum method, else use sha1sum.

## Build targets

	.SUFFIXES:
	.SECONDEXPANSION:
	.PRECIOUS:
	.SECONDARY:
	.PHONY: all tools compare clean tidy

.SUFFIXES are the prerequisites of the special target- a list of suffixes to be used for checking suffix rules reference(https://www.gnu.org/software/make/manual/make.html#index-_002eSUFFIXES)

In this case it's empty, so let's assume there's no suffixes.

.SECONDEXPANSION can expand prerequisites a second time- again empty, so no use here.

.PRECIOUS specifies which targets are precious- ie they are not deleted if make is killed or interrupted. Again, empty, so everything here is subject to deletion if we kill make.

.SECONDARY targets are intermediate files, not automatically deleted- also empty here.

.PHONY targets aren't really the name of a file, rather just the name of a recipe to be executed when you make an explicit request. Here we have 5- all, tools, compare, clean, and tidy

As we see below, each of the phony targets then gets defined.

	all: $(ROM)

Just populates with the ROM variable, which as we recall is the file from the very top of the makefile.

	compare: $(ROM)
		@$(SHA1) -c rom.sha1
		tools/unnamed.py -r . donkeykong.sym

Compares the SHA1 value from above and compares it to the rom.sha1 file.
Also finds unnamed symbols in the donkeykong.sym symbols file.

	tidy:
		rm -f $(ROM) $(OBJS) $(ROM:.gb=.sym) $(ROM:.gb=.map)
		$(MAKE) -C tools clean

Removes the rom, object, sym, and map files 

	clean: tidy
		find . \( -iname '*.1bpp' -o -iname '*.2bpp' -o -iname '*.pcm' -o -iname '*.lz' \) -exec rm {} +

Removes the 1bpp, 2pbb, and lz files.

	tools:
		$(MAKE) -C tools/

I think this is just adding the tools directory to the working path.

	ifeq (,$(filter clean tools,$(MAKECMDGOALS)))
	$(info $(shell $(MAKE) -C tools))
	endif

## Start the actual build

Some logic to create the command goals files 


	%.o: dep = $(shell tools/scan_includes $(@D)/$*.asm)
	%.o: %.asm $$(dep)
		rgbasm -h -o $@ $<

Pattern matching and defining the dep variable - looking for .asm files. and looping through them.
Passes an argument to RGBASM
-h, aka --halt-without-nop. By default rgbasm inserts a nop instruction immediatlely after halt instructions. this -h disables that.
-o, aka output file - creates an object file at the given filename

	$(ROM): $(OBJS)
		rgblink -n $(ROM:.gb=.sym) -m $(ROM:.gb=.map) -p 0xFF -o $@ $(OBJS)
		rgbfix -sv -k 01 -l 0x33 -m 0x03 -p 0xFF -r 02 -t "DONKEY KONG" $@

For each of the rom file object files:  
rgblink - object linker
- -n write a symbol file to the given filename, based on the ROM filename
- -m write a map file ot the given filename, based on the ROM filename. These will both need to change to .gbc if we go that route.
- -p pad value - when inserting padding between sections, pad with this value, has no effect if -O is specified. Default is 0, here we use 0xFF. 
- -o writes the ROM image to a given output file. 

rbgfix - header and checksum fixer
- -sv s is for Super Gameboy compatible, v is for validate. Other values to consider here include c for Gameboy Color compatible.
- -k sets the new licensee string
- -l licensee_id - should be set to 0x33 in all new softwrae.
- -m MBC type - mapper selection, here it's 0x03 which is ROM+MBC1_RAM+BATT. There's lots of options here.
- -p pad value - pad the rom to a given size. Here it's using the recommended value of 0xFF
- -r RAM size - another value that is adjustable with 02 being for an 8k RAM option.
- -t Title, Donkey kong, of course  

Moving on...

	gfx/font.2bpp: tools/gfx += --trim-whitespace
	gfx/bank4mariosprites.2bpp: tools/gfx += --trim-whitespace
	gfx/bank11graphics.2bpp: tools/gfx += --trim-whitespace
	gfx/gameover_screen.2bpp: tools/gfx += -w 2
	/#gfx/dk_menu_finger.2bpp: tools/gfx += --trim-whitespace

Compresses the graphics files.  

	%.2bpp.lz : %.2bpp
		$(if $(tools/dkcompress),\
			tools/dkcompress $(tools/dkcompress) $< $@,\
			tools/dkcompress $< $@)

	%.2bpp: %.png
		rgbgfx -o $@ $<
		$(if $(tools/gfx),\
			tools/gfx $(tools/gfx) -o $@ $@)

	%.1bpp: %.png
		rgbgfx -d1 -o $@ $<
		$(if $(tools/gfx),\
			tools/gfx $(tools/gfx) -d1 -o $@ $@)
			
more graphics compression

# The sourcecode itself. 		

## main.asm

I'll dive on each of these as they may be relevant to the colorization process. for now just short descriptions

	INCLUDE "constants.asm"
	
loads the charmap.asm and macros.asm files. Also adds all the files in the constants directory.
	
	INCLUDE "home.asm"

Loads a bunch of values in to various registers. Lots of $38 (recall $ == 0x, so it's just saying this is a hex value). Now what follows are info for each of the ROM banks.

	INCLUDE "bank_000.asm"
	
This is the actual start of the program code. the Start: and MainLoop: functions live here. this may be a prime spot to start making changes for GBC.	
	
	INCLUDE "src/sgb_functions.asm"

Does a bunch of additional functions if the cartridge is running on a super gameboy. Could probably cheat off of here to create a gbc_functions.asm file.

	INCLUDE "bank_001.asm"
	INCLUDE "bank_002.asm"
	INCLUDE "bank_003.asm"
	INCLUDE "bank_004.asm"

Lots of assembly, doing lord knows what- will dig in to these only if necessary. Lots of jump commands defined here. Appears mostly to be related to bank at hand.

	;Banks 5/6 (Level data)
	SECTION "ROM Bank $005", ROMX[$4000], BANK[$05]
	INCLUDE "data/levels.asm"
	INCLUDE "data/level_data_1.asm"

	SECTION "ROM Bank $006", ROMX[$4000], BANK[$06]
	INCLUDE "data/level_data_2.asm"

As the name suggests, these are the source files for the level data.

	INCLUDE "bank_007.asm"
	INCLUDE "bank_008.asm"
	INCLUDE "bank_009.asm"
	INCLUDE "bank_00a.asm"
	INCLUDE "bank_00b.asm"
	INCLUDE "bank_00c.asm"
	INCLUDE "bank_00d.asm"
	INCLUDE "bank_00e.asm"
	INCLUDE "bank_00f.asm"
	INCLUDE "bank_010.asm"
	INCLUDE "bank_011.asm"

More jumps, although starting at bank 011 it's just pushing a bunch of hex values through- likely purely ROM data, not program data.

	;Bank 12 (Level data)
	SECTION "ROM Bank $012", ROMX[$4000], BANK[$12]
	INCLUDE "data/level_data_3.asm"

Again as the name suggests, bank 012 is level data.

	INCLUDE "bank_013.asm"
	INCLUDE "bank_014.asm"
	INCLUDE "bank_015.asm"
	INCLUDE "bank_016.asm"
	INCLUDE "bank_017.asm"
	INCLUDE "bank_018.asm"
	INCLUDE "bank_019.asm"
	INCLUDE "bank_01a.asm"
	INCLUDE "bank_01b.asm"
	INCLUDE "bank_01c.asm"
	INCLUDE "bank_01d.asm"
	INCLUDE "bank_01e.asm"
	INCLUDE "bank_01f.asm"
	
The rest of the source. Interseting to note that bank 01e includes super gameboy palette and border data.	

## constants.asm

The first file loaded in the main assembly.

	INCLUDE "charmap.asm"
	
Mostly defines the Character map (see https://rgbds.gbdev.io/docs/v0.5.2/rgbasm.5/#Character_maps) - lots of hex values being mapped to character values.
	
	INCLUDE "macros.asm"

Points to code.asm, data.asm, and gfx.asm, which presumably contain assembly macros to aid in writing code.

	INCLUDE "constants/hardware_constants.asm"

Basically lays out the various register addresses where things live, or start and stop. GBC sprite and background palette registers are defined here. Look at adjusting these to point to the SGB register locations.
	
	INCLUDE "constants/misc_constants.asm"
	
Sets a bunch of other hex values for various game state values.	
	
	INCLUDE "constants/sgb_constants.asm"
	
I think these are bog standard registers for the super gameboy- this is where SGB palette data is also referenced.

### charmap.asm

As mentioned earlier, this is something that will relate eventually to the compiler. Basically each character is given a hex value, in essense to help simplify writing text.

	charmap " ", $20
	charmap "0", $30
	charmap "1", $31
	charmap "2", $32
	charmap "3", $33
	charmap "4", $34
	charmap "5", $35
	charmap "6", $36
	charmap "7", $37
	charmap "8", $38
	charmap "9", $39
	charmap "A", $41
	charmap "B", $42
	charmap "C", $43
	charmap "D", $44
	charmap "E", $45
	charmap "F", $46
	charmap "G", $47
	charmap "H", $48
	charmap "I", $49
	charmap "J", $4A
	charmap "K", $4B
	charmap "L", $4C
	charmap "M", $4D
	charmap "N", $4E
	charmap "O", $4F
	charmap "P", $50
	charmap "Q", $51
	charmap "R", $52
	charmap "S", $53
	charmap "T", $54
	charmap "U", $55
	charmap "V", $56
	charmap "W", $57
	charmap "X", $58
	charmap "Y", $59
	charmap "Z", $5A
	charmap "©", $5F
	charmap ".", $60
	charmap "ō", $61
	charmap "-", $70

	;charmap "1980", $5B,$5C,$5D,$62
	;charmap "1981", $5B,$5C,$5D,$5B
	;charmap "1983", $5B,$5C,$5D,$5E
	;charmap "1994", $5B,$5C,$5C,$63

### macros.asm 

Just pointing to some other asm files.

	INCLUDE "macros/code.asm"
	INCLUDE "macros/data.asm"
	INCLUDE "macros/gfx.asm"

### macros/code.asm 

Finally some actually assembly code rather than high level compiler stuff.

	ld_long: MACRO
		IF STRLWR("\1") == "a" 
			; ld a, [$40]
			db $FA
			dw \2
		ELSE 
			IF STRLWR("\2") == "a" 
				; ld [$40], a
				db $EA
				dw \1
			ENDC
		ENDC
	ENDM

Creates an assembly macro called ld_long. It looks at "\1" (the first argument passed to the macro), does a lowercase conversion via STRLWR and compares to lowercase "a". If that's true, then poke the byte value $FA in the current memory location 
followed by a word poke of "\2" (the second argument to the macro). If it's not "a", check if \2 (the second argument) is "a" and if that one is we poke in $EA followed by \1. The end result- a value comes in, presumably 2 words and if the first word is "a" then the current memory address becomes $FA and the second word passed to the macro. 
Example- we pass in $41, $42- as shown above $41 is character A, so after the macro the value $FA42 is returned. 

	;1:function to call
	switchcall: MACRO
		ld a, BANK(\1)
		rst BankswitchRST
		call \1
	ENDM
	
