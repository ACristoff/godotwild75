extends Node2D



#ALEX DID NOT WRITE THIS CODE CALEB DID
@onready var daggersound = preload("res://Assets/Audio/UI/WeaponSounds/MM_Blade_Attack.mp3")
@onready var fansound = preload("res://Assets/Audio/UI/WeaponSounds/MM_Fan_Attack.mp3")
@onready var slingshotsound = preload("res://Assets/Audio/UI/WeaponSounds/MM_Slingshot_Attack.mp3")
@onready var katanasound = preload("res://Assets/Audio/UI/WeaponSounds/MM_Blade_Attack.mp3")
@onready var macesound = preload("res://Assets/Audio/UI/WeaponSounds/MM_Club_Attack.mp3")
@onready var bowsound = preload("res://Assets/Audio/UI/WeaponSounds/MM_Bow_Attack.mp3")
@onready var tridentsound = preload("res://Assets/Audio/UI/WeaponSounds/MM_Trident_Attack.mp3")
@onready var flame = preload("res://Assets/Effects/flame_infusion.tscn")
@onready var weaposongo = preload("res://Assets/Audio/Music/Weapon_Shop.mp3")

var mikoChosen = true
var onibi : int
var onibi_refund
var frontIndicator = 0
var arrows_disabled = false
var WeaponName = ""
var cost = 50
var type = 1
var gameManager
var mikoEquip
var heikoEquip
var fill_price = 0
var price = 50
var frequency = .09
var loop_break = false
var accept = true
var bought1 = false
var bought2 = false
var bought3 = false
var bought4 = false
var bought5 = false
var bought6 = false
var bought7 = false
var chosen_weapon = ""

signal confirm_weapon
signal on_unlock

var manager: GameManager

#@onready var whosSelect = $CanvasLayer/MarginContainer/VBoxContainer/MarginContainer/Label2
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

var weapon_dummy_data = {
	"Dagger": {
		"state" : 'UNLOCKED',
		"isSelected" : true
	},
	"Fan": {
		"state" : 'LOCKED',
		"isSelected" : false
	},
	"Slingshot": {
		"state" : 'LOCKED',
		"isSelected" : false
	},
	"Katana": {
		"state" : 'LOCKED',
		"isSelected" : false
	},
	"Mace": {
		"state" : 'LOCKED',
		"isSelected" : false
	},
	"Bow": {
		"state" : 'LOCKED',
		"isSelected" : false
	},
	"Trident": {
		"state" : 'LOCKED',
		"isSelected" : false
	}
}

func _ready() -> void:
	AudioManager._play_music(weaposongo, -9)
	#$AudioStreamPlayer2D2.play()
	manager = get_node("/root/GameManager")
	#print(manager.weapon_data, weapon_dummy_data)
	
	_locker(LevelManager.onibi, manager.weapon_data)
	#onibi = 10000
	
	#print(manager)
	
	_miko()
	var tween = create_tween()
	tween.tween_property(dagger, "progress_ratio", pos1, 0)
	tween.tween_property(trident, "progress_ratio", pos2, 0)
	tween.tween_property(bow, "progress_ratio", pos3, 0)
	tween.tween_property(mace, "progress_ratio", pos4, 0)
	tween.tween_property(katana, "progress_ratio", pos5, 0)
	tween.tween_property(slingshot, "progress_ratio", pos6, 0)
	tween.tween_property(fan, "progress_ratio", pos7, 0)

