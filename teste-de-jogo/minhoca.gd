extends Area2D

@export var speed := 300
@export var direction := Vector2.RIGHT  # direita por padrão
@export var damage := 10

func _ready():
	# Garante que a direção nunca seja ZERO
	direction = direction.normalized()

func _physics_process(delta):
	global_position += direction * speed * delta

	# Se sair bem fora da tela, ele some
	if global_position.x < -200 or global_position.x > 2000:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
