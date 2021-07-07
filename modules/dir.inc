  MODULE Dir

; Bits representing spatial directions

xNeg EQU %00000001  ; bit 0
xPos EQU %00000010  ; bit 1
yNeg EQU %00000100  ; bit 2
yPos EQU %00001000  ; bit 3
zNeg EQU %00010000  ; bit 4
zPos EQU %00100000  ; bit 5

maskX EQU xNeg | xPos
maskY EQU yNeg | yPos
maskZ EQU zNeg | zPos

  ENDMODULE
