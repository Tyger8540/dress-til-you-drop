class_name ReflexRendevouxInteraction
extends MinigameInteraction


func initiate_minigame(minigame: Node) -> void:
	# TODO any necessary initialization for the minigame
	Signals.minigame_started.emit(minigame)
	pass


func _on_minigame_completed(currency_earned: int) -> void:
	print("Minigame completed! Earned: ", currency_earned, " currency")
	Signals.minigame_defeated.emit()


func _on_minigame_failed() -> void:
	print("Minigame failed!")
	Signals.minigame_failed.emit()
