extends CharacterBody2D

enum goomba_estados {
	andar,
	morrer
}

@onready var animacao: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $hitbox
@onready var detector_parede: RayCast2D = $detector_parede
@onready var detector_chao: RayCast2D = $detector_chao
@onready var detector_player: RayCast2D = $detector_player

var velocidade = 20
var direcao = 1

var status: goomba_estados

func _ready() -> void:
	go_to_andar_state()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		goomba_estados.andar:
			andar_state()
		goomba_estados.morrer:
			morrer_state()
	
	move_and_slide()

func go_to_andar_state():
	status = goomba_estados.andar
	animacao.play("andar")
func andar_state():
	velocity.x = velocidade * direcao
	
	if detector_parede.is_colliding():
		scale.x *= -1
		direcao *= -1
		
	if not detector_chao.is_colliding():
		scale.x *= -1
		direcao *= -1
	
	if detector_player.is_colliding():
		velocity.x = (velocidade + 20) * direcao
		return

func go_to_morrer_state():
	status = goomba_estados.morrer
	animacao.play("morrer")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	velocity = Vector2.ZERO
	await animacao.animation_finished
	queue_free()
func morrer_state():
	pass

func levar_dano():
	go_to_morrer_state()

func _on_timer_andar_timeout() -> void:
	if detector_player.is_colliding():
		return
	
	scale.x *= -1
	direcao *= -1
