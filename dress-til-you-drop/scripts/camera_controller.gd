extends Node

@export var cams: Array[Camera3D]
@export var cam_zones: Array[Area3D]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_cam(cam: Camera3D) -> void:
	cam.make_current()
	#if cam_zone.previous_cam.current:
		#cam_zone.next_cam.make_current()
	#else:
		#cam_zone.previous_cam.make_current()
