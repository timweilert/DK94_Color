# Donkey Kong '94

This is a disassembly of Donkey Kong '94 with changes to make it a Gameboy Color ROM using the Super Gameboy palettes

To set up the repository, see [**INSTALL.md**](INSTALL.md).

# Credits

- https://github.com/bailli/eDKit for the data compression code
- https://github.com/CelestialAmber/DKGBDisasm for the decompiled code
- https://github.com/jojobear13/shinpokered for a good example of another SGB-compatible game getting the GBC treatment.

# Trying Not To Reinvent The Wheel

The [last Gameboy-related project I did](https://github.com/timweilert/shinpokered-liteimprovements) was a very minor mod on Jojobear13's excellent [shinpokered improvment on the Pokemon RE source code](https://github.com/jojobear13/shinpokered).

One of the aspects I quite appreciated about that project was the backporting in of Pokemon Yellow's dual SGB/GBC compatiblity. Although it didn't go as far as creating a full colorization, it was the perfect splash of color to cheer up my playthrough on shinpokered. 

Looking to learn more about Gameboy development and assembly language I have set out to give 1994's Donkey Kong a similar treatment- maintain all backwards compatiblity of the game while adding in the SGB palettes to run in GBC mode. 

My approach here is to glean the essential parts needed to do a SGB to GBC conversion and document them so that others might have a path to follow. To that extent, I'm going to do a line-by-line review of the relevant pieces and explain what's going on in detail (again, I'm learning assembly, so this is as much a chance for me to wrap my head around this stuff as anything else).

# Tools

I use a Windows-based setup with the following tools:
- Cygwin to manage compliers (GCC, RGBASM, etc) and provide bash
- VS Code, modified to run Cygwin's bash terminal rather than PowerShell. With this I can easily index and search code and do regular builds with the makefile in this repo. 
- BGB (placed in my Cygwin bin directory) to allow for quick ROM launching and debug.

# Beginning at the Start(up)

Before we start executing any code we have to check what kind of Gameboy we're using. According to [pandocs documentation](https://gbdev.io/pandocs/Power_Up_Sequence.html) all of the Gameboy models before the GBC will initialize their A register to the value $01. Everything GBC and later initialize A to $11. Side-note- I'm going to keep using the term GBC instead of the dev term CGB.

In [shinpokered's home.asm file](https://github.com/jojobear13/shinpokered/blob/master/home.asm#L102-L113) we see the following:

	SECTION "Main", ROM0

	Start::
		cp GBC
		jr z, .gbc
		xor a
		jr .ok
	.gbc
		ld a, 1	;gbctest - set the marker for being in gbc mode
	.ok
		ld [hGBC], a
		jp Init

Taking this piece by piece:

	SECTION "Main", ROM0

This is the 0th ROM, ie- the place where overall code execution will begin after the bootrom has finished executing.	

	Start::
		cp GBC 

Elsewhere in 9shinpokered's source [hardware_constants.asm](https://github.com/jojobear13/shinpokered/blob/master/constants/hardware_constants.asm#L3) the constant 'GBC' is defined as follows:

	GBC EQU $11

The cp GBC line does a compare with the value in A and the flag result goes to the F register. Since constant GBC is $11 we check to see the difference between the A register and $11 and store the resulting flag in F.

For a DMG/SGB, cp GBC should result in $01 minus $11, which does not throw the Z flag, but instead throws a C (carry) flag since ($01 - $11) causes an underflow to occur.

For a GBC, cp GBC results in $00 which throws the Z flag in the F register because the result is zero. It also throws the N flag since we do a subtraction to get there.

		jr z, .gbc

Thisdoes a relative jump based on the result of the last operand (cp GBC). If the last value was zero (which implies we're on a GBC) then we jump to the line below, .gbc. If not, just proceed to the next line.

		xor a

At this point the A register is still representative of the type of gameboy we're using. So if we XOR A with itself then A goes to $00.

		jr .ok

If we're executing this line we are NOT a GBC, so we skip the .gbc section below and jump to .ok

	.gbc
		ld a, 1	;gbctest - set the marker for being in gbc mode

Set register A to the value 1, used as a marker for being in GBC mode.

	.ok
		ld [hGBC], a
    
Set the memory address at hGBC (in this case it's [$FFFE, per hram.asm](https://github.com/jojobear13/shinpokered/blob/master/hram.asm#L331)) to the value from A. If we're in GBC mode that value is 1, if we're not then A should be 0. I take it that we're going to use Hi RAM here since it's pretty fast and we want to avoid bogging things down when doing checks of the hGBC flag later

	jp Init

Finally jump to the Init portion of the code. In a sense this bit of code could be added before the main code without altering the main.

## So what's the result? 

We've checked the A register on boot for the kind of gameboy we are using by comparing to a defined constant (GBC EQU $11).
From there we use the resulting comparison to set a flag (hGBC) to either 1 (on a GBC) or 0 (not a GBC).

# Where does hGBC get called?

Doing a quick search of the shinpokered codebase I see that hGBC gets called in a few spots. This may be a little bit of an arbitrary way to approach things, but I'm going to just start working through each of the instances to see where it's getting called to better understand how it's done over there. Once that's done I can translate the concepts over here to DK94.

# home.asm

Examining [home.asm](https://github.com/jojobear13/shinpokered/blob/master/home.asm#L2211-L2232) shows another gbcnote with new functions not in the original black-and-white version of Pokemon Red:

	;gbcnote - new functions
	UpdateGBCPal_BGP::
		push af
		ld a, [hGBC]
		and a
		jr z, .notGBC
		push bc
		push de
		push hl
		ld a, [rBGP]
		ld b, a
		ld a, [wLastBGP]
		cp b
		jr z, .noChangeInBGP
		callba _UpdateGBCPal_BGP
	.noChangeInBGP
		pop hl
		pop de
		pop bc
	.notGBC
		pop af
		ret

This is clearly a function to Update the GBC Palette for the Background. Again, taking things line-by-line:

	UpdateGBCPal_BGP::

In this case we update the BackGround Pallette for GBC usage, however this code can get called anywhere and may not execute if we don't have a valid hGBC flag

		push af

Take the current value of the AF register and stick it on the stack (SP). Then decrement the SP by 2. This is done in case we aren't on a GBC and we need to recover the AF register values.

		ld a, [hGBC]

Put the value of the hGBC flag in to the A register

		and a

Doing an AND on A will give the following:
- For DMG/SGB- hGBC is $00, so $00 AND $00 is going to give $00 (zero)
- For GBC- hGBC is $01, so $01 AND $01 is going to give $01 (not zero)

		jr z, .notGBC

If the last operation was zero (DMG case) then relative jump to .notGBC, otherwise we go on.

		push bc
		push de
		push hl

These three push lines save off the current values in BC, DE, and HL. We use these registers in the meantime to do some palette comparisons.

		ld a, [rBGP]

Fill register A with the value from rBGP's address- [in shinpokered this is a constant ($FF47), which is commented as follows](https://github.com/jojobear13/shinpokered/blob/master/constants/hardware_constants.asm#L76):
    
	rBGP	EQU $ff47 ; BG Palette Data (R/W) - Non CGB Mode Only

Okay, back to the home.asm code...

		ld b, a

Put the value from A (the BG palette data) in to B.

		ld a, [wLastBGP]

Put the value from wLastBGP in to A. wLastBGP is the Last BackGround Palette that was loaded, this is a memory location defined in [shinpokered's wram.asm](https://github.com/jojobear13/shinpokered/blob/master/wram.asm#L3011):

    wLastBGP::
      ds 1

Basically, statically allocate 1 byte for this data at whatever address this happens to be when building occurs. Looking adjacent to this area it's basically nestled in an area in Work RAM where there was a gap. Okay, back to home.asm again...

		cp b

Compare B to A. If the wLastBGP is the same as the current rBGP, then the comparison throws a Z flag

		jr z, .noChangeInBGP

If we didn't change background palette then we jump to .noChangeinBGP

		callba _UpdateGBCPal_BGP

If we did change, then we do a callba macro using _UpdateGBCPal_BGP

	.noChangeInBGP
		pop hl
		pop de
		pop bc

If we didn't actually change anything then restore the HL, DE, and BC registers to their states prior to entering this function.

	.notGBC
		pop af

We came in to the function, found that we weren't on a GBC after comparing the hGBC register and jumped down here. Before we did we pushed AF on to the stack, so now we're popping AF back from the stack to restore the original state of things before the function was called.

		ret
	
we're done, return to wherever we got called from.