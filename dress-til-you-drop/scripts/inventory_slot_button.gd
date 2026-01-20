class_name InventorySlotButton
extends TextureButton

@export var inactive_texture: CompressedTexture2D
@export var active_texture: CompressedTexture2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("inventory_slot_selected", set_inactive)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_inactive(sender) -> void:
	if sender != self:
		texture_normal = inactive_texture


func set_active() -> void:
	texture_normal = active_texture


func _on_button_up() -> void:
	set_active()
	Signals.emit_signal("inventory_slot_selected", self)
