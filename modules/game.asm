  MODULE Game
  ; requires: Scr, Utils, BgBuffer, Sprite

start
    ld a, Scr.papBlk | Scr.inkWht
    call Utils.setScreenAttr
    call Utils.drawBackground
    
    ld hl, 13 _hl_ 8
    call BgBuffer.fillFromScreen
    
.loop
    ld b, 9
    ld de, sprites
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
    ld bc, #0008
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
