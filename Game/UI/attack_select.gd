extends Node2D

@onready var attack_button = preload("res://Game/UI/attack_button_template.tscn")

signal attack_chosen

func new_button(attack_text, attack_key ):
	#print(attack, attack_button)
	var new_button_inst = attack_button.instantiate()
	self.add_child(new_button_inst)
	new_button_inst.text = attack_text
	new_button_inst.attack_key = attack_key
	new_button_inst.connect("pressed", emit_chosen.bind(attack_key))
	#new_button_inst.connect( emit_chosen.bind(""))
	#player.hit.connect(_on_player_hit.bind("sword", 100))

	pass

func emit_chosen(attack_key):
	
	#print(attack_key)
	attack_chosen.emit(attack_key)
	pass
