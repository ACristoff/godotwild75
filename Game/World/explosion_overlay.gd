extends Node2D

@onready var exorcism_sprite = preload("res://Assets/Effects/deathblast.tscn")

#I'm being lazy by doing this
var grid_size = 64

func kill_kids():
	var all_squares = get_children()
	
	for square in all_squares:
		square.queue_free()

func blow_up_squares(vec_arr):
	print(vec_arr)
	for vec in vec_arr:
		var new_explosion = exorcism_sprite.instantiate()
		add_child(new_explosion)
		new_explosion.position = vec * Vector2(grid_size, grid_size)
	await get_tree().create_timer(1.0).timeout
	kill_kids()
	pass
