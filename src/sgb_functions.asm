;function for checking whether the game is running on Super Gameboy or not
; This is going to be an essential part of porting in GBC functionality since
; we need the program to think it is a SGB to get palette data, but not do many of the other
; SGB functions such as borders and comms with SGB specific hardware.
CheckIfOnSGB:
    ldh a, [rIE] ; Load A with the value from Hi RAM for the interrupt enable register rIE
    set 0, a ; Set bit 0 in Register A to 1. 
    ei ;enable interrupts
    ld a, $0a ; Set A to the value $0A
    call SendSGBPacketFromTableSkipSGBCheck ; Sends a packet, even if we aren't on a SGB. 
    ; PICK UP HERE!
    ldh a, [rJOYP]
    cp $ff
    jr nz, .onSGB
    call CheckInputSGB
    ldh a, [rJOYP]
    cp $ff
    jr nz, .onSGB
    ld a, $09
    call SendSGBPacketFromTableSkipSGBCheck
    ld hl, wIsOnSGB
    res 7, [hl] ;set the bit 7 of wIsOnSGB to 0 if not running on sgb, otherwise set it to 1
    ld a, $cc ;if the game is not running on sgb, set da40(HUD text type) to cc, otherwise set it to 9c
    ld [wHUDTextType], a
    di ;disable interrupts
    ret ;return
.onSGB
    ld hl, wIsOnSGB
    set 7, [hl]
    ld a, $9c 
    ld [wHUDTextType], a
    ld a, $2d
    call SendSGBPacketFromTableDelay
    ld a, $1f
    call SendSGBPacketFromTableDelay
    di
    call InitRegistersSGBPacket
    ld a, $e4
    ldh [rBGP], a
    ld hl, $9800
    ld de, $000c
    ld a, $80
    ld b, $0d
.loop1:
    ld c, $14
.loop2:
    ld [hl+], a
    inc a
    dec c
    jr nz, .loop2
    add hl, de
    dec b
    jr nz, .loop1
    ld a, $1e ;switch to bank 1e, which contains alot of the sgb exclusive graphics
    rst BankswitchRST
    ;load the sgb border graphics
    ld hl, SGBBorderGraphics1
    ld de, $8800 ;vram offset to copy graphics to
    ld bc, $1000 ;uncompressed size
    call DecompressNoHeader
    ld a, $81
    ldh [rLCDC], a
    ld a, $27
    call SendSGBPacketFromTableDelay
    ei
    di
    call InitRegistersSGBPacket
    ld hl, SGBBorderGraphics2
    ld de, $8800
    ld bc, $06e0
    call DecompressNoHeader
    ld a, $81
    ldh [rLCDC], a
    ld a, $2a
    call SendSGBPacketFromTableDelay
    ei
    di
    call InitRegistersSGBPacket
    ld hl, Bank1E_Graphics_6125 ;this doesn't seem like graphics
    ld de, $8800
    ld bc, $0860
    call DecompressNoHeader
    ld a, $81
    ldh [rLCDC], a
    ld a, $28
    call SendSGBPacketFromTableDelay
    ei
    di
    call InitRegistersSGBPacket
    ld hl, SGBBorderPaletteData
    ld de, $8800
    ld bc, $1000
    call DecompressNoHeader
    ld a, $81
    ldh [rLCDC], a
    ld a, $10
    call SendSGBPacketFromTableDelay
    ei
    di
    call InitRegistersSGBPacket
    ld hl, UnknownData_1E_4C72
    ld de, $8800
    ld bc, $0fd2
    call DecompressNoHeader
    ld a, $81
    ldh [rLCDC], a
    ld a, $11
    call SendSGBPacketFromTableDelay
    ei
    di
    call InitRegistersSGBPacket
    ld a, $0c
    rst BankswitchRST ;switch to bank C
    ld hl, UnknownData_0c_5ddd
    ld de, $8800
    ld bc, $0680
    call CopyData16
    ld a, $81
    ldh [rLCDC], a
    ld a, $20
    call SendSGBPacketFromTableDelay
    ei
    di
    call InitRegistersSGBPacket
    ld hl, $6438 ;offset to the pauline help sfx in bank 0xC
    ld de, $8800
    ld bc, $0bca
    call CopyData16
    ld a, $81
    ldh [rLCDC], a
    ld a, $20
    call SendSGBPacketFromTableDelay
    ei
    ld a, $05
    call SendSGBPacketFromTable
    ld a, $09
    call SendSGBPacketFromTable
    jp SendSGBPatchPackets


