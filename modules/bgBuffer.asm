  MODULE BgBuffer   ; Stores a fixed-sized rectangle of the screen background
  ; requires: Stack, Tile

  ALIGN 256
buffer              ; tiles of the rectangle by rows
    block 540       ; 8×16 tiles + 7 tiles for horiz offset

coords
v   byte -0         ; top of the buffered screen rectangle in tiles
u   byte -0         ; left of the buffered screen rectangle in tiles

start               ; addr of the top-left corner inside the buffer
    word buffer     ; should equal buffer + 4 * (8*v + u) % 512

; Wraps the addr (in a reg pair with the high part regH)
; of a buffer row if it is outside the buffer.
; spoils: af
  MACRO BgBuffer.wrapRow regH
    ld a, regH
    cp high(BgBuffer.buffer) + 2
    jp c, .skipWrap
  .2 dec regH
.skipWrap
  ENDM


; Calculates `start` by `coords`. Also, returns it in hl.
; > (start), hl: start position in the buffer
; spoils: af, de
  MACRO BgBuffer.setStart
    ld hl, coords
    ld a, (hl)      ; v
  .3 rlca           ; * 8
    inc hl
    add a, (hl)     ; + u
    sla a           ; * 2 % 256
    ld h, 0
    ld l, a
    add hl, hl      ; * 2
    ld de, buffer
    add hl, de
    ld (start), hl
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
    ld sp, hl       ; hl is free now
    
    BgBuffer.setStart
    ; hl: start position in the buffer
    ld bc, #0810    ; b: 8 (width), c: 16 (height)
    
.row
    pop de          ; from rowAddrTable
.left+1
    ld a, -0        ; u coord
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
    BgBuffer.wrapRow h
    ld b, 8
    dec c
    jp nz, .row
    
    Stack.restore
    ret


; > de: new uv coords
move
    ret

  ENDMODULE