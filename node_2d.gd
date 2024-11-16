extends Node2D
signal fill
@onready var path = $Path2D
@onready var follow = $Path2D/PathFollow2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var speed = randi_range(.3, 1)
	var rand_y = randi_range(0, 280)
	follow.progress_ratio = 0
	path.curve.add_point(Vector2(84, 120))
	path.curve.add_point(Vector2(640, 392))
	path.curve.set_point_out(0, Vector2(280, rand_y))
	_flame_velocity()
	
func destroy():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow.progress_ratio == 1:
		emit_signal("fill")
		queue_free()

func _flame_velocity():
	$Path2D/PathFollow2D/Firelantern.visible = true
	var speed = randf_range(.3, .6)
	var tween = create_tween()
	tween.tween_property(follow, "progress_ratio", 1, speed)
	
