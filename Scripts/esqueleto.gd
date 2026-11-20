extends CharacterBody2D

enum esqueleto_estados {
	andar,
	atacar,
	morrer
}

@onready var animacao: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $hitbox
@onready var detector_parede: RayCast2D = $detector_parede
@onready var detector_player: RayCast2D = $detector_player
@onready var detector_chao: RayCast2D = $detector_chao
@onready var posicao_osso: Node2D = $posicao_osso

const OSSO = preload("uid://ubkwthefabbj")

const velocidade = 30.0
var direcao = 1
var pode_atacar = true

var status: esqueleto_estados

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		esqueleto_estados.andar:
			andar_state()
		esqueleto_estados.atacar:
			atacar_state()
		esqueleto_estados.morrer:
			morrer_state()
	
	move_and_slide()

func _ready() -> void:
	go_to_andar_state()

func go_to_andar_state():
	status = esqueleto_estados.andar
	animacao.play("andar")
func andar_state():
	if animacao.frame == 3 or animacao.frame == 4:
		velocity.x = velocidade * direcao
	else:
		velocity.x = 0
	
	if detector_parede.is_colliding():
		scale.x *= -1
		direcao *= -1
		
	if not detector_chao.is_colliding():
		scale.x *= -1
		direcao *= -1
	
	if detector_player.is_colliding():
		go_to_atacar_state()
		return

func go_to_atacar_state():
	status = esqueleto_estados.atacar
	animacao.play("atacar")
	velocity = Vector2.ZERO
	pode_atacar = true
func atacar_state():
	if !detector_player.is_colliding():
		go_to_andar_state()
		return
	
	if animacao.frame == 2 && pode_atacar:
		lancar_osso()
		pode_atacar = false
		await get_tree().create_timer(2.0, true, true).timeout

func go_to_morrer_state():
	status = esqueleto_estados.morrer
	animacao.play("morrer")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	velocity = Vector2.ZERO
func morrer_state():
	pass

func levar_dano():
	go_to_morrer_state()

func lancar_osso():
	var novo_osso = OSSO.instantiate()
	add_sibling(novo_osso)
	novo_osso.position = posicao_osso.global_position
	novo_osso.set_direction(self.direcao)

func _on_animated_sprite_2d_animation_finished() -> void:
	if animacao.animation == "atacar":
		go_to_andar_state()
		return
