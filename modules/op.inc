  MODULE Op
  
  ; Infix operation returning a 16-bit value with
  ; the left operand as high byte and the right one as low byte
  DEFINE _hl_ << 8 |
  
  
  MACRO Op.add_rr_a regH, regL
    add a, regL
    ld regL, a
    adc a, regH
    sub regL
    ld regH, a
  ENDM
  
  ; bc <- bc + a
  ; spoils: af
  ; time: 20, length: 5
  MACRO Op.add_bc_a
    Op.add_rr_a b, c
  ENDM
  
  ; de <- de + a
  ; spoils: af
  ; time: 20, length: 5
  MACRO Op.add_de_a
    Op.add_rr_a d, e
  ENDM
  
  ; hl <- hl + a
  ; spoils: af
  ; time: 20, length: 5
  MACRO Op.add_hl_a
    Op.add_rr_a h, l
  ENDM
    
  ENDMODULE
