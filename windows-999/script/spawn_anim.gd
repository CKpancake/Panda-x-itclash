extends Node

@onready var base_window: Control = $".."
@export var spawn_taskbar_icon: Node 

var save_position := Vector2(0,0)
var custom_scale := 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open()
	

func open():
	base_window.visible = true
	base_window.scale = Vector2(0.6,0.6)
	base_window.modulate.a = 0.0
	var t = create_tween()
	t.set_parallel()
	t.tween_property(base_window,"scale",Vector2(1.0,1.0) * custom_scale,0.15).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	t.tween_property(base_window,"modulate",Color(1.0, 1.0, 1.0, 1.0),0.25).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func close():
	var t = create_tween()
	t.set_parallel()
	t.tween_property(base_window,"scale",Vector2(0.6,0.6) * custom_scale,0.25).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	t.tween_property(base_window,"modulate",Color(1.0, 1.0, 1.0, 0.0),0.15).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.25).timeout
	base_window.visible = false

func minimize():
	save_position = base_window.global_position
	var t = create_tween()
	t.set_parallel()
	t.tween_property(base_window,"scale",Vector2(0.1,0.1) * custom_scale,0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	t.tween_property(base_window,"global_position",spawn_taskbar_icon.taskbar_icon.global_position,0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	t.tween_property(base_window,"modulate",Color(1.0, 1.0, 1.0, 0.0),0.3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.2).timeout
	base_window.visible = false

func maximize():
	base_window.visible = true
	var t = create_tween()
	t.set_parallel()
	t.tween_property(base_window,"scale",Vector2(1.0,1.0) * custom_scale,0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	t.tween_property(base_window,"global_position",save_position,0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	t.tween_property(base_window,"modulate",Color(1.0, 1.0, 1.0, 1.0),0.3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
