  MODULE Transition
  ; requires: Coord, Dir

steps EQU 4

    ALIGN 2
currentPhase
.steps
    byte -0
.increment
    byte -0
.sprite
    word -0
.tileCoords
    word -0

nextPhase
.steps
    byte -0
.increment
    byte -0
.sprite
    word -0
.tileCoords
    word -0

; Moves the cuboid and changes its coords
perform
    call performStep
    or a
    jp nz, perform
    
    ret


; Draws the next cuboid sprite of the transition
; > a: current phase steps left (0 if the transition ended)
performStep
    ; get sprite addr
    ld hl, (currentPhase.sprite)
    push hl
    ld e, (hl)
    inc l
    ld d, (hl)
    ex de, hl       ; hl: sprite addr
    
    ; draw sprite
    ld de, (currentPhase.tileCoords)
    ei
    halt
    call Sprite.draw
    
    ; increment sprite pointer
    pop hl
    ld a, (currentPhase.increment)
    or a
    jp p, .positive
.negative
    dec hl
    dec l
    ld (currentPhase.sprite), hl
    jp .endIncrement
.positive
    inc l
    inc hl
    ld (currentPhase.sprite), hl
.endIncrement
    
    ; decrement steps
    ld a, (currentPhase.steps)
    dec a
    ld (currentPhase.steps), a
    ret nz
    
    ld a, (nextPhase.steps)
    or a
    call nz, prepareSecondPhase
    
    ret


; Calculates values for transition phases
; < c: direction
; spoils: af, b, hl
prepare
    ; set each phase step count
    ld a, steps + 1
    ld (currentPhase.steps), a
    ld (nextPhase.steps), a
    
    ; calculate sprite row offset
    ; (an intermediate value in sprite row calculation)
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
    ld (currentPhase.sprite), hl
    pop bc
    
    ; second phase
    ld a, 8
    sub b
    ld b, a
    call getSprite
    ; hl: second phase final sprite
    
    ld a, Dir.xNeg | Dir.yNeg
    and c
    jr nz, .negDir
.posDir
    ld a, -steps * 2
    dec h
    Op.add_hl_a
    ld a, 1         ; a: positive increment
    jp .endDir
.negDir
    ld a, steps * 2
    Op.add_hl_a
    ld a, -1        ; a: negative increment
.endDir
    ; hl: second phase initial sprite
    ld (nextPhase.sprite), hl
    ld (currentPhase.increment), a
    ld (nextPhase.increment), a
    
    ; calculate tile coords
    call Coord.getTileCoords
    ld (currentPhase.tileCoords), de
    call changeCoords
    call Coord.getTileCoords
    ld (nextPhase.tileCoords), de
    
    ret


; Copies next phase prepared data to current phase
; spoils: hl
prepareSecondPhase
    ; copy next phase values to current phase
    ld hl, (nextPhase.steps)
    ld (currentPhase.steps), hl
    ld hl, (nextPhase.sprite)
    ld (currentPhase.sprite), hl
    ld hl, (nextPhase.tileCoords)
    ld (currentPhase.tileCoords), hl
    
    ; zero next phase steps
    ld hl, nextPhase.steps
    ld (hl), 0
    ret


; Changes the cuboid coords and orientation
; according to the transition
; < c: direction
; spoils: af, b, hl
changeCoords
    ld hl, Coord.spatial
    ld b, Dir.xPos
    ld a, Dir.maskY
    and c
    jr z, .notY
    inc l
    ld b, Dir.yPos
.notY
    ; hl: Coord.x if dir x; Coord.y if dir y
    ; b: Dir.xPos if dir x; Dir.yPos if dir y
    
    ld a, Dir.xNeg | Dir.yNeg
    and c
    jr nz, .dirNeg
    
.dirPos
    ; inc x/y coord if dir is same as orientation
    ld a, (Coord.orientation)
    and c
    and Dir.maskX | Dir.maskY
    jr z, .notSame
    inc (hl)
.notSame
    ; inc x/y coord if not dir z
    ld a, Dir.maskZ
    and c
    jr nz, .dirEnd
    inc (hl)
    jp .dirEnd
    
.dirNeg
    ; dec x/y coord if orientation z
    ld a, (Coord.orientation)
    and Dir.maskZ
    jr z, .notOrientZ
    dec (hl)
.notOrientZ
    ; dec x/y coord if not dir z
    ld a, Dir.maskZ
    and c
    jr nz, .dirEnd
    dec (hl)
.dirEnd
    
    ; inc/dec z coord if dir z
    ld hl, Coord.z
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
