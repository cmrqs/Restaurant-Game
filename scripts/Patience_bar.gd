tool
extends TextureProgress

func initialize(patience) -> void:
	max_value = patience
	value = patience

func animate(target, tween_duration = 1.0) -> void:
	pass