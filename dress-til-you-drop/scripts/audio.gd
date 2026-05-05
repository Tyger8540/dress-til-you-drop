extends Node

@onready var tree := get_tree()


func play_sound(sound: AudioStream, volume := 0.0, autoplay := true) -> AudioStreamPlayer:
	var audio_player := AudioStreamPlayer.new()
	audio_player.bus = "SFX"
	audio_player.stream = sound
	audio_player.volume_db = volume
	audio_player.autoplay = autoplay
	audio_player.finished.connect(func(): audio_player.queue_free())
	tree.current_scene.add_child.call_deferred(audio_player)
	return audio_player


func play_music(track: AudioStream, volume := 0.0, autoplay := true, parent := tree.current_scene) -> AudioStreamPlayer:
	var music_player := AudioStreamPlayer.new()
	music_player.bus = "Music"
	music_player.stream = track
	music_player.volume_db = volume
	music_player.autoplay = autoplay
	music_player.finished.connect(func(): music_player.queue_free())
	parent.add_child.call_deferred(music_player)
	return music_player


func pause_music() -> void:
	for child in tree.current_scene.get_children():
		if child is AudioStreamPlayer and child.bus == "Music":
			child.set_stream_paused(true)


func resume_music() -> void:
	for child in tree.current_scene.get_children():
		if child is AudioStreamPlayer and child.bus == "Music":
			child.set_stream_paused(false)
