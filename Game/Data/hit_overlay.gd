extends Node2D

@onready var square_sprite = preload("res://Game/UI/hit_overlay_tile.tscn")

func make_squares(attack):
	#print(cells)
	var pattern = attack.ATTACK_PATTERN
	
	for vec in pattern:
		print(vec)
		var new_square = square_sprite.instantiate()
		add_child(new_square)
	pass

func kill_kids():
	var all_squares = get_children()
	for square in all_squares:
		square.queue_free()
