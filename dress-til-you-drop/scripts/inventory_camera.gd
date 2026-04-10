class_name InventoryCamera
extends Camera

@export var inventory_ui: InventoryUI
@export var shop_ui: ShopUI

var last_cam: Camera


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.inventory_closed.connect(close_inventory)
	Signals.shop_closed.connect(close_shop)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	#look_at(player.global_position)
	
	if Input.is_action_just_pressed("inventory"):
		if not player.in_inventory:
			open_inventory()
		else:
			close_inventory()
	
	if Input.is_action_just_pressed("shop"):
		if not player.in_inventory and not player.in_shop:
			open_shop()
		else:
			close_shop()


func open_inventory() -> void:
	last_cam = player.current_cam
	last_cam.visible = false
	visible = true
	inventory_ui.clear_inventory_ui()
	inventory_ui.set_inventory_ui()
	inventory_ui.visible = true
	top_level = true
	player.in_inventory = true
	player.current_cam = self
	set_cam(self)
	MouseController.set_mouse_visible(true)


func close_inventory() -> void:
	last_cam.visible = true
	visible = false
	inventory_ui.visible = false
	top_level = false
	player.in_inventory = false
	player.current_cam = last_cam
	set_cam(last_cam)
	MouseController.set_mouse_visible(false)


func open_shop() -> void:
	last_cam = player.current_cam
	last_cam.visible = false
	visible = true
	shop_ui.reset_shop(shop_ui.current_tab_type)
	shop_ui.visible = true
	top_level = true
	player.in_shop = true
	player.current_cam = self
	set_cam(self)
	MouseController.set_mouse_visible(true)
	player.saved_clothes.push_back(player.hair)
	player.saved_clothes.push_back(player.top)
	player.saved_clothes.push_back(player.bottom)
	player.saved_clothes.push_back(player.shoes)
	player.saved_clothes.push_back(player.accessory)
	player.hair.mesh = null
	player.top.mesh = null
	player.bottom.mesh = null
	player.shoes.mesh = null
	player.accessory.mesh = null


func close_shop() -> void:
	last_cam.visible = true
	visible = false
	shop_ui.visible = false
	top_level = false
	player.in_shop = false
	player.current_cam = last_cam
	set_cam(last_cam)
	MouseController.set_mouse_visible(false)
