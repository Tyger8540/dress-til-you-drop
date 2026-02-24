extends Control

const MOUSE_SPEED = 10
const CURSOR_OFFSET = Vector2(-166, -157)

var mouse_sensitivity_mult: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MouseMode.MOUSE_MODE_HIDDEN)
	process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos = get_window().get_mouse_position()
	var vector = Input.get_vector("cursor_left", "cursor_right", "cursor_up", "cursor_down")
	
	if vector != Vector2.ZERO:
		var display_size = DisplayServer.window_get_size()
		pos += vector * MOUSE_SPEED * mouse_sensitivity_mult
		pos.x = max(min(pos.x, display_size.x - 1), 0)
		pos.y = max(min(pos.y, display_size.y - 1), 0)
		Input.warp_mouse(pos)
	$Cursor.position = pos + CURSOR_OFFSET


#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#print("event relative before: " + str(event.screen_relative))
		#get_viewport().get_mouse_position()
		#get_viewport().warp_mouse(get_viewport().get_mouse_position() * mouse_sensitivity_mult)
		#event.global_position
		#event.screen_relative *= mouse_sensitivity_mult
		#print("event relative after: " + str(event.screen_relative))


func set_mouse_visible(is_visibile: bool):
	if is_visibile:
		#Input.set_mouse_mode(Input.MouseMode.MOUSE_MODE_VISIBLE)
		$Cursor.visible = true
	else:
		#Input.set_mouse_mode(Input.MouseMode.MOUSE_MODE_CONFINED_HIDDEN)
		$Cursor.visible = false


func set_mouse_sensitivity(new_sensitivity) -> void:
	mouse_sensitivity_mult = new_sensitivity
