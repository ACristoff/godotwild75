extends Unit

class_name PlayerUnit

@onready var action_ui = $action_select

#The logic for having these various states is due to so many different UI elements
enum unit_states {IDLE, SELECTED, ATTACK_THINK, ATTACK_ACTION_THINK, MOVE_THINK, ATTACKING, MOVING}

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

var has_walked = false
var has_attacked = false
var current_attack = null

signal turnEnded

#Action select
#Spawn the action select
#Despawn the action select
func action_select(state):
	action_ui.visible = state
	pass

func _ready():
	super()
	max_health = 10

func _process(delta):
	super(delta)
	pass

#On_action_selected
#grab the signal from action select
#transition unit state
#do action
func attack(cells, damage):
	super(cells, damage)
	has_attacked = true
	current_attack = null
	pass

#State transition func
func state_change(state):
	unit_state = state
	unit_state_change.emit(unit_state)
	
	if state == unit_states.ATTACK_THINK:
		action_ui.render_attacks(attacks)
		#action_select(false)

func finish_walk():
	super()
	has_walked = true
	checkTurnEnded()
	state_change(unit_states.IDLE)
	action_ui.disable_move()
	pass

func finish_attack():
	has_attacked = true
	checkTurnEnded()
	action_ui.disable_attack()

func _on_action_select_attack_selected():
	state_change(unit_states.ATTACK_THINK)
	pass # Replace with function body.

func _on_action_select_move_selected():
	state_change(unit_states.MOVE_THINK)
	#action_select(false)
	#action_select()
	action_ui.close()
	pass # Replace with function body.

func _on_action_select_attack_chosen(attack):
	current_attack = attack
	#print('current attack selected', current_attack)
	state_change(unit_states.ATTACK_ACTION_THINK)
	#action_select(false)
	action_ui.close()
	pass # Replace with function body.

func checkTurnEnded():
	if has_attacked and has_walked:
		has_moved = true
		turnEnded.emit()
