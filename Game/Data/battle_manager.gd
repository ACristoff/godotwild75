class_name BattleManager
extends Node2D

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

@export var grid: Resource = preload("res://Game/Data/grid.tres")
@export var level_music: AudioStreamWAV

@onready var win_screen = preload("res://Game/UI/win_screen.tscn")
@onready var fail_screen = preload("res://Game/UI/lose_screen.tscn")
@onready var deselect_sound = preload("res://Assets/Audio/UI/Menu_Back.mp3")

@onready var spirit_miko_scene:  = preload("res://Game/Characters/Friendlies/spirit_miko_unit.tscn") 
var miko: PlayerUnit
var spirit_miko: PlayerUnit

var ghost_accumulator = []
var units := {}
var enemies := {}
var friendlies := {}
var active_unit: Unit
var walkable_cells := []
var is_player_turn: bool = true
var is_enemy_turn: bool = false
var current_attack = null
var rotations = ["up", "right", "down", "left"]
var current_rotation = "up"

@onready var attack_overlay = $AttackOverlay
@onready var hit_overlay = $HitOverlay
@onready var explosion_overlay = $ExplosionOverlay
@onready var unit_path: UnitPath = $UnitPath
@onready var turn_indicator = $TurnIndicator


##TODO organize functions

func _ready():
	reinitialize()
	pass

##could be fixed but fuck man
func _input(event):
	if active_unit:
		if active_unit.unit_state == PlayerUnit.unit_states.ATTACK_ACTION_THINK:
			if event.is_action_pressed("rotate"):
				if rotations.find(current_rotation) + 1 == 4:
					current_rotation = rotations[0]
				else:
					current_rotation = rotations[rotations.find(current_rotation) + 1]
				#print(current_rotation, "THE CURRENT ATTACK",  current_attack)
				
				hit_overlay.make_squares(current_attack.ATTACK_VECS[current_rotation])
				#current_attack = "FUCK DUMB SHIT"
				#prints(current_attack, active_unit.current_attack, "BLKU")

#This rotates the attack pattern 90 degrees
func mutate_attack(attack_pattern):
	var rotated = []
	for vec in attack_pattern:
		var rotated_vector = Vector2(-vec.y, vec.x)
		rotated.append(rotated_vector)
	return rotated


##Finds the next unit in a given team that has moves available
func find_next_possible(team):
	for unit in team:
		var current = units[unit] as Unit
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
		if next_unit != null:
			next_unit.enemyBrain(units)
			next_unit.has_moved = true
			next_unit = find_next_possible(enemies)
		else:
			is_enemy_turn = false
			is_player_turn = true
			turn_indicator._SwitchingTurn()
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
		#var attack_cells = get_attack_cells()
		pass
	if state == PlayerUnit.unit_states.ATTACK_ACTION_THINK:
		prints('current', active_unit.current_attack, current_attack, active_unit)
		current_attack = active_unit.current_attack.duplicate()
		var attack_cells = get_attack_cells(active_unit, active_unit.current_attack)
		var all_cells = []
		for arr in attack_cells:
			for vec in attack_cells[arr]:
				all_cells.append(vec)
				pass
		attack_overlay.draw(all_cells)
		hit_overlay.make_squares(attack_cells["up"])
		current_attack.ATTACK_VECS = attack_cells
	pass

## Returns `true` if the cell is occupied by a unit.
func is_occupied(cell: Vector2) -> bool:
	return units.has(cell)

## Returns an array of cells a given unit can walk using the flood fill algorithm.
func get_walkable_cells(unit: Unit) -> Array:
	return flood_fill(unit.cell, unit.move_range, false)

func get_attack_cells(unit: Unit, attack):
	##REFACTOR THIS
	#print(attack.ATTACK_VECS)
	var new_vectors = {
		"up": [],
		"right": [],
		"down": [],
		"left": [],
	}
	var direcs = 3
	
	for vec in attack.ATTACK_VECS:
		var adjusted_vec = vec + unit.cell
		if grid.is_in_border(adjusted_vec) || !grid.is_within_bounds(adjusted_vec):
			continue
		new_vectors.up.append(adjusted_vec)

	##This is going to be super fucking jank but we're on the final night
	for i in direcs:
		if i == 0:
			var rotated = mutate_attack(attack.ATTACK_VECS)
			var right = []
			for vec in rotated:
				var adjusted_vec = vec + unit.cell
				if grid.is_in_border(adjusted_vec) || !grid.is_within_bounds(adjusted_vec):
					continue
				right.append(adjusted_vec)
			new_vectors.right = right
		if i == 1:
			var rotated = mutate_attack(mutate_attack(attack.ATTACK_VECS))
			var down = []
			for vec in rotated:
				var adjusted_vec = vec + unit.cell
				if grid.is_in_border(adjusted_vec) || !grid.is_within_bounds(adjusted_vec):
					continue
				down.append(adjusted_vec)
			new_vectors.down = down
		if i == 2:
			var rotated = mutate_attack(mutate_attack(mutate_attack(attack.ATTACK_VECS)))
			var left = []
			for vec in rotated:
				var adjusted_vec = vec + unit.cell
				if grid.is_in_border(adjusted_vec) || !grid.is_within_bounds(adjusted_vec):
					continue
				left.append(adjusted_vec)
			new_vectors.left = left
		#prints(right, down , left)
	#print(new_vectors)
	return new_vectors



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
			if grid.is_in_border(coordinates):
				continue
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
	current_rotation = "up"

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
			var cells_in_range = current_attack.ATTACK_VECS[current_rotation]
			## if range bad then deselect
			
			if (!cells_in_range.has(cell)):
				deselect_unit()
				clear_active_unit()
				
				return
			var attack_cells = cells_in_range
			if active_unit == miko || active_unit == spirit_miko:
				var mirrored_unit_cell = null
				if active_unit == miko:
					mirrored_unit_cell = spirit_miko.cell
				else:
					mirrored_unit_cell = miko.cell
				#var mirror_origin = attack_origin - active_unit.cell
				##prints("relative is", mirror_origin, mirrored_unit_cell)
				#for to_hit_cell in current_attack.ATTACK_VECS:
					###Refactor this to work from alternate miko origin, then do an operation
					#var hit_cell = mirror_origin + to_hit_cell
					#hit_cell = hit_cell + mirrored_unit_cell
					#attack_cells.append(hit_cell)
					#pass
				##print("miko or spirit miko attacked!")
			##DO ATTACK
			manage_attack(attack_cells, "ENEMY")
			await get_tree().create_timer(0.4).timeout
			if ghost_accumulator.size() > 0:
				#print("current ghosts", ghost_accumulator)
				##iterate and add ghosts here
				for ghost in ghost_accumulator:
					spawn_ghost(ghost[0], ghost[1])
					#ghost_accumulator.erase(ghost)
				ghost_accumulator.clear()
		move_current_unit(cell)

