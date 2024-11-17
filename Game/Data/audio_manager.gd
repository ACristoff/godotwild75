extends AudioStreamPlayer


#const levelMusic = preload("res://assets/audio/psycho-logy.mp3")
#@export var LevelMusic : Array[AudioStreamMP3]
var current_music: AudioStreamMP3
var new_music: AudioStreamMP3
var new_volume: int

@onready var fade_timer = $FadeTimer

func _process(delta):
	#prints(current_music, new_music)
	if new_music && !fade_timer.is_stopped():
		#print("SUBTRACT VOLUME")
		volume_db = volume_db - (30 * delta)
	pass



func switch_songs():
	fade_timer.start()
	pass


func _play_music(music: AudioStreamMP3, volume = 0.0):
	#print('test', music)
	if current_music:
		new_music = music
		new_volume = volume
		switch_songs()
		return
	current_music = music
	stream = music
	volume_db = volume
	play()

func play_sfx(stream: AudioStreamMP3, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "FX_Player"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()


func play_sfx_wav(stream: AudioStreamWAV, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "FX_Player"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()


func _on_fade_timer_timeout():
	stream = new_music
	volume_db = new_volume
	play()
	current_music = new_music
	fade_timer.stop()
	pass # Replace with function body.
