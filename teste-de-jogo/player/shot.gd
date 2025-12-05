extends Area2D

var speed = 800
var direction := Vector2.ZERO

func _process(delta):
	global_position += direction * speed * delta


func set_direction(new_direction: Vector2):
	direction = new_direction.normalized()


func _on_area_entered(area: Area2D):
	print("Tiro acertou:", area.name)

	# Se quiser destruir o tiro ao bater:
	queue_free()
