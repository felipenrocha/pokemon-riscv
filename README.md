

## Pokemon Game on RISCV - Using RARS and Bitmap Display

    Author: Felipe Nascimento Rocha



#### Projeto Final de OAC




###### Running on FPGRARS

    Windows: 
    ```
        fgprars main.s
    ```

###### Running on RARS

        1. Open Rars15_Custom.jar


        2. Inside Rars, open the file "jogo.s"


        3. Click on the "Spanner/Screwdiver" icon to assemble and mount the program.


        4. On the top, click on Tools->Bitmap Display:

            4.1 Inside Bitmap Display click on "Connect from program".


        5. On the top, click on Tools -> Keybord and Display MMIO Simulator

            5.1 Inside de Keyboard, click on "Connect from Program"
        

        6. Run the program (Play sign).


###### How to Play:

        PS.: Run the inputs inside the Keybord and Display MMIO Simulator display (bottom one) (only lower cases!);

        1. W,A,S,D To move the character;

        2. Z select;

        3. X go back;

### Requirements TODO:

- [x]   (0,5) história do jogo (com caixas de diálogo);
- [x]   (1,0) música e efeitos sonoros;
- [x]   (0,5) mínimo de 1 item utilizável;
- [x]   (1,0) mínimo de 5 tipos de pokémons diferentes, com um sistema “pedra-papel-tesoura” entre eles (normal perde
para luta, luta para psíquico, etc.);
- [x]   (1,0) mínimo de três tipos de telas jogáveis: seleção de pokémons iniciais, área aberta, e ginásio;
- [x]   (1,0) fases com número crescente de inimigos (inclusa a animação deles), espaços abertos e paredes;
- [x]   (1,0) IA que controla os inimigos e sistema de turnos da luta;
- [x]   (0,5) cenas de batalhas, podendo ser apenas uma imagem mostrando os personagens e as vidas deles;
- [x]   (0,5) menu de ações do jogador;
- [x]   (0,5) movimentação dos personagens
- [ ]   (0,5) três tipos de terrenos especiais (NOPE);
- [x]   (2.0) documentação: descreva seu projeto no formato de um Artigo Científico IEEE para o SBGames.
