extends Node2D

@onready var songo = preload("res://Assets/Audio/Music/Intro_Cutscene.mp3")
@export var speed = 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_camera()
	pass

func _song():
	AudioManager._play_music(songo, 1)
	#$Path2D/PathFollow2D/Camera2D/AudioStreamPlayer2D.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Path2D/PathFollow2D.progress_ratio < 1:
		$Path2D/PathFollow2D.progress_ratio += delta/speed
	pass


func _on_custscene_2_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Miko":
		LevelManager.nextLevel()
