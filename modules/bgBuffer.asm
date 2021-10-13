  MODULE BgBuffer   ; Stores a fixed-sized rectangle of the screen background
  ; requires: Stack, Tile

  ALIGN 256
buffer              ; tiles of the rectangle by rows
    block 540       ; 8×16 tiles + 7 tiles for horiz offset

coords
v   byte -0         ; top of the buffered screen rectangle in tiles
u   byte -0         ; left of the buffered screen rectangle in tiles

start
    word buffer     ; addr of the top-left corner inside the buffer


  MACRO BgBuffer.wrapRow regH
    ld a, regH
    cp high(BgBuffer.buffer) + 2
    jp c, .skipWrap
  .2 dec regH
.skipWrap
  ENDM


; Fills the buffer with the screen pixels
; < hl: u, v coodrs of the top-left corner of the rectangle
; spoils: af, bc, de, hl
fillFromScreen
    Stack.store
    
    ; store coords
    ld (coords), hl
    ld a, h
    ld (.left), a   ; u coord
    
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
    ld a, 0         ; u coord
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


; > de: new uv coords
move

  ENDMODULE