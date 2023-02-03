
# .include "SYSTEM/MACROSv21.s"
.data
.include "../sprites/textbox/textbox.s"
TEXT_RA: .word 0

.text



PRINTBOX:
	# print box of text a0
        addi    sp, sp, -4
        sw      ra, 0(sp)                      # 4-byte Folded Spill

	mv s2, a0

	la a0, textbox
	li a1, 32
	li a2, 176
	li a3, 0
	call PRINT
	li a3, 1
	call PRINT

	mv a0, s2

	mv a0, s2
	li a1,48
	li a2,192
	li a4, 0
	call PRINTSTR_BOX


	mv a0, s2
	# la a0, msg1
	li a1,48
	li a2,192
	li a4, 1
	call PRINTSTR_BOX

	lw      ra, 0(sp)                      # 4-byte Folded Reload
	addi    sp, sp, 4

	ret


PRINTSTR_BOX:
	 	li a7,104
		li a3,0xc700
		ecall
		ret		