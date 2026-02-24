extends TextureRect

@export var normal: Array[Texture2D]
@export var hover: Array[Texture2D]
@export var selected: Array[Texture2D]
@export var hover_options: Array[Texture2D]
@export var hover_display_options: Array[DisplayServer.WindowMode]

var index: int = 0  # Fullscreen == 0, Windowed == 1
var is_hovering: bool = false
var is_selected: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = normal[index]
	Signals.ui_selected.connect(set_normal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_normal() -> void:
	is_hovering = false
	is_selected = false
	texture = normal[index]


func _on_mouse_entered() -> void:
	#is_hovering = true
	#if not is_selected:
		#texture = hover[index]
	pass


func _on_mouse_exited() -> void:
	is_hovering = false
	if not is_selected:
		texture = normal[index]


func _on_option_1_button_up() -> void:
	if is_selected:
		is_selected = false
		texture = hover[index]
	else:
		is_selected = true
		texture = selected[index]


func _on_option_2_button_up() -> void:
	if is_selected:
		is_selected = false
		if index == 0:
			index = 1
		elif index == 1:
			index = 0
		texture = normal[index]
		is_hovering = false
		DisplayServer.window_set_mode(hover_display_options[index], 0)


func _on_option_1_mouse_entered() -> void:
	is_hovering = true
	if not is_selected:
		texture = hover[index]


func _on_option_2_mouse_entered() -> void:
	if is_selected:
		is_hovering = true
		texture = hover_options[index]


func _on_option_1_mouse_exited() -> void:
	is_hovering = false
	if not is_selected:
		texture = normal[index]


func _on_option_2_mouse_exited() -> void:
	if is_selected:
		texture = selected[index]
