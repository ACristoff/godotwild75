extends PlayerUnit

var heiko_attacks = [
	{
		"weapon_name": "Palm Strike",
		"RANGE": 1,
		"DAMAGE": 1,
		"MOVE": Vector2(0,0),
		"EXORCISM": false,
		"BLAST_PATTERN": [],
		"ATTACK_VECS": [Vector2(0,-1)]
	},
]

	#"Dagger": {
		#"weapon_name": "Dagger",
		#"state": 'LOCKED',
		#"isSelected": true,
		#"DAMAGE": 2,
		#"ATTACK_VECS": [Vector2(0, -1,), Vector2(0, -2)],
		#"BLAST_PATTERN": [
			#Vector2(0,0),
			#Vector2(1, -1),
			#Vector2(-1, -1),
			#Vector2(-1 ,1),
			#Vector2(1 ,1)
		#],
	#},


func _init():
	attacks = heiko_attacks
	pass
