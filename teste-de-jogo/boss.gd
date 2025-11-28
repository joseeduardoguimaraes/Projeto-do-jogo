extends Node2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $Hurtbox
@onready var beam_spawn: Marker2D = $BeamSpawnPoint

# PRELOAD DOS ATAQUES
@onready var PROJETIL_SEGUIDOR = preload("res://peidin.tscn")
@onready var PROJETIL_HORIZONTAL = preload("res://minhoca.tscn")
@onready var BEAM = preload("res://raio.tscn")

var life := 30
var attack_cooldown := 0.0
var attack_delay := 2.0  # intervalo entre ataques

var contador_beam := 0    # player passa 4 vezes → dispara beam

func _ready():
	hurtbox.connect("area_entered", Callable(self, "_on_hurtbox_area_entered"))
	anim.play("idle")
func _process(delta):
	attack_cooldown -= delta
	if attack_cooldown <= 0:
		escolher_ataque()

func escolher_ataque():
	var ataque = randi() % 3

	match ataque:
		0:
			ataque_proj_seguidor()
		1:
			ataque_proj_horizontal()
		2:
			if contador_beam >= 4:
				ataque_beam()
				contador_beam = 0
			else:
				ataque_proj_seguidor()
				
	attack_cooldown = attack_delay
