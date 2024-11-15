extends Node2D

@onready var exorcism_sprite = preload("res://Assets/Effects/deathblast.tscn")
@onready var kill_timer = $KillKidsTimer

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
	kill_timer.start()
	pass


func _on_kill_kids_timer_timeout():
	kill_kids()
	pass # Replace with function body.
