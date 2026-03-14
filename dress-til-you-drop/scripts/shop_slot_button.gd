class_name ShopSlotButton
extends InventorySlotButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("shop_slot_selected", set_inactive)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_inactive(sender) -> void:
	if sender != self:
		texture_normal = inactive_texture


func set_active() -> void:
	texture_normal = active_texture


func _on_button_up() -> void:
	if inventory_item == null:
		return
	
	set_active()
	
	Signals.emit_signal("shop_slot_selected", self)
