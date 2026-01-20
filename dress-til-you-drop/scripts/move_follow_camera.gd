extends MoveCamera

enum FollowAxis { NONE, X_POS, X_NEG, Y_POS, Y_NEG, Z_POS, Z_NEG }

@export var follow_axis: FollowAxis
@export var follow_distance: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)
	
	match follow_axis:
		FollowAxis.X_POS:
			global_position.x = lerp(global_position.x, player.global_position.x + follow_distance, FOLLOW_SPEED * delta)
		FollowAxis.X_NEG:
			global_position.x = lerp(global_position.x, player.global_position.x - follow_distance, FOLLOW_SPEED * delta)
		FollowAxis.Y_POS:
			global_position.y = lerp(global_position.y, player.global_position.y + follow_distance, FOLLOW_SPEED * delta)
		FollowAxis.Y_NEG:
			global_position.y = lerp(global_position.y, player.global_position.y - follow_distance, FOLLOW_SPEED * delta)
		FollowAxis.Z_POS:
			global_position.z = lerp(global_position.z, player.global_position.z + follow_distance, FOLLOW_SPEED * delta)
		FollowAxis.Z_NEG:
			global_position.z = lerp(global_position.z, player.global_position.z - follow_distance, FOLLOW_SPEED * delta)