func _locker(currency: int, weapon_data) -> void:
	onibi = currency
	for weapon in weapon_data:
		if weapon_data[weapon].state == 'UNLOCKED' and weapon == "Dagger":
			unlock_dagger()
			if weapon_data[weapon].isSelected == true:
				select_dagger()
		if weapon_data[weapon].state == 'UNLOCKED' and weapon == "Fan":
			unlock_fan()
			if weapon_data[weapon].isSelected == true:
				select_fan()
		if weapon_data[weapon].state == 'UNLOCKED' and weapon == "Slingshot":
			unlock_slingshot()
			if weapon_data[weapon].isSelected == true:
				select_slingshot()
		if weapon_data[weapon].state == 'UNLOCKED' and weapon == "Katana":
			unlock_katana()
			if weapon_data[weapon].isSelected == true:
				select_katana()
		if weapon_data[weapon].state == 'UNLOCKED' and weapon == "Mace":
			unlock_mace()
			if weapon_data[weapon].isSelected == true:
				select_mace()
		if weapon_data[weapon].state == 'UNLOCKED' and weapon == "Bow":
			unlock_bow()
			if weapon_data[weapon].isSelected == true:
				select_bow()
		if weapon_data[weapon].state == 'UNLOCKED' and weapon == "Trident":
			unlock_trident()
			if weapon_data[weapon].isSelected == true:
				select_trident()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Value.text = str(onibi)
	if arrows_disabled == false:
		if Input.is_action_pressed("ui_right"):
			InfoHide()
			#update_select()
			arrows_disabled = true
			frontIndicator += 1
			_switch_weapon_right()
			$CanvasLayer/ButtonArrow/TextureButton.disabled = true
			$CanvasLayer/ButtonArrow2/TextureButton2.disabled = true
		elif Input.is_action_pressed("ui_left"):
			InfoHide()
			#update_select()
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
		cost = 50
		type = 1
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
		cost = 80
		WeaponName = "Sensu"
		type = 2
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
		cost = 100
		WeaponName = "Slingshot"
		type = 3
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
		cost = 240
		type = 4
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
		cost = 400
		type = 5
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
		cost = 520
		type = 6
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
		type = 7
		cost = 888
		tween.tween_callback(_refresh_buttons)

func _miko():
	#whosSelect.text = ("- Miko -")
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property($CanvasLayer/Miko, "global_position", $mikoend.global_position, .2)
	tween.tween_property($CanvasLayer/Miko, "modulate:a", 1/1, .2)
	tween.tween_property($CanvasLayer/Heiko, "global_position", $heikostart.global_position, .2)
	tween.tween_property($CanvasLayer/Heiko, "modulate:a", .5/1, .2)
	
func _heiko():
	#whosSelect.text = ("- Heiko -")
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
		type = 1
		cost = 50
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
		cost = 888
		type = 7
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
		cost = 520
		type = 6
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
		cost = 400
		type = 5
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
		cost = 240
		type = 4
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
		cost = 100
		type = 3
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
		type = 2
		cost = 80
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
	$CanvasLayer/BeginBattles.disabled = false
	$AudioStreamPlayer2D.pitch_scale = .3
	update_select()
	accept = true
	loop_break = false
	$CanvasLayer/WeaponName.text = WeaponName
	arrows_disabled = false
	$CanvasLayer/ButtonArrow/TextureButton.disabled = false
	$CanvasLayer/ButtonArrow2/TextureButton2.disabled = false
	$CanvasLayer/Infuse.disabled = false
	if type == 1:
		price = 50
		frequency = .09
		$Path2D/Pnt1/Dagger/ColorRect.visible = true
		$Path2D/Pnt1/Cost.visible = true
	elif type == 2:
		price = 80
		frequency = .08
		$Path2D/Pnt7/Fan/ColorRect.visible = true
		$Path2D/Pnt7/Cost.visible = true
	elif type == 3:
		frequency = .07
		$Path2D/Pnt6/Slingshot/ColorRect.visible = true
		$Path2D/Pnt6/Cost.visible = true
		price = 100
	elif type == 4:
		frequency = .05
		$Path2D/Pnt5/Katana/ColorRect.visible = true
		$Path2D/Pnt5/Cost.visible = true
		price = 240
	elif type == 5:
		frequency = .02
		$Path2D/Pnt4/Mace/ColorRect.visible = true
		$Path2D/Pnt4/Cost.visible = true
		price = 400
	elif type == 6:
		frequency = .01
		$Path2D/Pnt3/Bow/ColorRect.visible = true
		$Path2D/Pnt3/Cost.visible = true
		price = 520
	elif type == 7:
		frequency = .008
		$Path2D/Pnt2/Trident/ColorRect.visible = true
		$Path2D/Pnt2/Cost.visible = true
		price = 888
		
		
