## Represents a grid with its size, the size of each cell in pixels, and some helper functions to
## calculate and convert coordinates.
## It's meant to be shared between game objects that need access to those values.
@tool
class_name Grid
extends Resource

## The grid's rows and columns.
@export var size := Vector2(20, 20)
## The size of a cell in pixels.
@export var cell_size := Vector2(64, 64)

## Half of ``cell_size``
var _half_cell_size = cell_size / 2


func calculate_mirror_position(cell):
	var mirrored_cell = Vector2(cell.x - 7, cell.y)
	if mirrored_cell.x < 0:
		mirrored_cell.x = 17 + mirrored_cell.x  
		pass
	#print(cell)
	return mirrored_cell

## Returns the position of a cell's center in pixels.
func calculate_map_position(grid_position: Vector2) -> Vector2:
	#prints((grid_position * cell_size + _half_cell_size) + Vector2(128, 64))
	#return grid_position * cell_size + _half_cell_size
	return (grid_position * cell_size + _half_cell_size) + Vector2(64, 128)


## Returns the coordinates of the cell on the grid given a position on the map.
func calculate_grid_coordinates(map_position: Vector2) -> Vector2:
	#prints(map_position, (map_position / cell_size).floor() + Vector2(-1, -2))
	return (map_position / cell_size).floor() + Vector2(-1,-2)


## Returns true if the `cell_coordinates` are within the grid.
func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var out := cell_coordinates.x >= 0 and cell_coordinates.x < size.x
	#print(out and cell_coordinates.y >= 0 and cell_coordinates.y < size.y)
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < size.y


## Makes the `grid_position` fit within the grid's bounds.
func grid_clamp(grid_position: Vector2) -> Vector2:
	var out := grid_position
	out.x = clamp(out.x, 0, size.x - 1.0)
	out.y = clamp(out.y, 0, size.y - 1.0)
	return out
