extends EnemyUnit
class_name BossOni

#Move Range = 2
#HP = 2???

var oni_attacks = {
	"Club Strike": {
		"RANGE": 1,
		"DAMAGE": 3,
		"ATTACK_VECS": [Vector2(0,0), Vector2(-1,0), Vector2(1,0)]
	},
	"Club Smash": {
		"RANGE": 1,
		"DAMAGE": 5,
		"ATTACK_VECS": [Vector2(0,0)]
	},
}

var targetOnRange = false

func _ready():
	super()
	move_range = 2
	max_health = 10
	onibiDrop = 100
	set_process(true)

func _process(delta):
	super(delta)

func _init():
	super()
	attacks = oni_attacks

func enemyBrain(boardState):
	super(boardState)
	getTargetCharacter("Club Strike", boardState)
	var attack = chooseAttack()
	var singleTarget = (attack == "Club Smash")
	#Attack if able, if not move first.
	move(attack, singleTarget)
	if(targetOnRange):
		doAttack(attack)
		pass
	endTurn()

func chooseAttack():
	#If there's more than one character to target, use AoE
	if targetCharacter == null:
		return "Club Strike"
	#If there's only one character to target, use single target
	else:
		return "Club Smash"

func getTargetCharacter(attackName: String, boardState):
	#Target most amount of characters in AoE range
	var characterAmount = 0
	var minDistance = 1000
	var auxOnRange = false
	var auxCell = cell
	#Loop through every cell in the grid (FUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
	var start = 0
	var end = 8
	if isSpirit:
		start = 10
		end = 18
	for x in range(start, end):
		for y in range(0, 8):
			var auxAmount = 0
			#Look at a certain cell in the grid
			var target = Vector2(x, y)
			var cells = attacks[attackName]["ATTACK_VECS"]
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
	#If he can target only 1 character, he will, and attack that specific character.
	if characterAmount == 1:
		for ch in characterList:
			if (ch.cell.x <= 7 and !isSpirit) or (ch.cell.x >= 10 and isSpirit):
				var distance = abs(cell.x - ch.cell.x) + abs(ch.cell.y - cell.y)
				#If character is on range of attack, that's the character I'm focusing on.
				if distance <= attacks["Club Smash"]["RANGE"]:
					targetOnRange = true
					targetCharacter = ch
					minDistance = distance
				else:
					targetOnRange = false
				#If there's no character on range of attack, target closest.
				if (distance < minDistance):
					minDistance = distance
					targetCharacter = ch
					targetCell = ch.cell
	
func move(attackName: String, singleTarget: bool):
	#Move to the closest grid point where the attack reaches (max range on the attack)
	#If enemy is already on best point, don't move.
	var targetPoint = cell
	#Distance to target cell
	var minDistance = 1000
	#Distance to closest point from character
	var closestDistance = 1000
	var auxMove = false
	if !singleTarget:
		for n in range(attacks[attackName]["RANGE"] + 1):
			var cells = [
				targetCell + Vector2(attacks[attackName]["RANGE"] - n, n),
				targetCell + Vector2((attacks[attackName]["RANGE"] - n)*-1, n),
				targetCell + Vector2(attacks[attackName]["RANGE"] - n, n*-1),
				targetCell + Vector2((attacks[attackName]["RANGE"] - n)*-1, n*-1)
			]
			for i in range(0, 4):
				if grid.is_within_bounds(cells[i]) and ((cells[i].x < 8 and !isSpirit) or (cells[i].x > 9 and isSpirit)):
					var aux = abs((cell - cells[i]).length())
					if aux <= move_range and aux <= minDistance:
						#Cell within move range and max attack range
						targetPoint = cells[i]
						minDistance = aux
						auxMove = true
						targetOnRange = true
	else:
		for n in range(attacks[attackName]["RANGE"] + 1):
			var cells = [
				targetCharacter.cell + Vector2(attacks[attackName]["RANGE"] - n, n),
				targetCharacter.cell + Vector2((attacks[attackName]["RANGE"] - n)*-1, n),
				targetCharacter.cell + Vector2(attacks[attackName]["RANGE"] - n, n*-1),
				targetCharacter.cell + Vector2((attacks[attackName]["RANGE"] - n)*-1, n*-1)
			]
			for i in range(0, 4):
				if grid.is_within_bounds(cells[i]) and ((cells[i].x < 8 and !isSpirit) or (cells[i].x > 9 and isSpirit)):
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
					var distanceToCharacter = abs((targetCell - cells[i]).length())
					if distanceToTarget <= move_range and distanceToCharacter <= closestDistance:
						#Cell within move range and closer to the character
						targetPoint = cells[i]
						minDistance = distanceToTarget
						closestDistance = distanceToCharacter
	if cell == targetPoint:
		walk_along([cell])
	else:
		unitPath.initialize(battleManager.get_walkable_cells(self))
		unitPath.draw(cell, targetPoint)
		walk_along(unitPath.current_path)
