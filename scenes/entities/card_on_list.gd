extends "res://scenes/entities/card.gd"

var is_dragging := false
var dragging_offset = Vector2.ZERO
var placeholder : Control
var canvas : CanvasLayer
var base_parent : Node


func _process(_delta: float) -> void:
	if is_dragging:
		var global_mouse_position = get_global_mouse_position()
		if global_mouse_position.x < base_parent.size.x + 10:
			position.x = placeholder.global_position.x
			position.y = (global_mouse_position + dragging_offset).y
			var node_under_dragging = find_panel_index_by_y(global_position.y - 10, base_parent)
			if node_under_dragging:
				base_parent.move_child(placeholder, node_under_dragging)
		else:
			base_parent.move_child(placeholder, -1)
			position = global_mouse_position + dragging_offset


func _on_name_button_down() -> void:
	is_dragging = true
	dragging_offset = global_position - get_global_mouse_position()

	canvas = CanvasLayer.new()
	base_parent = get_parent()
	placeholder = Control.new()
	placeholder.custom_minimum_size.y = size.y

	add_sibling(canvas)
	add_sibling(placeholder)
	reparent(canvas)


func _input(event: InputEvent) -> void:
	if is_dragging:
		if event is InputEventMouseButton and !event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			drop_card()

func drop_card():
	if get_global_mouse_position().x < base_parent.size.x + 10 or G.table == null:
		var node_under_dragging = find_panel_index_by_y(global_position.y - 10, base_parent)
		reparent(base_parent)
		base_parent.move_child(self, node_under_dragging)
	else:
		var pos = G.table.get_local_mouse_position() +  dragging_offset
		G.table.add_card.rpc(data, pos)
		self.queue_free()
	placeholder.queue_free()
	canvas.queue_free()
	is_dragging = false


func find_panel_index_by_y(y, box):
	for node in box.get_children():
		if node.get_class() == "PanelContainer" or node == placeholder:
			if node.global_position.y > y:
				return node.get_index()
	return box.get_child_count() - 1
