extends PlayerUnit

var miko_ref: PlayerUnit

func spawn_init(miko_data):
	##Mirror miko's data here
	cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(cell)
	pass

#func _ready():
	##"hello spirit world :)"
	#
	#pass
	#
