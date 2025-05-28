extends "res://scenes/users_and_moduls/moduls/character_block.gd"


func _on_button_toggled(toggled_on: bool) -> void:
	super._on_button_toggled(toggled_on)
	if toggled_on:
		Server.update()
		$side_btns/update_btn.show()
	else:
		$side_btns/update_btn.hide()


func _on_update_btn_pressed() -> void:
	Server.update()

	$main/character_list.hide()
	$main/players_selection.show()
	clean_player_selection()

	for player in Server.players:
		var el = Button.new()
		el.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		el.text = player["name"] if "name" in player.keys() else str(player["id"])
		$main/players_selection.add_child(el)
		el.connect("pressed", Callable(self, "select").bind(player["id"]))


func select(id : int) -> void:
	var player = find_player_by_id(id)
	if player:
		clean_player_selection()
		$main/character_list.set_up(find_char_by_name(player["name"]))
		if "hp" in player.keys():
			$main/character_list/VBoxContainer/header/PanelContainer/main_block/main/hp_box/hp.value = player["hp"]
		if "temp_hp" in player.keys():
			$main/character_list/VBoxContainer/header/PanelContainer/main_block/main/time_hp_box/hp.value = player["temp_hp"]
		$main/character_list.show()
		$main/players_selection.hide()
		return


func find_char_by_name(char_name : String):
	for character in G.characters:
		if character["name"] == char_name:
			return character
	return 0


func find_player_by_id(id : int):
	for player in Server.players:
		if player["id"] == id and "name" in player.keys():
			return player
	return 0


func clean_player_selection():
	while $main/players_selection.get_child_count() != 0:
		$main/players_selection.remove_child($main/players_selection.get_child(0))
