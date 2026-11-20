extends StaticBody2D

@onready var colisao: CollisionShape2D = $CollisionShape2D
@onready var hitbox: Area2D = $hitbox
@onready var bloco: Sprite2D = $Sprite2D
@onready var pedaco_1: Sprite2D = $pedaco1
@onready var pedaco_2: Sprite2D = $pedaco2
@onready var pedaco_3: Sprite2D = $pedaco3
@onready var pedaco_4: Sprite2D = $pedaco4

var quebrado = false

func hit():
	if quebrado:
		return
	
	quebrado = true
	colisao.set_deferred("disabled", true)
	hitbox.set_deferred("disabled", true)
	bloco.set_deferred("visible", false)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hit()
		animacao_quebrar()
		await get_tree().create_timer(1.0).timeout
		queue_free()

func animacao_quebrar():
	if !quebrado:
		return
	
	var pedacos = [pedaco_1, pedaco_2, pedaco_3, pedaco_4]
	var direcoes = [ Vector2(-40, 150), Vector2(40, 150), Vector2(-40, 150), Vector2(40, 150) ]
	
	for i in range(pedacos.size()):
		var pedaco = pedacos[i]
		var direcao = direcoes[i]
		
		pedaco.visible = true
		
		var tween = create_tween().set_parallel(true)
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_IN)
		
		tween.tween_property(pedaco, "position:x", pedaco.position.x + direcao.x, 1.0)
		tween.tween_property(pedaco, "position:y", pedaco.position.y + direcao.y, 0.6)
		tween.parallel().tween_property(pedaco, "rotation_degrees", pedaco.rotation_degrees + randf_range(-360, 360), 0.3)
