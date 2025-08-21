extends VBoxContainer


func _on_hp_value_changed(value: float) -> void:
	if "character" in G.user:
		G.user.character["hp_value"] = value


func _temp_on_hp_value_changed(value: float) -> void:
	if "character" in G.user:
		G.user.character["temp_hp"] = value
