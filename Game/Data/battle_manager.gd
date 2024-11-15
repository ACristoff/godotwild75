class_name BattleManager
extends Node2D

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

@export var grid: Resource = preload("res://Game/Data/grid.tres")
@export var level_music: AudioStreamWAV

@onready var spirit_miko_scene:  = preload("res://Game/Characters/Friendlies/spirit_miko_unit.tscn") 
var miko: PlayerUnit
var spirit_miko: PlayerUnit

var units := {}
var enemies := {}
var friendlies := {}
var active_unit: Unit
var walkable_cells := []
var is_player_turn: bool = true
var is_enemy_turn: bool = false
var current_attack = null

@onready var attack_overlay = $AttackOverlay
@onready var hit_overlay = $HitOverlay
@onready var explosion_overlay = $ExplosionOverlay
@onready var unit_path: UnitPath = $UnitPath
@onready var turn_indicator = $TurnIndicator


##TODO organize functions

func _ready():
	reinitialize()
	pass

func _input(event):
	if active_unit:
		if event.is_action_pressed("rotate"):
			hit_overlay.rotate_all_squares()
			mutate_attack(current_attack.ATTACK_PATTERN)
			pass

#This rotates the attack pattern 90 degrees
func mutate_attack(attack_pattern):
	var rotated = []
	for vec in attack_pattern:
		var rotated_vector = Vector2(-vec.y, vec.x)
		rotated.append(rotated_vector)
	current_attack.ATTACK_PATTERN = rotated

##Finds the next unit in a given team that has moves available
func find_next_possible(team):
	for unit in team:
		var current = units[unit] as PlayerUnit
		if !current.has_moved:
			return current
	return null

func turn_manager():
	if is_player_turn:
		#Check if all units are exhausted
		var next_unit = find_next_possible(friendlies)
		if next_unit == null:
			is_player_turn = false
			is_enemy_turn = true
			turn_indicator._SwitchingTurn()
	else:
		##TODO Do enemy turns here
		var next_unit = find_next_possible(enemies)
		if next_unit == null:
			is_enemy_turn = false
			is_player_turn = true
			turn_indicator._SwitchingTurn()
		pass
	pass

## Clears, and refills the `_units` dictionary with game objects that are on the board.
## Fills the friendlies and enemies dictionaries with references for turn ordering
func reinitialize():
	units.clear()
	for child in get_children():
		var unit := child as Unit
		if not unit:
			continue
		units[unit.cell] = unit
		unit.connect("death", on_unit_death)
		if unit is PlayerUnit:
			friendlies[unit.cell] = unit
			unit.connect("unit_state_change", on_unit_state_change)
			##Code for spawning and setting the spirit miko
			##Spawning code will mirror a lot of the requirements here
			if unit.is_in_group("miko"):
				miko = unit
				var spirit_miko_spawned = spirit_miko_scene.instantiate()
				add_child(spirit_miko_spawned)
				var spirit_coord = grid.calculate_mirror_position(unit.cell)
				spirit_miko_spawned.position = grid.calculate_map_position(spirit_coord)
				spirit_miko_spawned.cell = spirit_coord
				units[spirit_miko_spawned.cell] = spirit_miko_spawned
				friendlies[spirit_miko_spawned.cell] = spirit_miko_spawned
				spirit_miko_spawned.connect("unit_state_change", on_unit_state_change)
				spirit_miko_spawned.connect("death", on_unit_death)
				spirit_miko_spawned.spawn_init("bluh")
				spirit_miko = spirit_miko_spawned
				spirit_miko.attacks = unit.attacks
				#Set references into each unit in case we need it
				#I'm still engineering it so it may not even be necessary
				spirit_miko.miko_ref = unit
				unit.spirit_miko_ref = spirit_miko
		if unit is EnemyUnit:
			enemies[unit.cell] = unit
	#print(enemies, friendlies, units)
	turn_manager()

