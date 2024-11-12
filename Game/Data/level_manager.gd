extends Node2D

@export var level_list : Array[PackedScene] = [null]

var curr_level_index = 0
var curr_level

var current_scene : Node2D = null

func _ready():	
	var aux = get_child(get_child_count() - 2)
	#Check if I'm not grabbing WorldEnvironment
	if aux is Node2D:
		current_scene = aux
	#If there's no child Node2D (no level under LevelManager)
	if current_scene == null and level_list[0] != null:
		var s = load(level_list[0].resource_path)
		current_scene = s.instantiate()
		add_child(current_scene)
	#If there's no level in the level_list (not set in the editor)
	if level_list[0] == null and current_scene != null:
		level_list[0] = load(current_scene.scene_file_path)
	#If there's neither a level in the list nor a child in LevelManager we basically have no levels so
	#we need to set either one manually in the editor.
	get_tree().current_scene = current_scene

func _input(event):
	if event.is_action_pressed("debug_next_level"):
		nextLevel()
	if event.is_action_pressed("debug_prev_level"):
		prevLevel()

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
