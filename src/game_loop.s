
.text



START_GAME:
    addi sp, sp, -4
    sw ra, 0(sp)
    mv s10, zero


SETUP:
	mv s0, zero
	# set current map = city
	la t0, CURRENT_MAP
	sb zero, 0(t0)
	call PRINT_CURRENT_MAP

GAME_LOOP:

# call keypoll for animation
	call KEY2
	xori s10, s10, 1
	#a0 needs to be the data of current map so we can teleport it or check if its in right position:
	call GET_DATA_FROM_MAP
	# check if player needs to tp
	call CHECK_TELEPORT
	#a0 = boolean if player is in position
	# check if teleport occurred to change the background
	beq a0, zero, NO_TELEPORT 
	# teleport case:
		# call CLS
        # li a0, 500
		# call SLEEP
	call PRINT_CURRENT_MAP
	
NO_TELEPORT:
	# load current frame of character set it to a0:	

	# print last square of characters based on current map (32x32)

	call GET_MAP_ADRESS
	# a0 = current map adress

	# void procedure to print last tile of map where character was (animation)
	call PRINT_LAST_POS
	# get the adress of image to be used (a0 = adress of image) 
	call SPRITE_ADRESS
	la t0, CHAR_POS
	lh a1, 0(t0)
	lh a2, 2(t0)
	mv a3, s10
	call PRINT

	li t0,0xFF200604
	sw s0, 0(t0)
	
	j GAME_LOOP


END_GAME_LOOP:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret
