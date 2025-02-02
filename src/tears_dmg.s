
isaac_tears_dmg:
	ld de,global_.isaac_tears

	ld c,n_isaac_tears
@tear_loop:
	ld h,d  ; tear ptr to hl
	ld l,e
	ld a,(hl)  ; tear to a
	and a  ; tear is not none ?
	jp z,@continue_tear_loop  ; if none continue

	push de  ; save tear ptr for later

	ldi a, (hl)  ; load y tear
	add TEARS_OFFSET_Y
	ld (collision_.p.1.y), a
	ld (collision_.p_RD.1.y), a
	ld a,(hl)  ; load x tear
	add TEARS_OFFSET_X
	ld (collision_.p.1.x), a
	ld (collision_.p_RD.1.x), a

	ld de,global_.enemies
	ld b,n_enemies
@ennemy_loop:
	ld h,d  ; ennemy ptr to hl
	ld l,e
	ldi a,(hl) ; ennemy info to a
	bit ALIVE_FLAG, a  ; is alive ?
	jr z,@continue_ennemy_loop  ; if not continue
	and ENEMY_SIZE_MASK  ; ennemy size to a
	ld (collision_.hitbox2),a
	ldi a,(hl)  ; load ennemy y
	ld (collision_.p.2.y),a
	ldi a,(hl)  ; load ennemy x
	ld (collision_.p.2.x),a
	call preloaded_collision
	and a  ; collison ?
	jp z,@continue_ennemy_loop  ; if not continue

; //// DEAL DMG \\\\
	; destroy tear
	pop hl  ; pop tear ptr
	push hl  ; don't remove tear from stack
	xor a
	ld (hl),a  ; tear becomes none

	; apply damage
	call tear_hit_sfx
	ld hl,3  ; TODO: remove hardcoded value
	add hl,de  ; ennemy hp ptr to hl
	ld a, (hl)  ; ennemy hp to a
	dec a  ; we want to check hp <=? 0
	       ; so we check hp-1 <? 0
	       ; we might consider storing hp-1 directly
	ld hl, global_.isaac.dmg  ; load dmg
	sub (hl)  ; inflict dmg
	jr c, @kill_ennemy
	; ennemy was just hurt
	ld hl,3  ; TODO: remove hardcoded value
	add hl, de  ; ennemy hp ptr to hl
	inc a  ; hp-1 to hp
	ld (hl), a  ; set new hp
	jr @continue_ennemy_loop

@kill_ennemy:
	; kill ennemy
	ld a, (de)  ; ennemy info to a
	res 7, a  ; reset isAlive bit TODO: remove hardcoded
	ld (de), a  ; write new ennemy info

	; unlock room if needed
	ld a, (load_map_.mobs)  ; reduce mob number
	dec a
	ld (load_map_.mobs), a
	and a  ; check of mob number is 0
	jr nz, @break_ennemy_loop
	ld a, (current_floor_.current_room)  ; room ptr to hl
	ld h, a
	ld a, (current_floor_.current_room + 1)
	ld l, a
	inc hl  ; room info ptr to hl
	inc hl
	ld a, (hl)  ; room info to a
	res 3, a  ; open room ? TODO: remove hardcoded
	ld (hl), a  ; write new room info
	ld (load_map_.doors), a  ; also update in loaded representation
	ld a, GAMESTATE_CHANGINGROOM  ; update room
	pop de  ; free used stack slot (contains tear
	jp setGameState
; \\\\ DEAL DMG ////

@continue_ennemy_loop:
	ld hl,_sizeof_enemy
	add hl,de  ; next ennemy ptr to hl
	ld d,h  ; new ennemy ptr to de
	ld e,l

	dec b  ; check if some ennemies are left
	jr nz,@ennemy_loop
@break_ennemy_loop:
	pop de  ; pop tear ptr
@continue_tear_loop:
	ld hl,_sizeof_tear
	add hl,de  ; next tear ptr to hl
	ld d,h  ; new tear ptr to de
	ld e,l

	dec c  ; check if some tears are left
	jp nz,@tear_loop
