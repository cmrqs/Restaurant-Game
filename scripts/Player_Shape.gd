extends Area2D

onready var player = get_parent()

func _ready():
	connect("area_entered", self, "_on_area_enter")

func _on_area_enter(body):
	if body.global_position.y > player.global_position.y:
		player.set_z_index(0)
	else:
		player.set_z_index(1)