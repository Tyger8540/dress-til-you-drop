class_name PauseMenu
extends Panel

enum MenuState {
	NONE,
	CONTINUE,
	SETTINGS,
	QUIT,
}


## Raised above fullscreen UI spawned on CanvasLayer (earring minigame).
var _elevated_pause_layer: CanvasLayer = null
var _saved_parent_before_elevate: Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		var turning_on_pause: bool = not get_tree().paused
		if turning_on_pause:
			_elevate_above_minigame_if_needed()

		get_tree().paused = not get_tree().paused
		visible = get_tree().paused

		if not get_tree().paused:
			_restore_normal_parent()


func _is_earring_minigame_running() -> bool:
	var root: Node = get_tree().current_scene
	if root == null:
		return false
	return root.find_child("EarringMinigame", true, false) != null


func _elevate_above_minigame_if_needed() -> void:
	if _elevated_pause_layer != null:
		return
	if not _is_earring_minigame_running():
		return

	var scene_root: Node = get_tree().current_scene
	var saved_parent: Node = get_parent()
	if scene_root == null or saved_parent == null:
		return

	var layer := CanvasLayer.new()
	layer.name = "PauseMenuElevatedLayer"
	layer.layer = 128

	_saved_parent_before_elevate = saved_parent
	saved_parent.remove_child(self)

	scene_root.add_child(layer)
	layer.add_child(self)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	_elevated_pause_layer = layer


func _restore_normal_parent() -> void:
	if _elevated_pause_layer == null or _saved_parent_before_elevate == null:
		return
	var layer: CanvasLayer = _elevated_pause_layer
	var restored_parent: Node = _saved_parent_before_elevate
	_elevated_pause_layer = null
	_saved_parent_before_elevate = null

	if is_instance_valid(layer):
		layer.remove_child(self)
	if is_instance_valid(restored_parent):
		restored_parent.add_child(self)
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	if is_instance_valid(layer):
		layer.queue_free()


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
	_restore_normal_parent()


func quit_game() -> void:
	_restore_normal_parent()
	# TODO save game before quitting
	get_tree().quit()
