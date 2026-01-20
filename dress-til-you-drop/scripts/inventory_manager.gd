extends Node

# TODO see if we need to add different lists for each category
var inventory = [] 
var player_node: Node = null


signal inventory_updated


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: Push_back default clothing into inventory
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_item(item):
	inventory.push_back(item)
	print("Item added!", inventory)
