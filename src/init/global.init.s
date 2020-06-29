initHitBoxes:

.DEFINE 8_8_HB 0
.DEFINE H_DOOR_HB 1
.DEFINE V_DOOR_HB 2
.DEFINE 16_16_HB 3
.DEFINE 16_8_HB 4
.DEFINE 8_16_HB 5
.DEFINE H_WALL_HB 6
.DEFINE V_WALL_HB 7

; // init hitboxes
    ld hl, global_.hitboxes_width
    ld a, $08
    ldi (hl), a
	ld a, $00
    ldi (hl), a
    ld a, $08
    ldi (hl), a
	ld a, $10
    ldi (hl), a
	ldi (hl), a
	ld a, $08
	ldi (hl), a
	ld a, $A0
	ldi (hl), a
	ld a, $10
	ldi (hl), a
    ld hl, global_.hitboxes_height
    ld a, $08
    ldi (hl), a
    ldi (hl), a
	ld a, $00
    ldi (hl), a
	ld a, $10
    ldi (hl), a
	ld a, $08
	ldi (hl), a
	ld a, $10
	ldi (hl), a
	ldi (hl), a
	ld a, $90
	ldi (hl), a


global_init:

.DEFINE ROCK_INFO %11000011 ; alive, hurt by bombs, ID 0, size 3
.DEFINE VOID_INFO %00001000	; not alive, not hurt by bombs, ID 1; size 0
.DEFINE HWALL_INFO %10010110 ; alive, not hurt by bombs, ID 2, size 6
.DEFINE VWALL_INFO %10011111 ; alive, not hurt by bombs, ID 3, size 7

	ld hl,global_.blocking_inits

@rock:
; ////// ROCK \\\\\\
	ld a,ROCK_INFO
	ldi (hl),a
; \\\\\\ ROCK //////

@void:
; ////// VOID \\\\\\
	ld a, VOID_INFO
	ldi (hl),a
; \\\\\\ VOID //////

@hwall:
; ////// horizontal wall \\\\\\
	ld a, HWALL_INFO
	ldi (hl),a
; \\\\\\ horizontal wall //////

@vwall:
; ////// vertical wall \\\\\\
	ld a, VWALL_INFO
	ldi (hl),a
; \\\\\\ vertical wall //////

@isaac_init:
	ld hl, global_.isaac
	ld a,$20
	ldi (hl),a; x = 32
	ld a,$40
	ldi (hl),a; y = 64
	ld a,$7F
	ldi (hl),a; hp = $7F
	ld a,1
	ldi (hl),a; dmg = 1
	xor a
	ldi (hl),a
	ldi (hl),a; flags off
	ld a,$10
	ldi (hl),a; range = 16
	ld a,0
	ldi (hl),a; speed = 0
	ld a,%00010000
	ldi (hl),a; tear x=2, tear y=0, a_flag = 0, b_flag = 0
	xor a
	ldi (hl),a; recover=0
	ldi (hl),a; bombs=0
	ld a,%00000011
	ldi (hl),a ; direction : smiling to the camera

	ld b,n_blockings
	ld hl, global_.blockings
@blocking_loop: ; they are no element for now
	ld a, (global_.blocking_inits.2.info)
	ldi (hl), a
	xor a
	ldi (hl), a
	ldi (hl), a
	dec b
	jp nz,@blocking_loop

	; tears
	ld hl, global_.issac_tear_pointer
	xor a
	ldi (hl),a	; issac_tear_pointer = 0
	ld hl, global_.isaac_tears
	ld b,n_isaac_tears
@isaac_tears_loop:
	ldi (hl),a ; x = 0
	ldi (hl),a ; y = 0
	ldi (hl),a ; not alive, not upgraded, speed x = 0, speed y = 0
	dec b
	jp nz,@isaac_tears_loop

	ldi (hl),a	; ennemy_tear_pointer = 0
	ld b,n_ennemy_tears
@ennemy_tears_loop:
	ldi (hl),a ; x = 0
	ldi (hl),a ; y = 0
	ldi (hl),a ;  not alive, not upgraded, speed x = 0, speed y = 0
	dec b
	jp nz,@ennemy_tears_loop


.DEFINE VOID_ENEMY_INFO %00000000 ; not alive, ID 0, size 0
.DEFINE HURTING_ROCK_INFO %10001011 ; alive, ID 1, size 3

	ld hl, global_.enemy_inits

@void_enemy:
	; /// void enemy \\\
	ld a, VOID_ENEMY_INFO
	ldi (hl),a
	xor a
	ldi (hl), a ; no hp
	ldi (hl), a ; void enemy doesn't exist, it can't hurt you
	ld (global_.speeds), a ; no speed
	; \\\ void enemy ///

@hurting_rock:
	; /// hurting rock \\\
	ld a, HURTING_ROCK_INFO
	ldi (hl), a
	ld a, 1
	ldi (hl), a
	ld a, 2
	ldi (hl), a
	xor a
	ld (global_.speeds + 1), a
	; \\\ hurting rock ///

	ld hl, global_.enemies
	ld b, n_enemies
@enemy_loop:
	ld a, (global_.enemy_inits.1.info)
	ldi (hl), a
	xor a
	ldi (hl), a
	ldi (hl), a
	ld a, (global_.enemy_inits.1.hp)
	ldi (hl), a
	xor a
	ldi (hl), a
	ld a, (global_.enemy_inits.1.dmg)
	ldi (hl), a
	dec b
	jp nz, @enemy_loop


.DEFINE VOID_OBJECT_INFO %00000000 ; not alive, ID 0, size 0

	ld hl, global_.object_inits

@void_object:
	; /// void object \\\
	ld a, VOID_OBJECT_INFO
	ldi (hl),a
	xor a
	ldi (hl), a
	ldi (hl), a ; no function
	; \\\ void object ///

	ld hl, global_.objects
	ld b, n_objects
@object_loop:
	ld a, (global_.object_inits.1.info)
	ldi (hl), a
	xor a
	ldi (hl), a
	ldi (hl), a
	ld a, (global_.object_inits.1.function)
	ldi (hl), a
	ld a, (global_.object_inits.1.function + 1)
	ldi (hl), a
	dec b
	jp nz, @object_loop
