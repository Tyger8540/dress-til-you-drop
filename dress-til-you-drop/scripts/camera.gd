class_name Camera
extends Camera3D

@export var player: Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	look_at(player.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	pass


func set_cam(cam: Camera) -> void:
	cam.make_current()
