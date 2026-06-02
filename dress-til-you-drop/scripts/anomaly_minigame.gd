extends Control

signal minigame_completed(currency_earned: int)
signal minigame_failed()

signal win_screen_expanded

const MIN_CURRENCY_EARNED = 10
const MAX_CURRENCY_EARNED = 50
const BASE_TIME_NEEDED = 10

const WIN_SCREEN_SIZE_Y = 747.0
const WIN_SCREEN_EXPANSION_SPEED = 500.0

@export var left_anomalies_1: Array[AnomalyButton]
@export var left_anomalies_2: Array[AnomalyButton]
@export var left_anomalies_3: Array[AnomalyButton]

var left_anomalies: Array[AnomalyButton]

var level: int

var anomaly_count: int
var total_anomalies: int

var minigame_finished: bool = false

var time_passed: float = 0.0
var currency_earned: int = 10

var win_screen_expanding: bool = false

var win_screen_finished: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LeftCharacter1.visible = false
	$RightCharacter1.visible = false
	$LeftCharacter2.visible = false
	$RightCharacter2.visible = false
	$LeftCharacter3.visible = false
	$RightCharacter3.visible = false
	level = InventoryManager.spot_the_anomaly_level
	start_minigame()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if win_screen_finished:
		if Input.is_action_just_pressed("continue"):
			Signals.minigame_defeated.emit()
			Signals.minigame_finished.emit()
			Signals.get_minigame_loot.emit(Enums.MinigameType.SPOT_THE_ANOMALY)
			Audio.resume_music()
			get_parent().queue_free()
	
	if not minigame_finished:
		time_passed += delta
	
	if win_screen_expanding:
		$WinScreen.size.y = min($WinScreen.size.y + WIN_SCREEN_EXPANSION_SPEED * delta, WIN_SCREEN_SIZE_Y)
		if is_equal_approx($WinScreen.size.y, WIN_SCREEN_SIZE_Y):
			win_screen_expanding = false
			win_screen_expanded.emit()
	
	$WinScreen/Currency/CurrencyEarned.text = str(int(currency_earned - $WinScreen/CurrencyEarnedTimer.time_left * (currency_earned / $WinScreen/CurrencyEarnedTimer.wait_time)))

func get_num_anomalies() -> int:
	if level == 1:
		left_anomalies = left_anomalies_1
	elif level == 2:
		left_anomalies = left_anomalies_2
	elif level == 3:
		left_anomalies = left_anomalies_3
	
	var count: int = 0
	for anomaly in left_anomalies:
		if anomaly.icon != anomaly.connected_button.icon:
			count += 1
	
	return count


func start_minigame() -> void:
	Audio.pause_music()
	var startup_audio := Audio.play_sound(load("res://audio/sfx/Minigames/Spot the Anomaly/STA_StartupSound.wav"))
	startup_audio.finished.connect(func(): Audio.play_music(load("res://audio/music/MainTheme.wav"), -12.5, true, get_parent()))
	
	var diff: int = get_num_anomalies()
	while diff < 5:
		for anomaly in left_anomalies:
			anomaly.icon = anomaly.textures.pick_random()
			anomaly.connected_button.icon = anomaly.textures.pick_random()
			if anomaly.icon == anomaly.connected_button.icon:
				anomaly.connected_button.icon = anomaly.textures[0]
		diff = get_num_anomalies()
	
	anomaly_count = diff
	total_anomalies = anomaly_count
	update_anomaly_count_text()
	if level == 1:
		$LeftCharacter1.visible = true
		$RightCharacter1.visible = true
	elif level == 2:
		$LeftCharacter2.visible = true
		$RightCharacter2.visible = true
	elif level == 3:
		$LeftCharacter3.visible = true
		$RightCharacter3.visible = true


func update_anomaly_count_text() -> void:
	$AnomaliesRemainingText.text = "Anomalies Remaining:" + str(anomaly_count)
	if anomaly_count <= 0:
		minigame_finished = true
		currency_earned = total_anomalies * BASE_TIME_NEEDED - int(time_passed)
		currency_earned = clamp(currency_earned, MIN_CURRENCY_EARNED, MAX_CURRENCY_EARNED)
		
		play_win_animation()


func play_win_animation() -> void:
	for anomaly in left_anomalies:
		var temp_timer: Timer = Timer.new()
		temp_timer.wait_time = randf_range(0.0, 5.0)
		temp_timer.one_shot = true
		temp_timer.autostart = true
		temp_timer.timeout.connect(anomaly.play_animation)
		anomaly.add_child(temp_timer)
		
		var temp_timer2: Timer = Timer.new()
		temp_timer2.wait_time = randf_range(0.0, 5.0)
		temp_timer2.one_shot = true
		temp_timer2.autostart = true
		temp_timer2.timeout.connect(anomaly.connected_button.play_animation)
		anomaly.connected_button.add_child(temp_timer2)
	await get_tree().create_timer(5.0).timeout
	win_screen_expanding = true
	await win_screen_expanded
	#play_currency_earned_animation()  # when using currency
	$WinScreen/ContinueText.process_mode = Node.PROCESS_MODE_INHERIT  # immediately show continue text
	win_screen_finished = true  # immediately show continue text


func play_currency_earned_animation() -> void:
	$WinScreen/Currency.visible = true
	$WinScreen/CurrencyEarnedTimer.start()


func _on_currency_earned_timer_timeout() -> void:
	$WinScreen/ContinueText.process_mode = Node.PROCESS_MODE_INHERIT
	win_screen_finished = true


func _on_level_increased() -> void:
	level += 1
