extends Node2D


var health
@export var host = Node2D

@onready var bottom = $Bottom
@onready var top = $Top

signal death
signal damaged

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top.value = 99


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bottom.value = top.value + 2

func _take_damage(damage):
	if top.value != 0:
		damage.emit(damage)
		top.value - damage
		top.modulate = Color.from_hsv(top.value/359.0, 100.0/100.0, 100.0/100.0, 255.0/255.0)
	else:
		emit_signal("death")
	
