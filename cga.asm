.ifndef CGA
CGA = 1

.include "x16.inc"

cgapalette:
   jmp @load         ; jump ahead of palette data to load routine
   
@data:
.word $000,$00A,$0A0,$0AA  ; full 16-color palette
.word $A00,$A0A,$A50,$AAA
.word $555,$55F,$5F5,$5FF
.word $F55,$F5F,$FF5,$FFF
.word $000,$0A0,$A00,$A50  ; MODE 4, PALETTE 0, LOW INTENSITY
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$5F5,$F55,$FF5  ; MODE 4, PALETTE 0, HIGH INTENSITY
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$0AA,$A0A,$AAA  ; MODE 4, PALETTE 1, LOW INTENSITY
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$5FF,$F5F,$FFF  ; MODE 4, PALETTE 1, HIGH INTENSITY
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$0AA,$A00,$AAA  ; MODE 5, LOW INTENSITY, COLOR
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$5FF,$F55,$FFF  ; MODE 5, HIGH INTENSITY, COLOR
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$030,$070,$0A0  ; MODE 5, LOW INTENSITY, GREEN
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$050,$0A0,$0F0  ; MODE 5, HIGH INTENSITY, GREEN
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$740,$A61,$A93  ; MODE 5, LOW INTENSITY, AMBER
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$C60,$FA1,$FF5  ; MODE 5, HIGH INTENSITY, AMBER
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000  ; offset 11 - spare
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000  ; offset 12 - spare
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000  ; offset 13 - spare
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000  ; offset 14 - spare
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000  ; offset 15 - spare
.word $000,$000,$000,$000
.word $000,$000,$000,$000
.word $000,$000,$000,$000

@load:
   lda #0            ; select VERA port 0
   sta VERA_ctrl
   VERA_SET_ADDR VRAM_palette, 1
   ldx #0            ; start with first half of palette
@loop1:
   lda @data,x
   sta VERA_data     ; store byte to VRAM
   inx
   bne @loop1        ; loop until index rolls over
@loop2:
   lda @data+256,x   ; load second half of palette
   sta VERA_data     ; store byte to VRAM
   inx
   bne @loop2        ; loop until index rolls over
   rts
   
.endif