func InfoHide():
	
	$Path2D/Pnt7/Fan/ColorRect.visible = false
	$Path2D/Pnt2/Trident/ColorRect.visible = false
	$Path2D/Pnt6/Slingshot/ColorRect.visible = false
	$Path2D/Pnt5/Katana/ColorRect.visible = false
	$Path2D/Pnt4/Mace/ColorRect.visible = false
	$Path2D/Pnt3/Bow/ColorRect.visible = false
	$Path2D/Pnt1/Dagger/ColorRect.visible = false
	$Path2D/Pnt1/Cost.visible = false
	$Path2D/Pnt2/Cost.visible = false
	$Path2D/Pnt3/Cost.visible = false
	$Path2D/Pnt4/Cost.visible = false
	$Path2D/Pnt5/Cost.visible = false
	$Path2D/Pnt6/Cost.visible = false
	$Path2D/Pnt7/Cost.visible = false
func _on_texture_button_pressed() -> void:
	InfoHide()
	#update_select()
	arrows_disabled = true
	frontIndicator -= 1
	_switch_weapon_left()
	$CanvasLayer/ButtonArrow/TextureButton.disabled = true
	$CanvasLayer/ButtonArrow2/TextureButton2.disabled = true
	
func _on_texture_button_2_pressed() -> void:
	InfoHide()
	#update_select()
	arrows_disabled = true
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
func unlock_dagger():
	on_unlock.emit("dagger")
	bought1 = true
	update_select()
	_refresh_buttons()
	fill_price = 0
	$Path2D/Pnt1/Cost.modulate.a = 0.0/255.0
	loop_break = true
	$Path2D/Pnt1/Dagger.value = 50
func unlock_fan():
	on_unlock.emit("fan")
	bought2 = true
	update_select()
	_refresh_buttons()
	fill_price = 0
	$Path2D/Pnt7/Cost.modulate.a = 0.0/255.0
	loop_break = true
	$Path2D/Pnt7/Fan.value = 80
func unlock_slingshot():
	on_unlock.emit("slingshot")
	bought3 = true
	update_select()
	_refresh_buttons()
	fill_price = 0
	$Path2D/Pnt6/Cost.modulate.a = 0.0/255.0
	loop_break = true
	$Path2D/Pnt6/Slingshot.value = 100
func unlock_katana():
	on_unlock.emit("katana")
	bought4 = true
	update_select()
	_refresh_buttons()
	fill_price = 0
	$Path2D/Pnt5/Cost.modulate.a = 0.0/255.0
	loop_break = true
	$Path2D/Pnt5/Katana.value = 240
func unlock_mace():
	on_unlock.emit("mace")
	bought5 = true
	update_select()
	_refresh_buttons()
	fill_price = 0
	$Path2D/Pnt4/Cost.modulate.a = 0.0/255.0
	loop_break = true
	$Path2D/Pnt4/Mace.value = 400
func unlock_bow():
	on_unlock.emit("bow")
	bought6 = true
	update_select()
	_refresh_buttons()
	fill_price = 0
	$Path2D/Pnt3/Cost.modulate.a = 0.0/255.0
	loop_break = true
	$Path2D/Pnt3/Bow.value = 520
func unlock_trident():
	on_unlock.emit("trident")
	bought7 = true
	update_select()
	_refresh_buttons()
	fill_price = 0
	$Path2D/Pnt2/Cost.modulate.a = 0.0/255.0
	loop_break = true
	$Path2D/Pnt2/Trident.value = 888
func fill_selection():
	fill_price += 1
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D.pitch_scale += .005
	update_visuals()
