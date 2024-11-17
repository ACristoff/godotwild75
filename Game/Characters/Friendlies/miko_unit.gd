extends PlayerUnit

var spirit_miko_ref: PlayerUnit

#TODO REFACTOR WEAPON RENDERING
var miko_attacks = [
	
]

func _init():

	#attacks = miko_attacks
	pass

func _ready():
	super()
	max_health = 10
	move_range = 4
	var manager: GameManager = get_node("/root/GameManager")
	#print(manager.weapon_data.has(true))
	var weapons = manager.weapon_data
	#print(weapons)
	for weapon in weapons:
		#if weapon.isSelected
		if weapons[weapon].isSelected:
			#var test = weapons[weapon]
			#print(weapon)
			miko_attacks.append(weapons[weapon])
			pass
		#print(weapons[weapon].isSelected)
		pass
	#print(miko_attacks)
	attacks = miko_attacks
	

	#"dagger": {
		#"state": 'UNLOCKED',
		#"isSelected": true,
		#"ATTACK_VECS": [Vector2(0, -1,), Vector2(0, -2)],
		#"BLAST_PATTERN": [
			#Vector2(0,0),
			#Vector2(1, -1),
			#Vector2(-1, -1),
			#Vector2(-1 ,1),
			#Vector2(1 ,1)
		#],
	#},
