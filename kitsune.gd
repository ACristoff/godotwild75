extends EnemyUnit
class_name Kitsune

#Move Range = 2
#HP = 2???

var kitsune_attacks = {
	"Spirit Flame": {
		"RANGE": 3,
		"DAMAGE": 2,
		"MOVE": Vector2(0,0),
		"EXORCISM": false,
		"BLAST_PATTERN": [],
		"ATTACK_PATTERN": [Vector2(0,0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1), Vector2(1, 0),]
	},
}

#Targets a cell, not a character
var targetCell = Vector2.ZERO
var targetOnRange = false

func _ready():
	super()
	move_range = 2
	set_process(true)

func _process(delta):
	super(delta)

func _init():
	super()
	attacks = kitsune_attacks

func enemyBrain(boardState):
	super(boardState)
	#Attack if able, if not move first.
	getTargetCharacter("Spirit Flame", boardState)
	move("Spirit Flame")
	if(targetOnRange):
		rangedAttack()

func getTargetCharacter(attackName: String, boardState):
	#Target most amount of characters in AoE range
	var characterAmount = 0
	var minDistance = 1000
	var auxOnRange = false
	var auxCell = cell
	#Loop through every cell in the grid (FUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
	for x in range(0, 7):
		for y in range(0, 7):
			var auxAmount = 0
			#Look at a certain cell in the grid
			var target = Vector2(x, y)
			var cells = attacks[attackName]["ATTACK_PATTERN"]
			#Check all surrounding cells (for the AoE effect)
			for c in cells:
				var lookin = Vector2(x, y) + c
				#Register amount of characters in that AoE
				if boardState.has(lookin) and boardState[lookin] is PlayerUnit:
					auxAmount += 1
					auxCell = Vector2(x,y)
			#If there's more characters that can be hit, target that cell.
			if auxAmount > characterAmount:
				characterAmount = auxAmount
				targetCell = auxCell
	
func rangedAttack():
	print("attacking")
	pass
	
func move(attackName: String):
	#Move to the closest grid point where the attack reaches (max range on the attack)
	#If enemy is already on best point, don't move.
	var targetPoint = cell
	#Distance to target cell
	var maxDistance = 0
	#Distance to closest point from character
	var closestDistance = 1000
	var auxMove = false
	for n in range(attacks[attackName]["RANGE"] + 1):
		var cells = [
			targetCell + Vector2(attacks[attackName]["RANGE"] - n, n),
			targetCell + Vector2((attacks[attackName]["RANGE"] - n)*-1, n),
			targetCell + Vector2(attacks[attackName]["RANGE"] - n, n*-1),
			targetCell + Vector2((attacks[attackName]["RANGE"] - n)*-1, n*-1)
		]
		for i in range(0, 3):
			if (grid.is_within_bounds(cells[i]) and cells[i].x < 8):
				var aux = abs((cell - cells[i]).length())
				if aux <= move_range and aux >= maxDistance:
					#Cell within move range and max attack range
					targetPoint = cells[i]
					maxDistance = aux
					auxMove = true
					targetOnRange = true
	#If no ideal cell was found, move closer to the target (as far away as possible)
	if(!auxMove):
		for n in range(move_range):
			var cells = [
				cell + Vector2(move_range - n, n),
				cell + Vector2((move_range - n)*-1, n),
				cell + Vector2(move_range - n, n*-1),
				cell + Vector2((move_range - n)*-1, n*-1)
			]
			for i in range(0, 3):
				if (grid.is_within_bounds(cells[i]) and cells[i].x < 8):
					var distanceToTarget = abs((cell - cells[i]).length())
					var distanceToCharacter = abs((targetCell - cells[i]).length())
					if distanceToTarget <= move_range and distanceToCharacter <= closestDistance:
						#Cell within move range and closer to the character
						targetPoint = cells[i]
						maxDistance = distanceToTarget
						closestDistance = distanceToCharacter
	walk_along([cell, targetPoint])
