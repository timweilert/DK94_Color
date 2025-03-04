;SGB command macros, taken from pokegold, and using constant names from poketcg
;https://gbdev.io/pandocs/#sgb-functions

attr_blk: MACRO
	db (ATTR_BLK << 3) + ((\1 * 6) / 16 + 1)
	db \1
ENDM

attr_blk_data: MACRO
	db \1 ; which regions are affected
	db \2 + (\3 << 2) + (\4 << 4) ; palette for each region
	db \5, \6, \7, \8 ; x1, y1, x2, y2
ENDM

attr_chr: MACRO
	db (ATTR_CHR << 3) + \1
	db \2 ;beginning x coordinate
    db \3 ;beginning y coordinate
    dw \4 ;number of data sets
    db \5 ;writing style
ENDM

attr_set: MACRO
	db (ATTR_SET << 3) + 1
	db \1
    ds 14
ENDM

sgb_pal_set: MACRO
	db (PAL_SET << 3) + 1
	dw \1, \2, \3, \4
    db \5
	ds 6, 0
ENDM

sgb_pal01: MACRO
	db (PAL01 << 3) + 1
ENDM

sgb_pal23: MACRO
	db (PAL23 << 3) + 1
ENDM

sgb_pal_trn: MACRO
	db (PAL_TRN << 3) + 1
	ds 15
ENDM

sgb_pal_pri: MACRO
	db (PAL_PRI << 3) + 1
    db \1
	ds 14
ENDM

sgb_attr_trn: MACRO
	db (ATTR_TRN << 3) + 1
	ds 15
ENDM

sgb_mlt_req: MACRO
	db (MLT_REQ << 3) + 1
	db \1 - 1
	ds 14
ENDM

sgb_chr_trn: MACRO
	db (CHR_TRN << 3) + 1
	db \1 + (\2 << 1)
	ds 14
ENDM

sgb_pct_trn: MACRO
	db (PCT_TRN << 3) + 1
	ds 15
ENDM

sgb_sou_trn: MACRO
	db (SOU_TRN << 3) + 1
	ds 15
ENDM

sgb_mask_en: MACRO
	db (MASK_EN << 3) + 1
	db \1
	ds 14
ENDM

sgb_data_snd: MACRO
	db (DATA_SND << 3) + 1
	dw \1 ; address
	db \2 ; bank
	db \3 ; length (1-11)
ENDM

sgb_sound: MACRO
	db (SOUND << 3) + 1
	db \1
    db \2
    db \3 + (\4 << 2) + (\5 << 4) + (\6 << 6)
    db \7
    ds 11
ENDM

sgb_atrc_en: MACRO
	db (ATRC_EN << 3) + 1
    db \1
	ds 14
ENDM



