class_name InteractionArea
extends Area3D

const DIALOG_BOX = preload("res://scenes/dialog_box.tscn")

@export var action_name: String = "interact"
@export var dialog: DialogResource  # lines of dialog to be displayed
@export var accessible: bool  # allows the player to enter the area connected to this InteractionArea
@export var connected_scene: PackedScene  # area connected to this InteractionArea

@export var connected_area: InteractionArea

var dialog_seen: bool = false


var interact: Callable = func():
	if dialog and not dialog_seen:
		var dialog_box: DialogBox = spawn_dialog_box()  # spawn a dialog box
		await dialog_box.dialog.dialog_finished  # await it to finish
		dialog_seen = true
		if dialog == load("res://resources/dialog/shop_1_unlocked.tres"):  # TODO PROTOTYPE CODE TO FIX
			get_tree().get_first_node_in_group("player").dress_up()
		dialog_box.queue_free()  # delete the dialog box
	if accessible:
		# change to the connected scene
		get_tree().change_scene_to_packed(connected_scene)  # TODO maybe change based on future scene changing logic
	if connected_area:
		connected_area.update_state()


func spawn_dialog_box() -> DialogBox:
	var dialog_box = DIALOG_BOX.instantiate()  # create a dialog box instance
	dialog_box.initialize_dialog(dialog)  # initialize with dialog
	add_child(dialog_box)  # add to the scene tree
	return dialog_box


func update_state() -> void:
	# TODO DO NOT HARDCODE THIS AFTER PLAYTEST 1
	get_parent().set_material_override(load("res://resources/materials/green_material.tres"))
	dialog = load("res://resources/dialog/shop_1_unlocked.tres")


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		InteractionManager.register_area(self)


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		InteractionManager.unregister_area(self)
