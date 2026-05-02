extends TextureButton

@onready var base_window: Control = $".."
@onready var spawn_anim: Node = $"../Spawn_Anim"
@onready var spawn_taskbar_icon: Node = $"../Spawn_Taskbar_Icon"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_down.connect(minimize_window)

func minimize_window():
	spawn_anim.minimize()
	
