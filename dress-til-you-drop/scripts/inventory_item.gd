class_name InventoryItem
extends Resource
# TODO Added this to group called Items: Figure out if it is global

@export var item_type: Enums.ClothingType
@export var item_name = ""
@export var item_texture: Mesh
@export var ui_texture: Texture2D
@export var price: Dictionary = {
	"Currency 1": 0,
	"Currency 2": 0,
	"Currency 3": 0,
}
@export var in_inventory: bool = false
# The path to the scene that will be spawned
var scene_path: String = "res://scenes/inventory_item.tscn"
