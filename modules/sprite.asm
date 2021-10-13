  MODULE Sprite     ; 
  ; requires: Op, Scr, Stack, Tile, Debug

; Draws a sprite on the screen
; < hl: sprite addr
;   d: u coord in tiles
;   e: v coord in tiles
; spoils: af, bc, de, hl, ix
draw
    Debug.borderA Scr.blu
    Stack.store
    ld sp, hl       ; hl is free now
    
    pop hl          ; hl: sprite shift in tiles
    pop bc          ; bc: sprite size in tiles
    
    ld a, c
    ld (clear.height), a
    ld a, b
    ld (.width), a  ; sprite width
    ld (clear.width), a
    ld a, 8
    sub b
    .2 rlca
    ld (clear.margin), a
    
    ; get sprite top-left coords
    ld a, d
    add a, h
    ld (.left), a   ; u coord of the left side of the sprite
    ld (clear.left), a
    ld (clear.sLeft), a
    ld a, e         ; de is free now
    add a, l        ; a: v coord of the top of the sprite
    ; get addr in rowAddrTable
    ld (clear.sTop), a
    rlca            ; a *= 2
    ld (clear.topMul2), a
    ld ixl, a
    ld ixh, high(Tile.rowAddrTable)
    
    Debug.borderA Scr.grn
.drawRow            ; ix: current row addr in rowAddrTable
    ld a, (ix)
    inc ixl
    ld d, (ix)
    inc ix
.left+1
    add a, -0       ; add u coord of the left side of the sprite
    ld e, a         ; de: screen addr
    
.drawTile
    pop hl          ; hl: tile addr
.cnt = 4
  DUP .cnt
.cnt = .cnt - 1
    ld a, (de)      ; get from the screen
    and (hl)        ; draw mask
    inc l
    or (hl)         ; draw pixels
    inc l
    ld (de), a      ; put to the screen
  IF .cnt
    inc d
  ENDIF
  EDUP
  .3 dec d          ; return to the tile top
    inc e           ; move right
    djnz .drawTile
    
.width+1
    ld b, -0        ; b: sprite width
    dec c           ; next tile row
    jp nz, .drawRow
    
    Stack.restore
    Debug.borderA Scr.blk
    ret


; Fills the sprite area with tiles from the buffer
; spoils: af, bc, de, hl, ix
clear
    Debug.borderA Scr.blu
    
    ld hl, (BgBuffer.coords)
.sLeft+1
    ld a, -0
    sub h
    .2 rlca
    ld h, a
    
.sTop+1
    ld a, -0
    sub l
    .3 rrca
    add a, h        ; a: offset in the buffer
    
    ld hl, BgBuffer.start
    ld e, (hl)
    inc l
    ld d, (hl)
    ex de, hl
    Op.add_hl_a     ; hl: addr in the buffer
    
    ;;///
    ; ld a, (BgBuffer.offset)
    ; rlca
    ; rla
    ; ld l, a
    ; ld a, high(BgBuffer.buffer)
    ; adc a, 0
    ;;///
    
.height+1
    ld c, -0        ; c: sprite height
    
.topMul2+2
    ld ixl, -0
    ld ixh, high(Tile.rowAddrTable)
    ; ix: current row addr in rowAddrTable
    
    Debug.borderA Scr.red
    
.clearRow
    ld a, (ix)
    inc ixl
    ld d, (ix)
    inc ix
.left+1
    add a, -0       ; add u coord of the left side of the sprite
    ld e, a         ; de: screen addr
    
.width+1
    ld b, -0        ; b: sprite width
    
.clearTile
.cnt = 4
  DUP .cnt
.cnt = .cnt - 1
    ld a, (hl)      ; get from the buffer
    ld (de), a      ; put to the screen
  IF .cnt
    inc l
    inc d
  ENDIF
  EDUP
  .3 dec d          ; return to the tile top
    inc e           ; move right
    inc hl
    djnz .clearTile
    
    BgBuffer.wrapRow h
.margin+1
    ld a, -0
    Op.add_hl_a     ; hl: new line in the buffer
    dec c           ; next tile row
    jp nz, .clearRow
    
    Debug.borderA Scr.blk
    ret

  ENDMODULE
