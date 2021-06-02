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
  
  INCLUDE "game.asm"

; Code modules
  INCLUDE "bgBuffer.asm"
  INCLUDE "sprite.asm"
  INCLUDE "tile.asm"
  INCLUDE "utils.asm"
codeEnd

; The stack is placed between
; the interrupt table and the interrupt routine
; max length is 59 words
; or 63 words when the Interrupt.initialize is not needed anymore
  ORG Interrupt.routine
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


  DISPLAY "codeEnd: ", codeEnd
  SAVESNA "cuboid.sna", main
