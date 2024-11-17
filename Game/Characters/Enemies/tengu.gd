extends EnemyUnit
class_name Tengu

#Move Range = 4
#HP = 2???

var tengu_attacks = {
	"Karate Chop": {
		"RANGE": 1,
		"DAMAGE": 1,
		"ATTACK_VECS": [Vector2(0,0)]
	},
}

var targetOnRange = false

func _ready():
	super()
	move_range = 4
	max_health = 1
	set_process(true)

func _process(delta):
	super(delta)

func _init():
	super()
	attacks = tengu_attacks

func enemyBrain(boardState):
	super(boardState)
	getTargetCharacter("Karate Chop")
	#Attack if able, if not move first.
	move("Karate Chop")
	if(targetOnRange):
		doAttack("Karate Chop")
		pass
	endTurn()

func getTargetCharacter(attackName: String):
	#Target closest character
	var minDistance = 1000
	var auxOnRange = false
	for ch in characterList:
		if ch.cell.x < 7:
			var distance = abs(cell.x - ch.cell.x) + abs(ch.cell.y - cell.y)
			#If character is on range of attack, that's the character I'm focusing on.
			if distance <= attacks[attackName]["RANGE"]:
				targetOnRange = true
				targetCharacter = ch
				minDistance = distance
			else:
				targetOnRange = false
			#If there's no character on range of attack, target closest.
			if (distance < minDistance):
				minDistance = distance
				targetCharacter = ch
	
func move(attackName: String):
	#Move to the closest grid point where the attack reaches (max range on the attack)
	#If enemy is already on best point, don't move.
	var targetPoint = cell
	#Distance to character
	var minDistance = 1000
	#Distance to closest point to character
	var closestDistance = 1000
	var auxMove = false
	for n in range(attacks[attackName]["RANGE"] + 1):
		var cells = [
			targetCharacter.cell + Vector2(attacks[attackName]["RANGE"] - n, n),
			targetCharacter.cell + Vector2((attacks[attackName]["RANGE"] - n)*-1, n),
			targetCharacter.cell + Vector2(attacks[attackName]["RANGE"] - n, n*-1),
			targetCharacter.cell + Vector2((attacks[attackName]["RANGE"] - n)*-1, n*-1)
		]
		for i in range(0, 4):
			if (grid.is_within_bounds(cells[i]) and cells[i].x < 8):
				var distanceToTarget = abs((cell - cells[i]).length())
				if distanceToTarget <= move_range and distanceToTarget <= minDistance:
					#Cell within move range and max attack range
					targetPoint = cells[i]
					minDistance = distanceToTarget
					auxMove = true
					targetOnRange = true
	#If no ideal cell was found, move closer to the target
	if(!auxMove):
		for n in range(move_range):
			var cells = [
				cell + Vector2(move_range - n, n),
				cell + Vector2((move_range - n)*-1, n),
				cell + Vector2(move_range - n, n*-1),
				cell + Vector2((move_range - n)*-1, n*-1)
			]
			for i in range(0, 4):
				if (grid.is_within_bounds(cells[i]) and cells[i].x < 8):
					var distanceToTarget = abs((cell - cells[i]).length())
					var distanceToCharacter = abs((targetCharacter.cell - cells[i]).length())
					if distanceToTarget <= move_range and distanceToCharacter <= closestDistance:
						#Cell within move range and closest to the character
						targetPoint = cells[i]
						minDistance = distanceToTarget
						closestDistance = distanceToCharacter
	if cell == targetPoint:
		walk_along([cell])
	else:
		unitPath.initialize(battleManager.get_walkable_cells(self))
		unitPath.draw(cell, targetPoint)
		walk_along(unitPath.current_path)
