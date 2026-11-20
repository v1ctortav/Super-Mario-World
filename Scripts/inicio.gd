extends Node2D

@onready var fechar_cena: Sprite2D = $fechar_cena
@onready var start: AudioStreamPlayer = $Start

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pular"):
		start.play()
		await get_tree().create_timer(0.8, true, true).timeout
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(fechar_cena, "modulate:a", 1, 1.2)
		await tween.finished
		await get_tree().create_timer(0.8, true, true).timeout
		get_tree().change_scene_to_file("res://Cenas/level_1.tscn")
