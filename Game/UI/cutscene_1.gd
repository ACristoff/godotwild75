extends Node2D

@export var speed = 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_camera()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Path2D/PathFollow2D.progress_ratio < 1:
		$Path2D/PathFollow2D.progress_ratio += delta/speed
	pass