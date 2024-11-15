extends Node2D



#ALEX DID NOT WRITE THIS CODE CALEB DID


var mikoChosen = true
var onibi : int
var frontIndicator = 0
var arrows_disabled = false
var WeaponName = ""
var cost
var type
var gameManager
var mikoEquip
var heikoEquip

signal confirm_weapon

@onready var whosSelect = $CanvasLayer/MarginContainer/VBoxContainer/MarginContainer/Label2
@onready var Value = $CanvasLayer/MarginContainer2/HBoxContainer/Label
@onready var dagger = $Path2D/Pnt1
@onready var trident = $Path2D/Pnt2
@onready var bow = $Path2D/Pnt3
@onready var mace = $Path2D/Pnt4
@onready var katana = $Path2D/Pnt5
@onready var slingshot = $Path2D/Pnt6
@onready var fan = $Path2D/Pnt7

var pos0 = 0
var pos1 = 1
var pos2 = 0.143
var pos3 = 0.286
var pos4 = 0.429
var pos5 = 0.572
var pos6 = 0.715
var pos7 = 0.858



func _ready() -> void:
	onibi = 100
	Value.text = str(onibi)
	_miko()
	var tween = create_tween()
	tween.tween_property(dagger, "progress_ratio", pos1, 0)
	tween.tween_property(trident, "progress_ratio", pos2, 0)
	tween.tween_property(bow, "progress_ratio", pos3, 0)
	tween.tween_property(mace, "progress_ratio", pos4, 0)
	tween.tween_property(katana, "progress_ratio", pos5, 0)
	tween.tween_property(slingshot, "progress_ratio", pos6, 0)
	tween.tween_property(fan, "progress_ratio", pos7, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if arrows_disabled == false:
		if Input.is_action_pressed("ui_right"):
			arrows_disabled = true
			frontIndicator += 1
			_switch_weapon_right()
			$CanvasLayer/ButtonArrow/TextureButton.disabled = true
			$CanvasLayer/ButtonArrow2/TextureButton2.disabled = true
		elif Input.is_action_pressed("ui_left"):
			arrows_disabled = true
			frontIndicator -= 1
			_switch_weapon_left()
			$CanvasLayer/ButtonArrow/TextureButton.disabled = true
			$CanvasLayer/ButtonArrow2/TextureButton2.disabled = true
	#print(dagger.progress_ratio)
	#$CanvasLayer/front_indicator.text = str(frontIndicator)
	#if frontIndicator == 7:
		#frontIndicator = 0
	#if frontIndicator == -1:
		#frontIndicator = 6
func _switch_weapon_right():
	if frontIndicator >= 7:
		trident.progress_ratio = 0
		frontIndicator = 0
	if frontIndicator <= -1:
		frontIndicator = 6
	if frontIndicator == 0:
		var tween = create_tween()
		#trident.progress_ratio = 0
		tween.set_parallel(true)
		tween.tween_property(dagger, "progress_ratio", pos1, .5)
		tween.tween_property(trident, "progress_ratio", pos2, .5)
		tween.tween_property(bow, "progress_ratio", pos3, .5)
		tween.tween_property(mace, "progress_ratio", pos4, .5)
		tween.tween_property(katana, "progress_ratio", pos5, .5)
		tween.tween_property(slingshot, "progress_ratio", pos6, .5)
		tween.tween_property(fan, "progress_ratio", pos7, .5)
		tween.set_parallel(false)
		WeaponName = "Tanto"
		tween.tween_callback(_refresh_buttons)
	elif frontIndicator == 1:
		var tween = create_tween()
		#prints(dagger.progress_ratio, "THIS BITCH")
		dagger.progress_ratio = 0
		tween.set_parallel(true)
		tween.tween_property(dagger, "progress_ratio", pos2, .5)
		tween.tween_property(trident, "progress_ratio", pos3, .5)
		tween.tween_property(bow, "progress_ratio", pos4, .5)
		tween.tween_property(mace, "progress_ratio", pos5, .5)
		tween.tween_property(katana, "progress_ratio", pos6, .5)
		tween.tween_property(slingshot, "progress_ratio", pos7, .5)
		tween.tween_property(fan, "progress_ratio", pos1, .5)
		tween.set_parallel(false)
		WeaponName = "Sensu"
		tween.tween_callback(_refresh_buttons)
	elif frontIndicator == 2:
		var tween = create_tween()
		fan.progress_ratio = 0
		tween.set_parallel(true)
		tween.tween_property(dagger, "progress_ratio", pos3, .5)
		tween.tween_property(trident, "progress_ratio", pos4, .5)
		tween.tween_property(bow, "progress_ratio", pos5, .5)
		tween.tween_property(mace, "progress_ratio", pos6, .5)
		tween.tween_property(katana, "progress_ratio", pos7, .5)
		tween.tween_property(slingshot, "progress_ratio", pos1, .5)
		tween.tween_property(fan, "progress_ratio", pos2, .5)
		tween.set_parallel(false)
		WeaponName = "Slingshot"
		tween.tween_callback(_refresh_buttons)
	elif frontIndicator == 3:
		var tween = create_tween()
		slingshot.progress_ratio = 0
		tween.set_parallel(true)
		tween.tween_property(dagger, "progress_ratio", pos4, .5)
		tween.tween_property(trident, "progress_ratio", pos5, .5)
		tween.tween_property(bow, "progress_ratio", pos6, .5)
		tween.tween_property(mace, "progress_ratio", pos7, .5)
		tween.tween_property(katana, "progress_ratio", pos1, .5)
		tween.tween_property(slingshot, "progress_ratio", pos2, .5)
		tween.tween_property(fan, "progress_ratio", pos3, .5)
		tween.set_parallel(false)
		WeaponName = "Katana"
		tween.tween_callback(_refresh_buttons)
	elif frontIndicator == 4:
		var tween = create_tween()
		katana.progress_ratio = 0
		tween.set_parallel(true)
		tween.tween_property(dagger, "progress_ratio", pos5, .5)
		tween.tween_property(trident, "progress_ratio", pos6, .5)
		tween.tween_property(bow, "progress_ratio", pos7, .5)
		tween.tween_property(mace, "progress_ratio", pos1, .5)
		tween.tween_property(katana, "progress_ratio", pos2, .5)
		tween.tween_property(slingshot, "progress_ratio", pos3, .5)
		tween.tween_property(fan, "progress_ratio", pos4, .5)
		tween.set_parallel(false)
		WeaponName = "Kanabo"
		tween.tween_callback(_refresh_buttons)
	elif frontIndicator == 5:
		var tween = create_tween()
		mace.progress_ratio = 0
		tween.set_parallel(true)
		tween.tween_property(dagger, "progress_ratio", pos6, .5)
		tween.tween_property(trident, "progress_ratio", pos7, .5)
		tween.tween_property(bow, "progress_ratio", pos1, .5)
		tween.tween_property(mace, "progress_ratio", pos2, .5)
		tween.tween_property(katana, "progress_ratio", pos3, .5)
		tween.tween_property(slingshot, "progress_ratio", pos4, .5)
		tween.tween_property(fan, "progress_ratio", pos5, .5)
		tween.set_parallel(false)
		WeaponName = "Yumi"
		tween.tween_callback(_refresh_buttons)
	elif frontIndicator == 6:
		var tween = create_tween()
		bow.progress_ratio = 0
		tween.set_parallel(true)
		tween.tween_property(dagger, "progress_ratio", pos7, .5)
		tween.tween_property(trident, "progress_ratio", pos1, .5)
		tween.tween_property(bow, "progress_ratio", pos2, .5)
		tween.tween_property(mace, "progress_ratio", pos3, .5)
		tween.tween_property(katana, "progress_ratio", pos4, .5)
		tween.tween_property(slingshot, "progress_ratio", pos5, .5)
		tween.tween_property(fan, "progress_ratio", pos6, .5)
		tween.set_parallel(false)
		WeaponName = "Yari"
		tween.tween_callback(_refresh_buttons)

func _miko():
	whosSelect.text = ("- Miko -")
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property($CanvasLayer/Miko, "global_position", $mikoend.global_position, .2)
	tween.tween_property($CanvasLayer/Miko, "modulate:a", 1/1, .2)
	tween.tween_property($CanvasLayer/Heiko, "global_position", $heikostart.global_position, .2)
	tween.tween_property($CanvasLayer/Heiko, "modulate:a", .5/1, .2)
	
func _heiko():
	whosSelect.text = ("- Heiko -")
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property($CanvasLayer/Heiko, "global_position", $heikoend.global_position, .2)
	tween.tween_property($CanvasLayer/Heiko, "modulate:a", 1/1, .2)
	tween.tween_property($CanvasLayer/Miko, "global_position", $mikostart.global_position, .2)
	tween.tween_property($CanvasLayer/Miko, "modulate:a", .5/1, .2)
	
func _switch_weapon_left():
	if frontIndicator >= 7:
		#trident.progress_ratio = 0
		frontIndicator = 0
	if frontIndicator <= -1:
		frontIndicator = 6
	if frontIndicator == 0:
		var tween = create_tween()
		fan.progress_ratio = 1
		tween.set_parallel(true)
		tween.tween_property(dagger, "progress_ratio", pos0, .5)
		tween.tween_property(trident, "progress_ratio", pos2, .5)
		tween.tween_property(bow, "progress_ratio", pos3, .5)
		tween.tween_property(mace, "progress_ratio", pos4, .5)
		tween.tween_property(katana, "progress_ratio", pos5, .5)
		tween.tween_property(slingshot, "progress_ratio", pos6, .5)
		tween.tween_property(fan, "progress_ratio", pos7, .5)
		tween.set_parallel(false)
		WeaponName = "Tanto"
		tween.tween_callback(_refresh_buttons)
	elif frontIndicator == 6:
		var tween = create_tween()
		#prints(dagger.progress_ratio, "THIS BITCH")
		dagger.progress_ratio = 1
		tween.set_parallel(true)
		tween.tween_property(dagger, "progress_ratio", pos7, .5)
		tween.tween_property(trident, "progress_ratio", pos0, .5)
		tween.tween_property(bow, "progress_ratio", pos2, .5)
		tween.tween_property(mace, "progress_ratio", pos3, .5)
		tween.tween_property(katana, "progress_ratio", pos4, .5)
		tween.tween_property(slingshot, "progress_ratio", pos5, .5)
		tween.tween_property(fan, "progress_ratio", pos6, .5)
		tween.set_parallel(false)
		WeaponName = "Yari"
		tween.tween_callback(_refresh_buttons)
	elif frontIndicator == 5:
		var tween = create_tween()
		trident.progress_ratio = 1
		tween.set_parallel(true)
		tween.tween_property(dagger, "progress_ratio", pos6, .5)
		tween.tween_property(trident, "progress_ratio", pos7, .5)
		tween.tween_property(bow, "progress_ratio", pos0, .5)
		tween.tween_property(mace, "progress_ratio", pos2, .5)
		tween.tween_property(katana, "progress_ratio", pos3, .5)
		tween.tween_property(slingshot, "progress_ratio", pos4, .5)
		tween.tween_property(fan, "progress_ratio", pos5, .5)
		tween.set_parallel(false)
		WeaponName = "Yumi"
		tween.tween_callback(_refresh_buttons)
	elif frontIndicator == 4:
		var tween = create_tween()
		bow.progress_ratio = 1
		tween.set_parallel(true)
		tween.tween_property(dagger, "progress_ratio", pos5, .5)
		tween.tween_property(trident, "progress_ratio", pos6, .5)
		tween.tween_property(bow, "progress_ratio", pos7, .5)
		tween.tween_property(mace, "progress_ratio", pos0, .5)
		tween.tween_property(katana, "progress_ratio", pos2, .5)
		tween.tween_property(slingshot, "progress_ratio", pos3, .5)
		tween.tween_property(fan, "progress_ratio", pos4, .5)
		tween.set_parallel(false)
		WeaponName = "Yanabo"
		tween.tween_callback(_refresh_buttons)
	elif frontIndicator == 3:
		var tween = create_tween()
		mace.progress_ratio = 1
		tween.set_parallel(true)
		tween.tween_property(dagger, "progress_ratio", pos4, .5)
		tween.tween_property(trident, "progress_ratio", pos5, .5)
		tween.tween_property(bow, "progress_ratio", pos6, .5)
		tween.tween_property(mace, "progress_ratio", pos7, .5)
		tween.tween_property(katana, "progress_ratio", pos0, .5)
		tween.tween_property(slingshot, "progress_ratio", pos2, .5)
		tween.tween_property(fan, "progress_ratio", pos3, .5)
		tween.set_parallel(false)
		WeaponName = "Katana"
		tween.tween_callback(_refresh_buttons)
	elif frontIndicator == 2:
		var tween = create_tween()
		katana.progress_ratio = 1
		tween.set_parallel(true)
		tween.tween_property(dagger, "progress_ratio", pos3, .5)
		tween.tween_property(trident, "progress_ratio", pos4, .5)
		tween.tween_property(bow, "progress_ratio", pos5, .5)
		tween.tween_property(mace, "progress_ratio", pos6, .5)
		tween.tween_property(katana, "progress_ratio", pos7, .5)
		tween.tween_property(slingshot, "progress_ratio", pos0, .5)
		tween.tween_property(fan, "progress_ratio", pos2, .5)
		tween.set_parallel(false)
		WeaponName = "Slingshot"
		tween.tween_callback(_refresh_buttons)
	elif frontIndicator == 1:
		var tween = create_tween()
		slingshot.progress_ratio = 1
		tween.set_parallel(true)
		tween.tween_property(dagger, "progress_ratio", pos2, .5)
		tween.tween_property(trident, "progress_ratio", pos3, .5)
		tween.tween_property(bow, "progress_ratio", pos4, .5)
		tween.tween_property(mace, "progress_ratio", pos5, .5)
		tween.tween_property(katana, "progress_ratio", pos6, .5)
		tween.tween_property(slingshot, "progress_ratio", pos7, .5)
		tween.tween_property(fan, "progress_ratio", pos0, .5)
		tween.set_parallel(false)
		WeaponName = "Sensu"
		tween.tween_callback(_refresh_buttons)
		
func _on_miko_pressed() -> void:
	_miko()

func _on_heiko_pressed() -> void:
	_heiko()


#func _on_timer_timeout() -> void:
	#$Timer.start
	#dagger.progress_ratio += .001
	#trident.progress_ratio += .001
	#bow.progress_ratio += .001
	#mace.progress_ratio += .001
	#katana.progress_ratio += .001
	#slingshot.progress_ratio += .001
	#fan.progress_ratio += .001
func _refresh_buttons():
	$CanvasLayer/WeaponName.text = WeaponName
	arrows_disabled = false
	$CanvasLayer/ButtonArrow/TextureButton.disabled = false
	$CanvasLayer/ButtonArrow2/TextureButton2.disabled = false
	if type == 1:
		pass
	elif type == 2:
		pass
	elif type == 3:
		pass
	elif type == 4:
		pass
	elif type == 5:
		pass
	elif type == 6:
		pass
	elif type == 7:
		pass

func _on_texture_button_pressed() -> void:
	frontIndicator -= 1
	_switch_weapon_left()
	$CanvasLayer/ButtonArrow/TextureButton.disabled = true
	$CanvasLayer/ButtonArrow2/TextureButton2.disabled = true
	
func _on_texture_button_2_pressed() -> void:
	frontIndicator += 1
	_switch_weapon_right()
	$CanvasLayer/ButtonArrow/TextureButton.disabled = true
	$CanvasLayer/ButtonArrow2/TextureButton2.disabled = true
	
#func _input(event: InputEvent) -> void:
	#if arrows_disabled == false:
		#if event.is_action_pressed("ui_right"):
			#arrows_disabled = true
			#frontIndicator += 1
			#_switch_weapon_right()
			#$CanvasLayer/ButtonArrow/TextureButton.disabled = true
			#$CanvasLayer/ButtonArrow2/TextureButton2.disabled = true
		#elif event.is_action_pressed("ui_left"):
			#arrows_disabled = true
			#frontIndicator -= 1
			#_switch_weapon_left()
			#$CanvasLayer/ButtonArrow/TextureButton.disabled = true
			#$CanvasLayer/ButtonArrow2/TextureButton2.disabled = true
