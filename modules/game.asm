  MODULE Game
  ; requires: Scr, Utils, Graphics, BgBuffer, Sprite

start
    ld a, Scr.papBlk | Scr.inkWht | Scr.bright
    call Utils.setScreenAttr
    ; call Utils.drawBackground
    ; call Utils.drawBrightGrid
    
    call Blocks.drawLevel
    
    ; ld hl, 12 _hl_ 12
    ld hl, 6 _hl_ 15
    call BgBuffer.fillFromScreen
    
    ; coords
    ld a, 12
    ld (Coord.x), a
    ld a, 8
    ld (Coord.y), a
    ld a, 9
    ld (Coord.z), a
    
    ld a, Dir.zPos
    ld (Coord.orientation), a
    
    ; get sprite addr
    ld hl, Graphics.cuboid + 8
    ld e, (hl)
    inc l
    ld d, (hl)
    ex de, hl       ; hl: sprite addr
    
    call Coord.getTileCoords
    call Sprite.draw
    
.loop
    ; dir
    call Keyboard.getKeys
    xor a
    or e
    jp z, .loop
    
    ld c, e
    call Transition.prepare
    push hl
    call BgBuffer.fillFromScreen
    pop hl
    call drawBuffer
    call Transition.perform
    jp .loop


; (for debug purposes)
drawBuffer
    ld a, Scr.papBlk | Scr.inkYlw
    call Utils.setScreenAttr
    
    ld d, l
    xor a
    ld c, a
    srl d
    rl c
  DUP 3
    srl d
    rra
  EDUP
    ld e, a
    add a, h
    ld e, a
    
    ld hl, Scr.attrStart
    add hl, de
    
    push bc
    ld de, 24
    ld b, 8
    ld a, Scr.papBlu | Scr.inkWht
.loop
    srl c
    jr c, .full
    ld a, Scr.papBlu | Scr.inkWht | Scr.bright
.full
  DUP 8
    ld (hl), a
    inc l
  EDUP
    add hl, de
    djnz .loop
    
    pop bc
    srl c
    ret nc
    ld a, Scr.papBlu | Scr.inkWht
  DUP 8
    ld (hl), a
    inc l
  EDUP
    
    ret


  ENDMODULE
