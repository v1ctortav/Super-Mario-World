extends Area2D

var velocidade = 20
func _process(delta: float) -> void:
	position.x += velocidade * delta


func _on_aumentar_velocidade_timeout() -> void:
	velocidade += 5
