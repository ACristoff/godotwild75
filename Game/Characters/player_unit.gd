extends Unit

class_name PlayerUnit

@onready var action_ui = $action_select

#The logic for having these various states is due to so many different UI elements
enum unit_states {IDLE, SELECTED, ATTACK_THINK, MOVE_THINK, ATTACKING, MOVING}

var unit_state = unit_states.IDLE

signal unit_state_change(state: unit_states)

## Toggles the "selected" animation on the unit.
var is_selected := false:
	set(value):
		is_selected = value
		if is_selected:
			unit_state = unit_states.SELECTED
			action_select(true)
			pass
		else:
			unit_state = unit_states.IDLE
			action_select(false)
			#_anim_player.play("idle")

var has_moved = false
var has_attacked = false

#Action select
#Spawn the action select
#Despawn the action select
func action_select(state):
	action_ui.visible = state
	pass

func _process(delta):
	super(delta)
	pass

#On_action_selected
#grab the signal from action select
#transition unit state
#do action

#State transition func
func state_change(state):
	unit_state = state
	unit_state_change.emit(unit_state)
	#print(unit_state)

func finish_walk():
	super()
	state_change(unit_states.IDLE)
	action_ui.disable_move()
	pass

func _on_action_select_attack_selected():
	state_change(unit_states.ATTACK_THINK)
	pass # Replace with function body.

func _on_action_select_move_selected():
	state_change(unit_states.MOVE_THINK)
	action_select(false)
	pass # Replace with function body.
