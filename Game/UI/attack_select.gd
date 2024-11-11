extends Node2D

@onready var attack_button = preload("res://Game/UI/attack_button_template.tscn")
#@onready var attack_menu = preload("res://Game/UI/attack_select.tscn")

func new_button(attack):
	print(attack, attack_button)
	var new_button = attack_button.instantiate()
	self.add_child(new_button)
	new_button.text = attack
	pass
