extends EnemyUnit
class_name Oni

#Move Range = 2
#HP = 2???

var oni_attacks = {
	"Club Strike": {
		"RANGE": 1,
		"DAMAGE": 3,
		"ATTACK_VECS": [Vector2(0,0)]
	},
}

var targetOnRange = false

func _ready():
	super()
	set_process(true)

func _process(delta):
	super(delta)

func _init():
	super()
	attacks = oni_attacks
	move_range = 2
	max_health = 4
	onibiDrop = 30

func enemyBrain(boardState):
	super(boardState)
	await get_tree().create_timer(1).timeout
	getTargetCharacter("Club Strike")
	#Attack if able, if not move first.
	move("Club Strike")
	if(targetOnRange):
		doAttack("Club Strike")
		pass
	endTurn()

func getTargetCharacter(attackName: String):
	#Target closest character
	var minDistance = 1000
	var auxOnRange = false
	for ch in characterList:
		if (ch.cell.x <= 7 and !isSpirit) or (ch.cell.x >= 10 and isSpirit):
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
	var walkable_cells = battleManager.get_walkable_cells(self)
	
	for n in range(attacks[attackName]["RANGE"] + 1):
		var cells = [
			targetCharacter.cell + Vector2(attacks[attackName]["RANGE"] - n, n),
			targetCharacter.cell + Vector2((attacks[attackName]["RANGE"] - n)*-1, n),
			targetCharacter.cell + Vector2(attacks[attackName]["RANGE"] - n, n*-1),
			targetCharacter.cell + Vector2((attacks[attackName]["RANGE"] - n)*-1, n*-1)
		]
		for i in range(0, 4):
			if grid.is_within_bounds(cells[i]) and walkable_cells.has(cells[i]) and ((cells[i].x < 8 and !isSpirit) or (cells[i].x > 9 and isSpirit)):
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
				if grid.is_within_bounds(cells[i]) and ((cells[i].x < 8 and !isSpirit) or (cells[i].x > 9 and isSpirit)):
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
		unitPath.initialize(walkable_cells)
		unitPath.draw(cell, targetPoint)
		walk_along(unitPath.current_path)
