  MODULE BgBuffer   ; Stores a fixed-sized rectangle of the screen background
  ; requires: Stack, Tile

  ALIGN 32
buffer              ; tiles of the rectangle by rows
    block 512       ; 8×16 tiles = 8×8 charcells = 64×64 px

oxy
oy  byte 0          ; top of the buffered screen rectangle in tiles
ox  byte 0          ; left of the buffered screen rectangle in tiles

; Fills the buffer with the screen pixels
; < hl: x, y coodrs of the top-left corner of the rectangle
; spoils: af, bc, de, hl
fillFromScreen
    Stack.store
    
    ; store coords
    ld (oxy), hl
    ld a, h
    ld (.left), a   ; x coord
    
    ; position sp to the required row in rowAddrTable
    ld a, l
    rlca            ; a *= 2
    ld l, a
    ld h, high(Tile.rowAddrTable)
    ld sp, hl       ; hl, de are free now
    
    ld bc, #0810    ; b: 8 (width), c: 16 (height)
    ld hl, buffer
    
.row
    pop de
.left+1
    ld a, 0         ; x coord
    add a, e
    ld e, a         ; de: screen addr
    
.tile
    ; fill one tile
.cnt = 4
  DUP .cnt
.cnt = .cnt - 1
    ld a, (de)
    ld (hl), a
  IF .cnt
    inc l
    inc d
  ENDIF
  EDUP
  .3 dec d
    ; next tile
    inc e
    inc hl
    djnz .tile
    ; next row
    ld b, 8
    dec c
    jp nz, .row
    
    Stack.restore
    ret

  ENDMODULE