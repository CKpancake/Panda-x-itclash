extends Button

var dict_id := {}
var id : Node
var sillouette_group : Control
var mouse_offset := Vector2(0,0)
var draggable := false
var dragging := false

var old_mouse_pos := Vector2(0,0)

@onready var sprite_group: Control = $Sprite_Group
@onready var window: Window_Bar = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(show_selection_box)
	mouse_exited.connect(hide_selection_box)
	button_down.connect(down)
	button_up.connect(up)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if old_mouse_pos != get_global_mouse_position() and sillouette_group:
		dragging = true
		sillouette_group.global_position = get_global_mouse_position() + mouse_offset
		
func show_selection_box():
	draggable = true
	gb.mouse_hovering = gb.HoverObj.WINDOW

func hide_selection_box():
	draggable = false
	gb.mouse_hovering = gb.HoverObj.NONE

func down():
	if draggable:
		create_sillouette()
		old_mouse_pos = get_global_mouse_position()

func up():
	if gb.mouse_hovering == gb.HoverObj.NONE and id and dragging:
		if sillouette_group:
			sillouette_group.queue_free()
			sillouette_group = null
		
		id.global_position = get_global_mouse_position() 
		id.get_node("AppDragging").snap_to_grid()
		id.visible = true
		
		window.child_apps.erase(dict_id)
		window.linked_app.child_apps.erase(dict_id)
		queue_free()
	else:
		if sillouette_group:
			sillouette_group.queue_free()
			sillouette_group = null

func create_sillouette():
	var sil = sprite_group.duplicate()
	sil.modulate.a = 0.6
	sil.scale = Vector2(0.034,0.034)
	sil.global_position = global_position
	get_tree().get_first_node_in_group("Desktop").add_child.call_deferred(sil)
	mouse_offset = sil.global_position - get_global_mouse_position()
	sillouette_group = sil
