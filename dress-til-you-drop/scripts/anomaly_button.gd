class_name AnomalyButton
extends Button

@export var connected_button: AnomalyButton
@export var textures: Array[Texture2D]
@export var anomaly_minigame: Control

var anomaly_detected: bool = false

@onready var animation: AnimatedSprite2D = $Animation


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon = textures.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func play_animation() -> void:
	animation.offset = size / 2.0
	animation.play()
	Audio.play_sound(load("res://audio/sfx/Minigames/Spot the Anomaly/STA_CorrectGuess.wav"))


func _on_button_up() -> void:
	if icon == connected_button.icon:
		print("not an anomaly!")
		# TODO make a disappointed sound or smth
		Audio.play_sound(load("res://audio/sfx/Minigames/Spot the Anomaly/STA_WrongGuess.wav"))
	else:
		print("anomaly detected!")
		if anomaly_detected:
			return
		else:
			anomaly_detected = true
			connected_button.anomaly_detected = true
		# TODO make a correct sound or smth
		#Audio.play_sound(load("res://audio/sfx/Minigames/Spot the Anomaly/STA_CorrectGuess.wav"))
		# TODO change the icons color or smth
		#if icon:
			#play_animation()
		#else:
			#connected_button.play_animation()
		play_animation()
		connected_button.play_animation()
		await connected_button.animation.animation_finished
		if icon == textures[0]:
			icon = textures[1]
		else:
			icon = textures[0]
		
		# TODO update count
		anomaly_minigame.anomaly_count -= 1
		anomaly_minigame.update_anomaly_count_text()
