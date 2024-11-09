extends Node2D

var units := {}
var active_unit: Unit
var _walkable_cells := []
var is_player_turn: bool = true

@export var grid: Resource = preload("res://Game/Data/grid.tres")

#wait till pathing is solved
@onready var _unit_path = null

func select_unit(cell: Vector2):
	prints("selecting: ", cell)
	
	#checks if the cell has a unit entry
	if not units.has(cell):
		return
	
	active_unit = units[cell]
	#grab the unit from the cell
	#active_unit = 
	pass

func deselect_unit():
	active_unit.is_selected = false
	pass

func move_current_unit(new_cell: Vector2):
	pass