func on_unit_state_change(state):
	if state == PlayerUnit.unit_states.MOVE_THINK:
		walkable_cells = get_walkable_cells(active_unit)
		unit_path.initialize(walkable_cells)
	if state == PlayerUnit.unit_states.ATTACK_THINK:
		#print("ATTACK THINK!")
		#var attack_cells = get_attack_cells()
		pass
	if state == PlayerUnit.unit_states.ATTACK_ACTION_THINK:
		#prints('current', active_unit.current_attack)
		current_attack = active_unit.current_attack
		var attack_cells = get_attack_cells(active_unit, active_unit.current_attack)
		attack_overlay.draw(attack_cells)
		hit_overlay.make_squares(active_unit.current_attack)
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

func deselect_unit():
	if active_unit:
		active_unit.is_selected = false
		if active_unit is PlayerUnit:
			active_unit.state_change(PlayerUnit.unit_states.IDLE)
	attack_overlay.clear()
	hit_overlay.kill_kids()
	unit_path.stop()

func move_current_unit(new_cell: Vector2):
	if is_occupied(new_cell) or not new_cell in walkable_cells:
		return
	var origin = active_unit.cell
	units.erase(active_unit.cell)
	units[new_cell] = active_unit
	#TODO repeated code, refactor later
	friendlies.erase(active_unit.cell)
	friendlies[new_cell] = active_unit
	deselect_unit()
	active_unit.walk_along(unit_path.current_path)
	if active_unit == miko || active_unit == spirit_miko:
		if active_unit == miko:
			miko_walk(spirit_miko, unit_path.current_path, origin)
		else:
			miko_walk(miko, unit_path.current_path, origin)
	await active_unit.walk_finished
	active_unit.has_moved = true
	clear_active_unit()
	turn_manager()

func miko_walk(miko_to_move, walk_vectors, origin):
	var new_path: PackedVector2Array
	units.erase(miko_to_move.cell)
	friendlies.erase(miko_to_move.cell)
	var offset := Vector2(0,0)
	var last_acceptable_vec = miko_to_move.cell
	var last_vec = origin
	for vec in walk_vectors:
		var direction = vec - last_vec
		var new_vec2 = last_acceptable_vec + direction
		last_vec = vec
		if units.has(new_vec2):
			continue
		last_acceptable_vec = new_vec2
		new_path.append(new_vec2)
	units[new_path[-1]] = miko_to_move
	friendlies[new_path[-1]] = active_unit
	miko_to_move.walk_along(new_path)
	#print(new_path)
	pass

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
			##There is a weird edge case I'm trying to take care of
			##When clicking on a friendly unit
			##I could engineer this better but we're halfway through the jam
			if units.has(cell):
				if units[cell] != active_unit:
					deselect_unit()
					clear_active_unit()
			return
		if active_unit.unit_state == PlayerUnit.unit_states.ATTACK_ACTION_THINK:
			#TODO range check
			var cells_in_range = get_attack_cells(active_unit, active_unit.current_attack)
			# if range bad then deselect
			var attack_origin = cell
			if (!cells_in_range.has(attack_origin)):
				deselect_unit()
				clear_active_unit()
				return
			var attack_cells = []
			for to_hit_cell in current_attack.ATTACK_PATTERN:
				var hit_cell = attack_origin + to_hit_cell
				attack_cells.append(hit_cell)
			if active_unit == miko || active_unit == spirit_miko:
				var mirrored_unit_cell = null
				if active_unit == miko:
					mirrored_unit_cell = spirit_miko.cell
				else:
					mirrored_unit_cell = miko.cell
				var mirror_origin = attack_origin - active_unit.cell
				#prints("relative is", mirror_origin, mirrored_unit_cell)
				for to_hit_cell in current_attack.ATTACK_PATTERN:
					##Refactor this to work from alternate miko origin, then do an operation
					var hit_cell = mirror_origin + to_hit_cell
					hit_cell = hit_cell + mirrored_unit_cell
					attack_cells.append(hit_cell)
					pass
				#print("miko or spirit miko attacked!")
				pass
			##DO ATTACK
			manage_attack(attack_cells, "ENEMY")
		move_current_unit(cell)

