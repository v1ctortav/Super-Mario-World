extends AnimatableBody2D

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.3)
	await tween.finished
	queue_free()
