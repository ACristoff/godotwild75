extends Node2D

var mikoChosen = true
var onibi : int
@onready var whosSelect = $CanvasLayer/MarginContainer/VBoxContainer/MarginContainer/Label2
@onready var Value = $CanvasLayer/MarginContainer2/HBoxContainer/Label
# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	onibi = 100
	Value.text = str(onibi)
	_miko()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _miko():
	whosSelect.text = ("- Miko -")
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property($CanvasLayer/Miko, "global_position", $mikoend.global_position, .2)
	tween.tween_property($CanvasLayer/Miko, "modulate:a", 1/1, .2)
	tween.tween_property($CanvasLayer/Heiko, "global_position", $heikostart.global_position, .2)
	tween.tween_property($CanvasLayer/Heiko, "modulate:a", .5/1, .2)
	
func _heiko():
	whosSelect.text = ("- Heiko -")
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property($CanvasLayer/Heiko, "global_position", $heikoend.global_position, .2)
	tween.tween_property($CanvasLayer/Heiko, "modulate:a", 1/1, .2)
	tween.tween_property($CanvasLayer/Miko, "global_position", $mikostart.global_position, .2)
	tween.tween_property($CanvasLayer/Miko, "modulate:a", .5/1, .2)
	
func _on_miko_pressed() -> void:
	_miko()

func _on_heiko_pressed() -> void:
	_heiko()
