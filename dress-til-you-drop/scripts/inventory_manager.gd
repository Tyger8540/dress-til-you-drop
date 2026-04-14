extends Node

# TODO see if we need to add different lists for each category
var inventory: Array[InventoryItem] = []

var minigame_one_defeated := false

#var player_node: Node = null
@onready var inventory_slot_scene = preload("res://scenes/inventory_slot.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.minigame_one_defeated.connect(_on_minigame_one_defeated)
	
	# TODO: Push_back default clothing into inventory
	#add_item(load("res://resources/inventory_items/alt_preppy_top.tres"))
	
	add_item(load("res://resources/inventory_items/underwear/underwear_top.tres"))
	add_item(load("res://resources/inventory_items/underwear/underwear_bottom.tres"))
	add_item(load("res://resources/inventory_items/french_preppy/french_preppy_bottom.tres"))
	add_item(load("res://resources/inventory_items/french_preppy/french_preppy_hair.tres"))
	add_item(load("res://resources/inventory_items/french_preppy/french_preppy_shoes.tres"))
	add_item(load("res://resources/inventory_items/french_preppy/french_preppy_top.tres"))
	add_item(load("res://resources/inventory_items/bohemian_goth/bohemian_goth_bottom.tres"))
	add_item(load("res://resources/inventory_items/bohemian_goth/bohemian_goth_hair.tres"))
	add_item(load("res://resources/inventory_items/bohemian_goth/bohemian_goth_shoes.tres"))
	add_item(load("res://resources/inventory_items/bohemian_goth/bohemian_goth_top.tres"))
	add_item(load("res://resources/inventory_items/green_preppy/green_preppy_bottom.tres"))
	add_item(load("res://resources/inventory_items/green_preppy/green_preppy_hair.tres"))
	add_item(load("res://resources/inventory_items/green_preppy/green_preppy_shoes.tres"))
	add_item(load("res://resources/inventory_items/green_preppy/green_preppy_top.tres"))
	add_item(load("res://resources/inventory_items/snow_bunny/snow_bunny_bottom.tres"))
	add_item(load("res://resources/inventory_items/snow_bunny/snow_bunny_hair.tres"))
	add_item(load("res://resources/inventory_items/snow_bunny/snow_bunny_shoes.tres"))
	add_item(load("res://resources/inventory_items/snow_bunny/snow_bunny_top.tres"))
	add_item(load("res://resources/inventory_items/witchy_scholar/witchy_scholar_bottom.tres"))
	add_item(load("res://resources/inventory_items/witchy_scholar/witchy_scholar_hair.tres"))
	add_item(load("res://resources/inventory_items/witchy_scholar/witchy_scholar_shoes.tres"))
	add_item(load("res://resources/inventory_items/witchy_scholar/witchy_scholar_top.tres"))
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_item(item: InventoryItem) -> void:
	inventory.push_back(item)
	#Signals.inventory_updated.emit()
	print("Item added!", inventory)


func _on_minigame_one_defeated() -> void:
	if minigame_one_defeated:
		return
	
	minigame_one_defeated = true
