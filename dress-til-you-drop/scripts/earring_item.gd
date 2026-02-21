class_name EarringItem
extends Control

# individual earring item in the grid
signal earring_clicked(earring: EarringItem)

@export var earring_id: int = -1  # unique ID for this earring instance
@export var shape_id: int = 0     # logical shape type (index into earring spritesheet 0..16)

var is_clickable: bool = true

@onready var color_rect: ColorRect = $ColorRect
@onready var earring_sprite: TextureRect = $EarringSprite
var shadow_rect: ColorRect
var _pending_texture: Texture2D  # applied in _ready when set before add_child

func _ready() -> void:
	_create_shadow()
	if _pending_texture != null and is_instance_valid(earring_sprite):
		earring_sprite.texture = _pending_texture
		_pending_texture = null
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	# ensure this node stays at a fixed size when manually positioned (no fill-anchors).
	size = custom_minimum_size
	scale = Vector2.ONE

func set_visual_size(side: float) -> void:
	custom_minimum_size = Vector2(side, side)
	size = custom_minimum_size
	if shadow_rect:
		shadow_rect.custom_minimum_size = custom_minimum_size
		shadow_rect.position = Vector2(-4, 4)

func set_shape_id(id: int) -> void:
	shape_id = id

func set_sprite_texture(tex: Texture2D) -> void:
	if is_instance_valid(earring_sprite):
		earring_sprite.texture = tex
	else:
		_pending_texture = tex

func get_shape_id() -> int:
	return shape_id

func reset_for_conveyor(new_shape_id: int) -> void:
	is_clickable = true
	modulate = Color(1, 1, 1, 1)
	set_shape_id(new_shape_id)

func mark_correct() -> void:
	is_clickable = false
	modulate = Color(0.7, 1.0, 0.7, 1.0)
	_play_click_pulse()

func mark_incorrect() -> void:
	is_clickable = false
	modulate = Color(1.0, 0.6, 0.6, 1.0)
	_play_click_pulse()

func _play_click_pulse() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.20)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.26)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _create_shadow() -> void:
	if shadow_rect:
		return
	shadow_rect = ColorRect.new()
	shadow_rect.color = Color(0, 0, 0, 0.18)
	# simple bottom-left/bottom shadow using explicit position.
	shadow_rect.anchor_left = 0.0
	shadow_rect.anchor_top = 0.0
	shadow_rect.anchor_right = 0.0
	shadow_rect.anchor_bottom = 0.0
	shadow_rect.position = Vector2(-4, 4)
	shadow_rect.custom_minimum_size = custom_minimum_size
	shadow_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shadow_rect)
	move_child(shadow_rect, 0)

func _gui_input(event: InputEvent) -> void:
	if not is_clickable:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			earring_clicked.emit(self)
