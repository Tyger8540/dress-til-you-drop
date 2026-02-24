class_name InventoryCamera
extends Camera

@export var inventory_ui: InventoryUI

var last_cam: Camera


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.inventory_closed.connect(close_inventory)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	#look_at(player.global_position)
	
	if Input.is_action_just_pressed("inventory"):
		if not player.in_inventory:
			open_inventory()
		else:
			close_inventory()


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
