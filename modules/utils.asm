  MODULE Utils
  ; requires: Op, Scr, Stack

; Sets attrs of all charcells of the screen
; < a: attribute
; spoils: b, de
setScreenAttr IFUSED
    Stack.store
    ld sp, Scr.end
    ld b, Scr.ccHeight
    ld d, a
    ld e, a
.loop
    .(Scr.ccWidth / 2) push de
    djnz .loop
    
    Stack.restore
    ret
  ENDIF

; spoils: b, de
drawBrightGrid IFUSED
    Stack.store
    ld sp, Scr.end
    ld b, Scr.ccHeight / 2
.loop
    ld de, (Scr.inkWht | Scr.bright) _hl_ Scr.inkWht
  .(Scr.ccWidth / 2) push de
    ld de, Scr.inkWht _hl_ (Scr.inkWht | Scr.bright)
  .(Scr.ccWidth / 2) push de
    djnz .loop
    
    Stack.restore
    ret
  ENDIF
  
; spoils: bc, de, hl
drawBackground IFUSED
    Stack.store
    ld sp, Scr.attrStart
    ld de, %0101010110101010
    ld hl, %1010101001010101
    ld c, 12
.outerLoop
    ld b, 4
.loop1
  .16 push de
  .16 push hl
    djnz .loop1
    
    ld b, 4
.loop2
  .16 push hl
  .16 push de
    djnz .loop2
    
    dec c
    jr nz, .outerLoop
    
    Stack.restore
    ret
  ENDIF

  ENDMODULE
