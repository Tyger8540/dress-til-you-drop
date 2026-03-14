extends Control

const SHOP_SLOT_BUTTON = preload("res://scenes/shop_slot_button.tscn")

@export var stock: Array[InventoryItem]
@export var stock_purchased: Array[bool]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_shop_buttons()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func create_shop_buttons() -> void:
	for item in stock:
		var shop_button = SHOP_SLOT_BUTTON.instantiate()
		shop_button.inventory_item = item
		shop_button.item_icon = item.ui_texture
