class_name ShopTabButton
extends InventoryTabButton

@export var tab_bubble: TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("shop_tab_selected", set_inactive)
	if inactive_texture == load("res://art/shop_ui/right side/categories/icons/unselected/hair unselected.png"):
		set_active()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_inactive(sender_tab_type) -> void:
	if sender_tab_type != tab_type:
		texture_normal = inactive_texture
		tab_bubble.visible = false


func set_active() -> void:
	texture_normal = active_texture
	tab_bubble.visible = true
	#position.y = TAB_ACTIVE_Y
	#Signals.emit_signal("inventory_updated", self)


func _on_button_up() -> void:
	set_active()
	Signals.emit_signal("shop_tab_selected", tab_type)
