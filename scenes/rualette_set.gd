extends PanelContainer

@onready var body = $VBoxContainer/body

var is_dragging : bool = false
var dragging_offset = Vector2.ZERO


func _process(delta):
	if is_dragging:
		rpc("sync_position", get_global_mouse_position() + dragging_offset)


@rpc("any_peer", "call_local")
func sync_position(pos: Vector2):
	global_position = pos


func set_up(selected_dises, ids, user_name = "", user_color = "#FFFFFF"):
	$VBoxContainer/header/header.text = user_name
	$VBoxContainer/header/header.add_theme_color_override("font_color", Color(user_color))
	$VBoxContainer/header/header.add_theme_color_override("font_hover_pressed_color", Color(user_color))
	$VBoxContainer/header/header.add_theme_color_override("font_hover_color", Color(user_color))
	$VBoxContainer/header/header.add_theme_color_override("font_pressed_color", Color(user_color))
	$VBoxContainer/body.set_up(selected_dises, ids)


func _on_button_pressed() -> void:
	rpc("delite")


@rpc("any_peer", "call_local")
func delite():
	if multiplayer.is_server():
		queue_free()


func _on_header_button_down() -> void:
	if !G.smth_is_pick:
		is_dragging = true
		dragging_offset = global_position - get_global_mouse_position()
		G.smth_is_pick = true


func _on_header_button_up() -> void:
	is_dragging = false
	dragging_offset = Vector2.ZERO
	G.smth_is_pick = false
