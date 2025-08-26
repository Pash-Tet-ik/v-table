extends PanelContainer

@onready var body = $VBoxContainer/body

var is_dragging : bool = false
var dragging_offset = Vector2.ZERO


func _process(delta):
	if is_dragging:
		sync_position.rpc(get_global_mouse_position() + dragging_offset)


func set_up(selected_dises : Array, user_name := "", user_color := "#FFFFFF"):
	$VBoxContainer/header/header.text = user_name
	$VBoxContainer/header/header.add_theme_color_override("font_color", Color(user_color))
	$VBoxContainer/header/header.add_theme_color_override("font_hover_pressed_color", Color(user_color))
	$VBoxContainer/header/header.add_theme_color_override("font_hover_color", Color(user_color))
	$VBoxContainer/header/header.add_theme_color_override("font_pressed_color", Color(user_color))
	set_up_roulettes(selected_dises)


func set_up_roulettes(selected_dises : Array):
	for i in range(len(selected_dises)):
		var roulette = load("res://scenes/roulette.tscn").instantiate()
		roulette.set_up(selected_dises[i], 50, 2.2 + randf_range(-1, 1))
		$VBoxContainer/body.add_child(roulette, true)


@rpc("any_peer", "call_local")
func sync_position(pos: Vector2):
	global_position = pos


func _on_button_pressed() -> void:
	delite.rpc()


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
