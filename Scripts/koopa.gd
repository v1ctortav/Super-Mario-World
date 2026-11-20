extends CharacterBody2D

enum koopa_estados {
	andar,
	casco,
	morrer
}

@onready var animacao: AnimatedSprite2D = $AnimatedSprite2D
@onready var colisao: CollisionShape2D = $CollisionShape2D
@onready var hitbox: Area2D = $hitbox
@onready var hitbox_colisao: CollisionShape2D = $hitbox/CollisionShape2D
@onready var detector_parede: RayCast2D = $detector_parede
@onready var detector_chao: RayCast2D = $detector_chao
@onready var timer_andar: Timer = $timer_andar

var velocidade = 25
var direcao = 1
var casco = false
var hits = 0

var status: koopa_estados

func _ready() -> void:
	go_to_andar_state()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if hits == 2:
		velocity.x = 120 * direcao
	
	match status:
		koopa_estados.andar:
			andar_state()
		koopa_estados.casco:
			casco_state()
		koopa_estados.morrer:
			morrer_state()
		
	
	move_and_slide()

func go_to_andar_state():
	status = koopa_estados.andar
	animacao.play("andar")
	timer_andar.start()
func andar_state():
	velocity.x = velocidade * direcao
	
	if detector_parede.is_colliding():
		scale.x *= -1
		direcao *= -1
		
	if not detector_chao.is_colliding():
		scale.x *= -1
		direcao *= -1

func go_to_casco_state():
	status = koopa_estados.casco
	animacao.play("casco")
	casco = true
	detector_chao.enabled = false
	timer_andar.stop()
	hitbox_casco()
func casco_state():
	if detector_parede.is_colliding():
		scale.x *= -1
		direcao *= -1
	
	if hits == 1:
		velocity.x = 0
	

	
func go_to_morrer_state():
	status = koopa_estados.morrer
	animacao.play("morrer")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	velocity = Vector2.ZERO
	await animacao.animation_finished
	queue_free()
func morrer_state():
	pass

func levar_dano():
	hits += 1
	if casco and hits > 2:
		go_to_morrer_state()
	else:
		go_to_casco_state()
func dano_fatal():
	go_to_morrer_state()

func hitbox_casco():
	if casco:
		colisao.shape.size.x = 15
		colisao.shape.size.y = 15
		colisao.position.x = 0.5
		colisao.position.y = -0.5
		hitbox_colisao.shape.size.x = 25
		hitbox_colisao.shape.size.y = 15
		hitbox_colisao.position.x = 0.5
		hitbox_colisao.position.y = -0.5
	else:
		colisao.shape.size.x = 15
		colisao.shape.size.y = 22
		colisao.position.x = 0.5
		colisao.position.y = 0
		hitbox_colisao.shape.size.x = 21
		hitbox_colisao.shape.size.y = 26
		hitbox_colisao.position.x = 0.5
		hitbox_colisao.position.y = 0

func _on_timer_andar_timeout() -> void:
	scale.x *= -1
	direcao *= -1


func _on_hitbox_area_entered(area: Area2D) -> void:
	if casco and area.is_in_group("koopas"):
		area.get_parent().dano_fatal()
	elif casco and area.is_in_group("inimigos"):
		area.get_parent().levar_dano()
	if area.is_in_group("area_letal"):
		go_to_morrer_state()
