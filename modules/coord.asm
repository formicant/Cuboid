  MODULE Coord
  ; requires: Scr

; (x, y, z) — spacial block coords
; (u, v) — screen tile coords
;
; +——— u      z
; |           |
; v           |
;             |
;          ___| (cu,cv)
;  x ———‾‾‾    \
;               \
;                y
;
; u = cu - 2x + y
; v = cv + x + 2y - 4z

cu EQU 23
cv EQU 33

  ALIGN 2
spatial
x   byte -0
y   byte -0
z   byte -0

orientation
    byte -0         ; can be Dir.xPos, Dir.yPos, or Dir.zPos


; Converts spacial (x, y, z) coords to tile (u, v) coords
; < (x), (y), (z): spacial coords
; > de: tile uv coords
; spoils: af
getTileCoords
    ld a, (x)
    rlca
    ld d, a
    ld a, (y)
    sub d
    add a, cu
    ld d, a         ; d: cu - 2x + y
    
    ld a, (z)
    rlca
    ld e, a
    ld a, (y)
    sub e
    sla a
    ld e, a
    ld a, (x)
    add a, e
    add a, cv
    ld e, a         ; e: cv + x + 2y - 4z
    
    ret

  ENDMODULE
