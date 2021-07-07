  MODULE Transition
  ; requires: Coord, Dir

steps EQU 4

    ALIGN 2
currentSprite
    word -0
secondPhaseSprite
    word -0
coordDelta
.x  byte -0
.y  byte -0
.z  byte -0
stepsToMake
    byte -0
isNegative
    byte -0


; Moves the cuboid and changes its coords
perform
    ld a, steps + 1
    ld (stepsToMake), a
    
.firstPhase
    call performStep
    ld a, (stepsToMake)
    dec a
    ld (stepsToMake), a
    jp nz, .firstPhase
    
    ld hl, (secondPhaseSprite)
    ld (currentSprite), hl
    ld a, steps + 1
    ld (stepsToMake), a
    
    ; change coords
    ld hl, Coord.spatial
    ld de, coordDelta
  DUP 3             ; TODO: optimize
    ld a, (de)
    add a, (hl)
    ld (hl), a
    inc de
    inc hl
  EDUP
    
.secondPhase
    call performStep
    ld a, (stepsToMake)
    dec a
    ld (stepsToMake), a
    jp nz, .secondPhase
    
    ret


performStep
    ld hl, (currentSprite)
    push hl
    ld e, (hl)
    inc l
    ld d, (hl)
    ex de, hl       ; hl: sprite addr
    
    call Coord.getTileCoords
    call Sprite.draw
  DUP 1
    ei
    halt
  EDUP
    
    pop hl
    ld a, (isNegative)
    or a
    jr z, .positive
.negative
    dec hl
    dec l
    ld (currentSprite), hl
    ret
.positive
    inc l
    inc hl
    ld (currentSprite), hl
    ret


; Calculates values for a transition
; < c: direction
; spoils: af, b, hl
prepare
    ; calculate sprite row offset
    ld b, 0
    ld a, Dir.maskY
    and c
    jr z, .notY
    inc b
.notY               ; b: 0 if dir x, 1 if dir y
    
    ld a, (Coord.orientation)
.orientationLoop
    inc b
  .2 rrca
    jr nc, .orientationLoop
    
    sla b           ; b: sprite row offset
    
    ; first phase
    push bc
    call getSprite
    ; hl: first phase initial sprite
    ld (currentSprite), hl
    pop bc
    
    ; second phase
    ld a, 8
    sub b
    ld b, a
    call getSprite
    ; hl: second phase final sprite
    
    ld a, Dir.xNeg | Dir.yNeg
    and c
    ld a, steps * 2
    jr nz, .negDir
.posDir
    Op.sub_hl_a
    xor a
    jp .endDir
.negDir
    Op.add_hl_a
    ld a, 1
.endDir
    ; hl: second phase initial sprite
    ld (secondPhaseSprite), hl
    ld (isNegative), a
    
    call prepareCoordDelta
    ret


prepareCoordDelta
    ; zeroing
    ld ix, coordDelta.z
    ld hl, coordDelta.z
    ld (hl), 0
    dec hl
    ld (hl), 0
    dec l
    ld (hl), 0
    
    ld b, Dir.xPos
    ld a, Dir.maskY
    and c
    jr z, .notY
    inc l
    ld b, Dir.yPos
.notY
    
    ld a, Dir.xNeg | Dir.yNeg
    and c
    jr nz, .dirNeg
    
.dirPos
    ld a, (Coord.orientation)
    and c
    and Dir.maskX | Dir.maskY
    jr z, .notSame
    inc (hl)
.notSame
    ld a, Dir.maskZ
    and c
    jr nz, .dirEnd
    inc (hl)
    jp .dirEnd
    
.dirNeg
    ld a, (Coord.orientation)
    and Dir.maskZ
    jr z, .notOrientZ
    dec (hl)
.notOrientZ
    ld a, Dir.maskZ
    and c
    jr nz, .dirEnd
    dec (hl)
.dirEnd
    
    ld hl, coordDelta.z
    ld a, Dir.maskZ
    and c
    jr z, .reorient
    
    ld a, (Coord.orientation)
    and Dir.maskZ
    jr z, .negZ
    inc (hl)
    jp .reorient
.negZ
    dec (hl)
    
.reorient
    ld a, (Coord.orientation)
    or b
    cpl
    and Dir.xPos | Dir.yPos
    ret z
    
    ld a, (Coord.orientation)
    xor Dir.zPos
    xor b
    ld (Coord.orientation), a
    ret


; Calculates the cuboid sprite
; in the sprite table
; < c: direction
;   b: sprite row offset
; > hl: sprite table cell addr
; spoils: af, b
getSprite
    ; b := b mod 6
    ld a, b
    sub 6
    jr c, .alreadyMod
    ld b, a
.alreadyMod
    
    ; b += 1 if dir y
    ld a, Dir.maskY
    and c
    jr z, .notY
    inc b
.notY
   
    ; b += 6 if dir z
    ld a, Dir.maskZ
    and c
    jr z, .notZ
    ld a, 6
    add a, b
    ld b, a
.notZ
    ; b: sprite row
    
    Op.mulConst b, 2 * steps + 1
    add a, steps    ; a: index of the center sprite in the row
    rlca
    ld hl, Graphics.cuboid
    Op.add_hl_a     ; hl: sprite table cell addr
    ret

  ENDMODULE
