extends Area2D

signal hurt(source)

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_area_entered(area):
	emit_signal("hurt", area)
	print("Hurtbox detectou AREA:", area)
func _on_body_entered(body):
	emit_signal("hurt", body)
