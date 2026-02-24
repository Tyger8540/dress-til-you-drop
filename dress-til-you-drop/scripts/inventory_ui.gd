class_name InventoryUI
extends Control

@export var player: Player
@export var inventory_slot_buttons: Array[InventorySlotButton]

var current_tab_type: Enums.ClothingType = Enums.ClothingType.ACCESSORY

@onready var grid_container = $ScrollContainer/GridContainer
@onready var current_tab = $"Tabs/Earrings Tab"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connecting the func
	Signals.inventory_updated.connect(_on_inventory_updated)
	Signals.inventory_tab_selected.connect(_on_inventory_tab_selected)
	#_on_inventory_updated()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Updates inventory UI
func _on_inventory_updated() -> void:
	# Clears current grid container contents
	clear_grid_container()
	# 
	for item in InventoryManager.inventory:
		if current_tab.type == item.item_type:
			var slot = InventoryManager.inventory_slot_scene.instantiate()
			grid_container.add_child(slot)
			slot.set_item(item)


# Clears the UI grid
func clear_grid_container() -> void:
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()


func set_inventory_ui() -> void:
	# NOTE might need to dynamically get inventory slots if >16 items for a certain type
	#var inventory_slot_buttons: Array[InventorySlotButton]
	#inventory_slot_buttons.push_back($Boxes.get_children())
	var index: int = 0
	for inventory_item in InventoryManager.inventory:
		if inventory_item.item_type == current_tab_type:
			inventory_slot_buttons[index].inventory_item = inventory_item
			inventory_slot_buttons[index].item_icon.texture = inventory_item.ui_texture
			
			match current_tab_type:
				Enums.ClothingType.ACCESSORY:
					if inventory_slot_buttons[index].inventory_item.item_texture == player.accessory.mesh:
						inventory_slot_buttons[index].set_active()
				Enums.ClothingType.TOP:
					if inventory_slot_buttons[index].inventory_item.item_texture == player.top.mesh:
						inventory_slot_buttons[index].set_active()
				Enums.ClothingType.BOTTOM:
					if inventory_slot_buttons[index].inventory_item.item_texture == player.bottom.mesh:
						inventory_slot_buttons[index].set_active()
				Enums.ClothingType.SHOES:
					if inventory_slot_buttons[index].inventory_item.item_texture == player.shoes.mesh:
						inventory_slot_buttons[index].set_active()
			
			index += 1


func clear_inventory_ui() -> void:
	#var inventory_slot_buttons: Array[InventorySlotButton]
	#inventory_slot_buttons.push_back($Boxes.get_children())
	for inventory_slot in inventory_slot_buttons:
		inventory_slot.item_icon.texture = null
		inventory_slot.inventory_item = null
		inventory_slot.set_inactive(null)


func _on_inventory_tab_selected(tab: InventoryTabButton) -> void:
	clear_inventory_ui()
	current_tab_type = tab.tab_type
	set_inventory_ui()
