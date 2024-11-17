extends Node2D

class_name GameManager

@onready var pause_menu = $PauseMenu
var paused = false

var onibi = 0

var weapon_data = {
	"Dagger": {
		"weapon_name": "Dagger",
		"state": 'UNLOCKED',
		"isSelected": true,
		"DAMAGE": 2,
		"ATTACK_VECS": [Vector2(0, -1,), Vector2(0, -2)],
		"BLAST_PATTERN": [
			Vector2(0,0),
			Vector2(1, -1),
			Vector2(-1, -1),
			Vector2(-1 ,1),
			Vector2(1 ,1)
		],
	},
	"Katana": {
		"weapon_name": "Katana",
		"state": 'LOCKED',
		"isSelected": false,
		"DAMAGE": 2,
		"ATTACK_VECS": [Vector2(0, -1,), Vector2(0, -2), Vector2(0, -3)],
		"BLAST_PATTERN": [
			Vector2(0,0),
			Vector2(0, -1),
			Vector2(0, -2),
			Vector2(0, -3),
			Vector2(1, -1),
			Vector2(-1, -1),
			Vector2(1, 0),
			Vector2(2, 0),
			Vector2(-1, 0),
			Vector2(-2, 0),
			Vector2(1, 1),
			Vector2(-1, 1),
		],
	},
	"Fan": {
		"weapon_name": "Fan",
		"state": 'LOCKED',
		"isSelected": false,
		"DAMAGE": 2,
		"ATTACK_VECS": [Vector2(0, -1,), Vector2(-1, -1), Vector2(1, -2), Vector2(-1, -2), Vector2(1, -2), Vector2(1, -1)],
		"BLAST_PATTERN": [            Vector2(0,-1),
			Vector2(0, -2),
			Vector2(0, -3),
			Vector2(0, -4),
			Vector2(-1, -2),
			Vector2(1, -2),
			Vector2(-2, -4),],
	},
	"Mace": {
		"weapon_name": "Mace",
		"state": 'LOCKED',
		"isSelected": false,
		"DAMAGE": 2,
		"ATTACK_VECS": [Vector2(0, -3), Vector2(1, -4), Vector2(-1, -4), Vector2(-1, -4), Vector2(1, -2), Vector2(-1, -2)],
		"BLAST_PATTERN": [
			Vector2(0,-1),
			Vector2(0, 1),
			Vector2(1, 0),
			Vector2(-1, 0),
			Vector2(-1, -2),
			Vector2(1, 1),
			Vector2(1, -1),
			Vector2(-1, -1),
			Vector2(-1, 1),
			Vector2(2, -2),
			Vector2(-2, 2),
			Vector2(2, 2),
			Vector2(-2, -2),
		],
	},
	"Bow": {
		"weapon_name": "Bow",
		"state": 'LOCKED',
		"isSelected": false,
		"DAMAGE": 2,
		"ATTACK_VECS": [Vector2(0, -3,), Vector2(0, -4), Vector2(0, -5), Vector2(-1, -4), Vector2(1, -4)],
		"BLAST_PATTERN": [
					   Vector2(0,-1),
			Vector2(0, 1),
			Vector2(1, 0),
			Vector2(-1, 0),
			Vector2(1, 1),
			Vector2(1, -1),
			Vector2(-1, -1),
			Vector2(-1, 1),
			Vector2(2, -2),
			Vector2(-2, 2),
			Vector2(2, 2),
			Vector2(-2, -2),
			Vector2(1, 2),
			Vector2(-1, 2),
			Vector2(1, -2),
			Vector2(-1, -2),
			Vector2(2, 1),
			Vector2(-2, 1),
			Vector2(2, -1),
			Vector2(-2, -1),
			Vector2(3, 2),
			Vector2(-3, 2),
			Vector2(3, -2),
			Vector2(-3, -2),
			Vector2(2, -3),
			Vector2(-2, 3),
			Vector2(-2, -3),
			Vector2(2, 3),
		],
	},
	"Slingshot": {
		"weapon_name": "Slingshot",
		"state": 'LOCKED',
		"isSelected": false,
		"DAMAGE": 2,
		"ATTACK_VECS": [Vector2(0, -3,), Vector2(1, -3), Vector2(-1, -3)],
		"BLAST_PATTERN": [            
			Vector2(0,-1),
			Vector2(0, 1),
			Vector2(1, 0),
			Vector2(-1, 0),
			Vector2(1, 1),
			Vector2(1, -1),
			Vector2(-1, -1),
			Vector2(-1, 1),
			Vector2(2, -3),
			Vector2(-2, 3),
			Vector2(2, 3),
			Vector2(-2, -3),
			Vector2(3, 2),
			Vector2(-3, 2),
			Vector2(3, -2),
			Vector2(-3, -2),],
	},
	"Trident": {
		"weapon_name": "Trident",
		"state": 'LOCKED',
		"isSelected": false,
		"DAMAGE": 2,
		"ATTACK_VECS": [Vector2(0, -1,), Vector2(0, -2), Vector2(0, -3), Vector2(0, -4), Vector2(-1, -2), Vector2(1, -2)],
		"BLAST_PATTERN": [
			Vector2(0,-4),
			Vector2(0, 4),
			Vector2(4, 0),
			Vector2(-4, 0),
			Vector2(1, 4),
			Vector2(1, -4),
			Vector2(-1, -4),
			Vector2(-1, 4),
			Vector2(1, -3),
			Vector2(-1, 3),
			Vector2(1, 3),
			Vector2(-1, -3),
			Vector2(2, 2),
			Vector2(-2, 2),
			Vector2(2, -2),
			Vector2(-2, -2),
			Vector2(4, 1),
			Vector2(-4, 1),
			Vector2(4, -1),
			Vector2(-4, -1),
			Vector2(3, 1),
			Vector2(-3, 1),
			Vector2(3, -1),
			Vector2(-3, -1),
			Vector2(2, -3),
			Vector2(-2, 3),
			Vector2(-2, -3),
			Vector2(2, 3),
			Vector2(3, -2),
			Vector2(-3, 2),
			Vector2(-3, -2),
			Vector2(3, 2),
		],
	}
}

func _ready():
	#print(funcs["win"])
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused

func _on_pause_menu_resume():
	pauseMenu()

func show_screen(screen_scene):
	var new_screen = screen_scene.instantiate()
	add_child(new_screen)
	#print(new_screen)
