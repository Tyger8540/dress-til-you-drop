class_name PauseMenuButton
extends Button

@export var pause_menu: PauseMenu
@export var pause_menu_state: PauseMenu.MenuState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_visibility_changed() -> void:
	# enables hover logic when hovering on pause menu open
	if get_global_rect().has_point(get_global_mouse_position()):
		pause_menu.set_panel(pause_menu_state)


func _on_mouse_entered() -> void:
	pause_menu.set_panel(pause_menu_state)
	Audio.play_sound(load("res://audio/sfx/UI/Hover.wav"))


func _on_mouse_exited() -> void:
	pause_menu.set_panel(PauseMenu.MenuState.NONE)
