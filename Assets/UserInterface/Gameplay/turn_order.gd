extends Node2D

@onready var states = $States
var yourTurn = true

func _ready() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Turnborder, "self_modulate", Color.DODGER_BLUE, 0)
	tween.tween_property($Turnborderlabel, "self_modulate", Color.DODGER_BLUE, 0)

func _SwitchingTurn():
	states.play("Switch")

func _enemyTurn():
	yourTurn = false
	states.play("Enemy")
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Turnborder, "self_modulate", Color.FIREBRICK, .5)
	tween.tween_property($Turnborderlabel, "self_modulate", Color.FIREBRICK, .5)
	
func _yourTurn():
	yourTurn = true
	states.play("Your")
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Turnborder, "self_modulate", Color.DODGER_BLUE, .5)
	tween.tween_property($Turnborderlabel, "self_modulate", Color.DODGER_BLUE, .5)

func _on_states_animation_finished(anim_name: StringName) -> void:
	if anim_name == ("Switch"):
		if yourTurn:
			_enemyTurn()
		else:
			_yourTurn()
