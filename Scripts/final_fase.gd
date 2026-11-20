extends Area2D

@export var prox_fase = ""
@onready var fechar_cena: Sprite2D = $fechar_cena

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.ganhar_fase()
		call_deferred("carregar_nova_cena")

func carregar_nova_cena():
	await get_tree().create_timer(1.2, true, true).timeout
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(fechar_cena, "modulate:a", 1, 1)
	await tween.finished
	await get_tree().create_timer(0.8, true, true).timeout
	get_tree().change_scene_to_file("res://Cenas/" + prox_fase + ".tscn")
