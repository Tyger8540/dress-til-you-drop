extends Control

signal minigame_completed(currency_earned: int)
signal minigame_failed()

const ROW_COUNT := 3
const ITEMS_PER_ROW := 6
const SESSION_DURATION := 22.0  # seconds (increased from 15 so player has more time)
const TARGETS_TO_WIN := 3
const LANE_GAP := 10.0
const PLAYFIELD_PADDING_Y := 10.0
const ITEM_GAP_X := 4.0

@export var auto_start_when_run_directly: bool = true
## Inset (left, top, right, bottom) so the fill bar stays inside the timer background. Increase if the bar overflows.
@export var timer_bar_inset: Vector4 = Vector4(8.0, 8.0, 8.0, 8.0)
## Scale of the gem slider. Change in the inspector to resize the gem.
@export var timer_gem_scale: float = 1.0
## Pixels to move the gem down from the fill line (positive = lower). Gem still follows the top of the fill.
@export var timer_gem_offset_y: float = 8.0
## Pixels to crop from top of bar_fill.png (removes empty/transparent space so fill stays aligned).
@export var timer_fill_crop_top: float = 0.0
## Pixels to crop from bottom of bar_fill.png (removes empty space beneath the bar graphic).
@export var timer_fill_crop_bottom: float = 0.0
## Optional custom font for the win screen (message and button). Assign a .ttf/.otf or a FontFile in the inspector.
@export var win_screen_font: FontFile = null
## Font size for the win message ("You found your sister's earring!").
@export var win_screen_message_font_size: int = 50
## Font size for the Continue button text. Set to 0 to use the theme default.
@export var win_screen_button_font_size: int = 35
## Custom button appearance: assign textures for normal, hover, and pressed. If texture_normal is set, a TextureButton is used instead of the default Button.
@export var win_screen_button_texture_normal: Texture2D = null
@export var win_screen_button_texture_hover: Texture2D = null
@export var win_screen_button_texture_pressed: Texture2D = null
## Size of the Continue button when using custom textures (ignored if using default button).
@export var win_screen_button_size: Vector2 = Vector2(160, 48)

@onready var main_frame: Control = $MainFrame
@onready var playfield_frame: ColorRect = $MainFrame/PlayfieldFrame
@onready var playfield: Control = $MainFrame/PlayfieldFrame/Playfield
@onready var target_preview: ColorRect = $MainFrame/TargetPreview
@onready var target_sprite: TextureRect = $MainFrame/TargetPreview/TargetSprite
@onready var score_label: Label = $MainFrame/TopBar/ScoreLabel
@onready var timer_background: TextureRect = $MainFrame/TopBar/TimerContainer/TimerBackground
@onready var timer_bar_bounds: Control = $MainFrame/TimerBarBounds
@onready var timer_bar: TextureRect = $MainFrame/TopBar/TimerContainer/TimerBar
@onready var timer_gem: TextureRect = $MainFrame/TopBar/TimerContainer/TimerGem
@onready var timer_glow: ColorRect = $MainFrame/TopBar/TimerContainer/TimerGlow
@onready var speed_label: Label = $MainFrame/TopBar/SpeedLabel

