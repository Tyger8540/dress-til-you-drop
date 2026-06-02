extends Node

@onready var random_timer: Timer = $RandomTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.minigame_started.connect(_on_minigame_started)
	Signals.minigame_finished.connect(_on_minigame_done)
	Audio.play_music(load("res://audio/music/ambienceLoopable.wav"))
	random_timer.timeout.connect(play_random_variation)
	random_timer.start(randf_range(40.0, 80.0))


func play_random_variation() -> void:
	var audio_stream := Audio.play_music(load("res://audio/music/Theme_chillVariationLoopable.wav"))
	audio_stream.finished.connect(func(): random_timer.start(randf_range(40.0, 80.0)))


func _on_minigame_started(_node: Node) -> void:
	random_timer.paused = true


func _on_minigame_done() -> void:
	random_timer.paused = false
