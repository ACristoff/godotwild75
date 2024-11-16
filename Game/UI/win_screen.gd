extends Node2D

signal itemshop
signal retry
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_onward_pressed() -> void:
	itemshop.emit()


func _on_retry_pressed() -> void:
	retry.emit()