const EARRING_ITEM_SCENE: PackedScene = preload("res://scenes/earring_item.tscn")
const EARRING_SPRITESHEET_PATH := "res://art/earring_minigame_assets/earrings_spritesheet.PNG"
const TIMER_FILL_TEXTURE_PATH := "res://art/earring_minigame_assets/bar_fill.PNG"
const EARRING_VARIANTS := 17  # 17 unique earring sprites
# Spritesheet: 3 rows × 6 columns; cell [2,5] (bottom-right) is empty.
const EARRING_SHEET_COLS := 6
const EARRING_SHEET_ROWS := 3
const SHAPE_VARIANTS := 17
const COLOR_TIMER_BAR_BASE := Color(0.9, 0.85, 0.35, 1.0)
const COLOR_TIMER_BAR_DANGER := Color(1.0, 0.35, 0.35, 1.0)
const COLOR_TIMER_BG_BASE := Color(0.18, 0.18, 0.22, 1.0)
const COLOR_TIMER_BG_DANGER := Color(0.4, 0.12, 0.16, 1.0)
var row_nodes: Array[Control] = [] # container node for each horizontal row
var rows: Array[Array] = []  # rows[row_index] = array of earringitem
var target_shape_id: int = 0
var time_remaining: float = SESSION_DURATION
var is_active: bool = false
var targets_found: int = 0
## base scroll speed in pixels/second. actual row speed alternates per row.
const BASE_ROW_SPEED := 90.0
var row_speeds: Array[float] = []
var _main_frame_original_scale: Vector2 = Vector2.ONE
var _main_frame_original_pos: Vector2 = Vector2.ZERO
var _speed_multiplier: float = 1.0
var _playfield_original_scale: Vector2 = Vector2.ONE
var _playfield_original_rot: float = 0.0
var _speed_stage: int = 1 # 1x, 2x, 3x
var _zoom_factor: float = 1.0
var _end_shake_seed: float = 0.0
var _shake_time: float = 0.0
var _earring_spritesheet: Texture2D
var _earring_atlas_cache: Dictionary = {}  # index -> AtlasTexture
var _timer_fill_texture: Texture2D
var _timer_fill_atlas: AtlasTexture  # cropped to remove transparent top/bottom
var _win_overlay: Control = null  # win screen shown when player finds all earrings

func _get_earring_atlas_texture(sprite_index: int) -> AtlasTexture:
	if _earring_spritesheet == null:
		_earring_spritesheet = load(EARRING_SPRITESHEET_PATH) as Texture2D
	if _earring_spritesheet == null:
		return null
	var idx: int = clampi(sprite_index, 0, EARRING_VARIANTS - 1) % EARRING_VARIANTS
	if _earring_atlas_cache.has(idx):
		return _earring_atlas_cache[idx]
	var tw: float = float(_earring_spritesheet.get_width())
	var th: float = float(_earring_spritesheet.get_height())
	var cell_w: float = tw / float(EARRING_SHEET_COLS)
	var cell_h: float = th / float(EARRING_SHEET_ROWS)
	# Map linear index 0..16 to (row,col). Cell [2,5] is empty.
	# 0-5 -> row 0, col 0-5; 6-11 -> row 1, col 0-5; 12-16 -> row 2, col 0-4 (skip col 5).
	var sheet_row: int
	var sheet_col: int
	if idx < 12:
		sheet_row = idx / EARRING_SHEET_COLS
		sheet_col = idx % EARRING_SHEET_COLS
	else:
		sheet_row = 2
		sheet_col = idx - 12
	var atlas := AtlasTexture.new()
	atlas.atlas = _earring_spritesheet
	atlas.region = Rect2(sheet_col * cell_w, sheet_row * cell_h, cell_w, cell_h)
	_earring_atlas_cache[idx] = atlas
	return atlas

func _ensure_timer_fill_atlas() -> void:
	if _timer_fill_atlas != null:
		return
	_timer_fill_texture = load(TIMER_FILL_TEXTURE_PATH) as Texture2D
	if _timer_fill_texture == null:
		return
	var tw: float = float(_timer_fill_texture.get_width())
	var th: float = float(_timer_fill_texture.get_height())
	var crop_t: float = clampf(timer_fill_crop_top, 0.0, th - 1.0)
	var crop_b: float = clampf(timer_fill_crop_bottom, 0.0, th - crop_t - 1.0)
	var content_h: float = th - crop_t - crop_b
	_timer_fill_atlas = AtlasTexture.new()
	_timer_fill_atlas.atlas = _timer_fill_texture
	_timer_fill_atlas.region = Rect2(0.0, crop_t, tw, content_h)

