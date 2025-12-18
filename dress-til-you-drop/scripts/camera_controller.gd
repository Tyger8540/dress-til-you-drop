extends Camera3D

const SWIVEL_SPEED = 5.0

@export var player: Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#rotation = rotation.move_toward(global_position - player.global_position, delta * SWIVEL_SPEED)
	look_at(player.global_position)
	player.rotation.y = rotation.y


func set_cam(cam: Camera3D) -> void:
	cam.make_current()
	#if cam_zone.previous_cam.current:
		#cam_zone.next_cam.make_current()
	#else:
		#cam_zone.previous_cam.make_current()
