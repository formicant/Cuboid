  SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
  DEVICE ZXSPECTRUM48

  DEFINE DEBUG

; Definitions
  INCLUDE "debug.inc"
  INCLUDE "op.inc"
  INCLUDE "scr.inc"
  INCLUDE "dir.inc"
  INCLUDE "stack.inc"

; Interrupt table and routine
  ORG #8000
  INCLUDE "interrupt.asm"

; Entry point
main
    ld sp, Stack.top
    call Interrupt.initialize
    jp Game.start

; Code modules
  INCLUDE "game.asm"
  INCLUDE "bgBuffer.asm"
  INCLUDE "blocks.asm"
  INCLUDE "sprite.asm"
  INCLUDE "tile.asm"
  INCLUDE "coord.asm"
  INCLUDE "transition.asm"
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
  SAVESNA "cuboid.sna", main
