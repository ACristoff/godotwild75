extends Node2D

@onready var attack_button = preload("res://Game/UI/attack_button_template.tscn")

signal attack_chosen

func new_button(attack):
	#print(attack, attack_button)
	var new_button_inst = attack_button.instantiate()
	self.add_child(new_button_inst)
	new_button_inst.text = attack
	new_button_inst.connect("pressed", emit_chosen)
	pass

func emit_chosen():
	print("bingus")
	pass
