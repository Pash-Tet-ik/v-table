extends PanelContainer

var is_dragging : bool = false
var dragging_offset = Vector2.ZERO

var holder : Control
var canvas : CanvasLayer
var base_parent : Node

func _on_name_button_down() -> void:
	canvas = CanvasLayer.new()
	base_parent = get_parent()
	holder = Control.new()
	holder.custom_minimum_size.y = size.y

	add_sibling(canvas)
	add_sibling(holder)
	reparent(canvas)

	is_dragging = true
	dragging_offset = global_position - get_global_mouse_position()


func _process(delta: float) -> void:
	if is_dragging:
		position.y = (get_global_mouse_position() + dragging_offset).y

		var node_under_dragging = find_index_by_y(global_position.y - 10, base_parent)
		if node_under_dragging:
			base_parent.move_child(holder, node_under_dragging)


func _input(event: InputEvent) -> void:
	if is_dragging:
		if event is InputEventMouseButton and !event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var node_under_dragging = find_index_by_y(global_position.y - 10, base_parent)
			reparent(base_parent)
			base_parent.move_child(self, node_under_dragging)
			holder.queue_free()
			canvas.queue_free()
			is_dragging = false


func find_index_by_y(y, box):
	for node in box.get_children():
		if node.get_class() == "PanelContainer" or node == holder:
			if node.global_position.y > y:
				return node.get_index()
	return box.get_child_count() - 1
	
