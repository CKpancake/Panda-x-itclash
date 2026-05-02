extends Button

class_name App

@onready var textureRect: TextureRect = $Sprite_Group/Icon
@onready var label: Label = $Sprite_Group/Label

enum Properties {
	NONE,
	STORAGE,
}

@export var app_properties : Properties

@export var child_apps := [
	#{"id": ,"date": ,"time": }
]

@export var window : PackedScene

@export var texture_icon : Texture

func _ready() -> void:
	textureRect.texture = texture_icon
	label.name = self.name
