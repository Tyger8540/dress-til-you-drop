extends Node

var active: bool = false

var stock: Array[InventoryItem]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_stock()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		purchase_item(load("res://resources/inventory_items/alt_preppy_top.tres"))


func load_stock() -> void:
	pass


func purchase_item(item: InventoryItem) -> void:  # TODO make item the correct inventory item type
	# check for required currency
	for currency_type in item.price:
		if PlayerStats.currency[currency_type] < item.price[currency_type]:
			# TODO let the player know they don't have enough funds
			print("insufficient funds")
			return
	#if PlayerStats.currency[item.currency_type] < item.price:  # TODO change to correct var names if different
		## TODO let the player know they don't have enough funds
		#print("insufficient funds")
		#return
	
	for currency_type in item.price:
		PlayerStats.currency[currency_type] -= item.price[currency_type]  # spend currencies
	
	InventoryManager.add_item(item)
	item.in_inventory = true
	
	# TODO make item out of stock in shop
	
	# TODO notify the player that they successfully purchased the item
