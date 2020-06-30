.DEFINE ISAAC_HITBOX 3
.DEFINE ISAAC_FEET_HITBOX 4
.DEFINE RECOVERY_TIME 30

move_and_collide:
	ld hl,global_.isaac.lagCounter
	dec (hl)
	jp nz,@no_move
	ld a,(global_.isaac.speedFreq)
	ld (global_.isaac.lagCounter),a

	ld a,(global_.isaac.speed)
	and MASK_4_LSB
	jr z,@no_diag_move
	ld a,(global_.isaac.speed)
	and MASK_4_MSB
	jr z,@no_diag_move

	ld a,(global_.isaac.speedFreq)
	bit 1,a
	jp nz,@multiple_of_2
	inc a
@multiple_of_2:
	srl a
	add (hl)
	ld (global_.isaac.lagCounter),a
@no_diag_move:


@y:
; //////// MOVE ISAAC  Y \\\\\\\
	ld a,(global_.isaac.speed)
	and MASK_4_LSB
	bit $3,a
	jr z,@@posit
	or MASK_4_MSB
@@posit:
	ld b,a									; B = SPEED Y
	ld hl,global_.isaac.y
	add (hl)
	ld (hl),a								; y += speed y


;   //// collision Y  init \\\\
	ld a, (global_.isaac.x)
	ld (collision_.p.1.x), a
	ld a, (global_.isaac.y)
	add $08
	ld (collision_.p.1.y), a
	ld a, ISAAC_FEET_HITBOX
	ld (collision_.hitbox1), a
;   \\\\ collision Y  init ////
	call collision_obstacles
	; //// CANCEL MOUVEMENT \\\\
	and a
	jr z, @@noCollision
	ld a,(global_.isaac.y)
	sub b
	ld (global_.isaac.y),a ; isaac.y -= speed y
	add $08
	ld (collision_.p.1.y),a
	ld a,(global_.isaac.speed)
	and MASK_4_MSB
	ld (global_.isaac.speed),a ; speed y = 0
	; \\\\ CANCEL MOUVEMENT ////
@@noCollision:
; \\\\\\\ MOVE ISAAC  Y ////////

@x:
; //////// MOVE ISAAC  X \\\\\\\
	ld a,(global_.isaac.speed)
	and MASK_4_MSB
	swap a
	bit $3,a
	jp z,@@posit
	or MASK_4_MSB
@@posit:
	ld b,a									; B = SPEED X
	ld hl,global_.isaac.x
	add (hl)
	ld (hl),a								; x += speed x

;   //// collision X  init \\\\
	ld a, (global_.isaac.x)
	ld (collision_.p.1.x), a
;   \\\\ collision X  init ////
	call collision_obstacles
	; //// CANCEL MOUVEMENT \\\\
	and a
	jr z, @@noCollision
	ld a,(global_.isaac.x)
	sub b
	ld (global_.isaac.x),a ; isaac.x -= speed x
	ld a,(global_.isaac.speed)
	and MASK_4_MSB
	ld (global_.isaac.speed),a ; speed y = 0
	; \\\\ CANCEL MOUVEMENT ////
	@@noCollision:
; \\\\\\\ MOVE ISAAC  X ////////
@no_move:





@enemies_collide:
	; /// load Isaac true position and hitbox \\\
	ld a, (global_.isaac.x)
	ld (collision_.p.1.x), a
	ld a, (global_.isaac.y)
	ld (collision_.p.1.y), a
	ld a, ISAAC_HITBOX
	ld (collision_.hitbox1), a
	; \\\ load Isaac true position and hitbox ///

	ld a, (global_.isaac.recover)
	and a
	jp nz, @@noEnemyCollisions
; /////// implement enemy damage \\\\\\\
;   //// collision with enemies loop \\\\
	ld de, global_.enemies
	ld c, n_enemies
	@@loop:
; /// loop start \\\
	ld h,d
	ld l,e

; / set hitbox and position as parameter \
	ldi a, (hl)
	bit ALIVE_FLAG, a
	jr z,@@noCollision ; check if element is alive
	and ENEMY_SIZE_MASK
	ld (collision_.hitbox2), a
	ldi a, (hl)
	ld (collision_.p.2.y), a
	ldi a, (hl)
	ld (collision_.p.2.x), a
; \ set hitbox and position as parameter /

; / test collision \
	push hl
	call collision
	pop hl
	and a
	jr z, @@noCollision

	; revcovery
	ld a, RECOVERY_TIME
	ld (global_.isaac.recover), a
	; damage
	inc hl
	inc hl
	ld a, (hl)
	and DMG_MASK
	ld b, a
	ld a, (global_.isaac.hp)
	sub b
	ld (global_.isaac.hp), a
	bit 7, a
	jr z, @@noDeath
	xor a
	ld (global_.isaac.x), a
	ld (global_.isaac.y), a 	; //// TODO implement death
@@noDeath:
	jr @@damageDone

@@noCollision:
; \ test collision /

@@ending_loop:
	ld hl, _sizeof_enemy
	add hl, de
	ld d,h
	ld e,l
	dec c
	jr nz, @@loop
	jr @@damageDone
;   \\\\ collision with enemies loop ////
@@noEnemyCollisions:
	dec a
	ld (global_.isaac.recover), a
@@damageDone:
; \\\\\\\ implement enemy damage ///////

; //////// TEST A B \\\\\\\
; if A / B are pressed
;	ld hl, global_.isaac.tears
;	bit $7,(hl); flag A set
;	jr z,@Aset
;	ld a,$10
;	ld (global_.isaac.x),a
;	ld (global_.isaac.y),a
;@Aset:
;
;	bit $6,(hl); flag B set
;	jr z,@Bset
;	ld a,$90
;	ld (global_.isaac.x),a
;	ld (global_.isaac.y),a
;@Bset:
; \\\\\\\ TEST A B ////////
