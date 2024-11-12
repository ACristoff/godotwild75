extends Node2D


signal attack_selected
signal attack_chosen
signal move_selected

@onready var move = $move
@onready var attack = $attack

@onready var attack_menu = preload("res://Game/UI/attack_select.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	pass # Replace with function body.

func disable_move():
	move.disabled = true

func disable_attack():
	attack.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func render_attacks(attacks):
	var menu = attack_menu.instantiate()
	attack.add_child(menu)
	for attack in attacks:
		var current = attacks[attack]
		var new_attack_text = str(attack, ' ', current.DAMAGE)
		menu.new_button(new_attack_text, attack)
		menu.connect('attack_chosen', _on_attack_chosen)
	pass

func attacking(attack_key):
	attack_chosen.emit(attack_key)
	pass

func _on_move_mouse_entered() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($GoldSelection, "global_position", $move.global_position, .05)
	tween.tween_callback(border_effect)

func _on_attack_mouse_entered() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($GoldSelection, "global_position", $attack.global_position, .05)
	tween.tween_callback(border_effect)

func border_effect():
	$switch_sound.play()

func _on_move_pressed() -> void:
	move_selected.emit()
	$select_sound.play()

func _on_attack_pressed() -> void:
	attack_selected.emit()
	$select_sound.play()

func _on_attack_chosen(attack):
	attacking(attack)
	pass