func manage_attack(attack_cells, team_to_hit):
	attack_overlay.clear()
	for cell in attack_cells:
		if units.has(cell):
			#print('HIT', units[cell])
			var unit = units[cell] as Unit
			#handle_exorcism(unit, current_attack)
			if grid.is_in_real_world(cell) && units[cell].health <= current_attack.DAMAGE:
				if !unit.is_in_group("mikos"):
					ghost_accumulator.append([
						unit.self_scene_path,
						grid.calculate_mirror_position(cell)
					])
			units[cell].take_damage(current_attack.DAMAGE)
		else:
			#print("MISS", cell)
			pass
	active_unit.has_attacked = true
	active_unit.state_change(PlayerUnit.unit_states.IDLE)
	active_unit.finish_attack()
	deselect_unit()
	clear_active_unit()


func spawn_ghost(unit, mirrored_origin):
	#print("SPAWN HERE", unit, mirrored_origin)
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
	pass

func handle_exorcism(unit, attack):
	#print(unit, attack)
	var cells_to_blow = []
	var positions_to_blow = []
	var mirrored_origin: Vector2 = grid.calculate_mirror_position(unit.cell)
	#hit_overlay.position = Vector2(0,0)
	#explosion_overlay.position = grid.calculate_map_position(mirrored_origin)
	for vec in attack.BLAST_PATTERN:
		#print(vec)
		var mirrored_vec = grid.calculate_mirror_position(vec + unit.cell)
		cells_to_blow.append(mirrored_vec)
		positions_to_blow.append(grid.calculate_map_position(mirrored_vec))
		if units.has(mirrored_vec):
			if grid.is_in_real_world(units[mirrored_vec].cell) && !units[mirrored_vec].is_in_group("mikos"):
				#print("THIS BITCH", units[mirrored_vec], vec + unit.cell)
				if !ghost_accumulator.has([units[mirrored_vec].self_scene_path, vec + unit.cell]):
					ghost_accumulator.append([units[mirrored_vec].self_scene_path, vec + unit.cell])
				units[mirrored_vec].take_damage(1)
				#print(ghost_accumulator)
			else:
				units[mirrored_vec].take_damage(1)
	explosion_overlay.blow_up_squares(positions_to_blow)
	pass

func _on_cursor_moved(new_cell):
	if active_unit and active_unit.is_selected and active_unit.unit_state == PlayerUnit.unit_states.MOVE_THINK:
		unit_path.draw(active_unit.cell, new_cell)
	#if active_unit and active_unit.is_selected and active_unit.unit_state == PlayerUnit.unit_states.ATTACK_ACTION_THINK:
		#var move_to_pos = grid.calculate_map_position(Vector2(0,0))
		#hit_overlay.position = move_to_pos

func on_unit_death(unit):
	if !unit.is_in_group("mikos"):
		#print(unit)
		handle_exorcism(unit, current_attack)
		#if grid.is_in_real_world(unit.cell):
			#handle_exorcism(unit, current_attack)
	else: 
		trigger_fail_con(unit)
	units.erase(unit.cell)
	if unit is PlayerUnit:
		friendlies.erase(unit.cell)
	elif unit is EnemyUnit:
		enemies.erase(unit.cell)
		check_for_win_con()

func trigger_fail_con(miko):
	print("FISSION MAILED", miko, "HAS DIED")
	var manager: GameManager = get_node("/root/GameManager")
	manager.show_screen(fail_screen)
	pass

func check_for_win_con():
	if enemies.size() == 0 && ghost_accumulator.size() == 0:
		var manager: GameManager = get_node("/root/GameManager")
		print("A WINRAR IS YOU CON")
		manager.show_screen(win_screen)
		#print()

func _on_cursor_deselect_pressed():
	if active_unit:
		AudioManager.play_sfx(deselect_sound, 1)
		deselect_unit()
		clear_active_unit()
