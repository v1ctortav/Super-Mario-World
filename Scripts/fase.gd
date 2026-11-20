extends Node2D

@onready var som_cena: AudioStreamPlayer = $som_cena

func _ready() -> void:
	som_cena.play()
