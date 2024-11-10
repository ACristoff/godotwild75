extends Node2D


signal attack_selected
signal move_selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_move_mouse_entered() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($GoldSelection, "global_position", $move.global_position, .05)
	tween.tween_callback(border_effect)


func _on_attack_mouse_entered() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($GoldSelection, "global_position", $attack.global_position, .05)
	tween.tween_callback(border_effect)
	
	
func border_effect():
	$switch_sound.play()

func _on_move_pressed() -> void:
	$select_sound.play()

func _on_attack_pressed() -> void:
	$select_sound.play()
