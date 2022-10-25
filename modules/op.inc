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

;   Alternative variant:
;   time: 18|22, length: 6
;   MACRO Op.add_rr_a regH, regL
;     add a, regL
;     jp nc, .nc
;     inc regH
; .nc
;     ld regL, a
;   ENDM

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
  
  
  MACRO Op.sub_rr_a regH, regL
    neg
    jr z, .skip
    dec h
    Op.add_rr_a regH, regL
.skip
  ENDM
  
  ; bc <- bc - a
  ; spoils: af
  ; time: 39, length: 10
  MACRO Op.sub_bc_a
    Op.sub_rr_a b, c
  ENDM
  
  ; de <- de - a
  ; spoils: af
  ; time: 39, length: 10
  MACRO Op.sub_de_a
    Op.sub_rr_a d, e
  ENDM
  
  ; hl <- hl - a
  ; spoils: af
  ; time: 39, length: 10
  MACRO Op.sub_hl_a
    Op.sub_rr_a h, l
  ENDM
  
  
  ; a <- reg * const
  ; returns junk if the product does not fit in 8 bits
  ; const < 256, reg is not a
  ; spoils: f
  MACRO Op.mulConst reg, const
  IF const > 0
.mask = #80
  WHILE (const & .mask) == 0
.mask = .mask / 2
  ENDW
    ld a, reg
.mask = .mask / 2
  WHILE .mask > 0
    rlca
  IF (const & .mask) != 0
    add a, reg
  ENDIF
.mask = .mask / 2
  ENDW
  ELSE
    xor a
  ENDIF
  ENDM


  ENDMODULE
