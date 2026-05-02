extends ScrollContainer

@onready var window: Window_Bar = $".."
@onready var Item: Button = $VBoxContainer/Item
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var amount_of_items: Label = $"../Amount of Items"

func _ready() -> void:
	update_children()
	gb.update_storage_children.connect(update_children)
	mouse_entered.connect(show_selection_box)
	mouse_exited.connect(hide_selection_box)

func _process(delta: float) -> void:
	amount_of_items.text = str(window.child_apps) + " Total Items..."

func show_selection_box():
	gb.mouse_hovering = gb.HoverObj.WINDOW

func hide_selection_box():
	gb.mouse_hovering = gb.HoverObj.NONE

func update_children():
	await get_tree().process_frame
	for i in v_box_container.get_children():
		if i.name != "Item":
			i.queue_free()
	for i in window.child_apps:
		var item = Item.duplicate()
		item.visible = true
		item.id = i["id"]
		item.dict_id = i
		item.get_node("Sprite_Group").get_node("TextureRect").texture = i["id"].texture_icon
		item.get_node("Sprite_Group").get_node("Name").text = i["id"].name
		item.get_node("Sprite_Group").get_node("Date").text = i["date"]
		v_box_container.add_child.call_deferred(item)
