extends Control

signal minigame_completed(currency_earned: int)
signal minigame_failed()

signal win_screen_expanded

const MIN_CURRENCY_EARNED = 10
const MAX_CURRENCY_EARNED = 50
const BASE_TIME_NEEDED = 10

const WIN_SCREEN_SIZE_Y = 747.0
const WIN_SCREEN_EXPANSION_SPEED = 500.0

@export var left_anomalies: Array[AnomalyButton]

var anomaly_count: int
var total_anomalies: int

var minigame_finished: bool = false

var time_passed: float = 0.0
var currency_earned: int = 10

var win_screen_expanding: bool = false

var win_screen_finished: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LeftCharacter.visible = false
	$RightCharacter.visible = false
	start_minigame()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if win_screen_finished:
		if Input.is_action_just_pressed("continue"):
			Signals.minigame_defeated.emit()
			Signals.minigame_finished.emit()
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
	total_anomalies = anomaly_count
	update_anomaly_count_text()
	$LeftCharacter.visible = true
	$RightCharacter.visible = true


func update_anomaly_count_text() -> void:
	$AnomaliesRemainingText.text = "Anomalies Remaining:" + str(anomaly_count)
	if anomaly_count <= 0:
		minigame_finished = true
		currency_earned = total_anomalies * BASE_TIME_NEEDED - int(time_passed)
		currency_earned = clamp(currency_earned, MIN_CURRENCY_EARNED, MAX_CURRENCY_EARNED)
		
		# TODO UPDATE THE GLOBAL CURRENCY TO BE USED IN THE SHOP!!!!!!!
		
		play_win_animation()
		#minigame_completed.emit(currency_earned)


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
