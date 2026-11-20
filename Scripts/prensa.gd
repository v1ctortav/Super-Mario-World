extends AnimatableBody2D

@onready var alvo: Sprite2D = $alvo

func _ready() -> void:
	alvo.visible = false
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "global_position", alvo.global_position, 1)
	tween.tween_property(self, "global_position", global_position, 3)
	tween.set_loops()