SendSGBPacketFromTableDelay:
    call SendSGBPacketFromTable
    ld b, 8
    jr DelayMainLoop

;Delays by ~70000 cycles (about 4 frames)
Delay2:
    ld b, 4
DelayMainLoop:
    ld de, 1750 ;Delay around 17500 cycles (1749*10 + 13 = 17503 cycles)
    call DelayLoop
    dec b
    jr nz, DelayMainLoop
    ret


InitRegistersSGBPacket:
    ldh a, [rIE]
    ld [wIERegisterTemp], a
    res 0, a
    ldh [rIE], a
.loop:
    ldh a, [rLY]
    cp $91 ;wait for vblank
    jr c, .loop
    ldh a, [rLCDC]
    and $7f ;and the lcdc register with 7f
    ldh [rLCDC], a
    ld a, [wIERegisterTemp]
    ldh [rIE], a ;set the IE register
    ret


;Delays by 10*de + 3 cycles
DelayLoop:
.loop
    nop
    nop
    nop
    dec de
    ld a, d
    or e
    jr nz, .loop
    ret

SendSGBPacketFromTableSkipSGBCheck:
    ld b, a ; Set B to the value from A
    ; During startup A has the value $0A
    jr SendSGBPacketFromTable.skipSGBCheck ; jump to the function but we're skipping the SGB check at this point

;a: pointer table index
SendSGBPacketFromTable:
    ld b, a ; Set B to the value from A
    ld a, [wIsOnSGB] ; Set A to the value of the wIsOnSGB flag
    bit 7, a ; Test bit 7 of register A, set the zero flag if the bit is not set.
    ; wIsOnSGB should have a value of %01000000 ($40) if we are on a SGB. 
    ret z ;return if the game is not running on sgb
.skipSGBCheck: ; can also be jumped to by the SendSGBPacketFromTableSkipGBCCheck function
    ; this is where the function starts during the startup routine.
    ldh a, [hCurrentBank] ; Load A with the value from Hi RAM for hCurrentBank
    ; on startup this value is $03 by the time we get here. Not entirely sure why.
    push af ; Push AF on to the stack
    ; At startup this would contain A == $0A
    ld a, BANK(SGBPacketTable) ;load the bank with the table (bank 1e)
    rst BankswitchRST ; Switch to the bank with the SGBPacketTable. Calls the code at the address for BankswitchRST
    ; Bankswitch RST is in the low ROM, address $0010 - part of the Gameboy bootloader perhaps?
    ld hl, SGBPacketTable ; Load HL with the base address for SGBPacketTable
    ld a, b ; Load A with the value from B. 
    ; During startup B was seeded with the value from A, so A is now set back to $0A
    add a ; Double A
    ; At startup, $0A + $0A == $14
    ld d, $00 ; Set D to value $00
    ld e, a ; Set E to value from A
    ; At startup, E is now $14
    add hl, de ; Add HL and DE, store result in HL
    ; At startup, HL is the address for the SGBPacketTable, DE is $0014 ($00 plus 2* the value from A at the beginning)
    ; In an unmodified ROM, the value for SGBPacketTable appears to be the same as InitSound, address $4000, confirmed by debugger
    ; Also confirmed by debugger- addr. $4000 is RO1E:4000 and is the SGBPacketTable. 
    ; Each packet in SGBPacket table is a word, so 2 bytes.
    ; $14 as an index of SGBPacketTable is Packet18, which is 'sgb_pal_set $04, $05, $06, $07, $C3'
    ; In any case, HL is now $4014. 
    ld a, [hl+] ; Load A with the value from HL and increment HL.
    ; On startup value is $80 and HL goes to $4015
    ld h, [hl] ; Set H to the value at HL 
    ; At start (value at $4015), value at $4015 at this time is $41, HL is now $4115
    ld l, a ; Set L to value from A
    ; At start- this is $80, so HL now becomes $4180
    call SendSGBPacket ; Sends a SGB packet, even if we aren't on a SGB. Most likely to initialize the values needed just in case we are.
    call Delay2 ; Delay for 4 frames
    pop af ; Pop AF back off the stack, remember this now contains the previous bank information ($0A)
    rst BankswitchRST ; switch to the previous bank and return
    ret


