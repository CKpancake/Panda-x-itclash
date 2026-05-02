extends TextureButton

@onready var base_window: Control = $".."
@onready var spawn_anim: Node = $"../Spawn_Anim"
@onready var spawn_taskbar_icon: Node = $"../Spawn_Taskbar_Icon"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_down.connect(close_window)

func close_window():
	spawn_anim.close()
	spawn_taskbar_icon.remove_taskbar()
	await get_tree().create_timer(0.25).timeout
	base_window.queue_free()
