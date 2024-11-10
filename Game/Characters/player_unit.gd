extends Unit

class_name PlayerUnit

@onready var action_ui = $action_select

#The logic for having these various states is due to so many different UI elements
enum unit_states {IDLE, SELECTED, ACTION_SELECT, ATTACK_THINK, MOVE_THINK, ATTACKING, MOVING}

var unit_state = "IDLE"

#Action select
#Spawn the action select
#Despawn the action select
func action_select():
	pass


## Toggles the "selected" animation on the unit.
var is_selected := false:
	set(value):
		is_selected = value
		if is_selected:
			#_anim_player.play("selected")
			pass
		else:
			_anim_player.play("idle")
#State transition func



#On_action_selected
#grab the signal from action select
#transition unit state
#do action


#func _ready():
	#die()
