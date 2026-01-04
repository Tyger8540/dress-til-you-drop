extends Node3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

func _ready():
	label.hide()

const base_text = "[E] to "

var interactable_areas = []
var can_interact = true

func register_area(area: InteractionArea):
	if not interactable_areas.has(area):
		interactable_areas.push_back(area)

func unregister_area(area: InteractionArea):
	interactable_areas.erase(area)

func _process(_delta):
	if interactable_areas.size() > 0 && can_interact:
		interactable_areas.sort_custom(_sort_by_distance_to_player)
		label.text = base_text + interactable_areas[0].action_name
		
		var area_3d_pos = interactable_areas[0].global_position
		
		# Get current camera
		var camera = get_viewport().get_camera_3d()
		
		# If camera exists, check if point is in front of us
		if camera:
			if not camera.is_position_behind(area_3d_pos):
				# Convert 3D world pos -> 2D screen pos
				var screen_pos = camera.unproject_position(area_3d_pos)
				label.global_position = screen_pos
				
				# Offsets
				label.global_position.y -= 36
				label.global_position.x -= label.size.x / 2
				label.show()
			else:
				# Hide label if the object is behind the camera
				label.hide()
	else: 
		label.hide()
		
func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
	
func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if interactable_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await interactable_areas[0].interact.call()
			
			can_interact = true
	
	
