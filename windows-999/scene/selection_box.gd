extends Node

@onready var selection_box: NinePatchRect = $"../SelectionBox"
@onready var collision_shape: CollisionShape2D = $"../SelectionBox/Area2D/CollisionShape2D"


var holding := false
var start_pos := Vector2.ZERO

func _process(_delta: float) -> void:
	var screen_control: Control = get_tree().get_first_node_in_group("ScreenControl")
	var mouse_pos := screen_control.get_global_mouse_position()

	if Input.is_action_just_pressed("click") and gb.mouse_hovering == gb.HoverObj.NONE and not gb.disable_selection_box:
		holding = true
		start_pos = mouse_pos
		selection_box.global_position = start_pos
		selection_box.size = Vector2.ZERO

	if Input.is_action_pressed("click") and holding:
		var size = mouse_pos - start_pos

		# Handle dragging in all directions
		var pos = start_pos

		if size.x < 0:
			pos.x = mouse_pos.x
			size.x = abs(size.x)

		if size.y < 0:
			pos.y = mouse_pos.y
			size.y = abs(size.y)

		selection_box.global_position = pos
		selection_box.size = size
		
		# Update collision shape
		var shape = collision_shape.shape as RectangleShape2D
		if shape:
			shape.size = size
			collision_shape.position = size / 2

	if Input.is_action_just_released("click"):
		holding = false
		selection_box.visible = false
	
	if holding and start_pos.distance_to(mouse_pos) > 12:
		selection_box.visible = true
