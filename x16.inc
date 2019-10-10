.ifndef X16_INC
X16_INC=1

; Zero Page address variables
ZP_PTR_1       = $FB
ZP_PTR_2       = $FD

; Banked RAM addresses
RAM_BANK       = $9F61
RAM_WIN        = $A000

; VERA addresses
VERA_base       = $9F20
VERA_addr_low   = VERA_base+0
VERA_addr_high  = VERA_base+1
VERA_addr_bank  = VERA_base+2
VERA_data       = VERA_base+3
VERA_data2      = VERA_base+4
VERA_ctrl       = VERA_base+5
VERA_irq_ctrl   = VERA_base+6
VERA_irq        = VERA_base+7

VRAM_composer  = $F0000
VRAM_palette   = $F1000
VRAM_layer0    = $F2000
VRAM_layer1    = $F3000
VRAM_sprinfo   = $F4000
VRAM_sprdata   = $F5800

VRAM_palette0  = $F1000 + (2*16)*0
VRAM_palette1  = $F1000 + (2*16)*1
VRAM_palette2  = $F1000 + (2*16)*2
VRAM_palette3  = $F1000 + (2*16)*3
VRAM_palette4  = $F1000 + (2*16)*4
VRAM_palette5  = $F1000 + (2*16)*5
VRAM_palette6  = $F1000 + (2*16)*6
VRAM_palette7  = $F1000 + (2*16)*7
VRAM_palette8  = $F1000 + (2*16)*8
VRAM_palette9  = $F1000 + (2*16)*9
VRAM_palette10 = $F1000 + (2*16)*10
VRAM_palette11 = $F1000 + (2*16)*11
VRAM_palette12 = $F1000 + (2*16)*12
VRAM_palette13 = $F1000 + (2*16)*13
VRAM_palette14 = $F1000 + (2*16)*14
VRAM_palette15 = $F1000 + (2*16)*15

VROM_petscii   = $1F000

;   Macros

.macro VERA_SET_ADDR addr, stride
	.ifnblank stride
		lda #((^addr) | (stride << 4))
	.else
		lda #(^addr) | $10
	.endif

	sta VERA_addr_bank
	lda #(>addr)
	sta VERA_addr_high
	lda #(<addr)
	sta VERA_addr_low
.endmacro

.endif ; X16_INC

