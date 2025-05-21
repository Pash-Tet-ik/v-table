extends VBoxContainer


func _on_hp_value_changed(value: float) -> void:
	G.data["hp"] = int(value)
