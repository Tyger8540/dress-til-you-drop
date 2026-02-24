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
	
	var underwear_top: InventoryItem = InventoryItem.new()
	underwear_top.item_type = Enums.ClothingType.TOP
	underwear_top.item_name = "Underwear Top"
	underwear_top.item_texture = load("res://models/main_character/underwear/top.obj")
	underwear_top.ui_texture = load("res://art/inventory_icons/underwear/top.png")
	add_item(underwear_top)
	
	var underwear_bottom: InventoryItem = InventoryItem.new()
	underwear_bottom.item_type = Enums.ClothingType.BOTTOM
	underwear_bottom.item_name = "Underwear Bottom"
	underwear_bottom.item_texture = load("res://models/main_character/underwear/bottom.obj")
	underwear_bottom.ui_texture = load("res://art/inventory_icons/underwear/bottom.png")
	add_item(underwear_bottom)
	
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
	
	var fancy_top: InventoryItem = InventoryItem.new()
	fancy_top.item_type = Enums.ClothingType.TOP
	fancy_top.item_name = "Fancy Top"
	fancy_top.item_texture = load("res://models/main_character/fancy outfit/top.obj")
	fancy_top.ui_texture = load("res://art/inventory_icons/fancy_outfit/top.png")
	add_item(fancy_top)
	
	var fancy_bottom: InventoryItem = InventoryItem.new()
	fancy_bottom.item_type = Enums.ClothingType.BOTTOM
	fancy_bottom.item_name = "Fancy Bottom"
	fancy_bottom.item_texture = load("res://models/main_character/fancy outfit/bottom.obj")
	fancy_bottom.ui_texture = load("res://art/inventory_icons/fancy_outfit/bottom.png")
	add_item(fancy_bottom)
	
	var fancy_shoes: InventoryItem = InventoryItem.new()
	fancy_shoes.item_type = Enums.ClothingType.SHOES
	fancy_shoes.item_name = "Fancy Shoes"
	fancy_shoes.item_texture = load("res://models/main_character/fancy outfit/shoes.obj")
	fancy_shoes.ui_texture = load("res://art/inventory_icons/fancy_outfit/shoes.png")
	add_item(fancy_shoes)
	
	var sand_top: InventoryItem = InventoryItem.new()
	sand_top.item_type = Enums.ClothingType.TOP
	sand_top.item_name = "Sand Top"
	sand_top.item_texture = load("res://models/main_character/sand outfit/top.obj")
	sand_top.ui_texture = load("res://art/inventory_icons/sand_outfit/top.png")
	add_item(sand_top)
	
	var sand_bottom: InventoryItem = InventoryItem.new()
	sand_bottom.item_type = Enums.ClothingType.BOTTOM
	sand_bottom.item_name = "Sand Bottom"
	sand_bottom.item_texture = load("res://models/main_character/sand outfit/bottom.obj")
	sand_bottom.ui_texture = load("res://art/inventory_icons/sand_outfit/bottom.png")
	add_item(sand_bottom)
	
	var sand_shoes: InventoryItem = InventoryItem.new()
	sand_shoes.item_type = Enums.ClothingType.SHOES
	sand_shoes.item_name = "Sand Shoes"
	sand_shoes.item_texture = load("res://models/main_character/sand outfit/shoes.obj")
	sand_shoes.ui_texture = load("res://art/inventory_icons/sand_outfit/shoes.png")
	add_item(sand_shoes)
	
	var siren_top: InventoryItem = InventoryItem.new()
	siren_top.item_type = Enums.ClothingType.TOP
	siren_top.item_name = "Siren Top"
	siren_top.item_texture = load("res://models/main_character/siren outfit/top.obj")
	siren_top.ui_texture = load("res://art/inventory_icons/siren_outfit/top.png")
	add_item(siren_top)
	
	var siren_bottom: InventoryItem = InventoryItem.new()
	siren_bottom.item_type = Enums.ClothingType.BOTTOM
	siren_bottom.item_name = "Siren Bottom"
	siren_bottom.item_texture = load("res://models/main_character/siren outfit/bottom.obj")
	siren_bottom.ui_texture = load("res://art/inventory_icons/siren_outfit/bottom.png")
	add_item(siren_bottom)
	
	var siren_shoes: InventoryItem = InventoryItem.new()
	siren_shoes.item_type = Enums.ClothingType.SHOES
	siren_shoes.item_name = "Siren Shoes"
	siren_shoes.item_texture = load("res://models/main_character/siren outfit/shoes.obj")
	siren_shoes.ui_texture = load("res://art/inventory_icons/siren_outfit/shoes.png")
	add_item(siren_shoes)
	
	minigame_one_defeated = true
