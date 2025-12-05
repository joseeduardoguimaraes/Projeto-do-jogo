extends Node2D

@export var speed = 1000.0
@export var lifetime = 2.0
var direction = 1 # 1 se nasceu na esquerda, -1 na direita

func _ready():
	$AnimatedSprite2D.flip_h = direction < 0
	$AnimatedSprite2D.play()

	$Area2D.body_entered.connect(_on_body_entered)

	var t := Timer.new()
	t.wait_time = lifetime
	t.one_shot = true
	t.connect("timeout", Callable(self, "_on_timeout"))
	add_child(t)
	t.start()

func _physics_process(delta):
	position.x += -direction * speed * delta

func _on_timeout():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("dead_state"):
			body.dead_state()

	queue_free()
