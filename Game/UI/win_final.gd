extends Node2D

@onready var credits = preload("res://Game/UI/credits_scene.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == ("Merge"):
		get_tree().change_scene_to_file("res://Game/UI/credits_scene.tscn")
