## Represents a unit on the game board.
## The board manages its position inside the game grid.
## The unit itself holds stats and a visual representation that moves smoothly in the game world.
@tool
class_name Unit
extends Path2D

## Emitted when the unit reached the end of a path along which it was walking.
signal walk_finished
signal death

@onready var _sprite: Sprite2D = $PathFollow2D/Sprite
@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _path_follow: PathFollow2D = $PathFollow2D

#const VECTOR_DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
enum direction {UP, DOWN, LEFT, RIGHT}
#direction the unit is facing
var current_direction = direction.UP
@onready var old_pos = global_position

## Shared resource of type Grid, used to calculate map coordinates.
@export var grid: Resource
## Distance to which the unit can walk in cells.
@export var move_range := 6
## The unit's move speed when it's moving along a path.
@export var move_speed := 600.0
## Texture representing the unit.
@export var max_health := 1

@export var health: int:
	set(value):
		health = clamp(value, 0, max_health)

@export var damage := 1

var attacks = {
	"BASE": {
		"RANGE": 2,
		"DAMAGE": 2,
		"MOVE": Vector2(0,0),
		"EXORCISM": false,
		"BLAST_PATTERN": [],
		"ATTACK_PATTERN": [Vector2(0,0)]
	},
}

@export var skin: Texture:
	set(value):
		skin = value
		if not _sprite:
			# This will resume execution after this node's _ready()
			await ready
		_sprite.texture = value
## Offset to apply to the `skin` sprite in pixels.
@export var skin_offset := Vector2.ZERO:
	set(value):
		skin_offset = value
		if not _sprite:
			await ready
		_sprite.position = value
## Coordinates of the current cell the cursor moved to.
@export var cell := Vector2.ZERO:
	set(value):
		# When changing the cell's value, we don't want to allow coordinates outside
		#	the grid, so we clamp them
		cell = grid.grid_clamp(value)

var _is_walking := false:
	set(value):
		_is_walking = value
		set_process(_is_walking)



func _ready() -> void:
	set_process(false)
	_path_follow.rotates = false

	cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(cell)

	# We create the curve resource here because creating it in the editor prevents us from
	# moving the unit.
	if not Engine.is_editor_hint():
		curve = Curve2D.new()

func _init():
	pass

func walk(delta):
	_path_follow.progress += move_speed * delta
	if _path_follow.progress_ratio >= 1.0:
		_is_walking = false
		# Setting this value to 0.0 causes a Zero Length Interval error
		_path_follow.progress = 0.00001
		position = grid.calculate_map_position(cell)
		curve.clear_points()
		finish_walk()
	pass

func finish_walk():
	emit_signal("walk_finished")
	pass

func _process(delta: float) -> void:
	#prints(old_pos, _sprite.global_position)
	if old_pos != _sprite.global_position:
		var normal = ( _sprite.global_position - old_pos).normalized()
		if normal == Vector2.LEFT: 
			current_direction = direction.LEFT
		elif normal == Vector2.RIGHT:
			current_direction = direction.RIGHT
			pass
		elif normal == Vector2.UP:
			current_direction = direction.UP
			pass
		elif normal == Vector2.DOWN:
			current_direction = direction.DOWN
			pass
	old_pos = _sprite.global_position
	var new_anim = str("idle_" + direction.keys()[current_direction])
	#prints(direction.keys()[current_direction], new_anim)
	_anim_player.current_animation = new_anim
	walk(delta)

#
#func explode(pattern):
	#print("boom, explosion pattern:", pattern)

#All the shit for dying
func die():
	print("unit fucking died")
	death.emit(self)
	#free the tile
	#explode
	#remove from turn order
	#explode([])
	queue_free()
	pass

#All the stuff for taking damage
func take_damage(damage):
	health -= damage
	if (health == 0):
		die()
		pass

#All the stuff for attacking
func attack(cells, damage):
	#prints(cells, damage)
	pass

## Starts walking along`	 the `path`.
## `path` is an array of grid coordinates that the function converts to map coordinates.
func walk_along(path: PackedVector2Array) -> void:
	if path.is_empty():
		return
	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.calculate_map_position(point) - position)
	cell = path[-1]
	_is_walking = true
	#print(path)
