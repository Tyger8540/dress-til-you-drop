extends Node

# TODO see if we need to add different lists for each category
var inventory: Array[InventoryItem] = []

var minigame_one_defeated := false

var find_my_earring_level: int = 1
var spot_the_anomaly_level: int = 1
var reflex_rendezvous_level: int = 1

#var player_node: Node = null
@onready var inventory_slot_scene = preload("res://scenes/inventory_slot.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.minigame_one_defeated.connect(_on_minigame_one_defeated)
	Signals.get_minigame_loot.connect(_on_minigame_defeated)
	
	# TODO: Push_back default clothing into inventory
	#add_item(load("res://resources/inventory_items/alt_preppy_top.tres"))
	
	add_item(load("res://resources/inventory_items/alt_preppy/alt_preppy_bottom.tres"))
	add_item(load("res://resources/inventory_items/alt_preppy/alt_preppy_hair.tres"))
	add_item(load("res://resources/inventory_items/alt_preppy/alt_preppy_shoes.tres"))
	add_item(load("res://resources/inventory_items/alt_preppy/alt_preppy_top.tres"))
	
	add_item(load("res://resources/inventory_items/light_boho/light_boho_bottom.tres"))
	add_item(load("res://resources/inventory_items/light_boho/light_boho_hair.tres"))
	add_item(load("res://resources/inventory_items/light_boho/light_boho_shoes.tres"))
	add_item(load("res://resources/inventory_items/light_boho/light_boho_top.tres"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_item(item: InventoryItem) -> void:
	inventory.push_back(item)
	#Signals.inventory_updated.emit()
	print("Item added!", inventory)


func _on_minigame_defeated(minigame: Enums.MinigameType) -> void:
	match minigame:
		Enums.MinigameType.FIND_MY_EARRING:
			match find_my_earring_level:
				1:
					add_item(load("res://resources/inventory_items/preppy_pink/preppy_pink_bottom.tres"))
					add_item(load("res://resources/inventory_items/preppy_pink/preppy_pink_hair.tres"))
					add_item(load("res://resources/inventory_items/preppy_pink/preppy_pink_shoes.tres"))
					add_item(load("res://resources/inventory_items/preppy_pink/preppy_pink_top.tres"))
					
					add_item(load("res://resources/inventory_items/snow_bunny/snow_bunny_bottom.tres"))
					add_item(load("res://resources/inventory_items/snow_bunny/snow_bunny_hair.tres"))
					add_item(load("res://resources/inventory_items/snow_bunny/snow_bunny_shoes.tres"))
					add_item(load("res://resources/inventory_items/snow_bunny/snow_bunny_top.tres"))
					
					find_my_earring_level += 1
				2:
					pass
				3:
					pass
				_:
					pass
		Enums.MinigameType.SPOT_THE_ANOMALY:
			match spot_the_anomaly_level:
				1:
					add_item(load("res://resources/inventory_items/catty_pink/catty_pink_bottom.tres"))
					add_item(load("res://resources/inventory_items/catty_pink/catty_pink_hair.tres"))
					add_item(load("res://resources/inventory_items/catty_pink/catty_pink_shoes.tres"))
					add_item(load("res://resources/inventory_items/catty_pink/catty_pink_top.tres"))
				
					add_item(load("res://resources/inventory_items/lone_wolf/lone_wolf_bottom.tres"))
					add_item(load("res://resources/inventory_items/lone_wolf/lone_wolf_hair.tres"))
					add_item(load("res://resources/inventory_items/lone_wolf/lone_wolf_shoes.tres"))
					add_item(load("res://resources/inventory_items/lone_wolf/lone_wolf_top.tres"))
					
					spot_the_anomaly_level += 1
				2:
					add_item(load("res://resources/inventory_items/dark_boho/dark_boho_bottom.tres"))
					add_item(load("res://resources/inventory_items/dark_boho/dark_boho_hair.tres"))
					add_item(load("res://resources/inventory_items/dark_boho/dark_boho_shoes.tres"))
					add_item(load("res://resources/inventory_items/dark_boho/dark_boho_top.tres"))
				
					add_item(load("res://resources/inventory_items/pink_snow/pink_snow_bottom.tres"))
					add_item(load("res://resources/inventory_items/pink_snow/pink_snow_hair.tres"))
					add_item(load("res://resources/inventory_items/pink_snow/pink_snow_shoes.tres"))
					add_item(load("res://resources/inventory_items/pink_snow/pink_snow_top.tres"))
					
					spot_the_anomaly_level += 1
				3:
					add_item(load("res://resources/inventory_items/brown_bear/brown_bear_ bottom.tres"))
					add_item(load("res://resources/inventory_items/brown_bear/brown_bear_hair.tres"))
					add_item(load("res://resources/inventory_items/brown_bear/brown_bear_shoes.tres"))
					add_item(load("res://resources/inventory_items/brown_bear/brown_bear_top.tres"))
				
					add_item(load("res://resources/inventory_items/preppy_peach/preppy_peach_bottom.tres"))
					add_item(load("res://resources/inventory_items/preppy_peach/preppy_peach_hair.tres"))
					add_item(load("res://resources/inventory_items/preppy_peach/preppy_peach_shoes.tres"))
					add_item(load("res://resources/inventory_items/preppy_peach/preppy_peach_top.tres"))
					
				_:
					pass
		Enums.MinigameType.REFLEX_RENDEZVOUS:
			match reflex_rendezvous_level:
				1:
					add_item(load("res://resources/inventory_items/goth_circus/goth_circus_bottom.tres"))
					add_item(load("res://resources/inventory_items/goth_circus/goth_circus_hair.tres"))
					add_item(load("res://resources/inventory_items/goth_circus/goth_circus_shoes.tres"))
					add_item(load("res://resources/inventory_items/goth_circus/goth_circus_top.tres"))
					
					add_item(load("res://resources/inventory_items/preppy_lav/preppy_lav_bottom.tres"))
					add_item(load("res://resources/inventory_items/preppy_lav/preppy_lav_hair.tres"))
					add_item(load("res://resources/inventory_items/preppy_lav/preppy_lav_shoes.tres"))
					add_item(load("res://resources/inventory_items/preppy_lav/preppy_lav_top.tres"))
					
					reflex_rendezvous_level += 1
				2:
					pass
				3:
					pass
				_:
					pass


func _on_minigame_one_defeated() -> void:
	if minigame_one_defeated:
		return
	
	minigame_one_defeated = true
