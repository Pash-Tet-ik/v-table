extends "res://scenes/entities/card.gd"

var is_dragging := false
var dragging_offset = Vector2.ZERO


func _ready() -> void:
	if !multiplayer.is_server():
		set_up(data)


func _process(_delta: float) -> void:
	if is_dragging:
		sync_position.rpc(get_global_mouse_position() + dragging_offset)


func _on_name_button_down() -> void:
	if !G.smth_is_pick:
		is_dragging = true
		dragging_offset = global_position - get_global_mouse_position()
		G.smth_is_pick = true


func _on_name_button_up() -> void:
	is_dragging = false
	dragging_offset = Vector2.ZERO
	G.smth_is_pick = false
	if !multiplayer.is_server() and G.user:
		var cont = G.user.get_node("ui/CharacterBlock/main")
		if cont.visible:
			if cont.get_global_mouse_position().x < cont.global_position.x + cont.size.x:
				var moves_box = G.user.get_node("ui/CharacterBlock/main/character_list/VBoxContainer/main/TabContainer/moves/v_box")
				var new_card = load("res://scenes/entities/card_on_list.tscn").instantiate()
				new_card.set_up(data)
				moves_box.add_child(new_card)
				delite.rpc()


@rpc("any_peer", "call_local")
func delite():
	if multiplayer.is_server():
		queue_free()


@rpc("any_peer", "call_local")
func sync_position(pos: Vector2):
	global_position = pos
