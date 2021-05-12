  MODULE Scr        ; Constants related to the screen

; Screen memory

start      EQU #4000  ; Screen memory start address
pixLength  EQU #1800  ; Byte length of pixel data
attrStart  EQU #5800  ; Attribute data start address
attrLength EQU  #300  ; Byte length of attribute data
length     EQU #1B00  ; Byte length of screen memory
end        EQU #5B00  ; Screen memory end address

; Screen dimensions

width    EQU 256    ; Screen width in pixels
height   EQU 192    ; Screen height in pixels
ccWidth  EQU  32    ; Screen width in charcells
ccHeight EQU  24    ; Screen height in charcells

; Colors

blk EQU 0
blu EQU 1
red EQU 2
mgn EQU 3
grn EQU 4
cyn EQU 5
ylw EQU 6
wht EQU 7

inkBlk EQU blk
inkBlu EQU blu
inkRed EQU red
inkMgn EQU mgn
inkGrn EQU grn
inkCyn EQU cyn
inkYlw EQU ylw
inkWht EQU wht

papBlk EQU blk << 3
papBlu EQU blu << 3
papRed EQU red << 3
papMgn EQU mgn << 3
papGrn EQU grn << 3
papCyn EQU cyn << 3
papYlw EQU ylw << 3
papWht EQU wht << 3

inkMask EQU inkWht
papMask EQU papWht
bright  EQU #40
flash   EQU #80

  ENDMODULE
