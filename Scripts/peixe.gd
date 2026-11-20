extends CharacterBody2D

enum peixe_estados {
	andar,
	morrer
}

@onready var animacao: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $hitbox
@onready var detector_parede: RayCast2D = $detector_parede

var velocidade = 20
var direcao = 1

var status: peixe_estados

func _ready() -> void:
	go_to_andar_state()

func _physics_process(_delta: float) -> void:	
	match status:
		peixe_estados.andar:
			andar_state()
		peixe_estados.morrer:
			morrer_state()
	
	move_and_slide()

func go_to_andar_state():
	status = peixe_estados.andar
	animacao.play("andar")
func andar_state():
	velocity.x = velocidade * direcao
	
	if detector_parede.is_colliding():
		scale.x *= -1
		direcao *= -1

func go_to_morrer_state():
	status = peixe_estados.morrer
	animacao.play("morrer")
	animacao.flip_v = true
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	velocity = Vector2.ZERO
	await animacao.animation_finished
	queue_free()
func morrer_state():
	pass

func levar_dano():
	go_to_morrer_state()
	
	scale.x *= -1
	direcao *= -1


func _on_timer_andar_timeout() -> void:
	scale.x *= -1
	direcao *= -1
