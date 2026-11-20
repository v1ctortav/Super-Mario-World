extends Node2D

@onready var fechar_cena: Sprite2D = $fechar_cena
@onready var seta: Sprite2D = $seta
@onready var score: Label = $score
@onready var opcao: AudioStreamPlayer = $Opcao
var btn = "sim"

func _ready() -> void:
	Global.vidas = 3
	Global.moedas = 0
	score.text = "SCORE: {score}".format({"score": str(Global.pontos).lpad(6, "0")})

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("direita") and btn == "sim":
		btn = "nao"
		seta.position.x = 352
	elif Input.is_action_just_pressed("esquerda") and btn == "nao":
		btn = "sim"
		seta.position.x = 264
	if Input.is_action_just_pressed("pular"):
		opcao.play()
		if btn == "sim":
			await get_tree().create_timer(0.6, true, true).timeout
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_QUAD)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(fechar_cena, "modulate:a", 1, 1)
			await tween.finished
			await get_tree().create_timer(0.8, true, true).timeout
			Global.pontos = 0
			get_tree().change_scene_to_file("res://Cenas/level_1.tscn")
		else:
			await get_tree().create_timer(0.6, true, true).timeout
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_QUAD)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(fechar_cena, "modulate:a", 1, 0.5)
			await tween.finished
			await get_tree().create_timer(0.5, true, true).timeout
			Global.pontos = 0
			get_tree().change_scene_to_file("res://Cenas/inicio.tscn")
