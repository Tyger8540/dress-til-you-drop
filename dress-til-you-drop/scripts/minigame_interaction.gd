extends Node

# script to attach to an InteractionArea node to trigger the earring minigame
# sets up the interact callable for the InteractionArea

const MINIGAME_SCENE = preload("res://scenes/earring_minigame.tscn")

var interaction_area: InteractionArea

func _ready() -> void:
	# get the parent InteractionArea
	interaction_area = get_parent() as InteractionArea
	if interaction_area:
		# override the interact callable to start the minigame
		interaction_area.interact = _start_minigame

func _start_minigame() -> void:
	# show dialog first (if any)
	if interaction_area and interaction_area.dialog.dialog.size() > 0:
		var dialog_box = interaction_area.spawn_dialog_box()
		await dialog_box.dialog.dialog_finished
		dialog_box.queue_free()
	
	# instantiate the minigame scene
	var minigame = MINIGAME_SCENE.instantiate()
	
	# add it to the current scene (on a CanvasLayer for proper UI display)
	var current_scene = get_tree().current_scene
	
	# check if there's already a CanvasLayer, if not create one
	var canvas_layer = current_scene.get_node_or_null("MinigameCanvasLayer")
	if not canvas_layer:
		canvas_layer = CanvasLayer.new()
		canvas_layer.name = "MinigameCanvasLayer"
		current_scene.add_child(canvas_layer)
	
	canvas_layer.add_child(minigame)
	
	# connect signals
	minigame.minigame_completed.connect(_on_minigame_completed)
	minigame.minigame_failed.connect(_on_minigame_failed)
	
	# start the minigame with 3 rounds
	minigame.start_minigame(3)

func _on_minigame_completed(currency_earned: int) -> void:
	print("Minigame completed! Earned: ", currency_earned, " currency")
	Signals.minigame_one_defeated.emit()

func _on_minigame_failed() -> void:
	print("Minigame failed!")