func update_visuals():
	if accept == true:
		if type == 1:
			$Path2D/Pnt1/Cost.text = str(fill_price) + "/50"
			$Path2D/Pnt1/Dagger.value = fill_price
			if fill_price == 50:
				unlock_dagger()
				manager.weapon_data["Dagger"]["state"] = "UNLOCKED"
		elif type == 2:
			$Path2D/Pnt7/Cost.text = str(fill_price) + "/80"
			$Path2D/Pnt7/Fan.value = fill_price
			if fill_price == 80:
				unlock_fan()
				manager.weapon_data["Fan"]["state"] = "UNLOCKED"
		elif type == 3:
			$Path2D/Pnt6/Cost.text = str(fill_price) + "/100"
			$Path2D/Pnt6/Slingshot.value = fill_price
			if fill_price == 100:
				unlock_slingshot()
				manager.weapon_data["Slingshot"]["state"] = "UNLOCKED"
		elif type == 4:
			$Path2D/Pnt5/Cost.text = str(fill_price) + "/240"
			$Path2D/Pnt5/Katana.value = fill_price
			if fill_price == 240:
				unlock_katana()
				manager.weapon_data["Katana"]["state"] = "UNLOCKED"
		elif type == 5:
			$Path2D/Pnt4/Cost.text = str(fill_price) + "/400"
			$Path2D/Pnt4/Mace.value = fill_price
			if fill_price == 400:
				unlock_mace()
				manager.weapon_data["Mace"]["state"] = "UNLOCKED"
		elif type == 6:
			$Path2D/Pnt3/Cost.text = str(fill_price) + "/520"
			$Path2D/Pnt3/Bow.value = fill_price
			if fill_price == 520:
				unlock_bow()
				manager.weapon_data["Bow"]["state"] = "UNLOCKED"
		elif type == 7:
			$Path2D/Pnt2/Cost.text = str(fill_price) + "/888"
			$Path2D/Pnt2/Trident.value = fill_price
			if fill_price == 888:
				unlock_trident()
				manager.weapon_data["Trident"]["state"] = "UNLOCKED"
func update_select():
	if type == 1:
		if bought1:
			$CanvasLayer/Select7.visible = false
			$CanvasLayer/Select.visible = true
			$CanvasLayer/Select2.visible = false
		else:
			$CanvasLayer/Select2.visible = false
			$CanvasLayer/Select7.visible = false
	elif type == 2:
		if bought2:
			$CanvasLayer/Select3.visible = false
			$CanvasLayer/Select2.visible = true
			$CanvasLayer/Select.visible = false
		else:
			$CanvasLayer/Select.visible = false
			$CanvasLayer/Select3.visible = false
	elif type == 3:
		if bought3:
			$CanvasLayer/Select3.visible = true
			$CanvasLayer/Select2.visible = false
			$CanvasLayer/Select4.visible = false
		else:
			$CanvasLayer/Select2.visible = false
			$CanvasLayer/Select4.visible = false
	elif type == 4:
		if bought4:
			$CanvasLayer/Select3.visible = false
			$CanvasLayer/Select4.visible = true
			$CanvasLayer/Select5.visible = false
		else:
			$CanvasLayer/Select3.visible = false
			$CanvasLayer/Select5.visible = false
	elif type == 5:
		if bought5:
			$CanvasLayer/Select4.visible = false
			$CanvasLayer/Select5.visible = true
			$CanvasLayer/Select6.visible = false
		else:
			$CanvasLayer/Select4.visible = false
			$CanvasLayer/Select6.visible = false
	elif type == 6:
		if bought6:
			$CanvasLayer/Select5.visible = false
			$CanvasLayer/Select6.visible = true
			$CanvasLayer/Select7.visible = false
		else:
			$CanvasLayer/Select5.visible = false
			$CanvasLayer/Select7.visible = false
	elif type == 7:
		if bought7:
			$CanvasLayer/Select6.visible = false
			$CanvasLayer/Select7.visible = true
			$CanvasLayer/Select.visible = false
		else:
			$CanvasLayer/Select6.visible = false
			$CanvasLayer/Select.visible = false
			
