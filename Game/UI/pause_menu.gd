extends Control

signal resume

func _on_resume_pressed():
	emit_signal("resume")
	pass


func _on_exit_pressed():
	get_tree().quit()
