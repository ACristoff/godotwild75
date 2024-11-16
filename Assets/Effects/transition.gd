extends ColorRect

@export var is_trans_in = false
@export var is_on = false
@onready var animation = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func trans_in():
	animation.play("Transition_In")
func trans_out():
	animation.play("Transition_Out")
	