func _on_infuse_pressed() -> void:
	onibi_refund = 0
	arrows_disabled = true
	$CanvasLayer/BeginBattles.disabled = true
	$CanvasLayer/ButtonArrow/TextureButton.disabled = true
	$CanvasLayer/ButtonArrow2/TextureButton2.disabled = true
	$CanvasLayer/Infuse.disabled = true
	if onibi == cost:
		for i in cost:
			if !loop_break:
				if onibi != 0:
					#print(onibi_refund)
					onibi -= 1
					#$AudioStreamPlayer2D.pitch_scale += .5
					onibi_refund += 1
					await(get_tree().create_timer(frequency).timeout)
					#print("hi")
					var FLAME = flame.instantiate()
					self.add_child(FLAME)
					FLAME.follow.progress_ratio = 0
					FLAME.connect("fill", fill_selection)
				else:
					#onibi = onibi_refund
					#fill_price = 0
					break
			else:
				break
			#$AudioStreamPlayer2D.pitch_scale = .3
	elif onibi > cost:
		for i in cost:
			if loop_break == false:
				if onibi != 0:
					#print(onibi_refund)
					onibi -= 1
					onibi_refund += 1
					#$AudioStreamPlayer2D.pitch_scale += .5
					await(get_tree().create_timer(frequency).timeout)
					#print("hi")
					var FLAME = flame.instantiate()
					self.add_child(FLAME)
					FLAME.follow.progress_ratio = 0
					FLAME.connect("fill", fill_selection)
				else:
					#onibi = onibi_refund
					#fill_price = 0
					break
			else:
				break
			#$AudioStreamPlayer2D.pitch_scale = .3
	elif onibi < cost:
		for i in onibi:
			if loop_break == false:
				if onibi != 0:
					#print(onibi_refund)
					onibi -= 1
					onibi_refund += 1
					await(get_tree().create_timer(frequency).timeout)
					#print("hi")
					var FLAME = flame.instantiate()
					self.add_child(FLAME)
					FLAME.follow.progress_ratio = 0
					FLAME.connect("fill", fill_selection)
				else:
					#onibi = onibi_refund
					#fill_price = 0
					break
			else:
				break
		var active_onibi = get_tree().get_nodes_in_group("onibi")
		for onibi_to_be_killed in active_onibi:
			onibi_to_be_killed.queue_free()
		onibi = onibi_refund
		fill_price = 0
		#$AudioStreamPlayer2D.pitch_scale = .3
		update_visuals()
		_refresh_buttons()

func select_dagger():
	chosen_weapon = ("dagger")
	$CanvasLayer/Select/Label.text = ("Selected")
func select_fan():
	chosen_weapon = ("fan")
	$CanvasLayer/Select2/Label.text = ("Selected")
func select_slingshot():
	chosen_weapon = ("slingshot")
	$CanvasLayer/Select3/Label.text = ("Selected")
func select_katana():
	chosen_weapon = ("katana")
	$CanvasLayer/Select4/Label.text = ("Selected")
func select_mace():
	chosen_weapon = ("mace")
	$CanvasLayer/Select5/Label.text = ("Selected")
func select_bow():
	chosen_weapon = ("bow")
	$CanvasLayer/Select6/Label.text = ("Selected")
func select_trident():
	chosen_weapon = ("mace")
	$CanvasLayer/Select7/Label.text = ("Selected")

func _on_select_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		chosen_weapon = ("Dagger")
		$CanvasLayer/Select/Label.text = ("Selected")
		AudioManager.play_sfx(daggersound, 1)
	else:
		$CanvasLayer/Select/Label.text = ("Select")
func _on_select_2_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		chosen_weapon = ("Fan")
		$CanvasLayer/Select2/Label.text = ("Selected")
		AudioManager.play_sfx(fansound, 1)
	else:
		$CanvasLayer/Select2/Label.text = ("Select")
func _on_select_3_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		chosen_weapon = ("Slingshot")
		$CanvasLayer/Select3/Label.text = ("Selected")
		AudioManager.play_sfx(slingshotsound, 1)
	else:
		$CanvasLayer/Select3/Label.text = ("Select")
func _on_select_4_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		chosen_weapon = ("Katana")
		$CanvasLayer/Select4/Label.text = ("Selected")
		AudioManager.play_sfx(katanasound, 1)
	else:
		$CanvasLayer/Select4/Label.text = ("Select")
func _on_select_5_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		chosen_weapon = ("Mace")
		$CanvasLayer/Select5/Label.text = ("Selected")
		AudioManager.play_sfx(macesound, 1)
	else:
		$CanvasLayer/Select5/Label.text = ("Select")
func _on_select_6_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		chosen_weapon = ("Bow")
		$CanvasLayer/Select6/Label.text = ("Selected")
		AudioManager.play_sfx(bowsound, 1)
	else:
		$CanvasLayer/Select6/Label.text = ("Select")
func _on_select_7_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		chosen_weapon = ("Trident")
		$CanvasLayer/Select7/Label.text = ("Selected")
		AudioManager.play_sfx(tridentsound, 1)
	else:
		$CanvasLayer/Select7/Label.text = ("Select")


func _on_button_pressed() -> void:
	_confirmed()
	LevelManager.nextLevel()

func _confirmed():
	confirm_weapon.emit(chosen_weapon)
	var manager: GameManager = get_node("/root/GameManager")
	manager.weapon_data[chosen_weapon].isSelected = true
	print()
	pass
