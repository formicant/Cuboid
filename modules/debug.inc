  MODULE Debug

  MACRO Debug.border color
  IFDEF DEBUG
    push af
    ld a, color
    out (#FE), a
    pop af
  ENDIF
  ENDM

  ENDMODULE