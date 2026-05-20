class_name InventoryItem
extends Resource
# TODO Added this to group called Items: Figure out if it is global

@export var item_type: Enums.ClothingType
@export var item_name = ""
@export var item_texture: Mesh
@export var ui_texture: Texture2D
@export var price: Dictionary = {
	"Diamonds": 0,
	"Hearts": 0,
	"Mags": 0,
}
@export var in_inventory: bool = false
@export var equipped: bool = false
@export var in_cart: bool = false
@export var locked: bool = false

# The path to the scene that will be spawned
var scene_path: String = "res://scenes/inventory_item.tscn"
