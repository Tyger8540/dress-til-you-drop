extends Control

@export var left_anomalies: Array[AnomalyButton]

var anomaly_count: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LeftCharacter.visible = false
	$RightCharacter.visible = false
	start_minigame()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_num_anomalies() -> int:
	var count: int = 0
	for anomaly in left_anomalies:
		if anomaly.icon != anomaly.connected_button.icon:
			count += 1
	
	return count


func start_minigame() -> void:
	var diff: int = get_num_anomalies()
	while diff < 5:
		for anomaly in left_anomalies:
			anomaly.icon = anomaly.textures.pick_random()
		diff = get_num_anomalies()
	
	anomaly_count = diff
	update_anomaly_count_text()
	$LeftCharacter.visible = true
	$RightCharacter.visible = true


func update_anomaly_count_text() -> void:
	$AnomaliesRemainingText.text = "Anomalies Remaining:" + str(anomaly_count)
	if anomaly_count <= 0:
		# TODO beat the minigame
		pass
