extends Control

@onready var grid_container = $ScrollContainer/GridContainer
@onready var current_tab = $"Tabs/Earrings Tab"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connecting the func
	InventoryManager.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated(current_tab)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Updates inventory UI
func _on_inventory_updated(current_tab) -> void:
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
