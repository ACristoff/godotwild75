extends PlayerUnit

var heiko_attacks = [
	{
		"weapon_name": "Palm Strike",
		"RANGE": 1,
		"DAMAGE": 3,
		"MOVE": Vector2(0,0),
		"EXORCISM": false,
		"BLAST_PATTERN": [
			Vector2(0,0),
			Vector2(1, -1),
			Vector2(-1, -1),
			Vector2(-1 ,1),
			Vector2(1 ,1)
		],
		"ATTACK_VECS": [Vector2(0,-1)]
	},
	{
		"weapon_name": "Spirit Kick",
		"RANGE": 2,
		"DAMAGE": 3,
		"MOVE": Vector2(0,0),
		"EXORCISM": false,
		"BLAST_PATTERN": [
			Vector2(0, 0),
			Vector2(0, -1),
			Vector2(1, 0),
			Vector2(-1, 0),
			Vector2(0 ,1)
		],
		"ATTACK_VECS": [Vector2(0,-1), Vector2(0,-2), Vector2(0,-3)]
	},
]

func _init():
	attacks = heiko_attacks
	health = 10
	pass

func _ready():
	super()
	move_range = 3
