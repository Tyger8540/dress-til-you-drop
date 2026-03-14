class_name AnomalyInteraction
extends MinigameInteraction


func initiate_minigame(minigame: Node) -> void:
	# TODO any necessary initialization for the minigame
	pass


func _on_minigame_completed(currency_earned: int) -> void:
	print("Minigame completed! Earned: ", currency_earned, " currency")
	Signals.spot_the_anomaly_defeated.emit()


func _on_minigame_failed() -> void:
	print("Minigame failed!")
	Signals.spot_the_anomaly_failed.emit()
