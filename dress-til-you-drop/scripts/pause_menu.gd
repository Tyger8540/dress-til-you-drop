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
		print("yo bro?")
		if get_tree().get_nodes_in_group("player")[0].in_inventory:
			Signals.inventory_closed.emit()
		elif $SettingsPanel.visible:
			close_settings()
		elif get_tree().get_nodes_in_group("player")[0].in_minigame:
			print("yoyoyoyoyo")
			pass
		else:
			get_tree().paused = not get_tree().paused
			visible = get_tree().paused
			MouseController.set_mouse_visible(visible)


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
	MouseController.set_mouse_visible(false)


func quit_game() -> void:
	# TODO save game before quitting
	get_tree().quit()


func open_settings() -> void:
	$OptionsPanel.visible = false
	$SettingsPanel.visible = true


func close_settings() -> void:
	$SettingsPanel.visible = false
	$OptionsPanel.visible = true
