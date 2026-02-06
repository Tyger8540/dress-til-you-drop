extends Control


@onready var icon = $ItemIcon


var item = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_item(new_item):
	item = new_item
	icon.texture = new_item["ui_texture"]
