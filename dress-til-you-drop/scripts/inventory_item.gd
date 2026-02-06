@tool
class_name InventoryItem
extends Node3D
# TODO Added this to group called Items: Figure out if it is global


@export var item_type = ""
@export var item_name = ""
@export var item_texture: Texture
@export var ui_texture: Texture
# The path to the scene that will be spawned
var scene_path: String = "res://scenes/inventory_item.tscn"


# TODO Ensure that mesh is the correct type to assign
@onready var icon_mesh = $MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Sets texture in the game
	if not Engine.is_editor_hint():
		icon_mesh.texture = item_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# TODO If this does not work, delete the first condition (icon_mesh...item_texture)
	if icon_mesh.texture!= item_texture && Engine.is_editor_hint():
		icon_mesh.texture = item_texture

func pickup_item():
	#var item = {
		#"type": item_type,
		#"name": item_name,
		#"texture": item_texture,
		#"ui_texture": ui_texture,
		#"scene_path": scene_path
	#}
	if InventoryManager.player_node:
		InventoryManager.add_item(self)
		# self.queue_free()
