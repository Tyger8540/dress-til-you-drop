class_name ShopUI
extends Control

const SHOP_SLOT_BUTTON = preload("res://scenes/shop_slot_button.tscn")
const CHECKOUT_BOX = preload("res://scenes/checkout_box.tscn")

@export var stock: Array[InventoryItem]
@export var stock_purchased: Array[bool]

@export var shop_buttons: Array[ShopSlotButton]

var current_tab_type: Enums.ClothingType = Enums.ClothingType.HAIR

@onready var browse_screen: Control = $BrowseScreen
@onready var checkout_screen: Control = $CheckoutScreen
@onready var checkout_boxes: HBoxContainer = $CheckoutScreen/CheckoutBoxes


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_shop(current_tab_type)
	Signals.shop_tab_selected.connect(reset_shop)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_shop_buttons() -> void:
	var index = 0
	for item in stock:
		if item.item_type == current_tab_type:
			shop_buttons[index].inventory_item = item
			shop_buttons[index].item_icon.texture = item.ui_texture
			shop_buttons[index].currency_amount.text = str(item.price["Mags"])
			if item.in_inventory:
				shop_buttons[index].checkmark_icon.visible = true
				shop_buttons[index].currency_icon.visible = false
				shop_buttons[index].currency_amount.visible = false
			else:
				shop_buttons[index].currency_icon.visible = true
				shop_buttons[index].currency_amount.visible = true
			if item.in_cart:
				shop_buttons[index].texture_normal = shop_buttons[index].active_texture
			if not item.locked:
				shop_buttons[index].locked_icon.visible = false
				shop_buttons[index].locked_text.visible = false
			else:
				# item.locked == true
				shop_buttons[index].currency_icon.visible = false
				shop_buttons[index].currency_amount.visible = false
			index += 1


func clear_shop_buttons() -> void:
	for shop_button in shop_buttons:
		shop_button.inventory_item = null
		shop_button.texture_normal = shop_button.inactive_texture
		shop_button.item_icon.texture = null
		shop_button.checkmark_icon.visible = false
		shop_button.currency_icon.visible = false
		shop_button.currency_amount.visible = false
		shop_button.locked_icon.visible = true
		shop_button.locked_text.visible = true


func set_checkout_screen() -> void:
	for item in stock:
		if item.in_cart:
			var checkout_box = CHECKOUT_BOX.instantiate()
			# TODO set checkout box attributes
			checkout_boxes.add_child(checkout_box)


func reset_shop(tab_type: Enums.ClothingType) -> void:
	clear_shop_buttons()
	current_tab_type = tab_type
	set_shop_buttons()


func _on_exit_store_button_up() -> void:
	Signals.shop_closed.emit()


func _on_purchase_button_up() -> void:
	for item in stock:
		if item.in_cart:
			#item.in_inventory = true
			item.in_cart = false
	Signals.shop_closed.emit()
	
	#set_checkout_screen()
	#checkout_screen.visible = true
	#browse_screen.visible = false