func _ready() -> void:
	# hide initially
	visible = false
	
	# convenience for testing: if you press f6 on this scene, auto-start.
	# when used via the game (canvaslayer/trigger), this won't run because the current scene is different.
	_main_frame_original_scale = main_frame.scale
	_main_frame_original_pos = main_frame.position
	_playfield_original_scale = playfield_frame.scale
	_playfield_original_rot = playfield_frame.rotation
	_update_playfield_pivot()
	if not playfield_frame.resized.is_connected(_on_playfield_resized):
		playfield_frame.resized.connect(_on_playfield_resized)
	_end_shake_seed = randf() * 1000.0
	_shake_time = 0.0
	
	_ensure_timer_fill_atlas()
	if is_instance_valid(timer_bar) and _timer_fill_atlas != null:
		timer_bar.texture = _timer_fill_atlas
	if auto_start_when_run_directly and get_tree().current_scene == self:
		start_minigame()

func _process(delta: float) -> void:
	if is_active:
		_update_rows(delta)
		
		var timer_mult := 1.0
		if _speed_stage == 2:
			timer_mult = 1.5
		elif _speed_stage >= 3:
			timer_mult = 2.0
		time_remaining -= delta * timer_mult
		_update_timer_bar()
		_apply_end_shake(delta)
		
		if time_remaining <= 0:
			time_remaining = 0
			_end_session(false)
	else:
		# ensure we don't leave any shake offset behind.
		main_frame.position = _main_frame_original_pos
		_shake_time = 0.0

func start_minigame(rounds: int = 3) -> void:
	targets_found = 0
	time_remaining = SESSION_DURATION
	visible = true
	is_active = true
	_speed_multiplier = 1.0
	_speed_stage = 1
	_zoom_factor = 1.0
	_shake_time = 0.0
	playfield_frame.scale = _playfield_original_scale
	playfield_frame.rotation = _playfield_original_rot
	_spawn_rows()
	_choose_new_target()
	_ensure_target_on_playfield_at_least(5)
	_update_score_label()
	_update_timer_bar()

func _spawn_rows() -> void:
	_clear_rows()
	rows.clear()
	rows.resize(ROW_COUNT)
	row_nodes.clear()
	
	# clear any existing children from the playfield
	for child: Node in playfield.get_children():
		child.queue_free()
	
	# determine row sizing based on the playfield height so rows are evenly spaced
	# and scale with resolution.
	var playfield_height: float = max(1.0, float(playfield.size.y))
	var total_gaps: float = LANE_GAP * float(max(0, ROW_COUNT - 1))
	var usable_height: float = playfield_height - PLAYFIELD_PADDING_Y * 2.0 - total_gaps
	var lane_height: float = usable_height / float(ROW_COUNT)
	var top_offset: float = PLAYFIELD_PADDING_Y
	
	row_speeds.clear()
	
	# create row containers dynamically inside the playfield.
	# each row gets its own control that stays fixed in y; individual earrings
	# inside the row move horizontally and wrap around, giving a conveyor feel.
	for row_index in range(ROW_COUNT):
		var row_container: Control = Control.new()
		row_container.name = "Row_%d" % row_index
		row_container.anchors_preset = Control.PRESET_TOP_LEFT
		row_container.anchor_left = 0.0
		row_container.anchor_right = 0.0
		row_container.anchor_top = 0.0
		row_container.anchor_bottom = 0.0
		row_container.size_flags_horizontal = Control.SIZE_FILL
		row_container.size_flags_vertical = Control.SIZE_FILL
		var lane_y: float = top_offset + (float(row_index) * (lane_height + LANE_GAP))
		row_container.position = Vector2(0.0, lane_y)
		row_container.custom_minimum_size = Vector2(playfield.size.x, lane_height)
		playfield.add_child(row_container)
		
		row_nodes.append(row_container)
		
		# alternate direction per row (even rows move right, odd rows move left)
		var direction: float = 1.0 if row_index % 2 == 0 else -1.0
		row_speeds.append(BASE_ROW_SPEED * direction)
	
	for row_index in range(ROW_COUNT):
		var row_node: Control = row_nodes[row_index]
		if row_node == null:
			continue
		rows[row_index] = []
		
		var row_width: float = playfield.size.x
		var center_y: float = row_node.custom_minimum_size.y * 0.5
		
		# build a contiguous belt that covers the visible width + a bit extra off-screen.
		# item size is derived from the lane height so tiles always \"fill\" the lane.
		var item_h: float = lane_height * 0.7
		var item_w: float = item_h
		var spacing: float = item_w + ITEM_GAP_X
		var needed_count: int = int(ceil((row_width + item_w * 2.0) / spacing))
		needed_count = max(needed_count, ITEMS_PER_ROW)
		
		for i in range(needed_count):
			var earring: EarringItem = EARRING_ITEM_SCENE.instantiate()
			earring.earring_id = row_index * 1000 + i
			earring.set_visual_size(item_w)
			var sprite_id: int = _random_shape_id()
			earring.set_shape_id(sprite_id)
			earring.set_sprite_texture(_get_earring_atlas_texture(sprite_id))
			earring.earring_clicked.connect(_on_earring_clicked)
			
			# start slightly off-screen so we always have blocks arriving.
			var start_x: float = -item_w + float(i) * spacing
			earring.position = Vector2(start_x, center_y - earring.custom_minimum_size.y * 0.5)
			
			row_node.add_child(earring)
			rows[row_index].append(earring)

