extends Node

@onready var main_node: App = $".."
@export var selection_box : CanvasItem
@export var hover_box : CanvasItem
@export var selection_area : Area2D
@export var app_sprite_group : Control

var draggable := false
var dragging := false
var old_mouse_pos := Vector2(0,0)

@export var sillouette_group : Control
var sillouette_offset := Vector2(0,0)

var anchor_point_offset := Vector2(24,24)

var mouse_active := false
var area_active := false

var custom_scale := 1

var disable_area_switch := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_node.mouse_entered.connect(show_selection_box)
	main_node.mouse_exited.connect(hide_selection_box)
	gb.mouse_clicked.connect(button_down)
	gb.mouse_released.connect(button_up)
	gb.store_selected_items.connect(check_store)
	gb.disable_area_selection.connect(disable_area_selection)
	selection_area.area_entered.connect(show_selection_box_Area)
	selection_area.area_exited.connect(hide_selection_box_Area)
	snap_to_grid()

func _process(_delta: float) -> void:
	if draggable and old_mouse_pos != main_node.get_global_mouse_position() and not dragging:
		create_sillouette()
	
	if sillouette_group:
		sillouette_group.global_position = main_node.get_global_mouse_position() + sillouette_offset
		if not dragging:
			sillouette_group.queue_free()
			sillouette_group = null
	
	if (mouse_active or area_active) and selection_box:
		selection_box.visible = true
	else:
		selection_box.visible = false
	
func show_selection_box():
	hover_box.visible = true
	gb.mouse_hovering = gb.HoverObj.APP

func hide_selection_box():
	hover_box.visible = false
	gb.mouse_hovering = gb.HoverObj.NONE

func show_selection_box_Area(area: Area2D = null):
	if area and not area.is_in_group("SelectionArea"):
		return
	area_active = true

func hide_selection_box_Area(area: Area2D = null):
	if area and not area.is_in_group("SelectionArea"):
		return
	area_active = false

func button_down():
	if not area_active:
		if hover_box.visible and gb.mouse_hovering == gb.HoverObj.APP:
			mouse_active = true
			selection_box.visible = true
		else:
			mouse_active = false
			selection_box.visible = false
	else:
		if hover_box.visible:
			disable_area_switch = true
	if gb.mouse_hovering == gb.HoverObj.NONE:
		mouse_active = false
		area_active = false
	if selection_box.visible and gb.mouse_hovering == gb.HoverObj.APP:
		draggable = true
		old_mouse_pos = main_node.get_global_mouse_position()

func button_up():
	if main_node.app_properties == main_node.Properties.STORAGE and hover_box.visible:
		gb.store_selected_items.emit(main_node)
	snap_to_grid()
	draggable = false
	if dragging:
		dragging = false
	elif disable_area_switch:
		gb.disable_area_selection.emit()
		disable_area_switch = false

func check_store(parent):
	if selection_box.visible and main_node != parent and sillouette_group:
		for obj in gb.grid_objects:
			if obj["id"] == main_node:
				gb.grid_objects.erase(obj)
				break
		main_node.visible = false
		var switch := false
		for i in parent.child_apps:
			if i["id"] == main_node:
				switch = true
				break
		if not switch:
			parent.child_apps.append({
				"id": main_node,
				"date": "6/7/67",
				"time": "6:07",
			})
			gb.update_storage_children.emit()

func create_sillouette():
	dragging = true
	var sg = app_sprite_group.duplicate()
	sg.modulate.a = 0.6
	sg.global_position = app_sprite_group.global_position
	sillouette_offset = sg.global_position - main_node.get_global_mouse_position()
	get_tree().get_first_node_in_group("Desktop").add_child.call_deferred(sg)
	sillouette_group = sg
	sillouette_group.scale *= custom_scale

func snap_to_grid():
	var check_position := Vector2(0,0)
	if sillouette_group:
		check_position = sillouette_group.global_position + anchor_point_offset
	else:
		check_position = main_node.global_position + anchor_point_offset
	check_position = (check_position - gb.grid_origin).snapped(gb.grid_size) + gb.grid_origin - anchor_point_offset
	
	if check_position.x < 0 or check_position.y < 0 or check_position.x > 1280 or check_position.y > 650:
		return
	
	for obj in gb.grid_objects:
		if obj["grid_pos"] == check_position:
			#if obj["id"] != main_node:
				#print(gb.grid_objects)
				#print("Position occupied" + str(obj["grid_pos"]) + "   " + str(check_position) + "  ")
			return
	
	for obj in gb.grid_objects:
		if obj["id"] == main_node:
			gb.grid_objects.erase(obj)
			break
	
	if main_node.visible:
		gb.grid_objects.append({
			"id": main_node,
			"grid_pos": round(check_position)
		})
		
	main_node.global_position = check_position

func disable_area_selection():
	area_active = false
