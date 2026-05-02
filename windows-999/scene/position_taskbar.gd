extends Node

@onready var taskbar_app: Button = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gb.taskbar_objects.append(taskbar_app)
	taskbar_app.global_position.x = (gb.taskbar_objects.find(taskbar_app) * 50.0) + 200.0
	taskbar_app.global_position.y = 850


# Called every frame. 'delta' is the elapsed time since the previous frame.S
func _process(delta: float) -> void:
	taskbar_app.global_position.y = lerp(taskbar_app.global_position.y,760.0,delta * 10)
	taskbar_app.global_position.x = lerp(taskbar_app.global_position.x,((gb.taskbar_objects.find(taskbar_app) * 50.0) + 200.0),delta * 10)
	
