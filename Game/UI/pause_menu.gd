extends Control

signal resume
var open = false

func _on_resume_pressed():
	emit_signal("resume")
	pass

func _on_exit_pressed():
	get_tree().quit()

func _open_settings():
	pass

func _on_resume_mouse_entered() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($GoldSelection, "global_position", $MarginContainer/VBoxContainer/Resume.global_position, .05)
	tween.tween_callback(border_effect)


func _on_settings_mouse_entered() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($GoldSelection, "global_position", $MarginContainer/VBoxContainer/Settings.global_position, .05)
	tween.tween_callback(border_effect)

func _on_exit_mouse_entered() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($GoldSelection, "global_position", $MarginContainer/VBoxContainer/Exit.global_position, .05)
	tween.tween_callback(border_effect)
	
func border_effect():
	pass


func _on_settings_pressed() -> void:
	if open == false:
		open = true
		$Panel.visible = true
	else:
		open = false
		$Panel.visible = false
