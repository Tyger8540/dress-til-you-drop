extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db($VolumeSlider.value / 100))
	print(AudioServer.get_bus_volume_db(0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_volume_slider_drag_ended(value_changed: bool) -> void:
	$VolumeSlider.release_focus()
	if value_changed:
		AudioServer.set_bus_volume_db(0, linear_to_db($VolumeSlider.value / 100))
		print(AudioServer.get_bus_volume_db(0))


func _on_sensitivity_slider_drag_ended(value_changed: bool) -> void:
	$SensitivitySlider.release_focus()
	if value_changed:
		MouseController.set_mouse_sensitivity($SensitivitySlider.value)


func _on_back_button_mouse_entered() -> void:
	add_theme_stylebox_override("panel", load("res://resources/style_boxes/settings_menu_mouse_back.tres"))


func _on_back_button_mouse_exited() -> void:
	add_theme_stylebox_override("panel", load("res://resources/style_boxes/settings_menu_mouse_none.tres"))
