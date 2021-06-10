  MODULE Game
  ; requires: Scr, Utils, Data, BgBuffer, Sprite

start
    ld a, Scr.papBlk | Scr.inkWht
    call Utils.setScreenAttr
    call Utils.drawBackground
    
    ld hl, 13 _hl_ 7
    call BgBuffer.fillFromScreen
    
.loop
    ld b, 9
    ld de, Data.cuboid + 54
    ld a, (de)
    ld l, a
    inc e
    ld a, (de)
    ld h, a
    inc de
    
.spriteLoop
    push bc, de
    
    ld de, #1010
    
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
