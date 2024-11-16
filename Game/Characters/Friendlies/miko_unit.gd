extends PlayerUnit

var spirit_miko_ref: PlayerUnit

#TODO REFACTOR WEAPON RENDERING
var miko_attacks = {
	"Sword": {
		"RANGE": 2,
		"DAMAGE": 2,
		"MOVE": Vector2(0,0),
		"EXORCISM": false,
		"BLAST_PATTERN": [Vector2(0,0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1), Vector2(1, 0),],
		"ATTACK_PATTERN": [Vector2(0,0), Vector2(0, -1), Vector2(0, -2)]
	},
}

func _init():
	attacks = miko_attacks
	pass
