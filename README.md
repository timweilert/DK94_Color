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

This does a relative jump based on the result of the last operand (cp GBC). If the last value was zero (which implies we're on a GBC) then we jump to the line below, .gbc. If not, just proceed to the next line.

		xor a

At this point the A register is still representative of the type of gameboy we're using. So if we XOR A with itself then A goes to $00.

		jr .ok

If we're executing this line we are NOT a GBC, so we skip the .gbc section below and jump to .ok

	.gbc
		ld a, 1	;gbctest - set the marker for being in gbc mode

Set register A to the value 1, used as a marker for being in GBC mode.

	.ok
		ld [hGBC], a
    
Set the memory address at hGBC (in this case it's [$FFFE, per hram.asm](https://github.com/jojobear13/shinpokered/blob/master/hram.asm#L331)) to the value from A. If we're in GBC mode that value is 1, if we're not then A should be 0. I take it that we're going to use Hi RAM here since it's pretty fast and we want to avoid bogging things down when doing checks of the hGBC flag later. Also of note- in shinpokered there's also an additional function to change the shader gamma by setting hGBC to value $02. I don't believe this will come in to play for DK94.

		jp Init

Finally jump to the Init portion of the code. In a sense this bit of code could be added before the main code without altering the main.

## So what's the result? 

We've checked the A register on boot for the kind of gameboy we are using by comparing to a defined constant (GBC EQU $11).
From there we use the resulting comparison to set a flag (hGBC) to either 1 (on a GBC) or 0 (not a GBC).

# Intro Code

In shinpokered the intro.asm file covers the introductory bits of code, including the Init function that gets called via that last jp init in home.asm. This is the first time things are being drawn on screen. The first major call of interest is PlayShootingStar. 

	PlayShootingStar:
		ld b, SET_PAL_GAME_FREAK_INTRO
		call RunPaletteCommand
		callba LoadCopyrightAndTextBoxTiles
		ldPal a, BLACK, DARK_GRAY, LIGHT_GRAY, WHITE
		ld [rBGP], a
		call UpdateGBCPal_BGP
		ld c, 180
		...

Line by lining it again:

	ld b, SET_PAL_GAME_FREAK_INTRO

Puts the value from constant SET_PAL_GAME_FREAK_INTRO in to register B. This constant is equal to value $0C

	call RunPaletteCommand

Let's call the palette command- I think we'll need to duplicate this in DK94. Here's what that RunPaletteCommand code looks like (in home.asm)

	RunPaletteCommand::
		ld a, [wOnSGB]
		and a
		ret z
		predef_jump _RunPaletteCommand

Load register A with the value from the wOnSGB work RAM address. As we will see, this value will be $1 because of the reworking of the LoadSGB function to set the flag high, but not do a bunch of other SGB-related VRAM stuff.

AND A with itself. At this point if shinpokered is on a SGB or GBC, then A should have value 1, so anding with itself gives us 1. If it's not then it'll result in 0. If the result of 'AND A' is zero, then return to where this case called, otherwise do predef_jump _RunPaletteCommand.

predef_jump is just a macro that wraps jumping to a specific spot in plain English rather than by address. In asm_macros.asm

	predef_jump: MACRO
		predef_id \1
		jp Predef
	ENDM

This actually wraps another macro called predef_id:

	predef_id: MACRO
		ld a, (\1Predef - PredefPointers) / 3
	ENDM

PredefPointers is a big list in predefs.asm that points to ASM routines. They all get added by the add_predef macro:

	add_predef: MACRO
	\1Predef::
		db BANK(\1)
		dw \1
	ENDM

The end result is that we call the _RunPaletteCommand code (that lives in palettes.asm). I think this is the core of the thing.

	_RunPaletteCommand:
		call GetPredefRegisters
		ld a, b	;b holds the address of the pal command to run
		cp $ff
		jr nz, .next
		ld a, [wDefaultPaletteCommand] ; use default command if command ID is $ff
	.next
		cp UPDATE_PARTY_MENU_BLK_PACKET
		jp z, UpdatePartyMenuBlkPacket
		ld l, a
		ld h, 0
		add hl, hl
		ld de, SetPalFunctions
		add hl, de
		ld a, [hli]
		ld h, [hl]
		ld l, a
		ld de, SendSGBPackets
		push de	;by pushing de, the next 'ret' command encountered will jump to SendSGBPackets
		jp hl

# _RunPaletteCommand

Taking it one line at a time:

	call GetPredefRegisters

Back over in predefs.asm:

	GetPredefRegisters::
	; Restore the contents of register pairs
	; when GetPredefPointer was called.
		ld a, [wPredefRegisters + 0]
		ld h, a
		ld a, [wPredefRegisters + 1]
		ld l, a
		ld a, [wPredefRegisters + 2]
		ld d, a
		ld a, [wPredefRegisters + 3]
		ld e, a
		ld a, [wPredefRegisters + 4]
		ld b, a
		ld a, [wPredefRegisters + 5]
		ld c, a
		ret

This code is loading H,L,D,E,B, and C registers with values from Working RAM, predefined registers, all 6 bytes. In shinpokered these live starting at address $CC4F.

	ld a, b	;b holds the address of the pal command to run

As we recall from back up at the beginning of PlayShootingStar, the first thing we did was load register B with SET_PAL_GAME_FREAK_INTRO, or the value $0C. That value is now loaded in to register A.

	cp $ff

Compare the value $FF to the value in A, which is $0C. It's been a minute since I worked on this, but the cp (compare) instruction subracts the value given from the value in register A then sets flags. It doesn't store the value. Since $FF is the maximum, we are going to have an underflow (N) flag high, Z flag low.

	jr nz, .next

If the result of the compare is not zero (N flag high, Z flag low), then jump relative to the .next section.

	ld a, [wDefaultPaletteCommand] ; use default command if command ID is $ff

There's a default palette that's defined in work RAM- we use that if the commanded value in register B was $FF. In shinpokered the wDefaultPaletteCommand value is only set in a few places. It can be set in battles, on the overworld, and- importantly in our case- for the Gamefreak intro. Over in palettes.asm:

	SetPal_GameFreakIntro:
		ld hl, PalPacket_GameFreakIntro
		ld de, BlkPacket_GameFreakIntro
		ld a, SET_PAL_GENERIC
		ld [wDefaultPaletteCommand], a
		ret

I think this code gets called in the init.asm or somewhere before we get to the intro palette code we're talking about here. In any case, that value is a constant $08 (from the same area of palette_constants.asm that we saw the SET_PAL_GAME_FREAK_INTRO constant).

To recap up to this point- we've seeded the _RunPaletteCommand with a B register value of $0C and checked that B reg's value isn't $FF. If it was $FF for some reason we'd go check a work RAM address for the value we should use instead. Proceeding to the .next section:

	cp UPDATE_PARTY_MENU_BLK_PACKET

We now compare the value in reg A to the constant UPDATE_PARTY_MENU_BLK_PACKET (which from the palette_constants.asm is $FC). Since our value (SET_PAL_GAME_FREAK_INTRO == $0C we will have a N flag and no Z flag)	

	jp z, UpdatePartyMenuBlkPacket

If we did have a zero result (meaning that we had sent the UPDATE_PARTY_MENU_BLK_PACKET in to the _RunPaletteCommand), we would jump to UpdatePartyMenuBlkPacket. I'm going to ignore this for now, but it shows how we can set up different cases to jump out when we have particular palettes being loaded.

	ld l, a
	ld h, 0

Load register L with the value from A ($0C) and load register H with value $0.

	add hl, hl

Add HL's value to itself and store it to HL. In this case $0C + $0C will give us $18.

	ld de, SetPalFunctions

Load the DE register pair with the SetPalFunctions address.

SetPalFunctions defines a bunch of SetPal functions (as the name would suggest) data via dw instructions. These are basically all the palette functions for the whole game. From palettes.asm:

	SetPalFunctions:
		dw SetPal_BattleBlack
		dw SetPal_Battle
		dw SetPal_TownMap
		dw SetPal_StatusScreen
		dw SetPal_Pokedex
		dw SetPal_Slots
		dw SetPal_TitleScreen
		dw SetPal_NidorinoIntro
		dw SetPal_Generic
		dw SetPal_Overworld
		dw SetPal_PartyMenu
		dw SetPal_PokemonWholeScreen
		dw SetPal_GameFreakIntro
		dw SetPal_TrainerCard
		;gbctest - adding packets from yellow
		dw SendUnknownPalPacket_7205d
		dw SendUnknownPalPacket_72064

Okay, back at the intro we've primed the DE register with the address for the SetPal_Functions code.		

	add hl, de

Add the value in DE (our address for SetPal_Functions) to the value we already had in HL (recall this is $18, which is the result of adding the original value $0C - the desired palette - to itself). I believe this doubling is due to the fact that SetPalFunctions is defininng each of the functions via dw instruction (using words instead of bytes means we need to double the size of the offset byte).

	ld a, [hli]

Store the value from the address that resulted from the add above to the A register and increment the HL register. Reg A now presumably contains the beginning value for the SetPal_GameFreakIntro code. 

	ld h, [hl]

Store the value from the address at HL (start of the SetPal_GameFreakIntro + 1 due to the increment above) in to register H. 	

	ld l, a

Store the value from Reg A in to reg L. So now Reg L has the value from the address for the start of the SetPal_GameFreakIntro code and H has the value from SetPal_GameFreakIntro + 1

	ld de, SendSGBPackets

As you recall, DE currently has the value of the SetPal_Functions address in it, now we replace it with the SendSGBPackets address.

	push de	;by pushing de, the next 'ret' command encountered will jump to SendSGBPackets

Push the value in DE to the stack- basically ensuring that the next function that gets returned to will send us to the top of the stack, ie - SendSGBPackets.

	jp hl

Now we jump to the address that's in HL, which as we recall is effectively the address to begin executing the SetPal_GameFreakIntro code.

So what have we learned from _RunPaletteCommand?

- The code here is basically a big switch statement that sets the CPU executing the case defined by whatever value is in Reg B at the time _RunPaletteCommand gets called.
- There are some carve-outs for specific functions (UpdatepartyMenuBlkPacket) that allow us to inject some additional logic before we proceed.
- It also enqueues SendSGBPackets to the top of the stack.
- This whole chunk of code is really only run if we are on a Super Gameboy (recall back in RunPaletteCommand if we do not meet the criteria of being on a SGB we just return). While it was very enlightening to walk through _RunPaletteCommand, we actually don't need it for Gameboy Color enhancement (although should leave this kind of stuff in place if it's there so we can maintain compatibility with SGB).

# LoadSGB

I realize i just said that we might skip most of the code above if we're not in a Super Gameboy, well, turns out that shinpokered's code simply tacks on some extra logic to the Super Gameboy code that allows us to piggyback.

LoadSGB is on of the first parts of code thar runs in init.asm as the pokemon program is starting up. It comes right before PlayIntro and our shooting star code.

In palettes.asm:

	LoadSGB:	;gbcnote - adjust for GBC
		xor a
		ld [wOnSGB], a
		call CheckSGB
		jr c, .onSGB
		ld a, [hGBC]
		and a
		jr z, .onDMG
		;if on gbc, set SGB flag but skip all the SGB vram stuff
		ld a, $1
		ld [wOnSGB], a
	.onDMG
		ret
	.onSGB
		ld a, $1
		ld [wOnSGB], a
		di
		call PrepareSuperNintendoVRAMTransfer
		ei
		ld a, 1
		ld [wCopyingSGBTileData], a
		ld de, ChrTrnPacket
		ld hl, SGBBorderGraphics
		call CopyGfxToSuperNintendoVRAM
		xor a
		ld [wCopyingSGBTileData], a
		ld de, PctTrnPacket
		ld hl, BorderPalettes
		call CopyGfxToSuperNintendoVRAM
		xor a
		ld [wCopyingSGBTileData], a
		ld de, PalTrnPacket
		ld hl, SuperPalettes
		call CopyGfxToSuperNintendoVRAM
		call ClearVram
		ld hl, MaskEnCancelPacket
		jp SendSGBPacket

Line by line:

		xor a
		ld [wOnSGB], a
		call CheckSGB

XOR'ing A clears that register out, making it 0, we then put a 0 in the work RAM wOnSGB address. Then we call CheckSGB. I'm not going to dive in to that code, since it basically looks like it's doing a bunch of checks, but it does start out doing a SendSGBPacket command. If it is on a SGB then the carry flag gets set. Also the DE register is set to

	jr c, .onSGB

If we are on a SGB, then the carry flag condition is true, so we'd skip ahead to the .onSGB section of this code. We are going to assume we're a GBC, so keep going.

	ld a, [hGBC]
	and a
	jr z, .onDMG

Here we see the hGBC value (I think for the first time in code execution?)- basically load reg A with the value from hGBC (recall 0 == not GBC, 1 == GBC). AND A with itself. If we get a zero as the result jump relative to .onDMG, otherwise continue. We will continue since the result of our AND A is not zero.

	;if on gbc, set SGB flag but skip all the SGB vram stuff
	ld a, $1
	ld [wOnSGB], a

Yay a code comment! As shown we use Reg A to set the wOnSGB value to $1. Following this we would presumably hit the ret instruction that comes next in the code and exit out of this subroutine. So the end result is that on GBC we now have values of $1 in both hGBC and wOnSGB.


# Returning to PlayShootingStar

We're only 2 lines in and if we're on a GBC presumably we have the following setup:

- Reg A has the value of the [wOnSGB] flag (should be $1)
- Reg B has the value of the SET_PAL_GAME_FREAK_INTRO ($0C)
- Everything else is a bit irrelevent.

On to line 3:

	callba LoadCopyrightAndTextBoxTiles

callba is a macro that gets us on the right bank, the LoadCopyrightAndTextBoxTiles isn't really palette related, just loading up tile data to be displayed by the screen.

	ldPal a, BLACK, DARK_GRAY, LIGHT_GRAY, WHITE

Now we're talking- ldPal is another macro	

	ldPal: MACRO
		ld \1, \2 << 6 | \3 << 4 | \4 << 2 | \5
	ENDM

In effect we are loading reg A with values for BLACK, DARK_GRAY, LIGHT_GRAY, and WHITE all bit shifted around each other to fit in a single byte.

Looking at the result of the shifts and the ORs, it looks like the bit order is WHITE,LIGHT_GRAY,DARK_GREY,BLACK. These values are constants- I think smartly defined in RGBASM or something like that.

So, the result is that Reg A now has values in it that represent colors.

	ld [rBGP], a
	
Now set the value of rBGP to be the bits from A. rBGP is as follows via hardware_constants.asm:

	rBGP        EQU $ff47 ; BG Palette Data (R/W) - Non CGB Mode Only

So in effect we've just put background palette data in to address $FF47 which is only used in non Gameboy Color mode. Back to PlayShootingStar once more:

	call UpdateGBCPal_BGP

Finally something related to the GBC and now we can explore the mechanics of actually doing GBC functions.

# Where does hGBC get called?

When I started doing this walkthrough this is the point where I began, upon digging through more of the init code I decided to move this here. Doing a quick search of the shinpokered codebase I see that hGBC gets called in a few spots. This may be a little bit of an arbitrary way to approach things, but I'm going to just start working through each of the instances to see where it's getting called to better understand how it's done over there. Once that's done I can translate the concepts over here to DK94.

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

# _UpdateGBCPal_BGP

I glossed over this a bit earlier because it deserves it's own exploration. This is the real meat of actually updating palettes on the Gameboy Color. For now this is just the background palette, but we will also need to cover Object palettes too.

From shinpokered's palettes.asm:

	_UpdateGBCPal_BGP::
	index = 0
		REPT NUM_ACTIVE_PALS
			ld a, [wGBCBasePalPointers + index * 2]
			ld e, a
			ld a, [wGBCBasePalPointers + index * 2 + 1]
			ld d, a
			xor a ; CONVERT_BGP
			call DMGPalToGBCPal
			ld a, index
			call BufferBGPPal	; Copy wGBCPal to palette indexed in wBGPPalsBuffer.
	index = index + 1
		ENDR
		call TransferBGPPals	;Transfer wBGPPalsBuffer contents to rBGPD
		ret

Line by lininig it here:

	index = 0

We're about to loop something

	REPT NUM_ACTIVE_PALS

This constant is defined in misc_constants.asm and is equal to 4. I think that's standard for the SGB, so hopefully that will translate to DK94. REPT just means we're going to repeat the following code that many times.

	ld a, [wGBCBasePalPointers + index * 2]

Load Reg A with the value of working RAM's wGBCBasePalPointers + index * 2- for the first iteration this will just give us the value of wGBCBasePalPointers. In the wram.asm layout: 

	wGBCBasePalPointers:: 
		ds NUM_ACTIVE_PALS * 2 ; 8 bytes

We get 2 bytes per palette. In this case since NUM_ACTIVE_PALS is 4 the wGBCBasePalPointers memory is 8 bytes long (think $01 23 45 67) starting at wherever wGBCBasePalPointers lives in memory (looks like north of address D669). so the index * 2 up in the ld a [wGBCBasePalPointers + index * 2] basically ensures that we stay on an even byte.

	ld e, a

Load that first value from wGBCBasePalPointers in to Reg E.

	ld a, [wGBCBasePalPointers + index * 2 + 1]

Load reg A with the adjacent value.

	ld d, a

Put the new A value in to reg D. Thinking about our $01 23 45 67 example above, on the first iteration (index == 0) DE would now have the value $01 (or is it $10, I can never quite tell with the endianness of bytes on Gameboy).

	xor a ; CONVERT_BGP

CONVERT_BGP comes from misc_constants and is part of what I believe is a GBC addition for shinpokered:

	; DMGPalToGBCPal
	CONVERT_BGP  EQU 0
	CONVERT_OBP0 EQU 1
	CONVERT_OBP1 EQU 2

In any case, we now XOR the value in A with 0. 

Now might be a good time to pause _UpdateGBCPAL_BGP and dig in to how wGBCBasePalPointers gets its values.

## Digression: wGBCBasePalPointers

Since wGBCBasePalPointers is 8 bytes that define the GBC's palette, we should look at where this value gets changed. In shinpokered there's really only one spot: Init GBCPalettes:

# SendSGBPackets and InitGBCPalettes

InitGBCPalettes is a bit of code nested inside of SendSGBPackets, which we saw earlier and gets called as a part of SendSGBPackets. Presumably this is because SendSGBPackets is going to have the palette information we need for the GBC calls.

SendSGBPackets from palettes.asm

	SendSGBPackets:
		ld a, [hGBC]	;gbcnote - replaced wGBC
		and a
		jr z, .notGBC
		push de
		call InitGBCPalettes
		pop hl
		;gbcnote - initialize the second pal packet in de (now in hl) then enable the lcd
		call InitGBCPalettes
		ld a, [rLCDC]
		and rLCDC_ENABLE_MASK
		ret z
		call Delay3
		ret
	.notGBC
		push de
		call SendSGBPacket
		pop hl
		jp SendSGBPacket

Line by line:

	ld a, [hGBC]	;gbcnote - replaced wGBC
	and a
	jr z, .notGBC

Load the value of the hGBC flag (set all the way back before init) in to reg A. AND'ing Reg A will give a 1 (true) if it's on GBC and a 0 (false) if not. If the result is a Zero flag, jump relative to .notGBC. Since we're on a GBC we will not skip the next bits.

	push de
	call InitGBCPalettes

Take the value in regs DE and push it to the stack for use later. The value in DE is ??? maybe not important, we'll see in a bit.

Next we call InitGBCPalettes (also in palettes.asm):  

	InitGBCPalettes:	;gbcnote - updating this to work with the Yellow code
		ld a, [hl]
		and $f8
		cp $20	;check to see if hl points to a blk pal packet
		jp z, TranslatePalPacketToBGMapAttributes	;jump if so
		;otherwise hl points to a different pal packet or wPalPacket
		inc hl
	index = 0
		REPT NUM_ACTIVE_PALS
			IF index > 0
				pop hl
			ENDC

			ld a, [hli]	;get palette ID into 'A'
			inc hl

			IF index < (NUM_ACTIVE_PALS + -1)
				push hl
			ENDC

			call GetGBCBasePalAddress	;get palette address into de
			ld a, e
			ld [wGBCBasePalPointers + index * 2], a
			ld a, d
			ld [wGBCBasePalPointers + index * 2 + 1], a

			ld a, CONVERT_BGP
			call DMGPalToGBCPal
			ld a, index
			call TransferCurBGPData

			ld a, CONVERT_OBP0
			call DMGPalToGBCPal
			ld a, index
			call TransferCurOBPData

			ld a, CONVERT_OBP1
			call DMGPalToGBCPal
			ld a, index + 4
			call TransferCurOBPData
	index = index + 1
		ENDR
		ret

Line by line

	ld a, [hl]

Load register A with the value from the address stored in HL. At this point HL may (should?) still contain the address for the SetPal function that we are interested in. (This is coming from _RunPaletteCommand). 

	and $f8

Do an AND between the value in HL's address and $F8. 	



### TBD ###
