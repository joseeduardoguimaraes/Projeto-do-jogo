extends Area2D

@export var speed := 200
@export var follow_time := 1.2   # tempo que ele persegue o player
@export var damage := 10

var player: CharacterBody2D = null
var velocity := Vector2.ZERO

func _ready():
	# Detecta player nas primeiras instâncias
	player = get_tree().get_first_node_in_group("player")

	# Timer que desliga perseguição
	await get_tree().create_timer(follow_time).timeout

	# Depois do follow_time, ele segue reto
	# A direção que ele estava indo no último frame fica "congelada"
	pass


func _physics_process(delta):
	if player and follow_time > 0:
		# Atualiza direção enquanto o follow_time existe
		velocity = (player.global_position - global_position).normalized() * speed
		follow_time -= delta
	elif velocity == Vector2.ZERO:
		# caso follow_time termine no mesmo frame que começou
		velocity = (player.global_position - global_position).normalized() * speed

	position += velocity * delta


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
	queue_free()
