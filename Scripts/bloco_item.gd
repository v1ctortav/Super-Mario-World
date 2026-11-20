extends StaticBody2D

@onready var hitbox: CollisionShape2D = $hitbox/CollisionShape2D
@onready var animacao: AnimatedSprite2D = $AnimatedSprite2D
const COGUMELO = preload("uid://5rr732x3sbh8")
@onready var spaw_item: Node2D = $spaw_item

var quebrado = false
@export var item = ""

func hit():
	if quebrado:
		return
	
	quebrado = true
	hitbox.set_deferred("disabled", true)
	animacao.play("quebrado")

func criar_item():
	var item_cena: Area2D
	if item != "":
		if item == "cogumelo_vida":
			item_cena = COGUMELO.instantiate()
	
		get_parent().add_child(item_cena)
		item_cena.position = spaw_item.global_position


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hit()
		call_deferred("criar_item")
