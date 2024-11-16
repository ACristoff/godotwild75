extends Node2D

@onready var bottom = $Bottom
@onready var top = $Top

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top.modulate = Color.from_hsv(top.value/359.0, 100.0/100.0, 100.0/100.0, 255.0/255.0)

func _take_damage(damage, max_health):
	var percentage = damage / max_health * 100
	if top.value != 0:
		top.value = top.value - (50)
		bottom.value = top.value + 2
		top.modulate = Color.from_hsv(top.value/359.0, 100.0/100.0, 100.0/100.0, 255.0/255.0)
