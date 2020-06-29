; ########## START DISPLAY CRITICAL SECTION ##########
display_vbl:
; ////// INIT DIRECTION \\\\\\

xor a
ld (display_.isaac.shoot_timer), a ; TODO hard coded


; ////// UPDATE SPRITES POSITION \\\\\\


; ///// Isaac \\\\\
		ld hl, ISAAC_SPRITESHEET

; //// Top Tiles \\\\
; /// Left \\\\
		ld hl,OAM_ISAAC
		ld a, (global_.isaac.y)
		ld (hl), a ;posY
		inc l
		ld a, (global_.isaac.x)
		ld (hl), a ; posX
		inc l
		ld a, (global_.isaac.direction)
		and %00000010                  ;get second last bit
		rrca
		ld d, a                     ; d <= bit0(position)
		ld a, (display_.isaac.shoot_timer)                      ; a <= (shoot_timer >0)
		and d
		ld e, a                     ; e <= ((shoot_timer >0) & position)
		ld a, ISAAC_TOP_LEFT
		add d
		add e
		ld (hl), a
; \\\ Left ///	
; /// Right \\\
		ld hl,OAM_ISAAC+$4
		ld a,(global_.isaac.y)
		ld (hl),a ;posY
		inc l
		ld a,(global_.isaac.x)
		add 8
		ld (hl),a ;posX
		inc l
		ld a, (global_.isaac.direction)
		and %00000001                     ;get last bit
		ld d, a                     ; d <= bit1(position)
		ld a, (display_.isaac.shoot_timer)     ; a <= (shoot_timer >0)
		and d
		ld e, a                     ; e <= ((shoot_timer >0) & position)
		ld a, ISAAC_TOP_RIGHT
		add d
		add e
		ld (hl), a
; \\\ Right ///

; \\\\ Top Tiles ////

; //// Bottom Tiles \\\\

; /// Setup sprite ids \\\
		ld a, (global_.isaac.speed)
		and a ; update Z flag with value of a
		jp z, @notMoving ; Isaac is not moving if its speed is 0
; // Moving \\
		ld a, (display_.isaac.frame)
		sla a ;a=a*2 (shift left)
		ld e,a //will store right_sprite_id
	//Left sprite id
		ld a, (global_.isaac.direction)
		and %00000010 ; bit1((global_.isaac.direction))
		rrca ;rotate right accumulator
		add ISAAC_BOTTOM_LEFT_WALK
		add e
		ld d,a ;left_sprite_id
	//Right sprite id
		ld a, (global_.isaac.direction)
		and %00000001 ; bit0((global_.isaac.direction))
		add ISAAC_BOTTOM_RIGHT_WALK
		add e
		ld e, a ;right_sprite_id
		jr @endMoving
; \\ Moving //

; // Not Moving \\
@notMoving: 
	//Left sprite id
		ld a, (global_.isaac.direction)
		and %00000010
		rrca
		add ISAAC_BOTTOM_LEFT_STAND
		ld d, a
	//Right sprite id
		ld a, (global_.isaac.direction)
		and %00000001
		add ISAAC_BOTTOM_RIGHT_STAND
		ld e, a
; \\ Not Moving //
@endMoving:
; \\\Setup sprite ids///

; /// Update OAM \\\

//bottom left
		ld hl,OAM_ISAAC+$8
		ld a, (global_.isaac.y)
		add 8
		ld (hl), a ;posY
		inc l
		ld a, (global_.isaac.x)
		ld (hl), a ;posX
		inc l
		ld (hl), d ;Chosen bottom left sprite 

//bottom right
		ld hl,OAM_ISAAC+$C
		ld a, (global_.isaac.y)
		add 8
		ld (hl), a ;posY
		inc l
		ld a, (global_.isaac.x)
		add 8
		ld (hl), a ;posX
		inc l
		ld (hl), e ;Chosen bottom right sprite


; \\\ Update OAM ///
; \\\\ Bottom Tiles ////
; /// Mouth Pixel \\\
ld hl, ISAAC_MOUTH_PIXEL_1
ld a, (hl)
or %00000001
ld (hl), a
ld hl, ISAAC_MOUTH_PIXEL_2
ld a, (hl)
or %00000001
ld (hl), a

ld a, (global_.isaac.direction)
cp %00000010
jp nz, @face_left

ld hl, ISAAC_MOUTH_PIXEL_1
ld a, (hl)
and %11111110
ld (hl), a
ld hl, ISAAC_MOUTH_PIXEL_2
ld a, (hl)
and %11111110
ld (hl), a

@face_left:
; \\\ Mouth Pixel ///

; /// Recover time \\\

	ld a, (global_.isaac.recover)
	bit 2,a
	jp z, @no_recover
	xor a
	ld (OAM_ISAAC), a
	ld (OAM_ISAAC+$4), a
	ld (OAM_ISAAC+$8), a
	ld (OAM_ISAAC+$C), a

	@no_recover:

; \\\ Recover time ///
; \\\\\ Isaac /////

; ///// Tears \\\\\
//TODO: temporary(-ish) code, opcode injection will go here

	ld d, n_isaac_tears+1 ;loop counter
@loopUpdateTears: //do {

	ld bc, OAM_ISAAC_TEARS ;Pointer to the start of the tears in OAM
	ld hl, global_.isaac.tears ;Pointer to the start of the tears
	ld a, (hl) ;tear posY
	and a
	jr z, @disabledTear ;if a==0 then tear is disabled
	ld (bc), a ;tear pos Y in OAM
	ldi a, (hl) ;tear posX
	ld (bc), a ;tear pos X in OAM
	inc c
	inc c ;next tear address in OAM
@disabledTear:

	//Get pointer to next tear Y position in hl
	inc hl ;tear direction
	inc hl ;next tear Y
	dec d ;loop counter --
	jr nz, @loopUpdateTears //} while((--d)!=0) 


	
	


; \\\\\ Tears /////
; \\\\\\ UPDATE SPRITES POSITION //////


; ########## END DISPLAY CRITICAL SECTION ##########
