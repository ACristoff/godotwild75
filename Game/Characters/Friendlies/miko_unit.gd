extends PlayerUnit

var spirit_miko_ref: PlayerUnit

var miko_attacks = {
	"Sword": {
		"RANGE": 2,
		"DAMAGE": 2,
		"MOVE": Vector2(0,0),
		"EXORCISM": false,
		"BLAST_PATTERN": [],
		"ATTACK_PATTERN": [Vector2(0,0), Vector2(0, -1), Vector2(0, -2)]
	},
}

func _init():
	attacks = miko_attacks
	pass
