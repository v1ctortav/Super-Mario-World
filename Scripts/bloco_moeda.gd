extends StaticBody2D

@onready var hitbox: CollisionShape2D = $hitbox/CollisionShape2D
@onready var animacao: AnimatedSprite2D = $AnimatedSprite2D
const BLOCO_MOEDA_ITEM = preload("uid://cqvmc1qs1xwx7")
@onready var spaw_moeda: Node2D = $spaw_moeda

var quebrado = false

func hit():
	if quebrado:
		return
	
	quebrado = true
	hitbox.set_deferred("disabled", true)
	animacao.play("quebrado")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hit()
		call_deferred("criar_moeda")
		body.ganhar_moeda()

func criar_moeda():
	var moeda = BLOCO_MOEDA_ITEM.instantiate()
	get_parent().add_child(moeda)
	moeda.position = spaw_moeda.global_position