func _update_rows(delta: float) -> void:
	var width: float = playfield.size.x
	
	for row_index in range(ROW_COUNT):
		var speed: float = 0.0
		if row_index < row_speeds.size():
			speed = row_speeds[row_index] * _speed_multiplier
		
		if row_index >= rows.size():
			continue
		
		var row_items: Array = rows[row_index]
		if row_items.is_empty():
			continue
		
		# move all items.
		for earring in row_items:
			if earring == null:
				continue
			earring.position = earring.position + Vector2(speed * delta, 0.0)
		
		# remove items that fully left the view, and spawn brand-new ones off-screen
		# on the entry side to keep spacing contiguous.
		var item_w: float = 0.0
		var spacing: float = 0.0
		for earring in row_items:
			if earring != null:
				item_w = earring.custom_minimum_size.x
				spacing = item_w + ITEM_GAP_X
				break
		if spacing <= 0.0:
			return
		
		var to_remove: Array[EarringItem] = []
		if speed > 0.0:
			for earring in row_items:
				if earring == null:
					continue
				# fully off to the right.
				if earring.position.x >= width + item_w:
					to_remove.append(earring)
		elif speed < 0.0:
			for earring in row_items:
				if earring == null:
					continue
				# fully off to the left.
				if earring.position.x + item_w <= -item_w:
					to_remove.append(earring)
		
		# actually remove them (and free nodes).
		for earring in to_remove:
			if is_instance_valid(earring):
				earring.queue_free()
			row_items.erase(earring)
		
		# spawn new items to keep belt contiguous (no drifting 'group').
		# right-moving: spawn on the left; left-moving: spawn on the right.
		var row_node: Control = row_nodes[row_index]
		var center_y: float = row_node.custom_minimum_size.y * 0.5
		if speed > 0.0:
			# find leftmost x among remaining items.
			var leftmost_x: float = INF
			for earring in row_items:
				if earring == null:
					continue
				leftmost_x = min(leftmost_x, earring.position.x)
			if leftmost_x == INF:
				leftmost_x = 0.0
			# keep spawning until we have an item at/before the entry threshold.
			while leftmost_x > -item_w:
				var new_item: EarringItem = EARRING_ITEM_SCENE.instantiate()
				new_item.earring_id = row_index * 1000 + randi()
				var new_id: int = _random_shape_id()
				new_item.set_shape_id(new_id)
				new_item.set_sprite_texture(_get_earring_atlas_texture(new_id))
				new_item.set_visual_size(item_w)
				new_item.earring_clicked.connect(_on_earring_clicked)
				var spawn_x: float = leftmost_x - spacing
				new_item.position = Vector2(spawn_x, center_y - new_item.custom_minimum_size.y * 0.5)
				row_node.add_child(new_item)
				row_items.append(new_item)
				leftmost_x = spawn_x
		elif speed < 0.0:
			# find rightmost right-edge among remaining items.
			var rightmost_edge: float = -INF
			for earring in row_items:
				if earring == null:
					continue
				rightmost_edge = max(rightmost_edge, earring.position.x + item_w)
			if rightmost_edge == -INF:
				rightmost_edge = width
			while rightmost_edge < width + item_w:
				var new_item: EarringItem = EARRING_ITEM_SCENE.instantiate()
				new_item.earring_id = row_index * 1000 + randi()
				var new_id: int = _random_shape_id()
				new_item.set_shape_id(new_id)
				new_item.set_sprite_texture(_get_earring_atlas_texture(new_id))
				new_item.set_visual_size(item_w)
				new_item.earring_clicked.connect(_on_earring_clicked)
				var spawn_x: float = rightmost_edge + ITEM_GAP_X
				new_item.position = Vector2(spawn_x, center_y - new_item.custom_minimum_size.y * 0.5)
				row_node.add_child(new_item)
				row_items.append(new_item)
				rightmost_edge = spawn_x + item_w

