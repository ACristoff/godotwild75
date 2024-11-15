extends Node2D

@onready var square_sprite = preload("res://Game/UI/hit_overlay_tile.tscn")

#I'm being lazy by doing this
var grid_size = 64

func make_squares(attack):
	#print(attack)
	var pattern = attack.ATTACK_PATTERN
	
	for vec in pattern:
		#print(vec)
		var new_square = square_sprite.instantiate()
		add_child(new_square)
		new_square.position = vec * Vector2(grid_size, grid_size)
	pass

func rotate_all_squares():
	self.rotate(PI/2)
	pass

func kill_kids():
	var all_squares = get_children()
	
	for square in all_squares:
		square.queue_free()
