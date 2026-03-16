extends RichTextLabel

var timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = 0.8
	timer.autostart = true
	timer.timeout.connect(_change_state)
	add_child(timer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _change_state() -> void:
	visible = !visible