func _choose_new_target() -> void:
	var all_earrings: Array[EarringItem] = []
	for row in rows:
		for e in row:
			all_earrings.append(e)
	
	if all_earrings.is_empty():
		return
	
	var chosen: EarringItem = all_earrings[randi() % all_earrings.size()]
	target_shape_id = chosen.get_shape_id()
	_update_target_preview()

## Ensures at least min_count earrings on the playfield have the current target shape,
## so the player always has enough targets to find (e.g. 3 for TARGETS_TO_WIN).
func _ensure_target_on_playfield_at_least(min_count: int) -> void:
	var all_earrings: Array[EarringItem] = []
	for row in rows:
		for e in row:
			all_earrings.append(e)
	if all_earrings.is_empty():
		return
	var target_count: int = 0
	for e in all_earrings:
		if e.get_shape_id() == target_shape_id:
			target_count += 1
	if target_count >= min_count:
		return
	var need_more: int = min_count - target_count
	var non_target: Array[EarringItem] = []
	for e in all_earrings:
		if e.get_shape_id() != target_shape_id:
			non_target.append(e)
	non_target.shuffle()
	for i in range(mini(need_more, non_target.size())):
		var earring: EarringItem = non_target[i]
		earring.set_shape_id(target_shape_id)
		earring.set_sprite_texture(_get_earring_atlas_texture(target_shape_id))

func _clear_rows() -> void:
	for row in rows:
		for earring in row:
			if is_instance_valid(earring):
				earring.queue_free()
	rows.clear()

func _on_earring_clicked(earring: EarringItem) -> void:
	if not is_active:
		return
	
	# ignore if this earring has already been clicked.
	if not earring.is_clickable:
		return
	
	print("Clicked earring id:", earring.earring_id, "shape:", earring.get_shape_id(), "target shape:", target_shape_id)
	
	if earring.get_shape_id() == target_shape_id:
		# correct earring found!
		print("Correct earring clicked")
		earring.mark_correct()
		_play_correct_fx()
		targets_found += 1
		_update_score_label()
		
		if targets_found >= TARGETS_TO_WIN:
			_end_session(true)
	else:
		# wrong earring - mark and disable further clicks.
		print("Wrong earring clicked")
		earring.mark_incorrect()
		_play_wrong_fx()

