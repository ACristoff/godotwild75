extends Node2D

@onready var Settings = $UI/Settings
@onready var MainMenu = $UI/MainMenu

var fullscreen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_game_pressed():
	LevelManager.nextLevel()

func _on_settings_pressed():
	Settings.visible = true
	MainMenu.visible = false

func _on_back_pressed():
	Settings.visible = false
	MainMenu.visible = true

func _on_exit_game_pressed():
	get_tree().quit()

func _on_fullscreen_pressed():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		$UI/Settings/HFlowContainer/Fullscreen.text = "Fullscreen"
		fullscreen = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		$UI/Settings/HFlowContainer/Fullscreen.text = "Windowed"
		fullscreen = true
