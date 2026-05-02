extends Node

@export var app_icon: Texture
@onready var spawn_anim: Node = $"../Spawn_Anim"

@export var taskbar_icon : Node

const TASKBAR_APP = preload("uid://56qm250gjqs4")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tba = TASKBAR_APP.instantiate()
	tba.get_node("TextureRect").texture = app_icon
	tba.get_node("Open_Window").window = spawn_anim
	taskbar_icon = tba
	get_tree().get_first_node_in_group("Desktop").add_child.call_deferred(tba)

func remove_taskbar():
	gb.taskbar_objects.remove_at(gb.taskbar_objects.find(taskbar_icon))
	taskbar_icon.queue_free()
