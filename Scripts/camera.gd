extends Camera2D

var alvo: Node2D

func _ready() -> void:
	get_player()

func _process(_delta: float) -> void:
	position = alvo.position

func get_player():
	var nodes = get_tree().get_nodes_in_group("player")
	if nodes.size() == 0:
		push_error("Player não encontrado.")
		return
	
	alvo = nodes[0]
