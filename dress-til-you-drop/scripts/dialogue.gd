class_name Dialogue
extends RichTextLabel

@export var text_speed: float = 0.05
@export var text_marker_speed: float = 0.5

var dialogue_array: Array[String]
var dialogue_index: int = 0

var text_revealing: bool = false
var text_revealed: bool = false
var text_timer: float = 0.0

var text_marker_timer: float = text_marker_speed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_dialogue()


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
			continue_dialogue()


func initialize_dialogue(_dialogue_array: Array[String]) -> void:
	dialogue_array = _dialogue_array


func start_dialogue() -> void:
	text = dialogue_array[dialogue_index]
	text_revealing = true


func continue_dialogue() -> void:
	visible_ratio = 0.0
	$TextMarker.visible = false
	text_revealing = true
	text_revealed = false
	dialogue_index += 1
	if dialogue_index == dialogue_array.size():
		get_parent().queue_free()
	else:
		text = dialogue_array[dialogue_index]
