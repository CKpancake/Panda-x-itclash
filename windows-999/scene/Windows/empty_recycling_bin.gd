extends Button

@onready var recyclebin_window: Window_Bar = $"../.."
@onready var inventory: ScrollContainer = $"../../Inventory"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_down.connect(empty)

func empty():
	recyclebin_window.child_apps.clear()
	recyclebin_window.linked_app.child_apps.clear()
	inventory.update_children()
