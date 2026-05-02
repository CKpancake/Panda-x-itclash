extends Node

@onready var taskbar_app: Button = $".."
@onready var hover_box: TextureRect = $"../HoverBox"

@export var window: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	taskbar_app.mouse_entered.connect(enable_drag)
	taskbar_app.mouse_exited.connect(disable_drag)
	taskbar_app.button_down.connect(open_window)

func enable_drag():
	hover_box.visible = true

func disable_drag():
	hover_box.visible = false

func open_window():
	if window.get_parent().visible:
		window.minimize()
	else:
		window.maximize()
