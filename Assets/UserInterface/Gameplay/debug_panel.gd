extends CanvasLayer

var open = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = str("WAKE UP")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if Input.is_action_just_pressed("E"):
			if open == false:
				visible = true
				open = true
			else:
				visible = false
				open = false

func _on_button_pressed() -> void:
	if open == false:
		visible = true
		open = true
	else:
		visible = false
		open = false
