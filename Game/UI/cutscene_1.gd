extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_camera()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$Path2D/PathFollow2D.progress_ratio += .05
	pass

func _camera():
	for i in 21:
		if $Path2D/PathFollow2D.progress_ratio < 1:
			$Path2D/PathFollow2D.progress_ratio += .05
		else:
			$Path2D/PathFollow2D.progress_ratio = 0
			_camera()
