SGB_PACKET_SIZE EQU $10 ; bytes

PAL01    EQU $00 ; Set SGB Palette 0,1 Data
PAL23    EQU $01 ; Set SGB Palette 2,3 Data
PAL03    EQU $02 ; Set SGB Palette 0,3 Data
PAL12    EQU $03 ; Set SGB Palette 1,2 Data

; There are 4 banks of SGB palette data (SGB0 through SGB3)
; These constants are used to select which palettes are being addressed

ATTR_BLK EQU $04 ; "Block" Area Designation Mode
ATTR_LIN EQU $05 ; "Line" Area Designation Mode
ATTR_DIV EQU $06 ; "Divide" Area Designation Mode
ATTR_CHR EQU $07 ; "1CHR" Area Designation Mode
SOUND    EQU $08 ; Sound On/Off
SOU_TRN  EQU $09 ; Transfer Sound PRG/DATA
PAL_SET  EQU $0a ; Set SGB Palette Indirect

; Per https://gbdev.io/pandocs/SGB_Command_Palettes.html#sgb-command-0a--pal_set
; 
; Used to copy pre-defined palette data from SGB system color palettes to actual SNES palettes.
;
; Note: all palette numbers are little-endian.
;
;     Byte  Content
;     0     Command*8+Length (fixed length=1)
;     1-2   System Palette number for SGB Color Palette 0 (0-511)
;     3-4   System Palette number for SGB Color Palette 1 (0-511)
;     5-6   System Palette number for SGB Color Palette 2 (0-511)
;     7-8   System Palette number for SGB Color Palette 3 (0-511)
;     9     Attribute File
;             Bit 0-5 - Attribute File Number (00h-2Ch) (Used only if Bit7=1)
;             Bit 6   - Cancel Mask           (0=No change, 1=Yes)
;             Bit 7   - Use Attribute File    (0=No, 1=Apply above ATF Number)
;     A-F   Not used (zero)
;    Before using this function, System Palette data should be initialized by PAL_TRN command, and (when used) Attribute File data should be initialized by ATTR_TRN.

PAL_TRN  EQU $0b ; Set System Color Palette Data
ATRC_EN  EQU $0c ; Enable/disable Attraction Mode
TEST_EN  EQU $0d ; Speed Function
ICON_EN  EQU $0e ; SGB Function
DATA_SND EQU $0f ; SUPER NES WRAM Transfer 1
DATA_TRN EQU $10 ; SUPER NES WRAM Transfer 2
MLT_REQ  EQU $11 ; Controller 2 Request
JUMP     EQU $12 ; Set SNES Program Counter
CHR_TRN  EQU $13 ; Transfer Character Font Data
PCT_TRN  EQU $14 ; Set Screen Data Color Data
ATTR_TRN EQU $15 ; Set Attribute from ATF
ATTR_SET EQU $16 ; Set Data to ATF
MASK_EN  EQU $17 ; Game Boy Window Mask
OBJ_TRN  EQU $18 ; Super NES OBJ Mode
PAL_PRI  EQU $19 ; Palette Priority

ATTR_BLK_CTRL_INSIDE  EQU 1
ATTR_BLK_CTRL_LINE    EQU 2
ATTR_BLK_CTRL_OUTSIDE EQU 4

MLT_REQ_1_PLAYER  EQU 0
MLT_REQ_2_PLAYERS EQU 1
MLT_REQ_4_PLAYERS EQU 3

MASK_EN_CANCEL_MASK          EQU 0
MASK_EN_FREEZE_SCREEN        EQU 1
MASK_EN_BLANK_SCREEN_BLACK   EQU 2
MASK_EN_BLANK_SCREEN_COLOR_0 EQU 3
