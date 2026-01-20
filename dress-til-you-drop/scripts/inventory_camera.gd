class_name InventoryCamera
extends Camera

@export var inventory_ui: Control

var last_cam: Camera


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	#look_at(player.global_position)
	
	if Input.is_action_just_pressed("inventory"):
		if not player.in_inventory:
			last_cam = player.current_cam
			last_cam.visible = false
			visible = true
			inventory_ui.visible = true
			top_level = true
			player.in_inventory = true
			player.current_cam = self
			set_cam(self)
		else:
			last_cam.visible = true
			visible = false
			inventory_ui.visible = false
			top_level = false
			player.in_inventory = false
			player.current_cam = last_cam
			set_cam(last_cam)
	
