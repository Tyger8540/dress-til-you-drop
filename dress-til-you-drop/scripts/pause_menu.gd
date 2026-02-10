class_name PauseMenu
extends Panel

enum MenuState {
	NONE,
	CONTINUE,
	SETTINGS,
	QUIT,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused


func set_panel(state: MenuState) -> void:
	var path: String = ""
	match state:
		MenuState.NONE:
			path = "res://resources/style_boxes/pause_menu_none.tres"
		MenuState.CONTINUE:
			path = "res://resources/style_boxes/pause_menu_continue.tres"
		MenuState.SETTINGS:
			path = "res://resources/style_boxes/pause_menu_settings.tres"
		MenuState.QUIT:
			path = "res://resources/style_boxes/pause_menu_quit.tres"
		_:
			pass
	
	$OptionsPanel.add_theme_stylebox_override("panel", load(path))


func continue_game() -> void:
	get_tree().paused = false
	visible = false


func quit_game() -> void:
	# TODO save game before quitting
	get_tree().quit()
