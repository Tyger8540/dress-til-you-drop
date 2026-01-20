class_name Player
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var current_cam: Camera3D

var move_direction: Vector3
var locked_cam_orientation: float = 0.0
var move_orientation_locked: bool = false
var in_inventory: bool = false

@onready var body: MeshInstance3D = $Body
@onready var accessory: MeshInstance3D = $Body/Accessory
@onready var top: MeshInstance3D = $Body/Top
@onready var bottom: MeshInstance3D = $Body/Bottom
@onready var shoes: MeshInstance3D = $Body/Shoes


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	
	if velocity.is_zero_approx():
		move_orientation_locked = false
	
	if move_direction:
		if not move_orientation_locked:
			locked_cam_orientation = current_cam.global_rotation.y
			move_orientation_locked = true
		
		look_at(global_position + move_direction)
		move_direction = move_direction.rotated(Vector3.UP, locked_cam_orientation)
		
		velocity.x = move_direction.x * SPEED
		velocity.z = move_direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if in_inventory:
		return
	
	move_and_slide()


func dress_up() -> void:
	# TODO PROTOTYPE CODE TO FIX
	top.mesh = load("res://models/main_character/schoolgirl-top.obj")
	bottom.mesh = load("res://models/main_character/schoolgirl-bottom.obj")
	shoes.mesh = load("res://models/main_character/schoolgirl-shoes.obj")
