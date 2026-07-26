extends Node

var audio_player: AudioStreamPlayer

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.bus = "Master" 
	play_music("res://audio/music.wav", -22.0)

func play_music(file_path: String, volume_db: float = 0.0) -> void:
	if audio_player.stream and audio_player.stream.resource_path == file_path and audio_player.playing:
		return
	var stream = load(file_path)
	if stream:
		audio_player.stream = stream
		audio_player.volume_db = volume_db
		audio_player.play()
	else:
		push_error("Konnte Musik nicht laden unter: " + file_path)
