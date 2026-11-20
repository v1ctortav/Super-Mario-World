extends Node

enum estados_vida_player {
	grande,
	pequeno
}

var status: estados_vida_player
var estado = ""
var moedas = 0
var pontos = 0
var vidas = 3
var tempo_fase = 0

func _ready() -> void:
	set_estado()
	
func set_estado():
	if estado == "grande":
		status = estados_vida_player.grande
	elif estado == "pequeno":
		status = estados_vida_player.pequeno
