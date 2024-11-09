extends Node2D

var units := {}
var active_unit: Unit
var _walkable_cells := []
var is_player_turn: bool = true

@export var grid: Resource = preload("res://Game/Data/grid.tres")

#wait till pathing is solved
@onready var _unit_path = null

func _ready():
	reinitialize()
	pass


## Clears, and refills the `_units` dictionary with game objects that are on the board.
func reinitialize():
	units.clear()
	
	for child in get_children():
		var unit := child as Unit
		if not unit:
			continue
		units[unit.cell] = unit
	#print(units)

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

func clear_active_unit() -> void:
	active_unit = null
	_walkable_cells.clear()

func _on_cursor_accept_pressed(cell):
	print(cell)
	pass # Replace with function body.


func _on_cursor_moved(new_cell):
	#print(new_cell)
	pass # Replace with function body.
