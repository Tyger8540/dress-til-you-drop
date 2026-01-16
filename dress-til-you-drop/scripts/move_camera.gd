class_name MoveCamera
extends Camera

enum CAM_AXIS { NONE, X, Y, Z, XY, XZ, YZ }

const FOLLOW_SPEED = 2.5

@export var cam_axis: CAM_AXIS


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match cam_axis:
		CAM_AXIS.X:
			global_position.x = lerp(global_position.x, player.global_position.x, FOLLOW_SPEED * delta)
		CAM_AXIS.Y:
			global_position.y = lerp(global_position.y, player.global_position.y, FOLLOW_SPEED * delta)
		CAM_AXIS.Z:
			global_position.z = lerp(global_position.z, player.global_position.z, FOLLOW_SPEED * delta)
		CAM_AXIS.XY:
			global_position.x = lerp(global_position.x, player.global_position.x, FOLLOW_SPEED * delta)
			global_position.y = lerp(global_position.y, player.global_position.y, FOLLOW_SPEED * delta)
		CAM_AXIS.XZ:
			global_position.x = lerp(global_position.x, player.global_position.x, FOLLOW_SPEED * delta)
			global_position.z = lerp(global_position.z, player.global_position.z, FOLLOW_SPEED * delta)
		CAM_AXIS.YZ:
			global_position.y = lerp(global_position.y, player.global_position.y, FOLLOW_SPEED * delta)
			global_position.z = lerp(global_position.z, player.global_position.z, FOLLOW_SPEED * delta)
		_:
			pass


func set_cam(cam: Camera) -> void:
	super(cam)
	
	match cam_axis:
		CAM_AXIS.X:
			global_position.x = player.global_position.x
		CAM_AXIS.Y:
			global_position.y = player.global_position.y
		CAM_AXIS.Z:
			global_position.z = player.global_position.z
		_:
			pass
	look_at(player.global_position)
