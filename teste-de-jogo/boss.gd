extends Node2D

#-----------------------
# Estados
#-----------------------

enum BossState {
	idle, minhoca, peido, layzao, estuprado
}
var status: BossState

#-----------------------
# Variaveis
#-----------------------

@onready var timer_minhoca: Timer = $"timer minhoca"
@onready var timer_peido: Timer = $"timer peido"
@onready var timer_layzao: Timer = $"timer layzao"
@onready var anim: AnimatedSprite2D = $anim
@onready var hurtbox: Area2D = $hurtbox



var peido_scene := preload("res://boss/ataque_2.tscn")
var minhoca_scene := preload("res://boss/ataque_1.tscn")
var beam_scene :=preload("res://boss/ataque_3.tscn")

# cooldown
var TM_minhoca = 6.0
var TM_peido   = 14.0
var TM_beam    = 16.0
var cd_minhoca :=true
var cd_peido   :=true
var cd_beam    :=true
var n
var life = 50


func _ready() -> void:
	$hurtbox.connect("hurt", Callable(self, "_on_hurtbox_hurt"))

	randomize()
	go_to_idle_state()
func _process(delta):
	
	
	match status:
		BossState.idle:      idlestate()
		BossState.minhoca:   minhocastate()
		BossState.peido:     peidostate()
		BossState.layzao:    beamstate()
		BossState.estuprado: estupradostate()
		
func go_to_idle_state():
	status = BossState.idle
	anim.play("idle")
	n = randi() % 101
	
func go_to_minhoca_state():
	status = BossState.minhoca
	var minhoca_lado = randi() % 2+1
	var new_minhoca = minhoca_scene.instantiate()
	add_sibling(new_minhoca)
	if minhoca_lado==1:
		new_minhoca.direction = -1
		new_minhoca.position = Vector2(3200,515)
	else:
		new_minhoca.direction = 1
		new_minhoca.position = Vector2(4900,515)
	timer_minhoca.start(TM_minhoca)
	cd_minhoca = false
	return

func go_to_peido_state():
	status = BossState.peido
	var new_peido = peido_scene.instantiate()
	add_sibling(new_peido)
	new_peido.position = self.position
	timer_peido.start(TM_peido)
	cd_peido = false
	return
func go_to_beam_state():
	cd_beam = false
	return

func go_to_estuprado_state():
	get_tree().quit()
func idlestate():
	if life <=25 and life >0:
		TM_beam = 10
		TM_peido = 0.0001
		TM_minhoca = 100
	if life <=0:
		go_to_estuprado_state()
	if n <= 50 and cd_minhoca == true:
		go_to_minhoca_state()
		return
	elif n <=80 and n>50 and cd_peido == true:
		go_to_peido_state()
		return
	elif n > 80 and cd_beam == true:
		go_to_beam_state()
		return
	else:
		go_to_idle_state()
		return

func minhocastate():
	go_to_idle_state()
	return
func peidostate():
	go_to_idle_state()
	return
func beamstate():
	go_to_idle_state()
	return
func estupradostate():
	return
func _on_hurtbox_hurt(source):
	life -= 1
	return

func _on_timer_peido_timeout() -> void:
	cd_peido = true


func _on_timer_minhoca_timeout() -> void:
	cd_minhoca = true


func _on_timer_layzao_timeout() -> void:
	cd_beam = true