func manage_attack(attack_cells, team_to_hit):
	attack_overlay.clear()
	var ghost_accumulator = []
	for cell in attack_cells:
		if units.has(cell):
			#print('HIT', units[cell])
			var unit = units[cell] as Unit
			handle_exorcism(unit, current_attack)
			if grid.is_in_real_world(cell):
				if !unit.is_in_group("mikos"):
					ghost_accumulator.append([
						unit.self_scene_path, 
						grid.calculate_mirror_position(cell)
					])
					pass
			units[cell].take_damage(current_attack.DAMAGE)
		else:
			#print("MISS", cell)
			pass
	active_unit.has_attacked = true
	active_unit.state_change(PlayerUnit.unit_states.IDLE)
	active_unit.finish_attack()
	if ghost_accumulator.size() > 0:
		##iterate and add ghosts here
		for ghost in ghost_accumulator:
			spawn_ghost(ghost[0], ghost[1])
			pass
		#print(ghost_accumulator)
		pass
	deselect_unit()
	clear_active_unit()



				#miko = unit
				#var spirit_miko_spawned = spirit_miko_scene.instantiate()
				#add_child(spirit_miko_spawned)
				#var spirit_coord = grid.calculate_mirror_position(unit.cell)
				#spirit_miko_spawned.position = grid.calculate_map_position(spirit_coord)
				#spirit_miko_spawned.cell = spirit_coord
				#units[spirit_miko_spawned.cell] = spirit_miko_spawned
				#friendlies[spirit_miko_spawned.cell] = spirit_miko_spawned
				#spirit_miko_spawned.connect("unit_state_change", on_unit_state_change)
				#spirit_miko_spawned.connect("death", on_unit_death)
				#spirit_miko_spawned.spawn_init("bluh")
				#spirit_miko = spirit_miko_spawned
				#spirit_miko.attacks = unit.attacks

func spawn_ghost(unit, mirrored_origin):
	print("SPAWN HERE", unit, mirrored_origin)
	var ghost_scene = load(unit)
	var ghost = ghost_scene.instantiate()
	add_child(ghost)
	ghost.position = grid.calculate_map_position(mirrored_origin)
	units[mirrored_origin] = ghost
	if ghost.is_in_group("enemies"):
		enemies[mirrored_origin] = ghost
	elif ghost.is_in_group("player"):
		friendlies[mirrored_origin] = ghost
		ghost.connect("unit_state_change", on_unit_state_change)
	ghost.connect("death", on_unit_death)
	ghost.cell = mirrored_origin
	##Initialization here maybe?
	#print(ghost)
	pass

func handle_exorcism(unit, attack):
	#print(unit, attack)
	var cells_to_blow = []
	var mirrored_origin: Vector2 = grid.calculate_mirror_position(unit.cell)
	#hit_overlay.position = Vector2(0,0)
	explosion_overlay.position = grid.calculate_map_position(mirrored_origin)
	#hit_overlay.blow_up_squares()
	for vec in attack.BLAST_PATTERN:
		#print(vec)
		var mirrored_vec = grid.calculate_mirror_position(vec + unit.cell)
		cells_to_blow.append(mirrored_vec)
		if units.has(mirrored_vec):
			#print('mirrored hit!', mirrored_vec)
			units[mirrored_vec].take_damage(1)
			pass
		#print(mirrored_vec)
	explosion_overlay.blow_up_squares(attack.BLAST_PATTERN)
	pass

func _on_cursor_moved(new_cell):
	if active_unit and active_unit.is_selected and active_unit.unit_state == PlayerUnit.unit_states.MOVE_THINK:
		unit_path.draw(active_unit.cell, new_cell)
	if active_unit and active_unit.is_selected and active_unit.unit_state == PlayerUnit.unit_states.ATTACK_ACTION_THINK:
		var move_to_pos = grid.calculate_map_position(new_cell)
		#print(new_cell, move_to_pos)
		hit_overlay.position = move_to_pos

func on_unit_death(unit):
	##TODO MOVE EXORCISM HERE
	units.erase(unit.cell)
	if unit is PlayerUnit:
		friendlies.erase(unit.cell)
	elif unit is EnemyUnit:
		enemies.erase(unit.cell)

func _on_cursor_deselect_pressed():
	if active_unit:
		deselect_unit()
		clear_active_unit()
