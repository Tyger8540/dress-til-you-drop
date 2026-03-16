extends Control

signal finished(success)

# Stores the key needed to do the QTE
@export var key_needed: Key = KEY_SPACE

# Stores time durations for the event
@export var time_limit_QTE: float = 0.5
@export var display_duration: float = 0.5

var success = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func exclamation():
	#Put stuff for visuals here
	pass

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(key_needed) and not success:
		success = true
		
		await get_tree().create_time(displayDuration.timeout)
		hide()

func success():
	
