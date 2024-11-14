extends EnemyUnit
class_name Kappa

#Move Range = 2
#HP = 2???

var kappa_attacks = {
	"Water Cannon": {
		"RANGE": 4,
		"DAMAGE": 2,
		"MOVE": Vector2(0,0),
		"EXORCISM": false,
		"BLAST_PATTERN": [],
		"ATTACK_PATTERN": [Vector2(0,0)]
	},
}

var targetOnRange = false

func _ready():
	super()
	move_range = 2
	set_process(true)
	getTargetCharacter()

func _process(delta):
	super(delta)

func _init():
	super()
	attacks = kappa_attacks

func enemyBrain():
	super()
	#Attack if able, if not move first.
	move()
	if(targetOnRange):
		rangedAttack()
	hasActed = true

func getTargetCharacter():
	#Target furthest character
	var maxDistance = 0
	var auxOnRange = false
	for ch in characterList:
		if ch.cell.x < 7:
			var distance = abs(cell.x - ch.cell.x + ch.cell.y - cell.y)
			#If character is on range of attack, that's the character I'm focusing on.
			if distance <= attacks["Water Cannon"]["RANGE"]:
				targetOnRange = true
				auxOnRange = true
			else:
				targetOnRange = false
			#If there's another character with a greater distance and on range, change targets there.
			#If there's no character on range, target furthest character.
			if (distance > maxDistance and targetOnRange) or (!targetOnRange and !auxOnRange):
				maxDistance = distance
				targetCharacter = ch
	targetOnRange = auxOnRange
	
func rangedAttack():
	print("attacking")
	pass
	
func move():
	#Move to the closest grid point where the attack reaches (max range on the attack)
	#If enemy is already on best point, don't move.
	var targetPoint = cell
	var maxDistance = 0
	for n in range(attacks["Water Cannon"]["RANGE"]):
		var posCell = targetCharacter.cell + Vector2(attacks["Water Cannon"]["RANGE"] - n, n)
		var negCell = targetCharacter.cell - Vector2(attacks["Water Cannon"]["RANGE"] - n, n)
		if (grid.is_within_bounds(posCell)):
			var aux = abs((cell - posCell).length())
			if aux <= move_range and aux > maxDistance:
				#Cell within move range and max attack range
				targetPoint = posCell
				maxDistance = aux
		if (grid.is_within_bounds(negCell)):
			var aux = abs((cell - posCell).length())
			if aux <= move_range and aux > maxDistance:
				#Cell within move range and max attack range
				targetPoint = negCell
				maxDistance = aux
	walk_along([cell, targetPoint])
