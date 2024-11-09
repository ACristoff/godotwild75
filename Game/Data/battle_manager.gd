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

## Returns `true` if the cell is occupied by a unit.
func is_occupied(cell: Vector2) -> bool:
	return units.has(cell)

func select_unit(cell: Vector2):
	prints("selecting: ", cell)
	
	#checks if the cell has a unit entry
	if not units.has(cell):
		return
	
	active_unit = units[cell]
	print(active_unit)
	pass

func deselect_unit():
	active_unit.is_selected = false
	pass

func move_current_unit(new_cell: Vector2):
	if is_occupied(new_cell) or not new_cell in _walkable_cells:
		print('blocked')
		return
	
	units.erase(active_unit.cell)
	units[new_cell] = active_unit
	deselect_unit()
	#active_unit.walk_along()
	pass

func clear_active_unit() -> void:
	active_unit = null
	_walkable_cells.clear()

func _on_cursor_accept_pressed(cell):
	if active_unit == null:
		select_unit(cell)
		#pass
	elif active_unit.is_selected:
		move_current_unit(cell)
	#print(cell)
	pass # Replace with function body.


func _on_cursor_moved(new_cell):
	#print(new_cell)
	pass # Replace with function body.
