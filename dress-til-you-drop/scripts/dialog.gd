class_name Dialog
extends RichTextLabel

signal dialog_finished

@export var text_speed: float = 0.05
@export var text_marker_speed: float = 0.5

var dialog_array: Array[String]
var dialog_index: int = 0

var text_revealing: bool = false
var text_revealed: bool = false
var text_timer: float = 0.0

var text_marker_timer: float = text_marker_speed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_dialog()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if text_revealing:
		if visible_ratio == 1.0:
			text_revealing = false
			text_revealed = true
		else:
			text_timer += delta
			if text_timer >= text_speed:
				text_timer = 0.0
				visible_characters += 1
	elif text_revealed:
		text_marker_timer += delta
		if text_marker_timer > text_marker_speed:
			$TextMarker.visible = not $TextMarker.visible
			text_marker_timer = 0.0
		
		if Input.is_action_just_pressed("ui_accept"):
			continue_dialog()


func initialize_dialog(_dialog_array: Array[String]) -> void:
	dialog_array = _dialog_array


func start_dialog() -> void:
	text = dialog_array[dialog_index]
	text_revealing = true


func continue_dialog() -> void:
	visible_ratio = 0.0
	$TextMarker.visible = false
	dialog_index += 1
	if dialog_index == dialog_array.size():
		dialog_finished.emit()
		get_parent().visible = false
		#get_parent().queue_free()
	else:
		text_revealing = true
		text_revealed = false
		text = dialog_array[dialog_index]
