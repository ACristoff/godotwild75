extends ColorRect

@export var is_trans_in = false
@export var is_on = false
@onready var animation = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_on:
		if is_trans_in:
			animation.play("Transition_In")
		else:
			animation.play("Transition_Out")
	else:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
