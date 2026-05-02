extends Node

@onready var main_node: App = $".."
@onready var app_dragging: Node = $"../AppDragging"

var clickable := false
var double_click_deb := 0.0
var old_position := Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_node.mouse_entered.connect(show_selection_box)
	main_node.mouse_exited.connect(hide_selection_box)
	main_node.button_down.connect(pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	double_click_deb -= delta
	if app_dragging.sillouette_group and old_position != app_dragging.sillouette_group.global_position:
		double_click_deb = -1

func show_selection_box():
	clickable = true

func hide_selection_box():
	clickable = false

func pressed():
	if double_click_deb > 0.0:
		double_click_deb = -1
		if main_node.window:
			var w = main_node.window.instantiate()
			w.global_position = Vector2(400,200) + Vector2(randf_range(0,200),randf_range(0,125))
			w.linked_app = main_node
			if main_node.app_properties == main_node.Properties.STORAGE:
				w.child_apps = main_node.child_apps
			get_tree().get_first_node_in_group("Desktop").add_child.call_deferred(w)
	else:
		double_click_deb = 0.6
		old_position = main_node.global_position
