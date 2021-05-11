  SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
  DEVICE ZXSPECTRUM48
  
  INCLUDE "scr.inc"
  
  ORG #8000

stackTop
main
    ld a, Scr.papBlk | Scr.inkWht
    call Utils.setScreenAttr
    call Utils.drawBackground
    ei
    
.loop
    ld a, 0
    out (254), a
    push iy
    
    ld de, #100C
    ld hl, (sprites + 2 * 4)
    call Sprite.draw
    
    pop iy
    ld a, 7
    out (254), a
    halt
    jp .loop
  
  INCLUDE "sprite.asm"
  INCLUDE "utils.asm"


  ORG #B900
  ALIGN 2
sprites
  INCBIN "../data/sprites.bin"
  
  ORG #E300
  ALIGN 8
tiles
  INCBIN "../data/tiles.bin"


  SAVESNA "cuboid.sna", main
