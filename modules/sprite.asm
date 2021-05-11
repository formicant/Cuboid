  MODULE Sprite     ; 

; Draws a sprite on the screen
; < hl: sprite addr
;   d: x coord in tiles
;   e: y coord in tiles
; spoils: af, bc, de, hl, ix, iy
draw
    ld (.spStorage), sp
    ld sp, hl       ; hl is free now
    
    pop hl          ; hl: sprite shift in tiles
    pop bc          ; bc: sprite size in tiles
    
    ld iyh, b       ; iyh: sprite width
    
    ; get sprite top-left coords
    ld a, d
    add a, h
    ld iyl, a       ; iyl: x coord of the left side of the sprite
    ld a, e         ; de is free now
    add a, l        ; a: y coord of the top of the sprite
    ; get addr in tileRowAddrTable
    rlca            ; a *= 2
    ld ixl, a
    ld ixh, high(Tile.tileRowAddrTable)
    
.drawRow            ; ix: current row addr in tileRowAddrTable
    ld a, (ix)
    inc ix
    ld d, (ix)
    inc ix
    add a, iyl
    ld e, a         ; de: screen addr
    
.drawTile
    pop hl          ; hl: tile addr
  DUP 4
    ld a, (de)      ; get from the screen
    and (hl)        ; draw mask
    inc l
    or (hl)         ; draw pixels
    inc l
    ld (de), a      ; put to the screen
    inc d
  EDUP
  .4 dec d          ; return to the tile top
    inc e           ; move right
    djnz .drawTile
    
    ld b, iyh       ; b: sprite width
    dec c           ; next tile row
    jp nz, .drawRow
    
    ld sp, (.spStorage)
    ret

.spStorage
    word 0

  ENDMODULE

  INCLUDE "tile.asm"
