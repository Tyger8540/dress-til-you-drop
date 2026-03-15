class_name EarringInteraction
extends MinigameInteraction


func initiate_minigame(minigame: Node) -> void:
	# start the minigame with 3 rounds
	minigame.start_minigame(3)
	Signals.minigame_one_started.emit(minigame)


func _on_minigame_completed(currency_earned: int) -> void:
	print("Minigame completed! Earned: ", currency_earned, " currency")
	Signals.minigame_one_defeated.emit()


func _on_minigame_failed() -> void:
	print("Minigame failed!")
	Signals.minigame_one_failed.emit()
