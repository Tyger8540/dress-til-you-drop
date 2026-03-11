class_name Player
extends CharacterBody3D

const SPEED = 4.0
const JUMP_VELOCITY = 4.5
const MAX_STEP_HEIGHT = 0.5  # NOTE might change for diff stair objects

@export var current_cam: Camera3D

var in_dialog: bool = false

var move_direction: Vector3
var locked_cam_orientation: float = 0.0
var move_orientation_locked: bool = false
var in_inventory: bool = false

var _snapped_to_stairs_last_frame = -INF
var _last_frame_was_on_floor = -INF

@onready var body: MeshInstance3D = $Body
@onready var accessory: MeshInstance3D = $Body/Accessory
@onready var top: MeshInstance3D = $Body/Top
@onready var bottom: MeshInstance3D = $Body/Bottom
@onready var shoes: MeshInstance3D = $Body/Shoes

@onready var inventory_ui = $InventoryUI


func _ready():
	Signals.inventory_slot_selected.connect(_on_inventory_slot_selected)
	print(typeof(Enums.CurrencyType.keys()[Enums.CurrencyType.STAR_SHIMMERS]))
	#typeof()


func _physics_process(delta: float) -> void:
	if is_on_floor(): _last_frame_was_on_floor = Engine.get_physics_frames()
	
	# Add the gravity.
	if not (is_on_floor() or _snapped_to_stairs_last_frame):
		velocity += get_gravity() * delta

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
	
	if not _snap_up_stairs_check(delta):
		# Because _snap_up_stairs_check moves the body manually, don't call move_and_slide
		# This should be fine since we ensure with the body_test_motion that it doesn't
		# collide with anything except the stairs it's moving up to.
		move_and_slide()
		_snap_down_to_stairs_check()


## TODO once merged with main (logic for opening inventory in inventory_camera.gd)
#func _input(event) -> void:
	#if event.is_action_pressed("inventory"):
		#inventory_ui.visible = !inventory_ui.visible
		#get_tree().paused = !get_tree().paused


func _on_inventory_slot_selected(inventory_slot: InventorySlotButton) -> void:
	match inventory_ui.current_tab_type:
		Enums.ClothingType.ACCESSORY:
			accessory.mesh = inventory_slot.inventory_item.item_texture
		Enums.ClothingType.TOP:
			top.mesh = inventory_slot.inventory_item.item_texture
		Enums.ClothingType.BOTTOM:
			bottom.mesh = inventory_slot.inventory_item.item_texture
		Enums.ClothingType.SHOES:
			shoes.mesh = inventory_slot.inventory_item.item_texture
	if in_inventory:
		return


func is_surface_too_steep(normal: Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle


func dress_up() -> void:
	# TODO PROTOTYPE CODE TO FIX
	top.mesh = load("res://models/main_character/schoolgirl-top.obj")
	bottom.mesh = load("res://models/main_character/schoolgirl-bottom.obj")
	shoes.mesh = load("res://models/main_character/schoolgirl-shoes.obj")


func _snap_down_to_stairs_check() -> void:
	var did_snap := false
	var floor_below: bool = %StairsBelowRayCast3D.is_colliding() and not is_surface_too_steep(%StairsBelowRayCast3D.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() - _last_frame_was_on_floor == 1
	if not is_on_floor() and velocity.y <= 0.0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result = PhysicsTestMotionResult3D.new()
		if _run_body_test_motion(self.global_transform, Vector3(0.0, -MAX_STEP_HEIGHT, 0.0), body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
	_snapped_to_stairs_last_frame = did_snap


func _snap_up_stairs_check(delta) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame: return false
	# Don't snap stairs if trying to jump, also no need to check for stairs ahead if not moving
	if self.velocity.y > 0.0 or (self.velocity * Vector3(1.0, 0.0, 1.0)).length() == 0.0: return false
	var expected_move_motion = self.velocity * Vector3(1.0, 0.0, 1.0) * delta
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion + Vector3(0.0, MAX_STEP_HEIGHT * 2.0, 0.0))
	# Run a body_test_motion slightly above the pos we expect to move to, towards the floor.
	#  We give some clearance above to ensure there's ample room for the player.
	#  If it hits a step <= MAX_STEP_HEIGHT, we can teleport the player on top of the step
	#  along with their intended motion forward.
	var down_check_result = KinematicCollision3D.new()
	if (self.test_move(step_pos_with_clearance, Vector3(0.0, -MAX_STEP_HEIGHT * 2.0, 0.0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("GeometryInstance3D"))):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		# Note I put the step_height <= 0.01 in just because I noticed it prevented some physics glitchiness
		# 0.02 was found with trial and error. Too much and sometimes get stuck on a stair. Too little and can jitter if running into a ceiling.
		# The normal character controller (both jolt & default) seems to be able to handled steps up of 0.1 anyway
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 or (down_check_result.get_position() - self.global_position).y > MAX_STEP_HEIGHT: return false
		%StairsAheadRayCast3D.global_position = down_check_result.get_position() + Vector3(0.0, MAX_STEP_HEIGHT, 0.0) + expected_move_motion.normalized() * 0.1
		%StairsAheadRayCast3D.force_raycast_update()
		if %StairsAheadRayCast3D.is_colliding() and not is_surface_too_steep(%StairsAheadRayCast3D.get_collision_normal()):
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false


func _run_body_test_motion(from: Transform3D, motion: Vector3, result = null) -> bool:
	if not result: result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)
