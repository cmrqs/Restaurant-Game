# Pathfinding on a TileMap with Navigation2D (Godot 3.1 tutorial)
# GDquest <https://www.youtube.com/watch?v=0fPOt0Jw52s>

extends Node2D

export var speed:float = 250
var path := PoolVector2Array() setget set_path
var isMoving:bool = false

var interactions:Array

func _ready() -> void:
	set_process(false)

func _process(delta:float) -> void:
	var move_distance:float = speed * delta
	move_along_path(move_distance)

func move_along_path(distance:float) -> void:
	var start_point:Vector2 = position
	isMoving = true
	
	for i in range(path.size()): # loop through all path points
		var distance_to_next:float = start_point.distance_to(path[0])
		if distance <= distance_to_next:
			position = start_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif path.size() == 1: # when player reaches the target
			position = path[0]
			set_process(false)
			isMoving = false
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)

func set_path(value:PoolVector2Array) -> void:
	path = value
	
	# avoid setting process to true on initializing
	if value.size() == 0: return
	set_process(true)