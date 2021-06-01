  MODULE Debug

  ; In debug mode, sets border color
  ; spoils: a
  ; time: debug 18, release 0
  MACRO Debug.borderA color
  IFDEF DEBUG
    ld a, color
    out (#FE), a
  ENDIF
  ENDM

  ; In debug mode, sets border color
  ; spoils: a'
  ; time: debug 34, release 0
  MACRO Debug.borderX color
  IFDEF DEBUG
    ex af, af'
    Debug.borderA color
    ex af, af'
  ENDIF
  ENDM

  ; In debug mode, sets border color
  ; spoils: none, stack: 1
  ; time: debug 39, release 0
  MACRO Debug.borderS color
  IFDEF DEBUG
    push af
    Debug.borderA color
    pop af
  ENDIF
  ENDM

  ENDMODULE
