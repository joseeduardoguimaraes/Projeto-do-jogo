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
	#extends CharacterBody2D

	# Estados possíveis do jogador
	enum PlayerState {
		idle,
		run,
		pulo,
		dash,
		crouch,
		fall,
		wall,
		dead,
		hit
	}

	# Referências aos nós do Godot
	@onready var anim: AnimatedSprite2D = $anim
	@onready var collision_shape: CollisionShape2D = $CollisionShape2D
	@onready var coyote_timer: Timer = $coyote_timer as Timer
	@onready var left_wall: RayCast2D = $left_wall
	@onready var right_wall: RayCast2D = $right_wall

	# Constantes de física
	const SPEED = 200.0
	const FORCA_PULO = -500.0
	const DASH_SPEED = 500.0
	const DASH_TIME = 0.2
	
	# Variáveis do jogador
	var direction := Input.get_axis("left", "right")
	var status: PlayerState
	var dash_timer = 0.0
	var dash_cout = 1
	var pular := true
	var in_wall := true
	var wall_acelerate = 20
	var life = 3
	var life_b = 3
	
	# Inicializa o jogador no estado idle
	func _ready() -> void:
		go_to_idle_state()
	
	# Processa a física e a máquina de estados a cada frame
	func _physics_process(delta: float) -> void:
		# Executa a lógica de cada estado
		match status:
			PlayerState.idle:
				idle_state(delta)
			PlayerState.run:
				run_state(delta)
			PlayerState.pulo:
				pulo_state(delta)
			PlayerState.dash:
				dash_state(delta)
			PlayerState.crouch:
				crouch_state(delta)
			PlayerState.fall:
				fall_state(delta)
			PlayerState.wall:
				wall_state(delta)
			PlayerState.dead:
				dead_state()
			PlayerState.hit:
				hit_state()
	
	# Aplica a movimentação ao personagem
	move_and_slide()

	# Funções para transição entre estados e animações correspondentes
	func go_to_idle_state():
		status = PlayerState.idle
		anim.play("idle")
		dash_cout = 0
		pular = true
	
	func go_to_run_state():
		status = PlayerState.run
		anim.play("run")
		dash_cout = 0
		pular = true
	
	func go_to_pulo_state():
		status = PlayerState.pulo
		anim.play("pulo")
		dash_cout = 0
	
	func go_to_dash_state():
		status = PlayerState.dash
		anim.play("dash")
		dash_timer = DASH_TIME
		dash_cout = 1
		if anim.flip_h:
			velocity.x = velocity.x - DASH_SPEED
		else:
			velocity.x = velocity.x + DASH_SPEED
		velocity.y = 0
	
	func go_to_crouch_state():
		status = PlayerState.crouch
		anim.play("dash")
		collision_shape.shape.height = 35
		collision_shape.position.y = 15
		velocity.x = 0
		dash_cout = 0
	
	func go_to_fall_state():
		status = PlayerState.fall
		anim.play("pulo")
		in_wall = true
	
	func go_to_wall_state():
		status = PlayerState.wall
		anim.play("wall")
		pular = true
		in_wall = true
		dash_cout = 0
		velocity = Vector2.ZERO
	
	# Lógica de cada estado
	func idle_state(delta):
		gravity(delta)
		move()
		if velocity.x != 0:
			go_to_run_state()
			return
		if velocity.y < 0:
			go_to_pulo_state()
		if velocity.y > 0:
			go_to_fall_state()
			return
		elif Input.is_action_just_pressed("dash") and dash_cout == 0:
			go_to_dash_state()
			return
		elif Input.is_action_pressed("crouch") and is_on_floor():
			go_to_crouch_state()
			return
	
	func run_state(delta):
		gravity(delta)
		move()
		if velocity.x == 0 and is_on_floor():
			go_to_idle_state()
			return
		if velocity.y > 0:
			go_to_fall_state()
			return
		if Input.is_action_just_pressed("pulo"):
			go_to_pulo_state()
			return
		if Input.is_action_just_pressed("dash") and dash_cout == 0:
			go_to_dash_state()
			return
		elif Input.is_action_pressed("crouch") and is_on_floor():
			go_to_crouch_state()
			return
	
	func pulo_state(delta):
		gravity(delta)
		move()
		pular = false
		if velocity.y > 0:
			go_to_fall_state()
		return
		if Input.is_action_just_pressed("dash") and dash_cout == 0:
			go_to_dash_state()
			return
	
	func dash_state(delta):
		gravity(delta)
		move()
		dash_timer -= get_physics_process_delta_time()
		if dash_timer <= 0:
			if velocity.y != 0:
				go_to_fall_state()
			if velocity.x != 0 and velocity.y == 0:
				go_to_run_state()
			elif velocity.x == 0 and velocity.y == 0:
				go_to_idle_state()	

	func crouch_state(delta):
		flip()
		if Input.is_action_just_released("crouch"):
			exit_crouch()
			go_to_idle_state()
			return
		
	func exit_crouch():
		collision_shape.shape.height = 60.0
		collision_shape.position.y = 0.0

	func fall_state(delta):
		gravity(delta)
		move()
		if Input.is_action_just_pressed("dash") and dash_cout == 0:
			go_to_dash_state()
			return
		if left_wall.is_colliding() and Input.is_action_pressed("left") and in_wall or right_wall.is_colliding() and Input.is_action_pressed("right") and in_wall:
			go_to_wall_state()
			in_wall = false
			return
		if is_on_floor():
			if velocity.x == 0:
				go_to_idle_state()
				return
			if velocity.x != 0:
			go_to_run_state()
				return
	
	func wall_state(delta):
		velocity.y += wall_acelerate * delta
		if left_wall.is_colliding():
			anim.flip_h = true
			direction = -1
		else:
			anim.flip_h = false
			direction = 1
		if Input.is_action_just_pressed("pulo") and pular:
			velocity.y = FORCA_PULO
			in_wall = false
			go_to_pulo_state()
			return
		if is_on_floor():
			go_to_idle_state()
			return
		if Input.is_action_just_released("left"):
			go_to_fall_state()
			return
		if Input.is_action_just_released("right"):
			go_to_fall_state()
			return
	
	func dead_state():
		pass
	
	func hit_state():
		pass
	
	# Lida com a movimentação horizontal e o pulo
	func move():
		flip()
		if status != PlayerState.dash:
			if Input.is_action_just_pressed("pulo") and pular:
				velocity.y = FORCA_PULO
			if is_on_floor() and !pular:
				pular = true
			elif pular and coyote_timer.is_stopped():
				coyote_timer.start()
			
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)

	# Inverte a sprite do jogador com base na direção
	func flip():
		direction = Input.get_axis("left", "right")
			if direction < 0:
			anim.flip_h = true
		elif direction > 0:
			anim.flip_h = false	

	# Aplica gravidade quando o jogador não está no chão
	func gravity(delta):
		if not is_on_floor():
			velocity += (get_gravity() * delta)
		elif is_on_floor() and status != PlayerState.dash:
			velocity.y = 0

	# Controla o tempo de tolerância para pulo (coyote time)
	func _on_coyote_timer_timeout() -> void:
		pular = false
