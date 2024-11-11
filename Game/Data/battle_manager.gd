class_name BattleManager
extends Node2D

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

@export var grid: Resource = preload("res://Game/Data/grid.tres")

var units := {}
var enemies := {}
var friendlies := {}
var active_unit: Unit
var walkable_cells := []
var is_player_turn: bool = true

@onready var unit_overlay = null
@onready var unit_path: UnitPath = $UnitPath

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
		unit.connect("unit_state_change", on_unit_state_change)
		if unit is PlayerUnit:
			print(unit)
			friendlies[unit.cell] = unit
		if unit is EnemyUnit:
			print(unit)
			enemies[unit.cell] = unit
	prints(friendlies, enemies, units)

func on_unit_state_change(state):
	if state == PlayerUnit.unit_states.MOVE_THINK:
		walkable_cells = get_walkable_cells(active_unit)
		unit_path.initialize(walkable_cells)
	if state == PlayerUnit.unit_states.ATTACK_THINK:
		print("ATTACK THINK!")
		pass
	pass

## Returns `true` if the cell is occupied by a unit.
func is_occupied(cell: Vector2) -> bool:
	return units.has(cell)

## Returns an array of cells a given unit can walk using the flood fill algorithm.
func get_walkable_cells(unit: Unit) -> Array:
	return flood_fill(unit.cell, unit.move_range)

func flood_fill(origin: Vector2, max_distance: int):
	var array = []
	var stack = [origin]
	
	while not stack.size() == 0:
		var current = stack.pop_back()
		if not grid.is_within_bounds(current):
			continue
		if current in array:
			continue
		
		var difference: Vector2 = (current - origin).abs()
		var distance = int(difference.x + difference.y)
		if distance > max_distance:
			continue
		
		array.append(current)
		for direction in DIRECTIONS:
			var coordinates: Vector2 = current + direction
			if is_occupied(coordinates):
				continue
			if coordinates in array:
				continue
			if coordinates in stack:
				continue
			stack.append(coordinates)
	return array

func select_unit(cell: Vector2):	
	#checks if the cell has a unit entry
	if not units.has(cell):
		return
	if units[cell] is not PlayerUnit:
		return
	active_unit = units[cell]
	active_unit.is_selected = true
	pass

func deselect_unit():
	if active_unit:
		active_unit.is_selected = false
#	unit_overlay.clear()
	unit_path.stop()
	pass

func move_current_unit(new_cell: Vector2):
	if is_occupied(new_cell) or not new_cell in walkable_cells:
		return
	units.erase(active_unit.cell)
	units[new_cell] = active_unit
	deselect_unit()
	active_unit.walk_along(unit_path.current_path)
	await active_unit.walk_finished
	active_unit.has_moved = true
	clear_active_unit()

func clear_active_unit() -> void:
	active_unit = null
	walkable_cells.clear()

func _on_cursor_accept_pressed(cell):
	if active_unit == null:
		select_unit(cell)
	elif active_unit.is_selected:
		if active_unit.unit_state == PlayerUnit.unit_states.SELECTED && cell != active_unit.cell:
			deselect_unit()
			clear_active_unit()
			
			pass
		move_current_unit(cell)

func _on_cursor_moved(new_cell):
	if active_unit and active_unit.is_selected and active_unit.unit_state == PlayerUnit.unit_states.MOVE_THINK:
		unit_path.draw(active_unit.cell, new_cell)
	pass # Replace with function body.

func _on_cursor_deselect_pressed():
	if active_unit:
		deselect_unit()
		clear_active_unit()
	pass # Replace with function body.
