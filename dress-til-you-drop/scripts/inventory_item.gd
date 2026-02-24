@tool
class_name InventoryItem
extends Node3D
# TODO Added this to group called Items: Figure out if it is global


@export var item_type: Enums.ClothingType
@export var item_name = ""
@export var item_texture: Mesh
@export var ui_texture: Texture2D
# The path to the scene that will be spawned
var scene_path: String = "res://scenes/inventory_item.tscn"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pickup_item():
	#var item = {
		#"type": item_type,
		#"name": item_name,
		#"texture": item_texture,
		#"ui_texture": ui_texture,
		#"scene_path": scene_path
	#}
	#if InventoryManager.player_node:
		#InventoryManager.add_item(self)
		# self.queue_free()
	
	InventoryManager.add_item(self)
