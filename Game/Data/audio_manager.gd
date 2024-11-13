extends AudioStreamPlayer2D


#const levelMusic = preload("res://assets/audio/psycho-logy.mp3")
#@export var LevelMusic : Array[AudioStreamMP3]
var current_music: AudioStreamPlayer2D

func _play_music(music: AudioStream, volume = 0.0):
	stream = music
	volume_db = volume
	play()
	pass

func play_music_level(music: AudioStreamMP3):
	#_play_music(LevelMusic[level], -12)
	pass

func play_sfx(stream: AudioStreamMP3, volume = 0.0):
	var fx_player = AudioStreamPlayer2D.new()
	fx_player.stream = stream
	fx_player.name = "FX_Player"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()
