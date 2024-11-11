extends Node2D

@onready var fire =  preload("res://Assets/Shaders/Onibi.tscn")
#signal die
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func spawn():
	var rand_x = randi_range(0, 301)
	var rand_y = randi_range(0, 318)
	var ONIBI = fire.instantiate()
	self.add_child(ONIBI)
	ONIBI.position = Vector2(rand_x, rand_y)
	prints(rand_x, rand_y, ONIBI.position)

func _on_spawner_timeout() -> void:
	spawn()
	$Spawner.start()
	$Spawner.wait_time = randi_range(2, 4)
