extends VBoxContainer


func _on_hp_value_changed(value: float) -> void:
	G.data["hp"] = int(value)


func _temp_on_hp_value_changed(value: float) -> void:
	G.data["temp_hp"] = int(value)
