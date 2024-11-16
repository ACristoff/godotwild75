extends Node2D

class_name GameManager

@onready var pause_menu = $PauseMenu
var paused = false

var weapon_data = {
	"dagger": {
		"state": 'UNLOCKED',
		"isSelected": true,
		"ATTACK_VECS": [Vector2(0, -1,), Vector2(0, -2)],
		"BLAST_PATTERN": [Vector2(0,0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1), Vector2(1, 0),],
	},
	"katana": {
		"state": 'LOCKED',
		"isSelected": false,
		"ATTACK_VECS": [Vector2(0, -1,), Vector2(0, -2), Vector2(0, -3)],
		"BLAST_PATTERN": [Vector2(0,0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1), Vector2(1, 0),],
	},
	"fan": {
		"state": 'LOCKED',
		"isSelected": false,
		"ATTACK_VECS": [Vector2(0, -1,), Vector2(0, -2)],
		"BLAST_PATTERN": [Vector2(0,0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1), Vector2(1, 0),],
	},
	"mace": {
		"state": 'LOCKED',
		"isSelected": false,
		"ATTACK_VECS": [Vector2(0, -1,), Vector2(0, -2)],
		"BLAST_PATTERN": [Vector2(0,0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1), Vector2(1, 0),],
	},
	"bow": {
		"state": 'LOCKED',
		"isSelected": false,
		"ATTACK_VECS": [Vector2(0, -1,), Vector2(0, -2)],
		"BLAST_PATTERN": [Vector2(0,0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1), Vector2(1, 0),],
	},
	"slingshot": {
		"state": 'LOCKED',
		"isSelected": false,
		"ATTACK_VECS": [Vector2(0, -1,), Vector2(0, -2)],
		"BLAST_PATTERN": [Vector2(0,0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1), Vector2(1, 0),],
	},
	"trident": {
		"state": 'LOCKED',
		"isSelected": false,
		"ATTACK_VECS": [Vector2(0, -1,), Vector2(0, -2)],
		"BLAST_PATTERN": [Vector2(0,0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1), Vector2(1, 0),],
	}
}

	#"Sword": {
		#"RANGE": 2,
		#"DAMAGE": 2,
		#"MOVE": Vector2(0,0),
		#"EXORCISM": false,
		#"BLAST_PATTERN": [Vector2(0,0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1), Vector2(1, 0),],
		#"ATTACK_PATTERN": [Vector2(0,0), Vector2(0, -1), Vector2(0, -2)]
	#},

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
