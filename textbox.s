
# .include "SYSTEM/MACROSv21.s"
.data
.include "sprites/textbox/textbox.s"
TEXT_RA: .word 0
msg1: .ascii "odeio oac era pra ser sexta"


.text
.data
.text
PRINTBOX:
	# print box of text a0
	la t0, TEXT_RA
	sw ra, 0(t0)

	mv s2, a0

	la a0, textbox
	li a1, 32
	li a2, 176
	mv a3, s0
	call PRINT

	mv a0, s2


	# la a0, msg1
	li a1,48
	li a2,192
	call PRINTSTR_BOX
	xori s0, s0,1

	mv a0, s2

	# la a0, msg1
	li a1,48
	li a2,192
	call PRINTSTR_BOX


	la t0, TEXT_RA
	lw ra, 0(t0)

	ret


PRINTSTR_BOX:
	 	li a7,104
		li a3,0xc700
		mv a4,s0
		ecall
		ret		