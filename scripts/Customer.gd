# Pathfinding on a TileMap with Navigation2D (Godot 3.1 tutorial)
# GDquest <https://www.youtube.com/watch?v=0fPOt0Jw52s>

extends Node2D

export var speed:float = 150
var path := PoolVector2Array() setget set_path
var isMoving:bool = false

var angry:bool = false
var patience:float = 5
onready var patience_bar = $Patience_bar

var table:Area2D

var waiting_in_line:bool = true
var waiting_menu:bool = false
var waiting_food:bool = false
var leaving = false

func _ready() -> void:
	patience_bar.max_value = patience
	patience_bar.value = patience
	patience_bar.hide()

func _process(delta:float) -> void:
	if isMoving:
		var move_distance:float = speed * delta
		move_along_path(move_distance)
	
	elif waiting_menu:
		patience_bar.show()
		patience -= delta
		patience_bar.value = patience
		if patience < 0:
			leave()
		elif patience < 2:
			infuriate()
	
	elif leaving:
		if position.y < get_viewport_rect().position.y:
			queue_free()

func infuriate() -> void:
	if angry: return
	
	angry = true

func leave() -> void:
	if leaving: return
	
	leaving = true
	table.customer = null
	table = null
	waiting_menu = false

func move_along_path(distance:float) -> void:
	var start_point:Vector2 = position
	
	for i in range(path.size()): # loop through all path points
		var distance_to_next:float = start_point.distance_to(path[0])
		if distance <= distance_to_next:
			position = start_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif path.size() == 1: # when reaches the target
			position = path[0]
			isMoving = false
			waiting_menu = true
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)

func set_path(value:PoolVector2Array) -> void:
	path = value
	
	# avoid setting process to true on initializing
	if value.size() == 0: return