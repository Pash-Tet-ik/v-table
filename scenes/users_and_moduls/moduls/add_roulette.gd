extends VBoxContainer

var selected_dises : Array


func _ready() -> void:
	for el in get_children():
		if el.name.begins_with("d"):
			el.connect("pressed", Callable(self, "add_dise").bind(el.name))


func _on_throw_pressed() -> void:
	for el in get_children():
		if el == $open:
			el.show()
		else:
			el.hide()
	if selected_dises:
		var aim_pos = G.user.global_position #+ user.get_viewport_rect().size / user.get_child(0).zoom / 2
		if "character" in G.user:
			G.table.add_roulettes(selected_dises, aim_pos, G.user.character["name"], G.user.character["color"])
		else:
			G.table.add_roulettes(selected_dises, aim_pos, "", "#FFFFFF")


func _on_open_pressed() -> void:
	selected_dises = []
	for el in get_children():
		if el == $open:
			el.hide()
		else:
			el.show()


func add_dise(type : String) -> void:
	selected_dises.append(int(type))


func _on_cancel_pressed() -> void:
	for el in get_children():
		if el == $open:
			el.show()
		else:
			el.hide()
