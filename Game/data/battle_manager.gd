extends Node2D


var active_unit: Unit
var is_player_turn: bool = true

var _walkable_cells := []

#wait till pathing is solved
@onready var _unit_path = null

func select_unit(cell: Vector2):
	print(cell)
	#grab the unit from the cell
	#active_unit = 
	pass

func deselect_unit():
	active_unit.is_selected = false
	pass

func move_current_unit(new_cell: Vector2):
	pass
