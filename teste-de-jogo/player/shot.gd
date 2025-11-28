extends Area2D

var speed = 800
var direction := Vector2.ZERO

func _process(delta):
	global_position += direction * speed * delta

func set_direction(new_direction: Vector2):
	direction = new_direction.normalized()
