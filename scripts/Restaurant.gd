# Pathfinding on a TileMap with Navigation2D (Godot 3.1 tutorial)
# GDquest <https://www.youtube.com/watch?v=0fPOt0Jw52s>

extends Node2D

onready var navigation:Navigation2D = $Navigation
onready var path_line:Line2D = $Path
onready var player = $Player
onready var customers = $Customers
onready var tables = $Tables

# _unhandled_input ignores user interface events
func _process(delta:float) -> void:
	player_movement()
	customer_movement()
	
func player_movement() -> void:
		# function pre-requisites
	if player.interactions.size() == 0:
		if not Input.is_action_just_pressed('click'):
			return
	
	var target:PoolVector2Array
	if player.interactions.size() > 0:
		target = navigation.get_simple_path(player.global_position, player.interactions[0].global_position, false)
	else:
		target = navigation.get_simple_path(player.global_position, get_global_mouse_position(), false)
	
	if player.isMoving: return
	
	path_line.points = target
	player.path = target

func customer_movement() -> void:
	for customer in customers.get_children():
		if customer.waiting_in_line == true:
			var table = tables.get_available_table()
			if table != null:
				customers.line = false
				customer.isMoving = true
				customer.waiting_in_line = false
				customer.table = table
				table.customer = customer
				customer.path = navigation.get_simple_path(customer.global_position, table.global_position, false)
				break
			
			elif customers.line:
				customer.isMoving = true
				customer.path = navigation.get_simple_path(customer.global_position, Vector2(210,600), false)
				break
		
		elif customer.leaving:
			customer.isMoving = true
			customer.path = navigation.get_simple_path(customer.global_position, Vector2(210,640), false)