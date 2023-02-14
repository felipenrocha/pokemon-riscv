.include "SYSTEM/MACROSv21.s"


.text

# call START_BATTLE

# call  MENU


# #  inicio do jogo
# call INICIO_JOGO	


# li a0, 1000
# call SLEEP 
call START_GAME




li a7, 10
ecall

.data
.include "src/switch.s"
.include "src/game_loop.s"

.include "src/textbox.s"
.include "src/animation.s"
.include "src/inicio.s"
.include "src/menu.s"
.include "src/background.s"
.include "src/keypoll.s"
.include "src/enemy.s"
.include "src/inventory.s"
.include "src/battle.s"
.include "src/hpbar.s"
.include "src/midi.s"

.include "src/pokemon.s"
.include "src/attack.s"
.include "src/move.s"
.include "src/type_advantage.s"
.include "src/ai.s"
.include "SYSTEM/SYSTEMv21.s"