func _end_session(success: bool) -> void:
	is_active = false
	# reset playfield transform immediately so the canvas doesn't appear stretched
	# or rotated during the end-of-round message.
	playfield_frame.scale = _playfield_original_scale
	playfield_frame.rotation = _playfield_original_rot
	_speed_multiplier = 1.0
	_speed_stage = 1
	_zoom_factor = 1.0
	main_frame.position = _main_frame_original_pos

	# keep ui stable at end-of-round (no text growth in the left column that can
	# cause the vboxcontainer to reflow/stretch). end immediately.
	_update_score_label()
	if is_instance_valid(speed_label):
		speed_label.text = ""
	if is_instance_valid(timer_glow):
		timer_glow.modulate.a = 0.0

	if success:
		_show_win_screen()
	else:
		_cleanup_and_close()
		minigame_failed.emit()

func _show_win_screen() -> void:
	_clear_win_overlay()
	_win_overlay = Control.new()
	_win_overlay.name = "WinOverlay"
	_win_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_win_overlay.offset_left = 0.0
	_win_overlay.offset_top = 0.0
	_win_overlay.offset_right = 0.0
	_win_overlay.offset_bottom = 0.0
	_win_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	main_frame.add_child(_win_overlay)

	var bg: ColorRect = ColorRect.new()
	bg.name = "WinOverlayBg"
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.offset_left = 0.0
	bg.offset_top = 0.0
	bg.offset_right = 0.0
	bg.offset_bottom = 0.0
	bg.color = Color(0.05, 0.05, 0.12, 0.92)
	bg.mouse_filter = Control.MOUSE_FILTER_STOP
	_win_overlay.add_child(bg)

	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.name = "WinVBox"
	vbox.set_anchors_preset(Control.PRESET_CENTER)
	vbox.anchor_left = 0.5
	vbox.anchor_top = 0.5
	vbox.anchor_right = 0.5
	vbox.anchor_bottom = 0.5
	vbox.offset_left = -200.0
	vbox.offset_top = -80.0
	vbox.offset_right = 200.0
	vbox.offset_bottom = 80.0
	vbox.add_theme_constant_override("separation", 24)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	_win_overlay.add_child(vbox)

	var msg: Label = Label.new()
	msg.name = "WinMessage"
	msg.text = "YOU FOUND YOUR SISTER'S EARRING."
	msg.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	msg.add_theme_font_size_override("font_size", win_screen_message_font_size)
	if win_screen_font != null:
		msg.add_theme_font_override("font", win_screen_font)
	msg.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	msg.custom_minimum_size = Vector2(360, 0)
	vbox.add_child(msg)

	var btn: BaseButton
	if win_screen_button_texture_normal != null:
		var tex_btn: TextureButton = TextureButton.new()
		tex_btn.name = "ContinueButton"
		tex_btn.text = "Continue"
		tex_btn.texture_normal = win_screen_button_texture_normal
		tex_btn.texture_hover = win_screen_button_texture_hover if win_screen_button_texture_hover != null else win_screen_button_texture_normal
		tex_btn.texture_pressed = win_screen_button_texture_pressed if win_screen_button_texture_pressed != null else win_screen_button_texture_normal
		tex_btn.custom_minimum_size = win_screen_button_size
		#tex_btn.expand_mode = TextureButton.EXPAND_IGNORE_SIZE
		if win_screen_font != null:
			tex_btn.add_theme_font_override("font", win_screen_font)
		if win_screen_button_font_size > 0:
			tex_btn.add_theme_font_size_override("font_size", win_screen_button_font_size)
		tex_btn.pressed.connect(_close_after_win)
		btn = tex_btn
	else:
		var std_btn: Button = Button.new()
		std_btn.name = "ContinueButton"
		std_btn.text = "Continue"
		std_btn.custom_minimum_size = win_screen_button_size
		if win_screen_font != null:
			std_btn.add_theme_font_override("font", win_screen_font)
		if win_screen_button_font_size > 0:
			std_btn.add_theme_font_size_override("font_size", win_screen_button_font_size)
		std_btn.pressed.connect(_close_after_win)
		btn = std_btn
	vbox.add_child(btn)

func _close_after_win() -> void:
	_cleanup_and_close()
	minigame_completed.emit(0)

