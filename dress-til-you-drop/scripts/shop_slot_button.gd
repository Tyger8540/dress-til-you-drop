class_name ShopSlotButton
extends InventorySlotButton

@export var shop_ui: ShopUI

@onready var checkmark_icon: TextureRect = $CheckmarkIcon
@onready var locked_icon: TextureRect = $LockedIcon
@onready var locked_text: RichTextLabel = $LockedText
@onready var currency_icon: TextureRect = $CurrencyIcon
@onready var currency_amount: RichTextLabel = $CurrencyAmount


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("shop_slot_selected", set_inactive)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_inactive(sender: ShopSlotButton) -> void:
	if sender != self:
		texture_normal = inactive_texture


func set_active() -> void:
	texture_normal = active_texture


func _on_button_up() -> void:
	if inventory_item == null:
		return
	
	if inventory_item.locked or inventory_item.in_inventory:
		# TODO play error selecting sound maybe
		return
	
	if inventory_item.in_cart:
		inventory_item.in_cart = false
		Signals.shop_slot_deselected.emit()
		set_inactive(null)
	else:
		# make sure the player can't select multiple of one item type
		#for item in shop_ui.stock:
			#if item.item_type == inventory_item.item_type:
				#if item.in_cart:
					#item.in_cart = false
					#item.set_inactive(null)
		inventory_item.in_cart = true
		set_active()
	
	Signals.emit_signal("shop_slot_selected", self)
