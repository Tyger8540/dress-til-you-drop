extends Node

# TODO see if we need to add different lists for each category
var inventory: Array[InventoryItem] = []
#var player_node: Node = null
@onready var inventory_slot_scene = preload("res://scenes/inventory_slot.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: Push_back default clothing into inventory
	var underwear_top: InventoryItem = InventoryItem.new()
	var underwear_bottom: InventoryItem = InventoryItem.new()
	
	underwear_top.item_type = Enums.ClothingType.TOP
	underwear_top.item_name = "Underwear Top"
	underwear_top.item_texture = load("res://models/main_character/underwear-top.obj")
	underwear_top.ui_texture = load("res://art/inventory_icons/underwear/top.png")
	add_item(underwear_top)
	
	underwear_bottom.item_type = Enums.ClothingType.BOTTOM
	underwear_bottom.item_name = "Underwear Bottom"
	underwear_bottom.item_texture = load("res://models/main_character/underwear-bottom.obj")
	underwear_bottom.ui_texture = load("res://art/inventory_icons/underwear/bottom.png")
	add_item(underwear_bottom)
	
	var schoolgirl_top: InventoryItem = InventoryItem.new()
	schoolgirl_top.item_type = Enums.ClothingType.TOP
	schoolgirl_top.item_name = "Schoolgirl Top"
	schoolgirl_top.item_texture = load("res://models/main_character/schoolgirl-top.obj")
	schoolgirl_top.ui_texture = load("res://art/inventory_icons/fancy_outfit/top.png")
	add_item(schoolgirl_top)
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_item(item: InventoryItem) -> void:
	inventory.push_back(item)
	#Signals.inventory_updated.emit()
	print("Item added!", inventory)
