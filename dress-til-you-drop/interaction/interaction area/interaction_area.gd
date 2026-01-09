extends Area3D
class_name InteractionArea

const DIALOG_BOX = preload("res://scenes/dialog_box.tscn")

@export var action_name: String = "interact"
@export var dialog: Array[String]


var interact: Callable = func():
	if dialog:
		var dialog_box: DialogBox = spawn_dialog_box()
		await dialog_box.dialog.dialog_finished
		dialog_box.queue_free()
		print("yippee")


func spawn_dialog_box() -> DialogBox:
	var dialog_box = DIALOG_BOX.instantiate()
	dialog_box.initialize_dialog(dialog)
	add_child(dialog_box)
	return dialog_box


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		InteractionManager.register_area(self)


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		InteractionManager.unregister_area(self)