func _clear_win_overlay() -> void:
	if _win_overlay != null and is_instance_valid(_win_overlay):
		_win_overlay.queue_free()
		_win_overlay = null

func _update_timer_bar() -> void:
	var fraction: float = clamp(time_remaining / SESSION_DURATION, 0.0, 1.0)
	var container: Control = $MainFrame/TopBar/TimerContainer
	var full_height: float = container.size.y
	var full_width: float = container.size.x
	# Inner rect: use TimerBarBounds if present (move/resize in 2D editor - it's under MainFrame), else use insets
	var left: float
	var top: float
	var inner_w: float
	var inner_h: float
	if is_instance_valid(timer_bar_bounds):
		# Bounds is under MainFrame; convert its rect to TimerContainer local space
		var bounds_global: Rect2 = timer_bar_bounds.get_global_rect()
		var container_global: Rect2 = container.get_global_rect()
		var sx: float = container.size.x / container_global.size.x if container_global.size.x > 0 else 1.0
		var sy: float = container.size.y / container_global.size.y if container_global.size.y > 0 else 1.0
		left = (bounds_global.position.x - container_global.position.x) * sx
		top = (bounds_global.position.y - container_global.position.y) * sy
		inner_w = max(1.0, bounds_global.size.x * sx)
		inner_h = max(1.0, bounds_global.size.y * sy)
	else:
		left = timer_bar_inset.x
		top = timer_bar_inset.y
		var right: float = timer_bar_inset.z
		var bottom: float = timer_bar_inset.w
		inner_w = max(1.0, full_width - left - right)
		inner_h = max(1.0, full_height - top - bottom)
	# Clamp so inner rect never extends past container
	left = clampf(left, 0.0, full_width - 1.0)
	top = clampf(top, 0.0, full_height - 1.0)
	inner_w = min(inner_w, full_width - left)
	inner_h = min(inner_h, full_height - top)
	# Fill bar: anchored to bottom so it never slides; only height shrinks
	var fill_bottom_y: float = top + inner_h
	var fill_height: float = inner_h * fraction
	var fill_top_y: float = fill_bottom_y - fill_height
	timer_bar.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	timer_bar.anchor_left = 0.0
	timer_bar.anchor_right = 0.0
	timer_bar.anchor_top = 1.0
	timer_bar.anchor_bottom = 1.0
	timer_bar.offset_left = left
	timer_bar.offset_right = left + inner_w
	timer_bar.offset_bottom = fill_bottom_y - full_height
	timer_bar.offset_top = timer_bar.offset_bottom - fill_height
	# Gem: follows the top of the fill line, offset lower by timer_gem_offset_y, stays inside
	if is_instance_valid(timer_gem):
		timer_gem.scale = Vector2(timer_gem_scale, timer_gem_scale)
		var gem_h: float = timer_gem.size.y * timer_gem_scale
		var gem_w: float = timer_gem.size.x * timer_gem_scale
		var fill_line_y: float = fill_top_y
		var gem_y: float = fill_line_y - gem_h + timer_gem_offset_y
		gem_y = clampf(gem_y, top, top + inner_h - gem_h)
		var gem_x: float = left + (inner_w - gem_w) * 0.5
		gem_x = clampf(gem_x, left, left + inner_w - gem_w)
		timer_gem.set_anchors_preset(Control.PRESET_TOP_LEFT)
		timer_gem.offset_left = gem_x
		timer_gem.offset_top = gem_y
		timer_gem.offset_right = gem_x + timer_gem.size.x
		timer_gem.offset_bottom = gem_y + timer_gem.size.y
		var danger: float = 1.0 - fraction
		var ramp: float = clamp((danger - 0.3) / 0.7, 0.0, 1.0)
		timer_gem.modulate = Color(1.0, 1.0, 1.0).lerp(Color(1.0, 0.6, 0.6), ramp * 0.5)

