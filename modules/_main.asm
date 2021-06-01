  SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
  DEVICE ZXSPECTRUM48

  DEFINE DEBUG
  
  INCLUDE "debug.inc"
  INCLUDE "op.inc"
  INCLUDE "scr.inc"
  
  ORG #8000

stackTop
main
    ld a, Scr.papBlk | Scr.inkWht
    call Utils.setScreenAttr
    call Utils.drawBackground
    ei
    
    ; wait
    ld b, 100
.waitBefore
    halt
    djnz .waitBefore
    
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
    halt
    call Sprite.draw
    
    ; wait
    ld bc, #000B
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
  
  INCLUDE "stack.asm"
  INCLUDE "bgBuffer.asm"
  INCLUDE "sprite.asm"
  INCLUDE "utils.asm"
  INCLUDE "tile.asm"


  ORG #B900
  ALIGN 2
sprites
  INCBIN "../data/sprites.bin"
  
  ORG #E300
  ALIGN 8
tiles
  INCBIN "../data/tiles.bin"


  SAVESNA "cuboid.sna", main