SGBPacketTable: ; address $4000 in unmodified ROM, although packets don't show up until $40E0
    ; Okay, looking at this closer- the SGB Packet table from $4000 to $40DF is pointers to the packets
    ; Each pointer is flipped, as an example:
    ; $4000: $E0
    ; $4001: $40
    ; These together are reconstituted to $40E0 which points to the address of the first packet's data.
    ; When SendSGBPacketFromTable is called it only takes the single byte indexed value then that function
    ; doubles it to get the actual offset from SGBPacketTable to load the data index from. From there
    ; the data is actually loaded at the proper index (starting at $40E0 per the values encoded between $4000 and $40DF)
    ; Index | Actual offset from SGBPacketTable | Value it points to (per unmodified ROM)
    dw Packet_0 ; index $00 | offset $00 | pointer to data at $40E0
    dw MaskEnBlankBlackPacket ; $01 | $02 | $40F0
    dw Packet_2 ; $02 | $04 | $4100
    dw Packet_3 ; $03 | $06 | $4110
    dw Packet_4 ; $04 | $08 | $4120
    dw PalPriPacket ; $05 | $0A | $4130
    dw Packet_6 ; $06 | $0C | $4140
    dw MaskEnFreezePacket ; $07 | $0E | $4150
    dw Packet_8 ; $08 | $10 | $4160
    dw MltReq1Packet ; $09 | $12 | $4170
    dw MltReq2Packet ; $0A | $14 | $4180
    dw MaskEnCancelPacket ; $0B | $16 | $4190
    dw Packet_12 ; $0C | $18 | $41A0
    dw Packet_13 ; $0D | $1A | $41B0
    dw Packet_14 ; $0E | $1C | $41C0
    dw Packet_15 ; $0F | $1E | $41D0
    dw PalTrnPacket ; $10 | $20 | $41E0
    dw AttrTrnPacket ; $11 | $22 | $41F0
    dw Packet_18 ; $12 | $24 | $4200
    dw Packet_18 ; $13 | $26 | $4200
    dw Packet_18 ; $14 | $28 | $4200
    dw Packet_18 ; $15 | $2A | $4200
    dw Packet_19 ; $16 | $2C | $4210
    dw Packet_20 ; $17 | $2E | $4220
    dw Packet_21 ; $18 | $30 | $4230
    dw Packet_22 ; $19 | $32 | $4240
    dw Packet_23 ; $1A | $34 | $4250
    dw Packet_24 ; $1B | $36 | $4260
    dw Packet_25 ; $1C | $38 | $4270
    dw Packet_26 ; $1D | $3A | $4280
    dw Packet_27 ; $1E | $3C | $4290
    dw Packet_28 ; $1F | $3E | $42A0
    dw SouTrnPacket ; $20 | $40 | $42B0
    dw Packet_30 ; $21 | $42 | $42C0
    dw Packet_31 ; $22 | $44 | $42D0
    dw Packet_32 ; $23 | $46 | $42E0
    dw Packet_33 ; $24 | $48 | $42F0
    dw Packet_34 ; $25 | $4A | $4300
    dw Packet_32 ; $26 | $4C | $42E0
    dw Packet_35 ; $27 | $4D | $4310
    dw Packet_36 ; $28 | $50 | $4320
    dw Packet_37 ; $29 | $52 | $4330
    dw Packet_38 ; $2A | $54 | $4340
    dw Packet_39 ; $2B | $56 | $4350
    dw Packet_40 ; $2C | $58 | $4360
    dw Packet_41 ; $2D | $5A | $4370
    dw Packet_42 ; $2E | $5C | $4380
    dw Packet_43 ; $2F | $5E | $4390
    dw Packet_44 ; $30 | $60 | $43A0
    dw Packet_45 ; $31 | $62 | $43B0
    dw Packet_46 ; $32 | $64 | $43C0
    dw Packet_47 ; $33 | $66 | $43D0
    dw Packet_48 ; $34 | $68 | $43E0
    dw Packet_50 ; $35 | $6A | $4400
    dw Packet_49 ; $36 | $6C | $43F0
    dw Packet_51 ; $37 | $6E | $4410
    dw Packet_52 ; $38 | $70 | $4420
    dw Packet_53 ; $39 | $72 | $4430
    dw Packet_54 ; $3A | $74 | $4440
    dw Packet_55 ; $3B | $76 | $4450
    dw Packet_56 ; $3C | $78 | $4460
    dw Packet_57 ; $3D | $7A | $4470
    dw Packet_57 ; $3E | $7C | $4470
    dw Packet_58 ; $3F | $7E | $4480
    dw Packet_59 ; $40 | $80 | $4490
    dw Packet_60 ; $41 | $82 | $44A0
    dw Packet_61 ; $42 | $84 | $44B0
    dw Packet_62 ; $43 | $86 | $44C0
    dw Packet_63 ; $44 | $88 | $44D0
    dw Packet_64 ; $45 | $8A | $44E0
    dw Packet_65 ; $46 | $8C | $44F0
    dw Packet_66 ; $47 | $8E | $4500
    dw Packet_67 ; $48 | $90 | $4510
    dw Packet_68 ; $49 | $92 | $4520
    dw Packet_69 ; $4A | $94 | $4530
    dw Packet_70 ; $4B | $96 | $4540
    dw Packet_71 ; $4C | $98 | $4550
    dw AttractionDisablePacket ; $4D | $9A | $4560
    dw AttractionEnablePacket ; $4E | $9C | $4570
    dw Packet_74 ; $4F | $9E | $4580
    dw Packet_75 ; $50 | $A0 | $4590
    dw Packet_77 ; $51 | $A2 | $45B0 * skips a packet
    dw Packet_78 ; $52 | $A4 | $45C0
    dw Packet_77 ; $53 | $A6 | $45B0
    dw Packet_78 ; $54 | $A8 | $45C0
    dw Packet_78 ; $55 | $AA | $45C0
    dw Packet_77 ; $56 | $AC | $45B0
    dw Packet_78 ; $57 | $AE | $45C0
    dw Packet_79 ; $58 | $B0 | $45D0
    dw Packet_77 ; $59 | $B2 | $45B0
    dw Packet_79 ; $5A | $B4 | $45D0
    dw Packet_70 ; $5B | $B6 | $4540
    dw Packet_70 ; $5C | $B8 | $4540
    dw Packet_70 ; $5D | $BA | $4540
    dw Packet_70 ; $5E | $BC | $4540
    dw Packet_80 ; $5F | $BE | $45E0
    dw Packet_85 ; $60 | $C0 | $4630
    dw Packet_86 ; $61 | $C2 | $4640
    dw Packet_87 ; $62 | $C4 | $4650
    dw Packet_88 ; $63 | $C6 | $4660
    dw Packet_81 ; $64 | $C8 | $45F0
    dw Packet_82 ; $65 | $CA | $4600
    dw Packet_83 ; $66 | $CC | $4610
    dw Packet_84 ; $67 | $CE | $4620
    dw SGBPatch1 ; $68 | $D0 | $4670
    dw SGBPatch2 ; $69 | $D2 | $4680
    dw SGBPatch3 ; $6A | $D4 | $4690
    dw SGBPatch4 ; $6B | $D6 | $46A0
    dw SGBPatch5 ; $6C | $D8 | $46B0
    dw SGBPatch6 ; $6D | $DA | $46C0
    dw SGBPatch7 ; $6E | $DC | $46D0
    dw SGBPatch8 ; $6F | $DE | $46E0

