; Disassembly of "donkeykong.gb"
; This file was created with mgbdis v1.3 - Game Boy ROM disassembler by Matt Currie.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $01e", ROMX[$4000], BANK[$1e]


INCLUDE "data/sgb_packets.asm"

;46f0
;sgb border palette data
SGBBorderPaletteData::
INCBIN "data/sgb_border_palette_data.bin"

UnknownData_1E_4C72::
INCBIN "data/bank_1e_4c72.bin" 

SGBBorderGraphics1::
INCBIN "gfx/sgb_border_1.bin"

SGBBorderGraphics2::
INCBIN "gfx/sgb_border_2.bin"

Bank1E_Graphics_6125::
INCBIN "gfx/bank1e_graphics_6125.bin"

;offset 0x64c5
UnknownData_1e_64c5::
    db $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00, $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00, $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00, $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00, $ff, $00, $1c, $3e, $38, $7c, $ff, $00, $ff, $00, $1c
    db $3e, $38, $7c, $ff, $00, $ff, $00, $07, $8f, $0e, $1f, $ff, $00, $ff, $00, $70
    db $f8, $e0, $f1, $ff, $00, $ff, $00, $c1, $e3, $83, $c7, $ff, $00, $ff, $00, $c1
    db $e3, $83, $c7, $ff, $00, $ff, $00, $70, $f8, $e0, $f1, $ff, $00, $ff, $00, $07
    db $8f, $0e, $1f, $ff, $00, $ff, $00, $1c, $3e, $38, $7c, $ff, $00, $ff, $00, $1c
    db $3e, $38, $7c, $ff, $00, $ff, $00, $07, $8f, $0e, $1f, $ff, $00, $ff, $00, $70
    db $f8, $e0, $f1, $ff, $00, $ff, $00, $c1, $e3, $83, $c7, $ff, $00, $ff, $00, $c1
    db $e3, $83, $c7, $ff, $00, $ff, $00, $70, $f8, $e0, $f1, $ff, $00, $ff, $00, $07
    db $8f, $0e, $1f, $ff, $00, $ff, $00, $1c, $3e, $38, $7c, $ff, $00, $ff, $00, $1c
    db $3e, $38, $7c, $ff, $00, $ff, $00, $07, $8f, $0e, $1f, $ff, $00, $ff, $00, $70
    db $f8, $e0, $f1, $ff, $00, $ff, $00, $c1, $e3, $83, $c7, $ff, $00, $ff, $00, $c1
    db $e3, $83, $c7, $ff, $00, $ff, $00, $70, $f8, $e0, $f1, $ff, $00, $ff, $00, $07
    db $8f, $0e, $1f, $ff, $00, $ff, $00, $1c, $3e, $38, $7c, $ff, $00, $ff, $00, $1c
    db $3e, $38, $7c, $ff, $00, $ff, $00, $07, $8f, $0e, $1f, $ff, $00, $ff, $00, $70
    db $f8, $e0, $f1, $ff, $00, $ff, $00, $c1, $e3, $83, $c7, $ff, $00, $ff, $00, $c1
    db $e3, $83, $c7, $ff, $00, $ff, $00, $70, $f8, $e0, $f1, $ff, $00, $ff, $00, $07
    db $8f, $0e, $1f, $ff, $00, $00, $00, $00, $00, $80, $80, $70, $f0, $2f, $7f, $00
    db $0c, $bb, $bb, $fe, $ff, $00, $00, $00, $00, $00, $00, $30, $30, $4e, $5e, $85
    db $8f, $00, $15, $77, $77, $00, $00, $00, $00, $06, $06, $09, $0b, $70, $70, $a0
    db $e6, $0e, $1f, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $8e
    db $8e, $74, $7c, $80, $99, $00, $00, $00, $00, $00, $00, $00, $00, $f1, $f1, $0e
    db $1e, $b0, $fd, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $e0, $e0, $5e
    db $5e, $01, $73, $76, $fe, $00, $00, $00, $00, $60, $60, $9c, $bc, $0b, $1b, $00
    db $64, $ee, $fe, $ff, $ff, $00, $00, $00, $00, $00, $00, $0c, $0c, $13, $13, $e1
    db $e1, $40, $4d, $1d, $df, $00, $00, $00, $00, $01, $01, $02, $02, $1c, $1c, $e8
    db $f9, $03, $6b, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $e3
    db $e3, $1d, $bd, $60, $7a, $00, $00, $00, $00, $00, $00, $c0, $c0, $bc, $bc, $03
    db $27, $ac, $fd, $ff, $ff, $00, $00, $00, $00, $00, $00, $c0, $c0, $38, $38, $17
    db $97, $00, $68, $dd, $ff, $00, $00, $00, $00, $18, $18, $27, $27, $c2, $ca, $80
    db $97, $13, $3f, $ff, $ff, $00, $00, $00, $00, $00, $00, $03, $03, $04, $04, $38
    db $38, $d0, $db, $07, $6f, $00, $00, $00, $00, $00, $00, $00, $00, $c7, $c7, $3a
    db $7a, $c0, $e5, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $78
    db $78, $07, $97, $d8, $fe, $00, $00, $00, $00, $01, $01, $02, $02, $1c, $1d, $e8
    db $e8, $03, $2f, $ce, $de, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $e3
    db $e3, $1d, $3d, $60, $79, $00, $00, $00, $00, $00, $00, $c0, $c0, $bc, $bc, $03
    db $67, $ec, $fe, $ff, $ff, $00, $00, $00, $00, $00, $00, $c0, $c0, $38, $38, $17
    db $5f, $00, $36, $dd, $ff, $00, $00, $00, $00, $18, $18, $27, $2f, $c2, $c6, $80
    db $99, $3b, $bf, $ff, $ff, $00, $00, $00, $00, $00, $00, $03, $03, $04, $04, $38
    db $3a, $d0, $d3, $07, $bf, $00, $00, $00, $00, $00, $00, $00, $00, $c7, $c7, $3a
    db $7b, $c0, $ec, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $78
    db $78, $07, $37, $d8, $fd, $00, $00, $00, $00, $80, $80, $70, $70, $2f, $2f, $00
    db $98, $bb, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $30, $30, $4e, $5e, $85
    db $8d, $00, $3e, $77, $7f, $00, $00, $00, $00, $06, $06, $09, $09, $70, $72, $a0
    db $a7, $0e, $7f, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $8e
    db $8e, $74, $75, $81, $af, $00, $00, $00, $00, $00, $00, $00, $00, $f1, $f1, $0e
    db $6e, $b0, $bd, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $e0, $e0, $5e
    db $7e, $01, $3b, $76, $f6, $00, $00, $00, $00, $60, $60, $9c, $9c, $0b, $2b, $00
    db $7e, $ee, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $0c, $0c, $13, $13, $e1
    db $e9, $40, $4e, $1d, $ff, $ff, $ff, $7e, $ff, $87, $f7, $e1, $fd, $ca, $ff, $70
    db $ff, $f9, $ff, $a7, $f7, $ff, $ff, $9f, $ff, $e1, $fd, $78, $7f, $b2, $ff, $1c
    db $ff, $7e, $ff, $e9, $fd, $ff, $ff, $e7, $ff, $78, $7f, $1e, $df, $ac, $ff, $07
    db $ff, $9f, $ff, $7a, $7f, $ff, $ff, $f9, $ff, $1e, $df, $87, $f7, $2b, $ff, $c1
    db $ff, $e7, $ff, $9e, $df, $ff, $ff, $7e, $ff, $87, $f7, $e1, $fd, $ca, $ff, $70
    db $ff, $f9, $ff, $a7, $f7, $ff, $ff, $9f, $ff, $e1, $fd, $78, $7f, $b2, $ff, $1c
    db $ff, $7e, $ff, $e9, $fd, $ff, $ff, $e7, $ff, $78, $7f, $1e, $df, $ac, $ff, $07
    db $ff, $9f, $ff, $7a, $7f, $ff, $ff, $f9, $ff, $1e, $df, $87, $f7, $2b, $ff, $c1
    db $ff, $e7, $ff, $9e, $df, $ff, $ff, $7e, $ff, $87, $f7, $e1, $fd, $ca, $ff, $70
    db $ff, $f9, $ff, $a7, $f7, $ff, $ff, $9f, $ff, $e1, $fd, $78, $7f, $b2, $ff, $1c
    db $ff, $7e, $ff, $e9, $fd, $ff, $ff, $e7, $ff, $78, $7f, $1e, $df, $ac, $ff, $07
    db $ff, $9f, $ff, $7a, $7f, $ff, $ff, $f9, $ff, $1e, $df, $87, $f7, $2b, $ff, $c1
    db $ff, $e7, $ff, $9e, $df, $ff, $ff, $7e, $ff, $87, $f7, $e1, $fd, $ca, $ff, $70
    db $ff, $f9, $ff, $a7, $f7, $ff, $ff, $9f, $ff, $e1, $fd, $78, $7f, $b2, $ff, $1c
    db $ff, $7e, $ff, $e9, $fd, $ff, $ff, $e7, $ff, $78, $7f, $1e, $df, $ac, $ff, $07
    db $ff, $9f, $ff, $7a, $7f, $ff, $ff, $f9, $ff, $1e, $df, $87, $f7, $2b, $ff, $c1
    db $ff, $e7, $ff, $9e, $df, $ff, $ff, $7e, $ff, $e1, $ef, $87, $bf, $53, $ff, $0e
    db $ff, $9f, $ff, $e5, $ef, $ff, $ff, $f9, $ff, $87, $bf, $1e, $fe, $4d, $ff, $38
    db $ff, $7e, $ff, $97, $bf, $ff, $ff, $e7, $ff, $1e, $fe, $78, $fb, $35, $ff, $e0
    db $ff, $f9, $ff, $5e, $fe, $ff, $ff, $9f, $ff, $78, $fb, $e1, $ef, $d4, $ff, $83
    db $ff, $e7, $ff, $79, $fb, $ff, $ff, $7e, $ff, $e1, $ef, $87, $bf, $53, $ff, $0e
    db $ff, $9f, $ff, $e5, $ef, $ff, $ff, $f9, $ff, $87, $bf, $1e, $fe, $4d, $ff, $38
    db $ff, $7e, $ff, $97, $bf, $ff, $ff, $e7, $ff, $1e, $fe, $78, $fb, $35, $ff, $e0
    db $ff, $f9, $ff, $5e, $fe, $ff, $ff, $9f, $ff, $78, $fb, $e1, $ef, $d4, $ff, $83
    db $ff, $e7, $ff, $79, $fb, $ff, $ff, $7e, $ff, $e1, $ef, $87, $bf, $53, $ff, $0e
    db $ff, $9f, $ff, $e5, $ef, $ff, $ff, $f9, $ff, $87, $bf, $1e, $fe, $4d, $ff, $38
    db $ff, $7e, $ff, $97, $bf, $ff, $ff, $e7, $ff, $1e, $fe, $78, $fb, $35, $ff, $e0
    db $ff, $f9, $ff, $5e, $fe, $ff, $ff, $9f, $ff, $78, $fb, $e1, $ef, $d4, $ff, $83
    db $ff, $e7, $ff, $79, $fb, $ff, $ff, $7e, $ff, $e1, $ef, $87, $bf, $53, $ff, $0e
    db $ff, $9f, $ff, $e5, $ef, $ff, $ff, $f9, $ff, $87, $bf, $1e, $fe, $4d, $ff, $38
    db $ff, $7e, $ff, $97, $bf, $ff, $ff, $e7, $ff, $1e, $fe, $78, $fb, $35, $ff, $e0
    db $ff, $f9, $ff, $5e, $fe, $ff, $ff, $9f, $ff, $78, $fb, $e1, $ef, $d4, $ff, $83
    db $ff, $e7, $ff, $79, $fb, $bb, $ff, $de, $ff, $d7, $ff, $c6, $ff, $ca, $de, $e1
    db $ff, $e9, $ef, $b3, $ff, $e9, $ef, $b3, $ff, $bb, $ff, $de, $ff, $d7, $ff, $c6
    db $ff, $ca, $de, $e1, $ff, $ca, $de, $e1, $ff, $e9, $ef, $b3, $ff, $bb, $ff, $de
    db $ff, $d7, $ff, $c6, $ff, $d7, $ff, $c6, $ff, $ca, $de, $e1, $ff, $e9, $ef, $b3
    db $ff, $bb, $ff, $de, $ff, $bb, $ff, $de, $ff, $d7, $ff, $c6, $ff, $ca, $de, $e1
    db $ff, $e9, $ef, $b3, $ff, $e9, $ef, $b3, $ff, $bb, $ff, $de, $ff, $d7, $ff, $c6
    db $ff, $ca, $de, $e1, $ff, $ca, $de, $e1, $ff, $e9, $ef, $b3, $ff, $bb, $ff, $de
    db $ff, $d7, $ff, $c6, $ff, $d7, $ff, $c6, $ff, $ca, $de, $e1, $ff, $e9, $ef, $b3
    db $ff, $bb, $ff, $de, $ff, $bb, $ff, $de, $ff, $d7, $ff, $c6, $ff, $ca, $de, $e1
    db $ff, $e9, $ef, $b3, $ff, $e9, $ef, $b3, $ff, $bb, $ff, $de, $ff, $d7, $ff, $c6
    db $ff, $ca, $de, $e1, $ff, $ca, $de, $e1, $ff, $e9, $ef, $b3, $ff, $bb, $ff, $de
    db $ff, $d7, $ff, $c6, $ff, $d7, $ff, $c6, $ff, $ca, $de, $e1, $ff, $e9, $ef, $b3
    db $ff, $bb, $ff, $de, $ff, $bb, $ff, $de, $ff, $d7, $ff, $c6, $ff, $ca, $de, $e1
    db $ff, $e9, $ef, $b3, $ff, $e9, $ef, $b3, $ff, $bb, $ff, $de, $ff, $d7, $ff, $c6
    db $ff, $ca, $de, $e1, $ff, $ca, $de, $e1, $ff, $e9, $ef, $b3, $ff, $bb, $ff, $de
    db $ff, $d7, $ff, $c6, $ff, $d7, $ff, $c6, $ff, $ca, $de, $e1, $ff, $e9, $ef, $b3
    db $ff, $bb, $ff, $de, $ff, $b3, $ff, $e9, $ef, $e1, $ff, $ca, $de, $c6, $ff, $d7
    db $ff, $de, $ff, $bb, $ff, $e1, $ff, $ca, $de, $c6, $ff, $d7, $ff, $de, $ff, $bb
    db $ff, $b3, $ff, $e9, $ef, $c6, $ff, $d7, $ff, $de, $ff, $bb, $ff, $b3, $ff, $e9
    db $ef, $e1, $ff, $ca, $de, $de, $ff, $bb, $ff, $b3, $ff, $e9, $ef, $e1, $ff, $ca
    db $de, $c6, $ff, $d7, $ff, $b3, $ff, $e9, $ef, $e1, $ff, $ca, $de, $c6, $ff, $d7
    db $ff, $de, $ff, $bb, $ff, $e1, $ff, $ca, $de, $c6, $ff, $d7, $ff, $de, $ff, $bb
    db $ff, $b3, $ff, $e9, $ef, $c6, $ff, $d7, $ff, $de, $ff, $bb, $ff, $b3, $ff, $e9
    db $ef, $e1, $ff, $ca, $de, $de, $ff, $bb, $ff, $b3, $ff, $e9, $ef, $e1, $ff, $ca
    db $de, $c6, $ff, $d7, $ff, $b3, $ff, $e9, $ef, $e1, $ff, $ca, $de, $c6, $ff, $d7
    db $ff, $de, $ff, $bb, $ff, $e1, $ff, $ca, $de, $c6, $ff, $d7, $ff, $de, $ff, $bb
    db $ff, $b3, $ff, $e9, $ef, $c6, $ff, $d7, $ff, $de, $ff, $bb, $ff, $b3, $ff, $e9
    db $ef, $e1, $ff, $ca, $de, $de, $ff, $bb, $ff, $b3, $ff, $e9, $ef, $e1, $ff, $ca
    db $de, $c6, $ff, $d7, $ff, $b3, $ff, $e9, $ef, $e1, $ff, $ca, $de, $c6, $ff, $d7
    db $ff, $de, $ff, $bb, $ff, $e1, $ff, $ca, $de, $c6, $ff, $d7, $ff, $de, $ff, $bb
    db $ff, $b3, $ff, $e9, $ef, $c6, $ff, $d7, $ff, $de, $ff, $bb, $ff, $b3, $ff, $e9
    db $ef, $e1, $ff, $ca, $de, $de, $ff, $bb, $ff, $b3, $ff, $e9, $ef, $e1, $ff, $ca
    db $de, $c6, $ff, $d7, $ff, $81, $91, $81, $d5, $c5, $ef, $c5, $ff, $91, $ff, $91
    db $bb, $81, $d5, $81, $c5, $81, $d5, $81, $c5, $81, $91, $81, $d5, $c5, $ef, $c5
    db $ff, $91, $ff, $91, $bb, $91, $ff, $91, $bb, $81, $d5, $81, $c5, $81, $91, $81
    db $d5, $c5, $ef, $c5, $ff, $c5, $ef, $c5, $ff, $91, $ff, $91, $bb, $81, $d5, $81
    db $c5, $81, $91, $81, $d5, $81, $91, $81, $d5, $c5, $ef, $c5, $ff, $91, $ff, $91
    db $bb, $81, $d5, $81, $c5, $81, $d5, $81, $c5, $81, $91, $81, $d5, $c5, $ef, $c5
    db $ff, $91, $ff, $91, $bb, $91, $ff, $91, $bb, $81, $d5, $81, $c5, $81, $91, $81
    db $d5, $c5, $ef, $c5, $ff, $c5, $ef, $c5, $ff, $91, $ff, $91, $bb, $81, $d5, $81
    db $c5, $81, $91, $81, $d5, $81, $91, $81, $d5, $c5, $ef, $c5, $ff, $91, $ff, $91
    db $bb, $81, $d5, $81, $c5, $81, $d5, $81, $c5, $81, $91, $81, $d5, $c5, $ef, $c5
    db $ff, $91, $ff, $91, $bb, $91, $ff, $91, $bb, $81, $d5, $81, $c5, $81, $91, $81
    db $d5, $c5, $ef, $c5, $ff, $c5, $ef, $c5, $ff, $91, $ff, $91, $bb, $81, $d5, $81
    db $c5, $81, $91, $81, $d5, $81, $91, $81, $d5, $c5, $ef, $c5, $ff, $91, $ff, $91
    db $bb, $81, $d5, $81, $c5, $81, $d5, $81, $c5, $81, $91, $81, $d5, $c5, $ef, $c5
    db $ff, $91, $ff, $91, $bb, $91, $ff, $91, $bb, $81, $d5, $81, $c5, $81, $91, $81
    db $d5, $c5, $ef, $c5, $ff, $c5, $ef, $c5, $ff, $91, $ff, $91, $bb, $81, $d5, $81
    db $c5, $81, $91, $81, $d5, $ff, $00, $1c, $3e, $38, $7c, $ff, $00, $ff, $00, $1c
    db $3e, $38, $7c, $ff, $00, $ff, $00, $07, $8f, $0e, $1f, $ff, $00, $ff, $00, $70
    db $f8, $e0, $f1, $ff, $00, $ff, $00, $c1, $e3, $83, $c7, $ff, $00, $ff, $00, $c1
    db $e3, $83, $c7, $ff, $00, $ff, $00, $70, $f8, $e0, $f1, $ff, $00, $ff, $00, $07
    db $8f, $0e, $1f, $ff, $00, $ff, $00, $1c, $3e, $38, $7c, $ff, $00, $ff, $00, $1c
    db $3e, $38, $7c, $ff, $00, $ff, $00, $07, $8f, $0e, $1f, $ff, $00, $ff, $00, $70
    db $f8, $e0, $f1, $ff, $00, $ff, $00, $c1, $e3, $83, $c7, $ff, $00, $ff, $00, $c1
    db $e3, $83, $c7, $ff, $00, $ff, $00, $70, $f8, $e0, $f1, $ff, $00, $ff, $00, $07
    db $8f, $0e, $1f, $ff, $00, $ff, $00, $1c, $3e, $38, $7c, $ff, $00, $ff, $00, $1c
    db $3e, $38, $7c, $ff, $00, $ff, $00, $07, $8f, $0e, $1f, $ff, $00, $ff, $00, $70
    db $f8, $e0, $f1, $ff, $00, $ff, $00, $c1, $e3, $83, $c7, $ff, $00, $ff, $00, $c1
    db $e3, $83, $c7, $ff, $00, $ff, $00, $70, $f8, $e0, $f1, $ff, $00, $ff, $00, $07
    db $8f, $0e, $1f, $ff, $00, $ff, $00, $1c, $3e, $38, $7c, $ff, $00, $ff, $00, $1c
    db $3e, $38, $7c, $ff, $00, $ff, $00, $07, $8f, $0e, $1f, $ff, $00, $ff, $00, $70
    db $f8, $e0, $f1, $ff, $00, $ff, $00, $c1, $e3, $83, $c7, $ff, $00, $ff, $00, $c1
    db $e3, $83, $c7, $ff, $00, $ff, $00, $70, $f8, $e0, $f1, $ff, $00, $ff, $00, $07
    db $8f, $0e, $1f, $ff, $00, $00, $5d, $00, $49, $00, $20, $00, $22, $00, $a2, $00
    db $b6, $00, $14, $00, $1c, $00, $14, $00, $1c, $00, $5d, $00, $49, $00, $20, $00
    db $22, $00, $a2, $00, $b6, $00, $a2, $00, $b6, $00, $14, $00, $1c, $00, $5d, $00
    db $49, $00, $20, $00, $22, $00, $20, $00, $22, $00, $a2, $00, $b6, $00, $14, $00
    db $1c, $00, $5d, $00, $49, $00, $5d, $00, $49, $00, $20, $00, $22, $00, $a2, $00
    db $b6, $00, $14, $00, $1c, $00, $14, $00, $1c, $00, $5d, $00, $49, $00, $20, $00
    db $22, $00, $a2, $00, $b6, $00, $a2, $00, $b6, $00, $14, $00, $1c, $00, $5d, $00
    db $49, $00, $20, $00, $22, $00, $20, $00, $22, $00, $a2, $00, $b6, $00, $14, $00
    db $1c, $00, $5d, $00, $49, $00, $5d, $00, $49, $00, $20, $00, $22, $00, $a2, $00
    db $b6, $00, $14, $00, $1c, $00, $14, $00, $1c, $00, $5d, $00, $49, $00, $20, $00
    db $22, $00, $a2, $00, $b6, $00, $a2, $00, $b6, $00, $14, $00, $1c, $00, $5d, $00
    db $49, $00, $20, $00, $22, $00, $20, $00, $22, $00, $a2, $00, $b6, $00, $14, $00
    db $1c, $00, $5d, $00, $49, $00, $5d, $00, $49, $00, $20, $00, $22, $00, $a2, $00
    db $b6, $00, $14, $00, $1c, $00, $14, $00, $1c, $00, $5d, $00, $49, $00, $20, $00
    db $22, $00, $a2, $00, $b6, $00, $a2, $00, $b6, $00, $14, $00, $1c, $00, $5d, $00
    db $49, $00, $20, $00, $22, $00, $20, $00, $22, $00, $a2, $00, $b6, $00, $14, $00
    db $1c, $00, $5d, $00, $49, $00, $00, $67, $ff, $00, $ff, $22, $ff, $cc, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $dc, $ff, $00, $ff, $44, $ff, $99, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $9d, $ff, $00, $ff, $88, $ff, $33, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $38, $38, $44, $4c, $ce, $df, $00, $ff, $11, $ff, $66
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $67, $ff, $00, $ff, $22, $ff, $cc, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $dc, $ff, $00, $ff, $44, $ff, $99, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $9d, $ff, $00, $ff, $88, $ff, $33, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $38, $38, $44, $4c, $ce, $df, $00, $ff, $11, $ff, $66
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $67, $ff, $00, $ff, $22, $ff, $cc, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $dc, $ff, $00, $ff, $44, $ff, $99, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $9d, $ff, $00, $ff, $88, $ff, $33, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $38, $38, $44, $4c, $ce, $df, $00, $ff, $11, $ff, $66
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $67, $ff, $00, $ff, $22, $ff, $cc, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $dc, $ff, $00, $ff, $44, $ff, $99, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $9d, $ff, $00, $ff, $88, $ff, $33, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $38, $38, $44, $4c, $ce, $df, $00, $ff, $11, $ff, $66
    db $ff, $ff, $ff, $ff, $ff, $38, $38, $44, $4c, $ce, $df, $00, $ff, $11, $ff, $66
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $9d, $ff, $00, $ff, $88, $ff, $33, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $dc, $ff, $00, $ff, $44, $ff, $99, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $9d, $ff, $00, $ff, $88, $ff, $33, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $38, $38, $44, $4c, $ce, $df, $00, $ff, $11, $ff, $66
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $9d, $ff, $00, $ff, $88, $ff, $33, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $dc, $ff, $00, $ff, $44, $ff, $99, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $9d, $ff, $00, $ff, $88, $ff, $33, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $38, $38, $44, $4c, $ce, $df, $00, $ff, $11, $ff, $66
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $9d, $ff, $00, $ff, $88, $ff, $33, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $dc, $ff, $00, $ff, $44, $ff, $99, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $9d, $ff, $00, $ff, $88, $ff, $33, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $38, $38, $44, $4c, $ce, $df, $00, $ff, $11, $ff, $66
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $9d, $ff, $00, $ff, $88, $ff, $33, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $dc, $ff, $00, $ff, $44, $ff, $99, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $9d, $ff, $00, $ff, $88, $ff, $33, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00, $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00, $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00, $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00, $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00, $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00, $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00, $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00, $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00, $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00, $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00, $ff, $00, $38, $7c, $1c, $3e, $ff, $00, $ff, $00, $38
    db $7c, $1c, $3e, $ff, $00, $ff, $00, $e0, $f1, $70, $f8, $ff, $00, $ff, $00, $0e
    db $1f, $07, $8f, $ff, $00, $ff, $00, $83, $c7, $c1, $e3, $ff, $00, $ff, $00, $83
    db $c7, $c1, $e3, $ff, $00, $ff, $00, $0e, $1f, $07, $8f, $ff, $00, $ff, $00, $e0
    db $f1, $70, $f8, $ff, $00

;0x74c5
INCLUDE "data/graphics_data_headers_1e.asm"