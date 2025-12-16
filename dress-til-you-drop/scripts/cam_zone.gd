class_name CamZone
extends Area3D

@export var player: Player
@export var previous_cam: Camera3D
@export var next_cam: Camera3D

var previous_zone_occupied: bool = false
var next_zone_occupied: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body is Node3D:  # TODO change to if body is Player (or whatever player class is called)
		pass


func _on_body_exited(body: Node3D) -> void:
	if body is Node3D:  # TODO change to if body is Player (or whatever player class is called)
		if previous_zone_occupied:
			if previous_cam.current:
				pass
			else:
				previous_cam.make_current()
		elif next_zone_occupied:
			if next_cam.current:
				pass
			else:
				next_cam.make_current()


func _on_previous_zone_body_entered(body: Node3D) -> void:
	if body is Node3D:  # TODO change to if body is Player (or whatever player class is called)
		previous_zone_occupied = true


func _on_previous_zone_body_exited(body: Node3D) -> void:
	if body is Node3D:  # TODO change to if body is Player (or whatever player class is called)
		previous_zone_occupied = false


func _on_next_zone_body_entered(body: Node3D) -> void:
	if body is Node3D:  # TODO change to if body is Player (or whatever player class is called)
		next_zone_occupied = true


func _on_next_zone_body_exited(body: Node3D) -> void:
	if body is Node3D:  # TODO change to if body is Player (or whatever player class is called)
		next_zone_occupied = false
