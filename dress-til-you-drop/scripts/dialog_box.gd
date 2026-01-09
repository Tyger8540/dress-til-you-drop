class_name DialogBox
extends Panel

@export var dialog: Dialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func initialize_dialog(_dialog_array: Array[String]) -> void:
	dialog.dialog_array = _dialog_array
