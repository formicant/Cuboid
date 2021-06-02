  SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
  DEVICE ZXSPECTRUM48

  DEFINE DEBUG

; Definitions
  INCLUDE "debug.inc"
  INCLUDE "op.inc"
  INCLUDE "scr.inc"
  INCLUDE "stack.inc"

; interrupt table and routine
  ORG #8000
  INCLUDE "interrupt.asm"

; Entry point
main
    call Interrupt.initialize
    
    ld a, Scr.papBlk | Scr.inkWht
    call Utils.setScreenAttr
    call Utils.drawBackground
    
    ld hl, 13 _hl_ 8
    call BgBuffer.fillFromScreen
    
.loop
    ld b, 9
    ld de, sprites
    ld a, (de)
    ld l, a
    inc e
    ld a, (de)
    ld h, a
    inc de
    
.spriteLoop
    push bc, de
    
    ld de, #1010
    
    ei
    halt
    
    call Sprite.draw
    
    ; wait
    ld bc, #0008
.wait
    djnz .wait
    dec c
    jr nz, .wait
    
    call Sprite.clear
    
    pop de, bc
    
    ld a, (de)
    ld l, a
    inc e
    ld a, (de)
    ld h, a
    inc de
    
    djnz .spriteLoop
    jp .loop


; Code modules
  INCLUDE "bgBuffer.asm"
  INCLUDE "sprite.asm"
  INCLUDE "tile.asm"
  INCLUDE "utils.asm"

; The stack is placed between
; the interrupt table and the interrupt routine
; max length is 59 words
; or 63 words when the Interrupt.initialize is not needed anymore
  ORG Interrupt.routine - 2
  INCLUDE "stack.asm"


; Data

  ORG #B900
  ALIGN 2
sprites
  INCBIN "../data/sprites.bin"

  ORG #E300
  ALIGN 8
tiles
  INCBIN "../data/tiles.bin"


  SAVESNA "cuboid.sna", main
