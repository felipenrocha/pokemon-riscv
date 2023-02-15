###############################################
#  Programa de exemplo para Syscall MIDI      #
#  ISC Abr 2018				      #
#  Marcus Vinicius Lamar		      #
###############################################

.data
# Numero de Notas a tocar
intro_num: .word 40
intro_notas: 60,112,64,112,67,112,73,112,72,451,72,676,72,112,72,112,72,451,72,451,72,451,71,338,71,338,73,225,72,676,76,225,79,1578,77,225,83,676,81,112,80,112,79,902,71,676,69,112,70,112,67,902,65,338,64,338,65,225,72,676,76,225,79,1804,77,338,76,338,77,225,79,902,71,338,69,338,65,225,67,1127,64,225
select_num: .word 5
select_notas:  17, 100, 101, 100, 17, 100, 12, 150, 9, 10
heal_num: .word 6
heal_notas:  67, 105, 67, 421, 67, 421, 67, 210, 72, 210, 72, 316

itemfound_num: .word 6
itemfound_notas: 71, 58, 71, 68, 71, 68, 71, 68, 71, 68, 71, 68



.text
PLAY_INTRO:
	addi sp, sp, -4
	sw ra, 0(sp)

	la s0,intro_num			# define o endere�o do n�mero de notas
	lw s1,0(s0)				# le o numero de notas
	la s0,intro_notas		# define o endere�o das notas
	li t0,0			# zera o contador de notas
	li a2,68		# define o instrumento
	li a3,127		# define o volume

PIL1:
	beq t0,s1, FIMPI		# contador chegou no final? ent�o  v� para FIM
	lw a0,0(s0)		# le o valor da nota
	lw a1,4(s0)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	mv a0,a1		# passa a dura��o da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	addi s0,s0,8		# incrementa para o endere�o da pr�xima nota
	addi t0,t0,1		# incrementa o contador de notas
	j PIL1			# volta ao loop
	
FIMPI:	

	
    lw ra, 0(sp)
    addi sp, sp, 4
    ret




PLAY_HEAL:
	addi sp, sp, -4
	sw ra, 0(sp)

    la s0,heal_num			# define o endere�o do n�mero de notas
	lw s1,0(s0)				# le o numero de notas
	la s0,heal_notas		# define o endere�o das notas
	li t0,0			# zera o contador de notas
	li a2,68		# define o instrumento
	li a3,127		# define o volume

PHL1:
	beq t0,s1, FIMPH		# contador chegou no final? ent�o  v� para FIM
	lw a0,0(s0)		# le o valor da nota
	lw a1,4(s0)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	mv a0,a1		# passa a dura��o da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	addi s0,s0,8		# incrementa para o endere�o da pr�xima nota
	addi t0,t0,1		# incrementa o contador de notas
	j PHL1			# volta ao loop
	


FIMPH:	
	lw ra, 0(sp)
    addi sp, sp, 4
    ret

PLAY_SELECT:

	addi sp, sp, -4
	sw ra, 0(sp)
    
	
	la s0,select_num			# define o endere�o do n�mero de notas
	lw s1,0(s0)				# le o numero de notas
	la s0,select_notas		# define o endere�o das notas
	li t0,0			# zera o contador de notas
	li a2,68		# define o instrumento
	li a3,127		# define o volume

PSL1:
	beq t0,s1, FIMPS		# contador chegou no final? ent�o  v� para FIM
	lw a0,0(s0)		# le o valor da nota
	lw a1,4(s0)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	mv a0,a1		# passa a dura��o da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	addi s0,s0,8		# incrementa para o endere�o da pr�xima nota
	addi t0,t0,1		# incrementa o contador de notas
	j PSL1			# volta ao loop
	
FIMPS:	
	lw ra, 0(sp)
    addi sp, sp, 4
    ret


PLAY_ITEM_FOUND:

	addi sp, sp, -4
	sw ra, 0(sp)

	
	la s7,itemfound_num			# define o endere�o do n�mero de notas
	lw s8,0(s7)				# le o numero de notas
	la s7,itemfound_notas		# define o endere�o das notas
	li t0,0			# zera o contador de notas
	li a2,68		# define o instrumento
	li a3,127		# define o volume

PIFL1:
	beq t0,s8, FIMPIF		# contador chegou no final? ent�o  v� para FIM
	lw a0,0(s7)		# le o valor da nota
	lw a1,4(s7)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	mv a0,a1		# passa a dura��o da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	addi s7,s7,8		# incrementa para o endere�o da pr�xima nota
	addi t0,t0,1		# incrementa o contador de notas
	j PIFL1

FIMPIF:		
	lw ra, 0(sp)
    addi sp, sp, 4
    ret
