extends Unit

class_name EnemyUnit

#The enemy's targeted character; who the enemy is aiming to hit.
var targetCharacter : PlayerUnit = null
#If the enemy targets a cell instead of a character, it uses this variable.
var targetCell : Vector2 = Vector2.ZERO
@onready var battleManager : BattleManager = get_parent()
#All characters on screen
var characterList

signal walkadoodledoo

var has_moved = false
var boardState
var isSpirit = false

@onready var unit_path_scene = preload("res://Game/Data/unit_path.tscn")
var unitPath : UnitPath

func _ready():
	super()
	unitPath = unit_path_scene.instantiate()
	add_child(unitPath)
	
func _process(delta):
	walk(delta)

func _init():
	super()
	health = 1

func enemyBrain(state):
	characterList = get_tree().get_nodes_in_group("player")
	boardState = state

func walk_along(path):
	super(path)
	print("this is my path ese", path)
	walkadoodledoo.emit(path, self)
	

func endTurn():
	unitPath.stop()
	has_moved = true
	await get_tree().create_timer(2).timeout
	battleManager.turn_manager()

func doAttack(attackName: String):
	var cell : Vector2
	if targetCharacter != null:
		cell = targetCharacter.cell
	else:
		cell = targetCell
	#Wait until finished moving
	await get_tree().create_timer(1).timeout
	#Draw the attack squares
	var attack = attacks[attackName]
	var attack_cells = battleManager.get_attack_cells(self, attack)
	#battleManager.attack_overlay.draw(attack_cells)
	battleManager.hit_overlay.make_squares(attack["ATTACK_VECS"])
	battleManager.hit_overlay.position = grid.calculate_map_position(cell)
	#Give it a second
	await get_tree().create_timer(1).timeout
	#If the enemy targets a Character
	if targetCharacter != null:
		targetCharacter.take_damage(attack["DAMAGE"])
		pass
	#If the enemy targets a Cell (AoE attacks)
	else:
		for c in attack["ATTACK_VECS"]:
			var lookin = targetCell + c
			#Register amount of characters in that AoE
			if boardState.has(lookin) and boardState[lookin] is PlayerUnit:
				boardState[lookin].take_damage(attack["DAMAGE"])
		pass
	battleManager.hit_overlay.kill_kids()
