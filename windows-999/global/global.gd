extends Node

enum HoverObj {
	APP,
	NONE,
	WINDOW,
}

var grid_size := Vector2(72,72)
var grid_origin := Vector2(24,24)
var mouse_hovering := HoverObj.NONE

var grid_objects := [
	#{"id":  "grid_pos":   }
]

var taskbar_objects := [
	#PackedScene
]

signal mouse_clicked
signal mouse_released

signal store_selected_items
signal disable_area_selection
signal update_storage_children

var disable_selection_box := false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		mouse_clicked.emit()
	if Input.is_action_just_released("click"):
		mouse_released.emit()
