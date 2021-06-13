  MODULE Blocks
  ; requires: Graphics, Levels, Sprite, Op

drawLevel
    ld hl, Level.blocks
    ld iy, Coord.spatial
    ld (iy+2), 0
    ld ixh, 16
.layer
    ld (iy+1), 0
    ld ixl, 16
.row
    ; ei : halt
    ld (iy+0), 0
    ld b, 16
.block
    ld a, (hl)
    rrca
    jr nc, .blockEnd
    sla a
    call drawBlock
.blockEnd
    inc hl
    inc (iy+0)
    djnz .block
    inc (iy+1)
    dec ixl
    jp nz, .row
    inc (iy+2)
    dec ixh
    jp nz, .layer
    
    ret

drawBlock
    push bc, hl, ix
    ld hl, Graphics.blocks
    Op.add_hl_a
    ld e, (hl)
    inc l
    ld d, (hl)
    ex de, hl
    
    call Coord.getTileCoords
    call Sprite.draw
    pop ix, hl, bc
    ret

  ENDMODULE
