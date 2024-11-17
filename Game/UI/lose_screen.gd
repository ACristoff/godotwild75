extends Node2D

signal retry
signal lvlselect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_pressed() -> void:
	LevelManager.switchScene(LevelManager.previous_level_index)
	retry.emit()


func _on_onward_2_pressed() -> void:
	lvlselect.emit()
