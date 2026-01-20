class_name InventoryTabButton
extends TextureButton

const TAB_ACTIVE_Y = 260.0
const TAB_INACTIVE_Y = 272.0

@export var inactive_texture: CompressedTexture2D
@export var active_texture: CompressedTexture2D

var base_size: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("inventory_tab_selected", set_inactive)
	base_size = size
	if inactive_texture == load("res://art/inventory_ui/assets/tabs/inactive - earrings.png"):
		set_active()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_inactive(sender) -> void:
	if sender != self:
		texture_normal = inactive_texture
		position.y = TAB_INACTIVE_Y
		size = base_size


func set_active() -> void:
	texture_normal = active_texture
	position.y = TAB_ACTIVE_Y


func _on_button_up() -> void:
	set_active()
	Signals.emit_signal("inventory_tab_selected", self)
