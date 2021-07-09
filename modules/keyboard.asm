  MODULE Keyboard
  ; requires: 

; > e: direction
; spoils: af, bc
getKeys
    ld e, 0
    ld c, #FE       ; keyboard port
    
    ; yPos [S]
    ld b, #FD
    in a, (c)
    and %00010
    sub 1
    rl e
    
    ; yNeg [W]
    ld b, #FB
    in a, (c)
    and %00010
    sub 1
    rl e
    
    ; xPos [A]
    ld b, #FD
    in a, (c)
    and %00001
    sub 1
    rl e
    
    ; xNeg [D]
    ld b, #FD
    in a, (c)
    and %00100
    sub 1
    rl e
    
    ret


  ENDMODULE
