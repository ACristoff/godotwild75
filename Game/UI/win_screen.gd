extends Node2D

@onready var winsongo = preload("res://Assets/Audio/Music/MM_Victory Fanfare Rev 2.mp3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager._play_music(winsongo, -6)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_onward_pressed() -> void:
	LevelManager.switchScene(LevelManager.getLevelIndex("weapon_shop"))

func _on_retry_pressed() -> void:
	LevelManager.switchScene(LevelManager.previous_level_index)
