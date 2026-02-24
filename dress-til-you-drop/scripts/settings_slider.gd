class_name SettingsSlider
extends HSlider

var is_dragging: bool = false
var has_mouse: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func update_slider() -> void:
	if not is_dragging and not has_mouse:
		add_theme_stylebox_override("slider", load("res://resources/style_boxes/settings_menu_slider_unselected.tres"))
	elif is_dragging or has_mouse:
		add_theme_stylebox_override("slider", load("res://resources/style_boxes/settings_menu_slider_selected.tres"))


func _on_drag_started() -> void:
	Signals.ui_selected.emit()
	is_dragging = true
	update_slider()


func _on_drag_ended(_value_changed: bool) -> void:
	is_dragging = false
	update_slider()


func _on_mouse_entered() -> void:
	has_mouse = true
	update_slider()


func _on_mouse_exited() -> void:
	has_mouse = false
	update_slider()
