extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func GutPunch():
	$AudioStreamPlayer2D.play()
func Sparkle():
	$AudioStreamPlayer2D2.play()
func Transition():
	unlock_pause()
	$Camera2D/Transition/AnimationPlayer2.play("Trans_Out")
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func unlock_pause():
	pass

func _on_cutscene_final_animation_finished(anim_name: StringName) -> void:
	if anim_name == ("Tengu"):
		LevelManager.nextLevel()
