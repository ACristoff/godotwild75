class_name BattleManager
extends Node2D

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

@export var grid: Resource = preload("res://Game/Data/grid.tres")

@export var level_music: AudioStreamWAV

var units := {}
var enemies := {}
var friendlies := {}
var active_unit: Unit
var walkable_cells := []
var is_player_turn: bool = true

@onready var attack_overlay = $AttackOverlay
@onready var unit_path: UnitPath = $UnitPath

func _ready():
	reinitialize()
	#attack_overlay.draw(get_walkable_cells($MikoUnit))
	pass

##Finds the next unit in a given team that has moves available
func find_next_possible(team):
	#var candidate = null
	for unit in team:
		var current = units[unit] as PlayerUnit
		if !current.has_moved:
			return current
	return null

func turn_manager():
	#print(units)
	if is_player_turn:
		#Check if all units are exhausted
		var next_unit = find_next_possible(friendlies)
		if next_unit == null:
			is_player_turn = false
			#prints('player turn:', is_player_turn)
	else:
		print("Enemy turn start")
		print(enemies)
		pass
	pass

## Clears, and refills the `_units` dictionary with game objects that are on the board.
##Fills the friendlies and enemies dictionaries with references for turn ordering
func reinitialize():
	units.clear()
	for child in get_children():
		var unit := child as Unit
		if not unit:
			continue
		units[unit.cell] = unit
		if unit is PlayerUnit:
			friendlies[unit.cell] = unit
			unit.connect("unit_state_change", on_unit_state_change)
		if unit is EnemyUnit:
			enemies[unit.cell] = unit
	turn_manager()

func on_unit_state_change(state):
	if state == PlayerUnit.unit_states.MOVE_THINK:
		walkable_cells = get_walkable_cells(active_unit)
		unit_path.initialize(walkable_cells)
	if state == PlayerUnit.unit_states.ATTACK_THINK:
		print("ATTACK THINK!")
		#var attack_cells = get_attack_cells()
		pass
	if state == PlayerUnit.unit_states.ATTACK_ACTION_THINK:
		print("ATTACK PICKED, NOW CHOOSING")
		print(active_unit.current_attack)
		var attack_cells = get_attack_cells(active_unit, active_unit.current_attack)
		attack_overlay.draw(attack_cells)
	pass

## Returns `true` if the cell is occupied by a unit.
func is_occupied(cell: Vector2) -> bool:
	return units.has(cell)

## Returns an array of cells a given unit can walk using the flood fill algorithm.
func get_walkable_cells(unit: Unit) -> Array:
	return flood_fill(unit.cell, unit.move_range, false)

func get_attack_cells(unit: PlayerUnit, attack):
	##TODO Give flood fill the ability to use every tile in range
	return flood_fill(unit.cell, attack.RANGE, true)

func flood_fill(origin: Vector2, max_distance: int, ignore_dudes: bool):
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
			if is_occupied(coordinates) && ignore_dudes == false:
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
	attack_overlay.clear()
	unit_path.stop()
	pass

func move_current_unit(new_cell: Vector2):
	if is_occupied(new_cell) or not new_cell in walkable_cells:
		return
	units.erase(active_unit.cell)
	units[new_cell] = active_unit
	#TODO repeated code, refactor later
	friendlies.erase(active_unit.cell)
	friendlies[new_cell] = active_unit
	deselect_unit()
	active_unit.walk_along(unit_path.current_path)
	await active_unit.walk_finished
	active_unit.has_moved = true
	clear_active_unit()
	turn_manager()

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
		if active_unit.unit_state == PlayerUnit.unit_states.ATTACK_ACTION_THINK:
			#TODO range check
			# if range bad then deselect
			var attack_origin = cell
			var attack_cells = []
			for to_hit_cell in active_unit.current_attack.ATTACK_PATTERN:
				var hit_cell = attack_origin + to_hit_cell
				attack_cells.append(hit_cell)
			##DO ATTACK
			manage_attack(attack_cells, "ENEMY")
		move_current_unit(cell)

func manage_attack(attack_cells, team_to_hit):
	for cell in attack_cells:
		if units.has(cell):
			print('HIT', units[cell])
			var unit = units[cell] as Unit
			units[cell].take_damage(1)
			##TODO HIT THIS SHIT
		else:
			print("MISS", cell)
	#print(attack_cells)
	pass

func _on_cursor_moved(new_cell):
	if active_unit and active_unit.is_selected and active_unit.unit_state == PlayerUnit.unit_states.MOVE_THINK:
		unit_path.draw(active_unit.cell, new_cell)
	pass # Replace with function body.

func _on_cursor_deselect_pressed():
	if active_unit:
		deselect_unit()
		clear_active_unit()
	pass # Replace with function body.
