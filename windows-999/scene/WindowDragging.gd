extends Node

@onready var base_window: Control = $".."
@onready var nine_patch_rect: NinePatchRect = $"../NinePatchRect"

@onready var minimize: TextureButton = $"../Minimize"
@onready var close: TextureButton = $"../Close"
@onready var drag_button: Button = $"../DragButton"
@onready var focus_button: Button = $"../FocusButton"

var draggable := false
var dragging := false
var focusable := false
var window_offset := Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drag_button.mouse_entered.connect(enable_drag)
	drag_button.mouse_exited.connect(disable_drag)
	drag_button.button_down.connect(start_drag)
	drag_button.button_up.connect(stop_drag)
	focus_button.mouse_entered.connect(enable_focus)
	focus_button.mouse_exited.connect(disable_focus)
	gb.mouse_clicked.connect(push_z_index)

func _process(_delta: float) -> void:
	print(focusable)
	if dragging:
		base_window.global_position = base_window.get_global_mouse_position() + window_offset

func enable_drag():
	draggable = true
	
func disable_drag():
	draggable = false
	
func enable_focus():
	focusable = true
	gb.mouse_hovering = gb.HoverObj.WINDOW

func disable_focus():
	focusable = false
	gb.mouse_hovering = gb.HoverObj.NONE

func start_drag():
	dragging = true
	base_window.z_index = 100
	window_offset = base_window.global_position - base_window.get_global_mouse_position()

func stop_drag():
	dragging = false

func push_z_index():
	if focusable or draggable:
		base_window.z_index = 100
	else:
		base_window.z_index = 1
