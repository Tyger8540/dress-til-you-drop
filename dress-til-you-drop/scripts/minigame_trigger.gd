extends Node

# helper script to trigger the earring minigame from an InteractionArea
# attach this to a node in your scene and connect it to an InteractionArea

const MINIGAME_SCENE = preload("res://scenes/earring_minigame.tscn")

func start_earring_minigame() -> void:
	# instantiate the minigame scene
	var minigame = MINIGAME_SCENE.instantiate()
	
	# add it to the current scene (or use a CanvasLayer for UI)
	var current_scene = get_tree().current_scene
	current_scene.add_child(minigame)
	
	# connect signals
	minigame.minigame_completed.connect(_on_minigame_completed)
	minigame.minigame_failed.connect(_on_minigame_failed)
	
	# start the minigame with 3 rounds
	minigame.start_minigame(3)

func _on_minigame_completed(currency_earned: int) -> void:
	print("Minigame completed! Earned: ", currency_earned, " currency")

func _on_minigame_failed() -> void:
	print("Minigame failed!")
