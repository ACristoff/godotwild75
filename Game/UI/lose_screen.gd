extends Node2D

signal retry
signal lvlselect

@onready var losesongo = preload("res://Assets/Audio/Music/MM_Defeat.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager._play_music(losesongo, -6)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_pressed() -> void:
	LevelManager.switchScene(LevelManager.previous_level_index)
	retry.emit()


func _on_onward_2_pressed() -> void:
	LevelManager.switchScene(LevelManager.previous_level_index-1)


func _on_retry_2_pressed():
	pass # Replace with function body.
