extends Control

const MOUSE_SPEED = 1000
const CURSOR_OFFSET = Vector2(-166, -157)

@export var cursor: TextureRect

var mouse_sensitivity_mult: float = 1.0

var clicking: bool = false

var in_minigame: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.minigame_one_started.connect(minigame_started, true)
	Signals.minigame_one_failed.connect(minigame_ended, false)
	Signals.minigame_one_defeated.connect(minigame_ended, false)
	get_tree().scene_changed.connect(check_new_scene)
	#Input.set_mouse_mode(Input.MouseMode.MOUSE_MODE_HIDDEN)
	process_mode = Node.PROCESS_MODE_ALWAYS
	cursor.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos = get_window().get_mouse_position()
	var vector = Input.get_vector("cursor_left", "cursor_right", "cursor_up", "cursor_down")
	
	if vector != Vector2.ZERO:
		var display_size = DisplayServer.window_get_size()
		pos += vector * MOUSE_SPEED * mouse_sensitivity_mult * delta
		pos.x = max(min(pos.x, display_size.x - 1), 0)
		pos.y = max(min(pos.y, display_size.y - 1), 0)
		Input.warp_mouse(pos)
	cursor.position = pos + CURSOR_OFFSET
	#if in_minigame:
		#$CanvasLayer/Cursor.position = $Cursor.position
	
	if not clicking and Input.is_action_just_pressed("ui_click"):
		click()


func click() -> void:
	print("clicking!")
	clicking = true
	var mouse = InputEventMouseButton.new()
	mouse.position = get_global_mouse_position()
	mouse.button_index = MouseButton.MOUSE_BUTTON_LEFT
	mouse.pressed = true
	Input.parse_input_event(mouse)
	await get_tree().process_frame
	mouse.pressed = false
	Input.parse_input_event(mouse)
	clicking = false


func check_new_scene() -> void:
	if get_tree().get_nodes_in_group("player").size() == 0:
		set_mouse_visible(true)
	else:
		set_mouse_visible(false)

#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#print("event relative before: " + str(event.screen_relative))
		#get_viewport().get_mouse_position()
		#get_viewport().warp_mouse(get_viewport().get_mouse_position() * mouse_sensitivity_mult)
		#event.global_position
		#event.screen_relative *= mouse_sensitivity_mult
		#print("event relative after: " + str(event.screen_relative))


func set_mouse_visible(is_visibile: bool):
	#if is_visibile:
		##Input.set_mouse_mode(Input.MouseMode.MOUSE_MODE_VISIBLE)
		#cursor.visible = true
	#else:
		##Input.set_mouse_mode(Input.MouseMode.MOUSE_MODE_CONFINED_HIDDEN)
		#cursor.visible = false
		
	cursor.visible = true


func set_mouse_sensitivity(new_sensitivity) -> void:
	mouse_sensitivity_mult = new_sensitivity


func minigame_started(minigame_scene) -> void:
	in_minigame = true
	set_mouse_visible(true)
	Input.set_mouse_mode(Input.MouseMode.MOUSE_MODE_VISIBLE)
	#cursor.reparent(minigame_scene.get_parent())
	#$CanvasLayer.visible = true


func minigame_ended() -> void:
	in_minigame = false
	set_mouse_visible(false)
	Input.set_mouse_mode(Input.MouseMode.MOUSE_MODE_HIDDEN)
	#cursor.reparent(self)
	#$CanvasLayer.visible = false
