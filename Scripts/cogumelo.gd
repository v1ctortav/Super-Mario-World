extends Area2D

@onready var detector_parede: RayCast2D = $detector_parede
@onready var detector_chao: RayCast2D = $detector_chao

var velocidade = 50
var direcao = 1
var gravidade = 4
var velocidade_y = 0
var velocidade_x = 0

var pode_virar = true

func _process(delta: float) -> void:
	var no_chao = detector_chao.is_colliding()
	if !no_chao:
		velocidade_y += gravidade * delta
		velocidade_x = 20 * delta
	else:
		velocidade_y = 0
		velocidade_x = velocidade * delta * direcao
		
	
	if detector_parede.is_colliding() and pode_virar:
		scale.x *= -1
		direcao *= -1
		pode_virar = false
		await get_tree().create_timer(0.2).timeout
		pode_virar = true
	
	position.x += velocidade_x
	position.y += velocidade_y
