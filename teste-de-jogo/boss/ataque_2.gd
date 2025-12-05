extends Node2D

@onready var anim: AnimatedSprite2D = $anim
@export var speed: float = 350.0
@export var lifetime: float = 3.0
@export var turn_speed: float = 5.0  

var target: Node2D = null
var current_dir := Vector2.RIGHT 

func _ready() -> void:
	anim.play("peido")

	target = get_tree().get_first_node_in_group("player")
		
	$Area2D.body_entered.connect(_on_body_entered)

	var t := Timer.new()
	t.wait_time = lifetime
	t.one_shot = true
	t.timeout.connect(_on_timeout)
	add_child(t)
	t.start()

func _physics_process(delta):
	if target == null:
		return

	var desired_dir = (target.global_position - global_position).normalized()
	current_dir = current_dir.lerp(desired_dir, turn_speed * delta).normalized()
	global_position += current_dir * speed * delta

	anim.flip_h = current_dir.x < 0

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("dead_state"):
			body.dead_state()

	queue_free()

func _on_timeout():
	queue_free()
