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
    ; store coords
    ld (coords), hl
    BgBuffer.setStart
    
    ld bc, 0 _hl_ 16
    jp fillRows


; Moves the screen coords of the buffer
; filling areas that are not currently in the buffer
; with the screen pixels.
; < hl: new u, v coodrs of the top-left corner of the rectangle
; spoils: af, bc, de, hl
move
    ld a, (v)       ; old v
    sub l           ; a: old v - new v
    jr c, .down
    jr nz, .up
    
    ld (coords), hl
    BgBuffer.setStart
    ret
    
.down
    neg             ; a: new v - old v
    ld c, a
    ld a, 16
    sub c
    ld b, a
    jp .rows
.up
    ld c, a
    ld b, 0
.rows
    ld (coords), hl
    BgBuffer.setStart
    call fillRows
    ret


; Fills some rows of the buffer with the screen pixels
; < b: number of skipped rows [0..15]
;   c: number of rows to fill [1..16]
; spoils: af, bc, de, hl
fillRows
    Stack.store
    
    ld a, (v)
    add b
    rlca            ; a *= 2
    ld l, a
    ld h, high(Tile.rowAddrTable)
    ld sp, hl       ; hl is free now
    ; sp: row in rowAddrTable
    
    ld hl, (start)
    ld a, b
  .4 rlca
    rla             ; * 32, high bit in C flag
    jr nc, .skipInc
    inc h
.skipInc
    Op.add_hl_a
    BgBuffer.wrapRow h
    
    ; hl: start position in the buffer
    
.row
    ld b, 8         ; buffer width
    pop de          ; from rowAddrTable
    ld a, (u)
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
    dec c
    jp nz, .row
    
    Stack.restore
    ret


; Fills left columns of the buffer with the screen pixels
; < b: number of skipped rows [0..15]
;   c: number of rows to fill [1..16]
; spoils: af, bc, de, hl
fillRows
    Stack.store
    
    ld a, (v)
    add b
    rlca            ; a *= 2
    ld l, a
    ld h, high(Tile.rowAddrTable)
    ld sp, hl       ; hl is free now
    ; sp: row in rowAddrTable
    
    ld hl, (start)
    ld a, b
  .4 rlca
    rla             ; * 32, high bit in C flag
    jr nc, .skipInc
    inc h
.skipInc
    Op.add_hl_a
    BgBuffer.wrapRow h
    
    ; hl: start position in the buffer
    
.row
    ld b, 8         ; buffer width
    pop de          ; from rowAddrTable
    ld a, (u)
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
    dec c
    jp nz, .row
    
    Stack.restore
    ret


  ENDMODULE