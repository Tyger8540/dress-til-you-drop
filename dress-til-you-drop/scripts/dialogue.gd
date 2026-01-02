extends RichTextLabel

@export var text_speed: float = 0.05
@export var text_marker_speed: float = 0.5

var text_revealing: bool = false
var text_revealed: bool = false
var text_timer: float = 1.0

var text_marker_timer: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_revealing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if text_revealing:
		if visible_ratio == 1.0:
			text_revealing = false
			text_revealed = true
		else:
			text_timer += delta
			if text_timer >= text_speed:
				text_timer = 0.0
				visible_characters += 1
	elif text_revealed:
		text_marker_timer += delta
		if text_marker_timer > text_marker_speed:
			$TextMarker.visible = not $TextMarker.visible
			text_marker_timer = 0.0
