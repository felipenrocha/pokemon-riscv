.include "SYSTEM/MACROSv21.s"


.text

call START_BATTLE

# call  MENU


# #  inicio do jogo
# call INICIO_JOGO	


# li a0, 1000
# call SLEEP 

# SETUP:
# 	mv s0, zero
# 	call GET_MAP_ADRESS
# 	call PRINT_BACKGROUND
	


# GAME_LOOP:

# # call keypoll for animation
# 	call KEY2
# 	xori s0, s0, 1



# 	#a0 needs to be the data of current map so we can teleport it or check if its in right position:
# 	call GET_DATA_FROM_MAP
# 	# check if player needs to tp
# 	call CHECK_TELEPORT
# 	#a0 = boolean if player is in position
# 	# check if teleport occurred to change the background
# 	beq a0, zero, NO_TELEPORT 
# 	# teleport case:
# 		call CLS
# 		li a0, 250
# 		call SLEEP
# 		call GET_MAP_ADRESS #a0 = current map adress
# 		li a1, 0
# 		li a2, 0
# 		li a3, 0
# 		call PRINT
# 		li a3, 1
# 		call PRINT
# 		call UPDATE_CHAR_POS
		


# NO_TELEPORT:
# 	# load current frame of character set it to a0:	

# 	# print last square of characters based on current map (32x32)

# 	call GET_MAP_ADRESS
# 	# a0 = current map adress

# 	# void procedure to print last tile of map where character was (animation)
# 	call PRINT_LAST_POS
# 	# get the adress of image to be used (a0 = adress of image) 
# 	call SPRITE_ADRESS
# 	la t0, CHAR_POS
# 	lh a1, 0(t0)
# 	lh a2, 2(t0)
# 	mv a3, s0
# 	call PRINT

# 	li t0,0xFF200604
# 	sw s0, 0(t0)
	
# 	j GAME_LOOP




li a7, 10
ecall

.data
.include "src/switch.s"
.include "src/textbox.s"
.include "src/animation.s"
.include "src/inicio.s"
.include "src/menu.s"
.include "src/background.s"
.include "src/keypoll.s"
.include "src/enemy.s"
.include "src/battle.s"
.include "src/hpbar.s"
.include "src/pokemon.s"
.include "src/attack.s"
.include "src/move.s"
.include "src/type_advantage.s"
.include "src/ai.s"
.include "SYSTEM/SYSTEMv21.s"
