extends PlayerUnit

var miko_attacks = {
	"Sword": {
		"RANGE": 2,
		"DAMAGE": 2,
		"MOVE": Vector2(0,0),
		"EXORCISM": false,
		"BLAST_PATTERN": [],
		"ATTACK_PATTERN": [Vector2(0,0)]
	},
}

func _init():
	attacks = miko_attacks
	pass
