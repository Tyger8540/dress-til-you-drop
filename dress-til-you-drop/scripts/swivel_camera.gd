class_name SwivelCamera
extends Camera

const SWIVEL_SPEED = 5.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	look_at(player.global_position)
	player.rotation.y = rotation.y
