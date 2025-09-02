Projeto do Jogo: Movimentação de Jogador 2D

Sistema de movimentação de jogador em 2D implementado em Godot (GDScript), inspirado em jogos como Celeste e Hollow Knight. Utiliza uma máquina de estados para gerenciar mecânicas como corrida, pulo, dash, agachamento e escalada em paredes. Este projeto reflete minhas habilidades em programação de jogos e serve como base para explorar conceitos de IA e automação, como controle de agentes autônomos em ambientes dinâmicos.

Características





Máquina de estados com estados como idle, run, pulo, dash, crouch, fall e wall



Movimentação fluida com aceleração e desaceleração



Pulo com coyote time (tolerância para pulo logo após sair da plataforma) e escalada em paredes



Dash com recarga limitada e colisão ajustada para agachamento



Animações sincronizadas com cada estado, usando flip para direção

Como Executar





Instale o Godot 4.x.



Clone o repositório: git clone https://github.com/joseeduardoguimaraes/Projeto-do-jogo.git



Abra o projeto no Godot (adicione a cena com o nó CharacterBody2D e os nós filhos: AnimatedSprite2D como "anim", CollisionShape2D, Timer como "coyote_timer", e RayCast2D como "left_wall" e "right_wall").



Configure as ações de input no Project Settings (ex.: "left", "right", "pulo", "dash", "crouch").



Execute a cena principal para testar a movimentação.

Demonstração




(Adicione um GIF aqui mostrando o jogador em ação – grave no Godot e suba para a pasta demo/)

Código Principal

O coração do projeto está no arquivo src/player_movement.gd, que implementa a lógica de física e estados. É modular e comentado para fácil compreensão e extensão (ex.: adicionar IA para inimigos).

Conexão com IA e Automação

Embora focado em jogos, este sistema de estados pode ser adaptado para IA: por exemplo, um agente autônomo que usa lógica similar para navegar em mapas, evitar obstáculos ou perseguir alvos. Estou explorando machine learning para otimizar caminhos em projetos futuros!

Licença

MIT License – sinta-se à vontade para usar e modificar.

Desenvolvido por José Eduardo Guimarães, estudante de Ciência da Computação. Contribuições bem-vindas!
