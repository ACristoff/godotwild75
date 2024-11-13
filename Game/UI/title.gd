extends Node2D

@onready var Settings = $UI/Settings
@onready var MainMenu = $UI/MainMenu

@onready var logosfx = preload("res://Assets/Audio/UI/BERET PARADE Cadence rev 2.mp3")
@onready var washsfx = preload("res://Assets/Audio/UI/Title Splash Screen Transition.mp3")
@onready var titlebgm = preload("res://Assets/Audio/Music/MM Theme but again.mp3")

var fullscreen = false
var on1 = true
var on2 = true
var played = false
var click = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func EnableClick():
	click = true
	
func LogoSFX():
	AudioManager.play_sfx(logosfx, 1)
func WashSFX():
	AudioManager.play_sfx(washsfx, 1)
func TitleMusic():
	AudioManager.play_sfx(titlebgm, 1)
	
func BarrelSequence():
	var tween = create_tween()
	tween.tween_property($Barrel, "scale", Vector2(4.5, 3.5), .25)
	tween.tween_property($Barrel, "scale", Vector2(3.5, 4.5), .25)
	tween.tween_property($Barrel, "scale", Vector2(4, 4), .5)
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
