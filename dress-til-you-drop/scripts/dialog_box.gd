class_name DialogBox
extends Panel

@export var dialog: Dialog  # reference to this dialog box's dialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func initialize_dialog(_dialog: DialogResource) -> void:
	dialog.dialog_array = _dialog.dialog  # sets the dialog array in dialog
	dialog.speaker_array = _dialog.speaker  # sets the speaker array in dialog


func set_dialog_mode() -> void:
	add_theme_stylebox_override("panel", load("res://resources/style_boxes/dialog_dialog_box.tres"))
	size = Vector2(1131.0, 366.0)
	position = Vector2(385.0, 690.0)
	dialog.position = Vector2(156.0, 160.0)


func set_description_mode() -> void:
	add_theme_stylebox_override("panel", load("res://resources/style_boxes/description_dialog_box.tres"))
	size = Vector2(1112.0, 286.0)
	position = Vector2(404.0, 770.0)
	dialog.position = Vector2(156.0, 80.0)
