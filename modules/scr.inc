  MODULE Scr  ; Constants related to the screen

; Screen memory

start      EQU $4000  ; Screen memory start address
pixLength  EQU $1800  ; Byte length of pixel data
attrStart  EQU $5800  ; Attribute data start address
attrLength EQU  $300  ; Byte length of attribute data
length     EQU $1B00  ; Byte length of screen memory
end        EQU $5B00  ; Screen memory end address

; Screen dimensions

width    EQU 256    ; Screen width in pixels
height   EQU 192    ; Screen height in pixels
ccWidth  EQU  32    ; Screen width in charcells
ccHeight EQU  24    ; Screen height in charcells

; Colors

inkBlk EQU 0
inkBlu EQU 1
inkRed EQU 2
inkMgn EQU 3
inkGrn EQU 4
inkCyn EQU 5
inkYlw EQU 6
inkWht EQU 7

papBlk EQU inkBlk << 3
papBlu EQU inkBlu << 3
papRed EQU inkRed << 3
papMgn EQU inkMgn << 3
papGrn EQU inkGrn << 3
papCyn EQU inkCyn << 3
papYlw EQU inkYlw << 3
papWht EQU inkWht << 3

inkMask EQU inkWht
papMask EQU papWht
bright  EQU $40
flash   EQU $80

  ENDMODULE
