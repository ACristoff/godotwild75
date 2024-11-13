extends PlayerUnit

var heiko_attacks = {
	"Palm Strike": {
		"RANGE": 1,
		"DAMAGE": 1,
		"MOVE": Vector2(0,0),
		"EXORCISM": false,
		"BLAST_PATTERN": [],
		"ATTACK_PATTERN": [Vector2(0,0)]
	},
}

func _init():
	attacks = heiko_attacks
	pass