func _update_score_label() -> void:
	score_label.text = "Score: %d / %d" % [targets_found, TARGETS_TO_WIN]

func _cleanup_and_close() -> void:
	_clear_win_overlay()
	_clear_rows()
	visible = false
	is_active = false
	main_frame.scale = _main_frame_original_scale
	main_frame.position = _main_frame_original_pos
	if is_instance_valid(timer_glow):
		timer_glow.modulate.a = 0.0
	if is_instance_valid(speed_label):
		speed_label.text = ""

func _random_shape_id() -> int:
	return randi() % EARRING_VARIANTS

func _update_target_preview() -> void:
	var atlas: AtlasTexture = _get_earring_atlas_texture(target_shape_id)
	if is_instance_valid(target_sprite):
		target_sprite.texture = atlas

func _play_correct_fx() -> void:
	if not is_instance_valid(playfield_frame):
		return
	# step-wise speed stages: 1x -> 2x -> 3x
	if _speed_stage < 3:
		_speed_stage += 1
	if _speed_stage == 1:
		_speed_multiplier = 1.0
	elif _speed_stage == 2:
		_speed_multiplier = 2.0
	else:
		_speed_multiplier = 3.0

	# bring back the subtle \"random rotate + zoom\" on correct click, but only
	# on the playfield canvas (not the ui column). reset happens in `_end_session`.
	_zoom_factor = min(_zoom_factor * 1.03, 1.18)
	var target_scale: Vector2 = _playfield_original_scale * _zoom_factor
	var angle_sign: float
	if randf() < 0.5:
		angle_sign = -1.0
	else:
		angle_sign = 1.0
	var angle_deg: float = angle_sign * (0.6 + randf() * 0.6) # ~0.6–1.2 degrees
	var target_rot: float = deg_to_rad(angle_deg)
	var t := create_tween()
	t.tween_property(playfield_frame, "scale", target_scale, 0.28)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t.parallel().tween_property(playfield_frame, "rotation", target_rot, 0.28)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	if is_instance_valid(timer_glow):
		timer_glow.modulate.a = 0.0
		var glow_tween := create_tween()
		glow_tween.tween_property(timer_glow, "modulate:a", 0.55, 0.18)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		glow_tween.tween_property(timer_glow, "modulate:a", 0.0, 0.22)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if is_instance_valid(speed_label):
		if _speed_stage <= 1:
			speed_label.text = ""
		else:
			speed_label.text = "x%d speed" % _speed_stage
func _apply_end_shake(delta: float) -> void:
	# increase screen shake as time runs out. this shakes the whole `mainframe`
	# (including play area + ui column) for urgency feedback.
	if SESSION_DURATION <= 0.0:
		return
	_shake_time += delta
	var t: float = clamp(1.0 - (time_remaining / SESSION_DURATION), 0.0, 1.0)
	# slightly stronger, earlier sway: quadratic easing for amplitude.
	var ramp: float = t * t                 # more motion mid-game but still subtle
	var amp: float = 6.0 * ramp            # max ~6px at t = 1
	# frequency also ramps up so the sway feels more urgent as time runs out.
	var freq: float = lerp(2.0, 9.0, ramp) # radians per second, 2→9 over time
	var jx: float = sin(_shake_time * freq)
	var jy: float = cos(_shake_time * freq * 1.3)
	main_frame.position = _main_frame_original_pos + Vector2(jx, jy) * amp

func _play_wrong_fx() -> void:
	if not is_instance_valid(main_frame):
		return
	var tween := create_tween()
	var offset := Vector2(6, 0)
	tween.tween_property(main_frame, "position", _main_frame_original_pos + offset, 0.06)
	tween.tween_property(main_frame, "position", _main_frame_original_pos - offset, 0.09)
	tween.tween_property(main_frame, "position", _main_frame_original_pos, 0.10)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_playfield_resized() -> void:
	_update_playfield_pivot()

func _update_playfield_pivot() -> void:
	playfield_frame.pivot_offset = playfield_frame.size * 0.5
