extends Area2D

onready var player = get_tree().get_root().find_node("Player", true, false)

var mouse_over:bool = false

var customer:Area2D

func _ready():
	set_process(false)
	connect("area_entered", self, "_on_area_enter")
	connect("mouse_entered", self, "_on_mouse_enter")
	connect("mouse_exited", self, "_on_mouse_exit")

func _process(delta):
	if self in player.interactions:
		get_node("Sprite").material.set_shader_param("width", 20)

func _input(event):
	if Input.is_action_just_pressed('click') and mouse_over:
		if not self in player.interactions:
			player.interactions.push_back(self)

func _on_area_enter(area):
	if player.interactions.size() > 0 and player.interactions[0] == self:
		player.interactions.pop_front()
		get_node("Sprite").material.set_shader_param("width", 0)

func _on_mouse_enter():
	set_process(true)
	mouse_over = true
	get_node("Sprite").material.set_shader_param("width", 10)

func _on_mouse_exit():
	mouse_over = false
	get_node("Sprite").material.set_shader_param("width", 0)