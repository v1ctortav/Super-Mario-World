extends Area2D

@onready var animacao: AnimatedSprite2D = $AnimatedSprite2D

var velocidade = 80
var direcao = 1

func _process(delta: float) -> void:
	position.x += velocidade * delta * direcao

func set_direction(direcao):
	self.direcao = direcao
	animacao.flip_h = direcao < 0


func _on_destruir_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		await get_tree().create_timer(0.5).timeout
		queue_free()
