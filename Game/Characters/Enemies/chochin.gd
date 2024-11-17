extends EnemyUnit
class_name Chochin

#Move Range = 4
#HP = 2???

var chochin_attacks = {
	"Flamethrower": {
		"RANGE": 2,
		"DAMAGE": 2,
		"ATTACK_VECS": [Vector2(0,0), Vector2(0, 1)]
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
	attacks = chochin_attacks
	move_range = 2
	max_health = 2
	onibiDrop = 20

func enemyBrain(boardState):
	super(boardState)
	getTargetCharacter("Flamethrower", boardState)
	#Attack if able, if not move first.
	move("Flamethrower")
	if(targetOnRange):
		doAttack("Flamethrower")
		pass
	endTurn()

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
	
func move(attackName: String):
	#Move to the closest grid point where the attack reaches (max range on the attack)
	#If enemy is already on best point, don't move.
	var targetPoint = cell
	#Distance to target cell
	var maxDistance = 0
	#Distance to closest point from character
	var closestDistance = 1000
	var auxMove = false
	var walkable_cells = battleManager.get_walkable_cells(self)
	
	for n in range(attacks[attackName]["RANGE"] + 1):
		var cells = [
			targetCell + Vector2(attacks[attackName]["RANGE"] - n, n),
			targetCell + Vector2((attacks[attackName]["RANGE"] - n)*-1, n),
			targetCell + Vector2(attacks[attackName]["RANGE"] - n, n*-1),
			targetCell + Vector2((attacks[attackName]["RANGE"] - n)*-1, n*-1)
		]
		for i in range(0, 4):
			if grid.is_within_bounds(cells[i]) and walkable_cells.has(cells[i]) and ((cells[i].x < 8 and !isSpirit) or (cells[i].x > 9 and isSpirit)):
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
				if grid.is_within_bounds(cells[i]) and walkable_cells.has(cells[i]) and ((cells[i].x < 8 and !isSpirit) or (cells[i].x > 9 and isSpirit)):
					var distanceToTarget = abs((cell - cells[i]).length())
					var distanceToCharacter = abs((targetCell - cells[i]).length())
					if distanceToTarget <= move_range and distanceToCharacter <= closestDistance:
						#Cell within move range and closer to the character
						targetPoint = cells[i]
						maxDistance = distanceToTarget
						closestDistance = distanceToCharacter
	if cell == targetPoint:
		walk_along([cell])
	else:
		unitPath.initialize(walkable_cells)
		unitPath.draw(cell, targetPoint)
		walk_along(unitPath.current_path)
