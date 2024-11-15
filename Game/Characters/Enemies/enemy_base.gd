extends Unit

class_name EnemyUnit

#We use this to spawn this enemy on the spirit world
#Had to change this a string because it would consider it a circular ref
#It's a little jank but who cares MAAAAAAN
@export var self_scene_path: String

#The enemy's targeted character; who the enemy is aiming to hit.
var targetCharacter : PlayerUnit = null
#All characters on screen
var characterList
var hasActed = false

@onready var battleManager : BattleManager = get_parent()

func _ready():
	super()
	characterList = get_tree().get_nodes_in_group("player")
	pass
	
func _process(delta):
	super(delta)
	if true and !hasActed:
		enemyBrain()

func _init():
	super()

func enemyBrain():
	pass
