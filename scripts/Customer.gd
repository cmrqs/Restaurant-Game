# Pathfinding on a TileMap with Navigation2D (Godot 3.1 tutorial)
# GDquest <https://www.youtube.com/watch?v=0fPOt0Jw52s>

extends Node2D

export var speed:float = 150
var path := PoolVector2Array() setget set_path
var isMoving:bool = false

var angry = false

var table:Area2D

var waiting_in_line:bool = true
var waiting_menu:bool = false
var waiting_time_menu = 0
var waiting_food:bool = false
var waiting_time_food = 0
var leaving = false

func _ready() -> void:
	pass

func _process(delta:float) -> void:
	if isMoving:
		var move_distance:float = speed * delta
		move_along_path(move_distance)
	
	elif waiting_menu:
		waiting_time_menu += delta
		if waiting_time_menu > 5:
			leaving = true
			table.free = true
			waiting_menu = false
		elif waiting_time_menu > 2:
			angry = true

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