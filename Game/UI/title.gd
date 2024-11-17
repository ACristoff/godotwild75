extends Node2D

@onready var Settings = $UI/Settings
@onready var MainMenu = $UI/MainMenu

@onready var logosfx = preload("res://Assets/Audio/UI/BERET PARADE Cadence rev 2.mp3")

@onready var bereparedosfx = [
	preload("res://Assets/Audio/UI/b00/b01.wav"),
	preload("res://Assets/Audio/UI/b00/b02.wav"),
	preload("res://Assets/Audio/UI/b00/b03.wav"),
	preload("res://Assets/Audio/UI/b00/b04.wav"),
	preload("res://Assets/Audio/UI/b00/b05.wav"),
	preload("res://Assets/Audio/UI/b00/b06.wav"),
	preload("res://Assets/Audio/UI/b00/b07.wav"),
	preload("res://Assets/Audio/UI/b00/b08.wav"),
	preload("res://Assets/Audio/UI/b00/b09.wav"),
]

@onready var washsfx = preload("res://Assets/Audio/UI/Title Splash Screen Transition.mp3")
@onready var titlebgm = preload("res://Assets/Audio/Music/MM Theme but again.mp3")
@onready var sweepsfx = preload("res://Assets/Audio/UI/Sweep_3.mp3")
@onready var kappasfx = preload("res://Assets/Audio/UI/Kappa.mp3")
@onready var kappabarrel = preload("res://Assets/Audio/UI/Kappa_In_Barrel.mp3")

var fullscreen = false
var on1 = true
var on2 = true
var played = false
var click = false

# Called when the node enters the scene tree for the first time.
func _ready():
	lock_pause()
	#print(titlebgm)
	pass # Replace with function body.

func lock_pause():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func EnableClick():
	click = true
	
func bereparedo():
	#print("HUH")
	AudioManager.play_sfx(logosfx, 1)
func LogoSFX():
	var random = randi_range(0,8)
	AudioManager.play_sfx_wav(bereparedosfx[random], 1)
func WashSFX():
	AudioManager.play_sfx(washsfx, -14)
func TitleMusic():
	#print("pls")
	AudioManager._play_music(titlebgm, -14)
func SweepSFX():
	$AudioStreamPlayer2D.play()
func Start_sweep():
	$MikoSweep/AnimationPlayer.play("sweep")
func Kacophany():
	$AudioStreamPlayer2D2.play()
func BarrelSequence():
	AudioManager.play_sfx(kappabarrel, 1)
	var tween = create_tween()
	tween.tween_property($Barrel, "scale", Vector2(4.2, 3.8), .33)
	tween.tween_property($Barrel, "scale", Vector2(3.8, 4.2), .33)
	tween.tween_property($Barrel, "scale", Vector2(4, 4), .44)
func SurpriseKappa():
	AudioManager.play_sfx(kappasfx, 1)
func SweepStop():
	$MikoSweep/AnimationPlayer.play("sweep_stop")
func MikoShiver():
	var shiver = true
func Escape():
	$KappaFullAnim/AnimationPlayer.play("kappa")
	
	
	
	
	
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event is not InputEventMouseMotion:
		if click and !played:
			$Cutscene.play("Main_Cutscene")
			played = true

func _on_start_game_pressed():
	LevelManager.nextLevel()

func _on_settings_pressed():
	Settings.visible = true
	MainMenu.visible = false

func _on_back_pressed():
	Settings.visible = false
	MainMenu.visible = true

func _on_exit_game_pressed():
	get_tree().quit()

func _on_fullscreen_pressed():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		$UI/Settings/HFlowContainer/Fullscreen.text = "Fullscreen"
		fullscreen = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		$UI/Settings/HFlowContainer/Fullscreen.text = "Windowed"
		fullscreen = true




func _on_sf_xbutt_pressed() -> void:
	if on1:
		#turn sounds off
		$SFXbutt/Music.frame = 1
		on1 = false
	else:
		#turn sounds on
		$SFXbutt/Music.frame = 0
		on1 = true
	


func _on_bg_mbutt_pressed() -> void:
	if on2:
		#turn music off
		$BGMbutt/Sound.frame = 1
		on2 = false
	else:
		#turn music on
		$BGMbutt/Sound.frame = 0
		on2 = true


func _on_cutscene_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Main_Cutscene":
		LevelManager.nextLevel()
