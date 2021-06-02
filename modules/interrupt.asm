  MODULE Interrupt
  ; requires: Op

  ALIGN #100
; Interrupt vector table
table
    block 257, high($) + 1

; Sets the interrupt vector
; Does not enable interrupts afterwards
initialize
    ld a, high(table)
    ld i, a
    im 2
    ret

; (high(table) - 7) free bytes here
; or even high(table) bytes when `initialize` is not needed anymore

  ORG high($) _hl_ high($)
; Interrupt routine
; Does not enable interrupts afterwards
routine
    di
    ret

  ENDMODULE
