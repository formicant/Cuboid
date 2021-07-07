  MODULE Game
  ; requires: Scr, Utils, Graphics, BgBuffer, Sprite

start
    ld a, Scr.papBlk | Scr.inkWht | Scr.bright
    call Utils.setScreenAttr
    ; call Utils.drawBackground
    
    call Blocks.drawLevel
    
    ld hl, 12 _hl_ 12
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
    
.loop
    ; dir
    ld c, Dir.xNeg
    call Transition.prepare
    call Transition.perform
    jp .loop
    


  ENDMODULE
