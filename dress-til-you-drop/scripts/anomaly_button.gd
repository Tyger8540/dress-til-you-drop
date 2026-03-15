class_name AnomalyButton
extends Button

@export var connected_button: AnomalyButton
@export var textures: Array[Texture2D]
@export var anomaly_minigame: Control

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


func _on_button_up() -> void:
	if icon == connected_button.icon:
		print("not an anomaly!")
		# TODO make a disappointed sound or smth
	else:
		print("anomaly detected!")
		# TODO make a correct sound or smth
		# TODO change the icons color or smth
		#if icon:
			#play_animation()
		#else:
			#connected_button.play_animation()
		play_animation()
		connected_button.play_animation()
		await connected_button.animation.animation_finished
		icon = null
		connected_button.icon = null
		
		# TODO update count
		anomaly_minigame.anomaly_count -= 1
		anomaly_minigame.update_anomaly_count_text()
