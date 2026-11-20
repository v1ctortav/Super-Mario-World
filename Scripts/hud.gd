extends Node

@onready var vidas: Label = $vidas/vidas
@onready var moedas: Label = $moedas_pontos/HBoxContainer/moedas
@onready var pontos: Label = $moedas_pontos/pontos
@onready var tempo: Label = $VBoxContainer/tempo

func _process(_delta: float) -> void:
	vidas.text = "{vidas}".format({"vidas": Global.vidas})
	moedas.text = "{moedas}".format({"moedas": Global.moedas})
	pontos.text = "{pontos}".format({"pontos": str(Global.pontos).lpad(6, "0")})
	tempo.text = "{tempo}".format({"tempo": str(Global.tempo_fase).lpad(6, "0")})
