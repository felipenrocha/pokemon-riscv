.include "SYSTEM/MACROSv21.s"

.data 

# s1 = RA_STASH TOP ADRESS


.text

		
# GAME_LOOP:
# 	la a0, msg1
# 	call PRINTBOX
# j GAME_LOOP

jal ra, MENU
	

SETUP:
	mv s0, zero
	call GET_MAP_ADRESS
	li a1, 0
	li a2, 0
	li a3, 0
	call PRINT
	li a3, 1
	call PRINT
	
#

GAME_LOOP:

	call KEY2
	
	xori s0, s0, 1
	


	#a0 needs to be the data of current map so we can teleport it or check if its in right position:
	call GET_DATA_FROM_MAP
	call CHECK_TELEPORT
	#a0 = boolean if player is in position
	# check if teleport occurred to change the background
	beq a0, zero, NO_TELEPORT 
	# teleport case:
		call GET_MAP_ADRESS #a0 = current map adress
		li a1, 0
		li a2, 0
		li a3, 0
		call PRINT
		li a3, 1
		call PRINT
		call UPDATE_CHAR_POS
		jal TEXT_BOX


NO_TELEPORT:
	# load current frame of character set it to a0:	

	# print last square of characters based on current map (32x32)

	call GET_MAP_ADRESS
	# a0 = current map adress

	call PRINT_LAST_POS
	# get the adress of image to be used (a0 = adress of image) 
	call SPRITE_ADRESS
	la t0, CHAR_POS
	lh a1, 0(t0)
	lh a2, 2(t0)
	mv a3, s0
	call PRINT

	li t0,0xFF200604
	sw s0, 0(t0)
	
	j GAME_LOOP




TEXT_BOX:
		loopbox:
		la a0, msg1
		call PRINTBOX
		j loopbox


	
.data
.include "textbox.s"
.include "animation.s"
.include "menu.s"
.include "background.s"
.include "keypoll.s"
.include "SYSTEM/SYSTEMv21.s"
