  SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
  DEVICE ZXSPECTRUM48

  DEFINE DEBUG

; Definitions
  INCLUDE "debug.inc"
  INCLUDE "op.inc"
  INCLUDE "scr.inc"
  INCLUDE "stack.inc"

; Interrupt table and routine
  ORG #8000
  INCLUDE "interrupt.asm"

; Entry point
main
    call Interrupt.initialize
  
  INCLUDE "game.asm"

; Code modules
  INCLUDE "bgBuffer.asm"
  INCLUDE "blocks.asm"
  INCLUDE "sprite.asm"
  INCLUDE "tile.asm"
  INCLUDE "coord.asm"
  INCLUDE "utils.asm"
codeEnd

; Data modules
  INCLUDE "graphics.asm"
  INCLUDE "level.asm"

; The stack is placed between
; the interrupt table and the interrupt routine
; max length is 59 words
; or 63 words when the Interrupt.initialize is not needed anymore
  ORG Interrupt.routine
  INCLUDE "stack.asm"


  DISPLAY "codeEnd: ", codeEnd
  DISPLAY "@stackTop: ", @stackTop
  SAVESNA "cuboid.sna", main
