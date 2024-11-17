extends Node2D

var tutorial = 1

var heiko = Color.from_hsv(41.0/359.0, 74.0/100.0, 100.0/100.0, 1.0/1.0 )
var miko = Color.from_hsv(347.0/359.0, 62.0/100.0, 100.0/100.0, 1.0/1.0 )

var tutsongo = preload("res://Assets/Audio/Music/MM_Tutorial_Town.mp3")

@onready var bodytext = $Text
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager._play_music(tutsongo, -9)
	$ColorRect.mouse_filter = 2
	bodytext["theme_override_colors/font_color"] = heiko
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tutorial == 1:
		bodytext.text = "You're lucky I found you when I did!"
		$Label.visible = true
	elif tutorial == 2:
		$Label.visible = false
		bodytext.text = "I've never seen Kappa so aggressive! Especially in groups."
	elif tutorial == 3:
		bodytext.text = "You don't seem all too familiar with combat"
	elif tutorial == 4:
		bodytext["theme_override_colors/font_color"] = heiko
		bodytext.text = "My name is Heiko"
		$MikoSweep.visible = false
		$HeikoTutorial.visible = true
	elif tutorial == 5:
		bodytext["theme_override_colors/font_color"] = miko
		$MikoSweep.visible = true
		$HeikoTutorial.visible = false
		bodytext.text = "I can see my spirit. That Kappa severed the bond between my body and spirit!"
	elif tutorial == 6:
		bodytext["theme_override_colors/font_color"] = heiko
		$MikoSweep.visible = false
		$HeikoTutorial.visible = true
		bodytext.text = "You have no choice but to go after it then"
	elif tutorial == 7:
		$Panel1.visible = false
		$HeikoTutorial.frame = 0
		bodytext.text = "Let me teach you how to fight, even a simple girl like you is hopeless against low-level Yokai"
	elif tutorial == 8:
		$Panel1.visible = true
		bodytext.text = "Firstly, When a Yokai dies, it's immense spiritual energy causes explosions in the opposite world that it died in."
		$HeikoTutorial.frame = 1
	elif tutorial == 9:
		$Panel2.visible = false
		$HeikoTutorial.frame = 0
		bodytext.text = "We call these, Spirit Bombs, they are absolutely lethal, Human and Yokai Beware."
	elif tutorial == 10:
		$Panel1.visible = false
		$Panel2.visible = true
		bodytext.text = "Next, Your spirit is tethered to your body and vice versa, Yokai inhabit both realms and if either your body or spirit is destroyed... it's over."
	elif tutorial == 11:
		$Panel3.visible = false
		$Panel2.visible = false
		$HeikoTutorial.frame = 0
		bodytext.text = "Lastly, every turn you get 2 actions"
	elif tutorial == 12:
		$Panel4.visible = false
		$Panel3.visible = true
		$HeikoTutorial.frame = 1
		bodytext.text = "Move: You can pick squares to move to, to gain a better attacking position"
	elif tutorial == 13:
		$Panel3.visible = false
		$Panel4.visible = true
		$HeikoTutorial.frame = 1
		bodytext.text = "Attack: During attack you can inflict damage on Yokai, if a Yokai dies it will cause a spirit blast in the other realm."
	elif tutorial == 14:
		$Panel4.visible = false
		$HeikoTutorial.frame = 0
		bodytext.text = "Once you've exhausted your actions, your enemies get a turn of their own"
	elif tutorial == 15:
		$Panel4.visible = false
		$HeikoTutorial.frame = 0
		bodytext.text = "And don't forget, Yokai are spiritual beings, if you kill a Yokai in the overworld, it will flee to the spirit world"
	elif tutorial == 16:
		$Panel4.visible = false
		$HeikoTutorial.frame = 0
		bodytext.text = "Did you get all that?"
		$ColorRect.mouse_filter = 0
		$"letsago!".visible = true
		$restart.visible = true
	elif tutorial == 17:
		bodytext.text = "I see those Kappa from before. Lets put what you learnt into action!"


func _on_next_panel_pressed() -> void:
	tutorial += 1
	#print("next")


func _on_undo_pressed() -> void:
	if tutorial <= 1:
		tutorial = 1
	else:
		tutorial -= 1
	#print("undo")


func _on_letsago_pressed() -> void:
	$ColorRect.mouse_filter = 2
	$"letsago!".visible = false
	$restart.visible = false
	tutorial = 1


func _on_restart_pressed() -> void:
	#i mixed them up this starts the game
	tutorial = 17
