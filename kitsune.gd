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
	getTargetCharacter("Spirit Flame")

func _process(delta):
	super(delta)

func _init():
	super()
	attacks = kitsune_attacks

func enemyBrain():
	super()
	#Attack if able, if not move first.
	move("Spirit Flame")
	if(targetOnRange):
		rangedAttack()
	hasActed = true

func getTargetCharacter(attackName: String):
	#Target most amount of characters in AoE range
	var characterAmount = 0
	var minDistance = 1000
	var auxOnRange = false
	#Loop through every cell in the grid (FUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
	for x in range(0, 7):
		for y in range(0, 7):
			var target = Vector2(x, y)
			var cells = []
			for i in attacks[attackName]["ATTACK_PATTERN"]:
				cells.append(attacks[attackName]["ATTACK_PATTERN"][i])
			pass
			#var distance = abs(cell.x - ch.cell.x + ch.cell.y - cell.y)
			##If character is on range of attack, that's the character I'm focusing on.
			#if distance <= attacks[attackName]["RANGE"]:
				#targetOnRange = true
				#targetCharacter = ch
				#minDistance = distance
			#else:
				#targetOnRange = false
			##If there's no character on range of attack, target closest.
			#if (distance < minDistance):
				#minDistance = distance
				#targetCharacter = ch
	
func rangedAttack():
	print("attacking")
	pass
	
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
					var distanceToCharacter = abs((targetCharacter.cell - cells[i]).length())
					if distanceToTarget <= move_range and distanceToCharacter >= closestDistance:
						#Cell within move range and closer to the character
						targetPoint = cells[i]
						maxDistance = distanceToTarget
						closestDistance = distanceToCharacter
	walk_along([cell, targetPoint])
