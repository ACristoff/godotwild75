extends Unit

class_name EnemyUnit

#The enemy's targeted character; who the enemy is aiming to hit.
var targetCharacter : PlayerUnit = null
@onready var battleManager : BattleManager = get_parent()
#All characters on screen
var characterList
var has_moved = false

func _ready():
	super()
	characterList = get_tree().get_nodes_in_group("player")
	pass
	
func _process(delta):
	super(delta)
	if battleManager.is_enemy_turn and !has_moved:
		has_moved = true

func _init():
	super()
	health = 1

func enemyBrain(boardState):
	pass
