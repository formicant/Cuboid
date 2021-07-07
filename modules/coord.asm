  MODULE Coord
  ; requires: Scr

  ALIGN 2
spatial
x   byte -0
y   byte -0
z   byte -0

orientation
    byte -0         ; can be Dir.xPos, Dir.yPos, or Dir.zPos


; Converts spatial (x, y, z) coords to tile (x, y) coords
; < (x), (y), (z): spatial coords
; > de: tile xy coords
; spoils: af
getTileCoords
    ld a, (x)
    rlca
    ld d, a
    ld a, (y)
    sub d
    add a, 23
    ld d, a         ; d: center - 2x + y
    
    ld a, (z)
    rlca
    ld e, a
    ld a, (y)
    sub e
    sla a
    ld e, a
    ld a, (x)
    add a, e
    add a, 33
    ld e, a         ; e: center + x + 2y - 4z
    
    ret

  ENDMODULE
