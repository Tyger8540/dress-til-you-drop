class_name ShopManager
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func purchase_item(item: Node) -> void:  # TODO make item the correct inventory item type
	# check for required currency
	if PlayerStats.currency[item.currency_type] < item.price:  # TODO change to correct var names if different
		# TODO let the player know they don't have enough funds
		print("insufficient funds")
		return
	
	# if enough currency
		# remove required currency
		# add item to inventory
		# make item out of stock
	
	pass