;offset 40e0
Packet_0:
    sgb_pal_set $2C, $2D, $2C, $2D, 0
MaskEnBlankBlackPacket:
    sgb_mask_en 2
Packet_2:
    sgb_sound $0C, $00, 0, 2, 0, 2, 0
Packet_3:
    attr_set $03
Packet_4:
    attr_blk 1
    attr_blk_data 1, 0, 0, 0, 0, 0, $13, $11
    ds 8
PalPriPacket:
    sgb_pal_pri 1
Packet_6:
    sgb_pal_set $B0, $B1, $B2, $B3, $D1
MaskEnFreezePacket:
    sgb_mask_en 1
Packet_8:
    sgb_pal_set $B4, $B5, $B6, $B7, $D2
MltReq1Packet:
    sgb_mlt_req 1
MltReq2Packet:
    sgb_mlt_req 2
MaskEnCancelPacket:
    sgb_mask_en 0
Packet_12:
    sgb_pal_set $AC, $AD, $AE, $AF, $D0
Packet_13:
    sgb_pal_set $AC, $AD, $AE, $E7, $D0
Packet_14:
    attr_set $01
Packet_15:
    attr_set $17
PalTrnPacket:
    sgb_pal_trn
AttrTrnPacket:
    sgb_attr_trn
Packet_18:
    sgb_pal_set $04, $05, $06, $07, $C3
Packet_19:
    sgb_pal_set $08, $09, $0A, $0B, $C7
Packet_20:
    sgb_pal_set $0C, $0D, $0E, $0F, $C8
Packet_21:
    sgb_pal_set $10, $11, $12, $13, $C9
Packet_22:
    sgb_pal_set $14, $15, $16, $17, $CA
Packet_23:
    sgb_pal_set $18, $19, $1A, $1B, $CB
Packet_24:
    sgb_pal_set $1C, $1D, $1E, $1F, $CC
Packet_25:
    sgb_pal_set $20, $21, $22, $23, $CD
Packet_26:
    sgb_pal_set $24, $25, $26, $27, $CE
Packet_27:
    sgb_pal_set $28, $29, $2A, $2B, $CF
Packet_28:
    sgb_sound $80, $80, 0, 3, 0, 2, 0
SouTrnPacket:
    sgb_sou_trn
Packet_30:
    sgb_pal_set $00, $2D, $2E, $2F, $40

