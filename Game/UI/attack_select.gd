extends Node2D

@onready var attack_button = preload("res://Game/UI/attack_button_template.tscn")

signal attack_chosen

var vertical_offset = 40

func new_button(attack_text, attack_obj):
	var attack_count = get_children().size()
	var new_button_inst = attack_button.instantiate()
	self.add_child(new_button_inst)
	new_button_inst.text = attack_text
	new_button_inst.attack_key = attack_obj.weapon_name
	new_button_inst.connect("pressed", emit_chosen.bind(attack_obj))
	
	#print(attack_count, attack_count * vertical_offset)
	new_button_inst.position.y = attack_count * vertical_offset
	pass

func emit_chosen(attack_key):
	attack_chosen.emit(attack_key)
	pass
