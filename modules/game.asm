  MODULE Game
  ; requires: Scr, Utils, Graphics, BgBuffer, Sprite

start
    ld a, Scr.papBlk | Scr.inkWht | Scr.bright
    call Utils.setScreenAttr
    call Utils.drawBackground
    
    call Blocks.drawLevel
    
    ld hl, 12 _hl_ 12
    call BgBuffer.fillFromScreen
    
.loop
    ld b, 9
    ld de, Graphics.cuboid + 54
    ld a, (de)
    ld l, a
    inc e
    ld a, (de)
    ld h, a
    inc de
    
    ld a, 8
    ld (Coord.x), a
    ld a, 8
    ld (Coord.y), a
    ld a, 9
    ld (Coord.z), a
    
.spriteLoop
    push bc, de
    
    call Coord.getTileCoords
    
    ei
    halt
    
    call Sprite.draw
    
    ; wait
    ld bc, #000B
.wait
    djnz .wait
    dec c
    jr nz, .wait
    
    call Sprite.clear
    
    pop de, bc
    
    ld a, (de)
    ld l, a
    inc e
    ld a, (de)
    ld h, a
    inc de
    
    djnz .spriteLoop
    jp .loop


  ENDMODULE