; Packet_30 is the first actual color data to be loaded during intialization. 
; Note Packet_30 is at address $42C0
;
; Packet_30:
;     sgb_pal_set $00, $2D, $2E, $2F, $40
;
; where sgb_pal_set is as follows: 
;
; sgb_pal_set: MACRO
; 	db (PAL_SET << 3) + 1
; 	dw \1, \2, \3, \4
;     db \5
; 	ds 6, 0
; ENDM
;
; And PAL_SET is a constant equal to $0A, but see the notes in sgb_constants.asm about what each bit does. '
; Reproduced here for ease of use. 
; Used to copy pre-defined palette data from SGB system color palettes to actual SNES palettes.
; Note: all palette numbers are little-endian.
;  Byte  Content
;  0     Command*8+Length (fixed length=1)
;  1-2   System Palette number for SGB Color Palette 0 (0-511)
;  3-4   System Palette number for SGB Color Palette 1 (0-511)
;  5-6   System Palette number for SGB Color Palette 2 (0-511)
;  7-8   System Palette number for SGB Color Palette 3 (0-511)
;  9     Attribute File
;          Bit 0-5 - Attribute File Number (00h-2Ch) (Used only if Bit7=1)
;          Bit 6   - Cancel Mask           (0=No change, 1=Yes)
;          Bit 7   - Use Attribute File    (0=No, 1=Apply above ATF Number)
;  A-F   Not used (zero)
; Before using this function, System Palette data should be initialized by PAL_TRN command, and (when used) Attribute File data should be initialized by ATTR_TRN.
;
; As an aside- in shinpokered the SGB pallette set macro is similar except it doesn't have \5 - it just set the last 7 bytes to 0
; rather than a \5th input followed by 6 bytes of 0s. 
;
; This makes the data at Packet 30 as follows:
;
; db $51
; dw $00, $2D, $2E, $2F, $40
; db $40
; ds 6, 0
;
; which gives the following: $51, $00, $00, $2D, $00, $2E, $00, $2F, $40, $00, $00, $00, $00, $00, $00
;
; Byte   Content   Description
; 0      $51       Command*8 + a fixed length of 1. Reverseing this we get Command = ($51 - $1)/$8 == $0A, the PAL_SET command.
; 1-2    $0000     SGB0 Palette number (0-511) - in this case palette 0
; 3-4    $2D00     SGB1 Palette number (0-511) - remember this is little endian, so it's really $002D or 45
; 5-6    $2E00     SGB2 Palette number (0-511) - dec 46
; 7-8    $2F00     SGB3 Palette number (0-511) - dec 47
; 9      $40       Attribute file, $40 = %0100 0000
; So looking at the attribute file value here we can see that we are using attribute file number $00, no Cancel Mask, and we will use the Attr file (bit 7)
;
; According to pandoc (https://gbdev.io/pandocs/SGB_Command_Palettes.html#sgb-command-0b--pal_trn) the raw data for these 512 palettes lives
; at memory addresses $3000 to $3FFF in SNES memory (not in GB memory). 
; 
; Trying to find a good resource for what these values are so I can create GB equivalents.
; 
; Effectively 16 bytes describing palette data. 
; https://gbdev.io/pandocs/SGB_Color_Palettes.html
; I think this could be 0000 2D00 2E00 2F40
; where                 PAL0 PAL1 PAL2 PAL3
; and since colors are encoded as 16 bit RGB as follows:
; Index: FEDC BA98 7654 3210
; Color: 0BBB BBGG GGGR RRRR
; So for PAL1 as an example:
; $2D00 = %0010 1101 0000 0000
;          0BBB BBGG GGGR RRRR
; So R is %00000, $0
;    G is %00010; $2
;    B is %11010; $1A
;
; I'm fairly certain $51 is the header and $40 with the 6 bytes of 0s behind it is the footer. 
;
; Confirmed via  https://gbdev.io/pandocs/SGB_Command_Palettes.html for SGB Command $00 - PAL01
;  Byte  Content
;  0     Command*8+Length (fixed length=01h)
;  1-E   Color Data for 7 colors of 2 bytes (16 bits) each:
;          Bit 0-4   - Red Intensity   (0-31)
;          Bit 5-9   - Green Intensity (0-31)
;          Bit 10-14 - Blue Intensity  (0-31)
;          Bit 15    - Not used (zero)
;  F     Not used (00h)
;
; 
;
; In practice the following values are visible with the debugger:
; SBG0:
; 6FBE - a kind of cream
; 001A - cherry red
; 1975 - brown
; 0485 - black'ish
;
; SGB1:
; 6FBE - cream
; 42BF - tan'ish pink
; 295F - bright pink
; 2DCF - dark grey
;
; SGB2:
; 6FBE - cream
; 575F - orange'ish pink
; 3dFF - middle pink
; 4274 - grey
;
; SGB3:
; 6FBE - cream
; 6BFF - light pale yellow
; 529F - pink
; 5719 - light grey
;
; using $6FBE as an example
;  BBBBB GGGGG RRRRR 
; %11011 11101 11110
; Gives the following values for each color:
; B: $1B | 27
; G: $1D | 29
; R: $1E | 30
; Doing a little math to convert to a 256 color palette (a la MS Paint)
; (value/32)=(x/256)
; Plugging these values in to MS Paint:
; B: 216
; G: 232
; R: 240
; Gives the cream color that we see in BGB. 

Packet_31:
    sgb_pal_set $00, $01, $02, $03, $C2
Packet_32:
    sgb_pal_set $B8, $B9, $BA, $BB, $C6
Packet_33:
    sgb_pal_set $B8, $B9, $BA, $BB, $D3
Packet_34:
    sgb_pal_set $B8, $B9, $BA, $BB, $D5
Packet_35:
    sgb_chr_trn 0, 0
Packet_36:
    sgb_pct_trn
Packet_37:
    sgb_pal_set $BC, $BD, $BE, $BF, $D4
Packet_38:
    sgb_chr_trn 1, 0
Packet_39:
    sgb_pal_set $CC, $CD, $CE, $CF, $C4
Packet_40:
    attr_set $18
Packet_41:
    sgb_pal01
    REPT 7
    RGB 0,0,0
    ENDR
    db $00
Packet_42:
    sgb_pal23
    REPT 7
    RGB 0,0,0
    ENDR
    db $00
Packet_43:
    sgb_pal_set $0180, $0180, $0180, $0180, $D6
Packet_44:
    sgb_pal_set $C4, $C5, $C6, $C7, $C0
Packet_45:
    sgb_pal_set $2C, $2D, $2C, $2D, $40
Packet_46:
    sgb_pal_set $E8, $E9, $EA, $EB, $DB
Packet_47:
    sgb_pal_set $EC, $ED, $EE, $EF, $DC
Packet_48:
    sgb_pal_set $F0, $F1, $F2, $F3, $DC
Packet_49:
    sgb_pal_set $F0, $F1, $F2, $F3, $DD
Packet_50:
    sgb_pal_set $F0, $F1, $F2, $F3, $DE
Packet_51:
    sgb_pal_set $F0, $F1, $F2, $F3, $DF
Packet_52:
    sgb_pal_set $F4, $F5, $F6, $F7, $E0
Packet_53:
    sgb_pal_set $F8, $F9, $FA, $FB, $E1
Packet_54:
    sgb_pal_set $FC, $FD, $FE, $FF, $DD
Packet_55:
    sgb_pal_set $FC, $FD, $FE, $FF, $DD
Packet_56:
    sgb_pal_set $FC, $FD, $FE, $FF, $DD
Packet_57:
    sgb_pal_set $100, $101, $102, $103, $DF
Packet_58:
    sgb_pal_set $100, $101, $102, $103, $E3
Packet_59:
    sgb_pal_set $104, $105, $106, $107, $E4
Packet_60:
    sgb_pal_set $104, $105, $106, $107, $E5
Packet_61:
    sgb_pal_set $104, $105, $106, $107, $E6
Packet_62:
    sgb_pal_set $104, $105, $106, $107, $E6
Packet_63:
    sgb_pal_set $104, $105, $106, $107, $E7
Packet_64:
    sgb_pal_set $108, $109, $10A, $10B, $E8
Packet_65:
    sgb_pal_set $108, $109, $10A, $10B, $E9
Packet_66:
    sgb_pal_set $114, $115, $116, $117, $EA
Packet_67:
    sgb_pal_set $108, $109, $10A, $10B, $EB
Packet_68:
    sgb_pal_set $108, $109, $10A, $10B, $EC
Packet_69:
    sgb_pal_set $10C, $10D, $10E, $10F, $D9
Packet_70:
    sgb_pal_set $C8, $C9, $CA, $CB, $C5
Packet_71:
    sgb_pal_set $108, $109, $10A, $10B, $E2
AttractionDisablePacket:
    sgb_atrc_en 0
AttractionEnablePacket:
    sgb_atrc_en 1
Packet_74:
    sgb_sound $00, $00, 0, 0, 0, 0, 3
Packet_75:
    attr_blk 3
    attr_blk_data 1, 0, 0, 0, $0B, $04, $12, $09
    attr_blk_data 1, 0, 0, 0, $01, $0B, $08, $10
    attr_blk_data 1, 0, 0, 0, $0B, $0B, $12, $10
    ds 12
Packet_77:
    attr_blk 2
    attr_blk_data 1, 0, 0, 0, $0B, $04, $12, $09
    attr_blk_data 1, 0, 0, 0, $01, $0B, $08, $10
    ds 2
Packet_78:
    attr_blk 1
    attr_blk_data 1, 0, 0, 0, $0B, $0B, $12, $10
    ds 8
Packet_79:
    sgb_pal_set $C0, $C1, $C2, $C3, $9A
Packet_80:
    sgb_pal_set $1FF, $1FF, $1FF, $1FF, $C1
Packet_81:
    attr_chr 1, $04, $0E, 3, 0
    db $3C
    ds 9
Packet_82:
    attr_chr 1, $08, $0E, 3, 0
    db $3C
    ds 9
Packet_83:
    attr_chr 1, $0C, $0E, 3, 0
    db $3C
    ds 9
Packet_84:
    attr_chr 1, $10, $0E, 3, 0
    db $3C
    ds 9
Packet_85:
    attr_chr 1, $04, $10, 3, 0
    db $FC
    ds 9
Packet_86:
    attr_chr 1, $08, $10, 3, 0
    db $FC
    ds 9
Packet_87:
    attr_chr 1, $0C, $10, 3, 0
    db $FC
    ds 9
Packet_88:
    attr_chr 1, $10, $10, 3, 0
    db $FC
    ds 9

;These packets contain SNES code which patches the SGB's code
;by sending it to the SNES's RAM, which apparently fixes a bug.
;https://forums.nesdev.com/viewtopic.php?f=12&t=16610#p206526
SGBPatch1:
    sgb_data_snd $85D, $00, $04
    db $8C ;used by last instruction of next packet
    db $D0, $F4 ;bne -0xC
    db $60 ;rts
    ds 7

SGBPatch2:
    sgb_data_snd $852, $00, $0B
    db $A9, $E7 ;lda 0xE7
    db $9F, $01, $C0, $7E ;sta $7EC001,x
    db $E8 ;inx
    db $E8 ;inx
    db $E8 ;inx
    db $E8 ;inx
    db $E0 ;cpx 0x8C (uses first byte of the previous packet)

SGBPatch3:
    sgb_data_snd $847, $00, $0B
    db $C4
    db $D0, $16 ;bne 0x16
    db $A5, $CB ;lda $CB
    db $C9, $05 ;cmp 5
    db $D0, $10 ;bne 0x10
    db $A2, $28 ;ldx 0x28

SGBPatch4:
    sgb_data_snd $83C, $00, $0B
    db $F0, $12 ;beq 0x12
    db $A5, $C9 ;lda $C9
    db $C9, $C8 ;cmp 0xC9
    db $D0, $1C ;bne 0x1C
    db $A5, $CA ;lda $CA
    db $C9 ;cmp 0xC4

SGBPatch5:
    sgb_data_snd $831, $00, $0B
    db $0C ;used by last instruction of next packet
    db $A5, $CA ;lda $CA
    db $C9, $7E ;cmp 0x7E
    db $D0, $06 ;bne 0x06
    db $A5, $CB ;lda $CB
    db $C9, $7E ;cmp 0x7E

SGBPatch6:
    sgb_data_snd $826, $00, $0B
    db $39 ;used by last instruction of next packet
    db $CD, $48, $0C ;cmp $C48
    db $D0, $34 ;bne 0x34
    db $A5, $C9 ;lda $C9
    db $C9, $80 ;cmp 0x80
    db $D0 ;bne 0x0C (uses first byte of the previous packet)

SGBPatch7:
    sgb_data_snd $81B, $00, $0B
    db $EA, $EA, $EA, $EA, $EA ;5 nop instructions
    db $A9, $01 ;0x820: lda 1
    db $CD, $4F, $0C ;cmp $C4f
    ;0x825
    db $D0 ;bne 0x39 (uses first byte of the previous packet)

SGBPatch8:
    sgb_data_snd $810, $00, $0B
    db $4C, $20, $08 ;jmp $820
    db $EA, $EA, $EA, $EA, $EA ;5 nop instructions
    db $60 ;rts
    db $EA, $EA ;2 nop instructions
