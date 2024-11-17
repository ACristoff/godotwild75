extends EnemyUnit
class_name Tanuki

#Move Range = 4
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

func _process(delta):
	super(delta)

func _init():
	super()
	attacks = kappa_attacks

func enemyBrain(boardState):
	super(boardState)
	getTargetCharacter("Water Cannon")
	#Attack if able, if not move first.
	move("Water Cannon")
	if(targetOnRange):
		doAttack("Water Cannon")
		pass
	endTurn()

func getTargetCharacter(attackName: String):
	#Target furthest character
	var maxDistance = 0
	var auxOnRange = false
	for ch in characterList:
		if ch.cell.x < 7:
			var distance = abs(cell.x - ch.cell.x) + abs(ch.cell.y - cell.y)
			#If character is on range of attack, that's the character I'm focusing on.
			if distance <= attacks[attackName]["RANGE"]:
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
	
func move(attackName: String):
	#Move to the closest grid point where the attack reaches (max range on the attack)
	#If enemy is already on best point, don't move.
	var targetPoint = cell
	#Distance to character
	var maxDistance = 0
	#Distance to furthest point from character
	var closestDistance = 0
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
			for i in range(0, 4):
				if (grid.is_within_bounds(cells[i]) and cells[i].x < 8):
					var distanceToTarget = abs((cell - cells[i]).length())
					var distanceToCharacter = abs((targetCharacter.cell - cells[i]).length())
					if distanceToTarget <= move_range and distanceToCharacter >= closestDistance:
						#Cell within move range and closer to the character
						targetPoint = cells[i]
						maxDistance = distanceToTarget
						closestDistance = distanceToCharacter
	if cell == targetPoint:
		walk_along([cell])
	else:
		unitPath.initialize(battleManager.get_walkable_cells(self))
		unitPath.draw(cell, targetPoint)
		walk_along(unitPath.current_path)
