class_name Dialog
extends RichTextLabel

signal dialog_finished

@export var text_speed: float = 0.05  # adjustable dialog box text speed
@export var text_marker_speed: float = 0.5  # adjustable text marker speed

var dialog_array: Array[String]  # array holding lines of dialog
var dialog_index: int = 0  # index of cur line of dialog

var text_revealing: bool = false  # true if text is currently being revealed
var text_revealed: bool = false  # true if all text in line has been revealed
var text_timer: float = 0.0  # timer for revealing chars based on text_speed

var text_marker_timer: float = text_marker_speed  # timer for flashing text marker


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_dialog()  # starts the dialog when first entering the scene tree


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if text_revealing:  # logic for revealing dialog based on text_speed
		if visible_ratio == 1.0:  # cur line of dialog is done revealing
			text_revealing = false
			text_revealed = true
		else:  # cur line of dialog is still being revealed
			text_timer += delta  # increase time since last char revealed
			if text_timer >= text_speed:  # reveal next char if enough time has passed
				text_timer = 0.0  # reset the timer
				visible_characters += 1  # reveal a char
	elif text_revealed:  # cur line of dialog has been revealed
		# logic for text marker in bottom right of dialog box
		text_marker_timer += delta
		if text_marker_timer > text_marker_speed:
			$TextMarker.visible = not $TextMarker.visible
			text_marker_timer = 0.0
		
		# continue dialog if input was received
		if Input.is_action_just_pressed("ui_accept"):
			continue_dialog()


func start_dialog() -> void:
	text = dialog_array[dialog_index]  # set text for the cur line of dialog
	text_revealing = true  # start revealing text


func continue_dialog() -> void:
	# reset the dialog box & go to next line
	visible_ratio = 0.0
	$TextMarker.visible = false
	dialog_index += 1
	
	if dialog_index == dialog_array.size():  # dialog finished
		dialog_finished.emit()  # tell interaction_area that dialog is finished
		get_parent().visible = false
	else:  # dialog not finished
		text_revealed = false
		start_dialog()  # start the next line of dialog
