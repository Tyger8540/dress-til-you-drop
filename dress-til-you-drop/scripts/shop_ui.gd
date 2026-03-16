extends Control

const SHOP_SLOT_BUTTON = preload("res://scenes/shop_slot_button.tscn")

@export var stock: Array[InventoryItem]
@export var stock_purchased: Array[bool]

@export var shop_buttons: Array[ShopSlotButton]

var current_tab_type: Enums.ClothingType = Enums.ClothingType.HAIR


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_shop_buttons()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func create_shop_buttons() -> void:
	for item in stock:
		var shop_button = SHOP_SLOT_BUTTON.instantiate()
		$BrowseScreen/Boxes.add_child(shop_button)
		shop_button.inventory_item = item
		shop_button.item_icon.texture = item.ui_texture


func set_shop_buttons() -> void:
	for item in stock:
		if item.item_type == current_tab_type:
			pass


func clear_shop_buttons() -> void:
	for shop_button in shop_buttons:
		pass


func _on_exit_store_button_up() -> void:
	# TODO see if this actually works
	visible = false
