  MODULE Utils
; requires module Scr

; Infix operation returning a 16-bit value with
  ; the left operand as high byte and the right one as low byte.
  DEFINE _hl_ << 8 |

; Sets attrs of all charcells of the screen
; < a: attribute
; Spoils: b, de
setScreenAttr: IFUSED
    ld [spStorage], sp
    ld sp, Scr.end
    ld b, Scr.ccHeight
    ld d, a
    ld e, a
.loop:
    .(Scr.ccWidth / 2) push de
    djnz .loop
    
    ld sp, [spStorage]
    ret
  ENDIF

; Spoils: b, de
drawBrightGrid: IFUSED
    ld [spStorage], sp
    ld sp, Scr.end
    ld b, Scr.ccHeight / 2
.loop:
    ld de, (Scr.inkWht | Scr.bright) _hl_ Scr.inkWht
    .(Scr.ccWidth / 2) push de
    ld de, Scr.inkWht _hl_ (Scr.inkWht | Scr.bright)
    .(Scr.ccWidth / 2) push de
    djnz .loop
    
    ld sp, [spStorage]
    ret
  ENDIF
  
; Spoils: bc, de
drawEveryOtherPixel: IFUSED
    ld [spStorage], sp
    ld sp, Scr.attrStart
    ld c, 12
.outerLoop:
    ld b, 16
    ld de, %0101010101010101
.loop1:
    .8 push de
    djnz .loop1
    
    ld b, 16
    ld de, %1010101010101010
.loop2:
    .8 push de
    djnz .loop2
    
    dec c
    jr nz, .outerLoop
    
    ld sp, [spStorage]
    ret
  ENDIF

spStorage: IFUSED
    word 0
  ENDIF

  ENDMODULE
