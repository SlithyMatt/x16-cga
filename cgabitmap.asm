.include "x16.inc"

.include "temp.inc" ; temporary file created for build configuration

.ifdef twobit
L1_CTRL_0 = $A1
pixperbyte = 4
.elseif .def(fourbit)
L1_CTRL_0 = $C1
pixperbyte = 2
.elseif .def(eightbit)
L1_CTRL_0 = $E1
pixperbyte = 1
.endif

.ifdef w640
L1_CTRL_1 = $10
maxbmsize = 640*480/pixperbyte
.elseif .def(w320)
L1_CTRL_1 = $00
maxbmsize = 320*240/pixperbyte
.endif

.if (maxbmsize > $ffff)
spanbanks = 1
.endif

.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"
   jmp start
   
bitmap:                          ; place RLE-compressed bitmap in ROM
.include rlefile
.byte 0                          ; null terminator

remaining:
.dword maxbmsize                 ; initialize bytes remaining to maxmimum bitmap size

.include "cga.asm"

start:
   lda #0                        ; select VERA port 0
   sta VERA_ctrl
   VERA_SET_ADDR VRAM_layer0, 0  ; disable VRAM layer 0
   lda #$FE
   and VERA_data
   sta VERA_data
   jsr cgapalette                ; load CGA palette
   VERA_SET_ADDR VRAM_layer1, 1  ; configure VRAM layer 1
   lda #L1_CTRL_0
   sta VERA_data
   lda #L1_CTRL_1
   sta VERA_data
   lda #$00
   sta VERA_data                 ; tile map N/A
   sta VERA_data
   sta VERA_data                 ; bitmap base $04000
   lda #$10
   sta VERA_data
   lda #$00                      ; H scroll N/A
   sta VERA_data
   lda #palette                  ; palette offset
   sta VERA_data
   lda #<bitmap                  ; load ROM bitmap address to ZP_PTR_1
   sta ZP_PTR_1
   lda #>bitmap
   sta ZP_PTR_1+1
   VERA_SET_ADDR $04000, 1       ; store uncompressed bitmap in VRAM at $04000
rloop:                           ; uncompress a pair of bytes from ROM
   ldy #0
   lda (ZP_PTR_1),y              ; get length of run
   tax
   beq done                      ; if length = 0, null terminator reached
   inc ZP_PTR_1                  ; increment ROM pointer
   bne @getdata
   inc ZP_PTR_1+1
@getdata:
   lda (ZP_PTR_1),y              ; get data to repeat
dloop:
   sta VERA_data                 ; store byte to VRAM   
   cpy remaining                 ; decrement the bytes remaining
   bne @skiphigh
   cpy remaining+1
   
.ifdef spanbanks   
   bne @skipbank
   cpy remaining+2
   beq view                      ; if we are about to underflow the bank, we're done
   dec remaining+2
@skipbank:

.else
   beq view                      ; if we are about to underflow the high byte, we're done
   
.endif ; spanbanks

   dec remaining+1
@skiphigh:
   dec remaining
   dex                           ; decrement length of run
   bne dloop                     ; if length != 0, store another byte to VRAM
   inc ZP_PTR_1                  ; else, increment ROM pointer
   bne @nextrun
   inc ZP_PTR_1+1   
@nextrun:
   jmp rloop                     ; get next run 
done:                            ; zero fill rest of bitmap
   lda #$00                      ; zero fill in VRAM = transparent pixels
zloop:
   cmp remaining
   bne @fill
   cmp remaining+1
   bne @fill
   
.ifdef spanbanks
   cmp remaining+2   
   beq view                      ; if bytes left = 0, ready to view

.else
   jmp view                      ; if bytes left = 0, ready to view

.endif ; spanbanks
   
@fill:
   sta VERA_data                 ; store another zero byte in VRAM
   
   cpy remaining                 ; decrement the bytes remaining
   bne @skiphigh
   cpy remaining+1
   
.ifdef spanbanks   
   bne @skipbank
   cpy remaining+2
   beq view                      ; if we are about to underflow the bank, we're done
   dec remaining+2
@skipbank:

.else
   beq view                      ; if we are about to underflow the high byte, we're done

.endif ; spanbanks

   dec remaining+1
@skiphigh:
   dec remaining

   jmp zloop
   
view:                            ; view image until restart
.ifdef w320
   VERA_SET_ADDR $F0001,1        ; if 320 pixels wide, zoom x2
   lda #64
   sta VERA_data
   sta VERA_data
.endif
@loop:
   nop
   jmp @loop                     ; loop forever   
   
end:
   



