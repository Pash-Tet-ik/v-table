extends Node2D

var input_access

func _ready() -> void:
	G.user = self

func set_up_charachter(character):
	var list = load("res://scenes/character_list/character_list.tscn").instantiate()
	list.set_up(character)
	$ui.add_child(list)


func _on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_refresh_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/characters_preview.tscn")


func _on_file_dialog_mouse_entered() -> void:
	G.user.input_access = false

func _on_file_dialog_mouse_exited() -> void:
	G.user.input_access = true


func _on_file_dialog_file_selected(path: String) -> void:
	var load_file = FileAccess.open(path, FileAccess.READ)
	G.characters.append(JSON.parse_string(load_file.get_as_text()))
	load_file.close()


func _on_add_new_pressed() -> void:
	$ui/right_bot/add_new/FileDialog.show()