SendSGBPacketCheckSGB:
    ld a, [wIsOnSGB]
    bit 7, a
    ret z ;return if the game is not running on sgb
    call SendSGBPacket
    jp Delay2

;hl: offset to packet data
SendSGBPacket:
    ld a, [hl] ; Set A to the value stored at HL
    ; During startup HL is $4180 at when this is called.
    ; $4180 is the address for MltReq2Packet in an unmodified ROM
    ; Value at this address is $89 during startup, so A goes to $89
    and $07 ; Do an AND between the value from HL and A store the result in A
    ; At startup $89 AND $07 equals $01
    ld b, a ; Load B with new value from A
    ; At startup this is $01, remember this is with a GBC
    ld c, $00 ; set C to value $00
    push bc ; Push BC to the stack
.loop:
    xor a ; set A to 0
    ;Set P14/P15 to 0 (reset signal)
    ld [c], a ; Set the value at $FF00 + C to 0
    ; As seen above this means $FF00 now goes to 0
    ; $FF00 is the rJOYP register, per pandocs
    ; https://gbdev.io/pandocs/Joypad_Input.html?highlight=Ff00#ff00--p1joyp-joypad
    ; "Usage in SGB Software: Beside for normal joypad input, SGB games misuse the 
    ; joypad register to output SGB command packets to the SNES, also, SGB programs 
    ; may read out gamepad states from up to four different joypads which can be 
    ; connected to the SNES. See SGB description for details."
    ld a, $30
    ;Set P14/P15 to 1
    ld [c], a ; Set the rJOYP register to $30 now
    ld b, $10 ; Set B to $10
.nextByte:
    ld e, $08
    ld a, [hl+] ;Get the next byte
    ld d, a
.nextBit:
    bit 0, d
    ld a, $10 ;If the bit is 0, set P14/P15 to 0/1, otherwise set them to 1/0
    jr nz, .zeroBit
    ld a, $20 ;Set P14/P15 to 1/0 (bit is 1)
.zeroBit:
    ld [c], a
    ;Set P14/P15 to 1 (must set between pulses)
    ld a, $30
    ld [c], a
    rr d ;go to the next bit
    dec e
    jr nz, .nextBit
    dec b
    jr nz, .nextByte
    ;Send bit 1 as a stop bit (end of parameter data)
    ld a, $20
    ld [c], a
    ;Set P14/P15 to 1
    ld a, $30
    ld [c], a
    pop bc
    dec b
    ret z ;return if there are no more packets
    push bc
    call Delay2 ;wait for 70000 cycles
    jr .loop

CheckInputSGB:
    ld a, $20
    ldh [rJOYP], a
    ldh a, [rJOYP]
    ldh a, [rJOYP]
    cpl
    and $0f
    swap a
    ld b, a
    ld a, $30
    ldh [rJOYP], a
    ld a, $10
    ldh [rJOYP], a
    ldh a, [rJOYP]
    ldh a, [rJOYP]
    ldh a, [rJOYP]
    ldh a, [rJOYP]
    ldh a, [rJOYP]
    ldh a, [rJOYP]
    ld a, $30
    ldh [rJOYP], a
    ret

;Sends the 8 last data_snd packets in the table, which send a patch for the
;SGB's code to the SNES's RAM.
SendSGBPatchPackets:
    ld c, $08
    ld a, $68 ;Set a to the index of the first data_snd packet
.loop:
    push af
    push bc
    call SendSGBPacketFromTable
    pop bc
    pop af
    inc a
    dec c
    jr nz, .loop
    ret
