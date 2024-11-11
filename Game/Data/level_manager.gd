extends Node2D

@export var level_list : Array[PackedScene]

var curr_level_index = 0
var curr_level

var current_scene = null

func _ready():
	#changeLevel(curr_level)
	#print(level_list[0])
	#curr_level = level_list[0]
	current_scene = get_child(get_child_count() - 2)
	pass

func _input(event):
	if event.is_action_pressed("debug_next_level"):
		nextLevel()
	if event.is_action_pressed("debug_prev_level"):
		prevLevel()
	if event.is_action_pressed("click"):
		print("click")
	pass

func switchScene(level):
	call_deferred("changeLevel", level)

func changeLevel(level):
	current_scene.free()
	var s = load(level_list[level].resource_path)
	current_scene = s.instantiate()
	add_child(current_scene)
	get_tree().current_scene = current_scene
	#get_tree().current_scene = current_scene

func nextLevel():
	if curr_level_index < level_list.size() - 1:
		curr_level_index += 1
		switchScene(curr_level_index)
	pass
	
func prevLevel():
	if curr_level_index > 0:
		curr_level_index -= 1
		switchScene(curr_level_index)
	pass
