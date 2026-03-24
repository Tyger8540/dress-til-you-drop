extends Control
# Reflex Rendevoux Minigame Script


# Stores time durations for the event
@export var time_limit_QTE = 0.5


# Stores time duration before sprite reverts to norm
@export var display_duration = 0.2


# References
@onready var girl: Sprite2D = $Background/Girl
@onready var gargoyle: Sprite2D = $Background/Gargoyle
@onready var health_label: Label = $Background/HealthLabel
@onready var hidden_stuff: Control = $"Background/Hidden Stuff"
@onready var exclamation: Sprite2D = $"Background/Hidden Stuff/Exclamation"
@onready var impact_frame: Sprite2D = $"Background/Hidden Stuff/ImpactFrame"

const GARGOYLE_IDLE = preload("uid://c4uj186wu188v")
const GARGOYLE_STRIKE = preload("uid://bxqnsumv7jjff")
const GIRL_HURT = preload("uid://byb0541sjbdq2")
const GIRL_IDLE = preload("uid://twxgmtbpdtaa")
const GIRL_STRIKE = preload("uid://c8l2q3hn2hls0")

# TODO implement sound

# Holds value for how long to wait before sound plays and qte begins
var time_before_QTE = 0.2


# QTE success tracker
var success: bool = false


# Keeps track of if end condition has been met
enum game_status {ONGOING, LOST, WON}
var current_game_state = game_status.ONGOING 


# keeps track of if a QTE is currently going (limits key abuse lol)
var qte_time: bool = false


# var used to check if any key was pressed for QTE to determine timeout
var turns_completed = 0;


# number of lives
var health_girl: int = 3
var health_gargoyle: int = 5


# string displayed for health
var health_girl_string: String = "10"


# Ensures new QTE is not made during gargoyle atk anim
# when the player strikes when there is no QTE
var pause_new_qte_creation: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	qte_creation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Create QTE
func qte_creation():
	
	# variable used to check that no moves have been made since the start of qte
	var starting_turn_number = turns_completed
	
	# Get random float for time
	time_before_QTE = randf_range(1.1, 3.0)
	
	# Ensure QTE time is set false
	qte_time = false
	
	await get_tree().create_time(time_before_QTE.timeout)
	
	# Conducts checks for if any key was pressed
	# (in other words check that number of rounds completed is the same before and after,
	# if they are the same: timeout, otherwise ignore)
	if starting_turn_number == turns_completed:
		# TODO: Play sound
		
		qte_time = true
		exclamation.show()
		
		await get_tree().create_time(time_limit_QTE.timeout)
		if starting_turn_number == turns_completed:
			time_runs_out()


# Visuals for girl's attack and update to gargoyle health
func girl_attack() -> void:
	girl.texture = GIRL_STRIKE
	await get_tree().create_time(display_duration.timeout)
	impact_frame.show()
	girl.texture = GIRL_IDLE
	await get_tree().create_time(display_duration.timeout)
	impact_frame.hide()
	health_gargoyle -= 1


# Updates the number of lives display
func update_health() -> void:
	#This keeps the string two digits long
	health_girl_string = "0" + str(health_girl)


# Visuals for gargoyle attack and girl hurt, also updates health
func gargoyle_attack()-> void:
	gargoyle.texture = GARGOYLE_STRIKE
	await get_tree().create_time(display_duration.timeout)
	girl.texture = GIRL_HURT
	gargoyle.texture = GARGOYLE_IDLE
	await get_tree().create_time(display_duration.timeout)
	girl.texture = GIRL_IDLE
	health_girl -= 1


# Events that occur if player is too slow
func time_runs_out()->void:
	exclamation.hide()
	gargoyle_attack()
	update_health()
	reset_qte_vars()


# Interprets input: checks whether it is a success or not
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept"):
		if not qte_time:
			# Strike is too early
			pause_new_qte_creation = true
			gargoyle_attack()
			update_health()
		elif not success:
			# Successful strike
			pause_new_qte_creation = true
			success = true
			exclamation.hide()
			girl_attack()
		reset_qte_vars()


# Resetting QTE values for next QTE
# Or ends game if condition has been met
func reset_qte_vars() -> void:
	success = false
	pause_new_qte_creation = false
	qte_time = false
	turns_completed += 1
	check_end_condition()
	if current_game_state == game_status.ONGOING:
		qte_creation()
	elif current_game_state == game_status.LOST:
		lose()
	elif current_game_state == game_status.WON:
		win()


# Checks if end conditions have been met
func check_end_condition() -> void:
	# Loss if girl is dead
	if health_girl <= 0:
		current_game_state = game_status.LOST
	# Win if gargoyle is dead
	elif health_gargoyle <= 0:
		current_game_state = game_status.WON


# TODO implement the ending results and stuff
func lose():
	pass

func win():
	pass
