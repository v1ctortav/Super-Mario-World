# 🍄 Super Mario World

Um jogo de plataforma 2D feito em **Godot 4.6** e **GDScript** como projeto acadêmico de Ciência da Computação. O jogo é um tributo não oficial a *Super Mario World*, da Nintendo.

Atravesse quatro fases, colete moedas e desvie de inimigos e armadilhas antes que o tempo acabe.

## O que tem no jogo

- Movimento com aceleração e desaceleração, salto, agachamento e natação.
- Blocos interativos, moedas e cogumelos que transformam o personagem.
- Inimigos com comportamentos próprios, incluindo Koopas com cascos que deslizam e esqueletos que lançam projéteis.
- Plataformas móveis, prensas e um HUD com vidas, moedas, pontuação e tempo restante.

## Como jogar

1. Baixe ou clone este repositório.
2. No gerenciador de projetos da **Godot 4.6**, clique em **Importar** e selecione o arquivo `project.godot`.
3. Aguarde a importação dos recursos, pressione **F5** e use **Espaço** na tela inicial.

| Tecla | Ação |
| --- | --- |
| **A** / **D** | Mover para a esquerda / direita |
| **Espaço** ou **F** | Pular ou subir na água |
| **Shift** | Agachar |

## Como o projeto foi organizado

- [Cenas/](Cenas/) reúne o menu, as quatro fases e as telas de vitória e derrota.
- [Entidades/](Entidades/) reúne cenas reutilizáveis do personagem, dos inimigos, dos blocos e de outros elementos de jogo.
- [Scripts/](Scripts/) contém a lógica em GDScript. O personagem usa uma máquina de estados para organizar ações como pular, cair e nadar. O script global mantém dados como vidas, moedas e pontuação entre as fases.
- [Sprites/](Sprites/), [Tiles/](Tiles/), [Sons/](Sons/) e [Fontes/](Fontes/) reúnem os recursos do jogo.

## Créditos

*Super Mario World* e os personagens da franquia pertencem à Nintendo. Os recursos de terceiros pertencem a seus respectivos titulares. Este é um projeto estudantil e independente, sem vínculo com a Nintendo.

