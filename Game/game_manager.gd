extends Node2D

class_name GameManager

@onready var pause_menu = $PauseMenu
var paused = false

var weapon_data = {
	"dagger": {
		"state" : 'UNLOCKED',
		"isSelected" : false
	},
	"fan": {
		"state" : 'LOCKED'
	},
	"slingshot": {
		"state" : 'LOCKED'
	},
	"katana": {
		"state" : 'LOCKED'
	},
	"mace": {
		"state" : 'LOCKED'
	},
	"bow": {
		"state" : 'LOCKED'
	},
	"trident": {
		"state" : 'LOCKED'
	}
}

func _ready():
	#print(funcs["win"])
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused

func _on_pause_menu_resume():
	pauseMenu()

func show_screen(screen_scene):
	var new_screen = screen_scene.instantiate()
	add_child(new_screen)
	#print(new_screen)
