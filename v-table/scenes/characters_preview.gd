extends Node2D

var input_access

func _ready() -> void:
	$ui/CharacterSelection.user = self
	G.user = self

func set_up_charachter(character):
	var list = load("res://scenes/character_list/character_list.tscn").instantiate()
	list.set_up(character)
	$ui.add_child(list)


func _on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_refresh_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/characters_preview.tscn")
