extends VBoxContainer


func _ready() -> void:
	$main/volume/HBoxContainer/HSlider.value = G.settings["volume"]["master"]

func _on_open_pressed() -> void:
	$open.hide()
	$close.show()
	$main.show()


func _on_close_pressed() -> void:
	$open.show()
	$close.hide()
	$main.hide()

	G.save_settings()


func _on_h_slider_value_changed(value: float) -> void:
	G.settings["volume"]["master"] = value
	AudioServer.set_bus_volume_db(0,linear_to_db(value))


func _on_exit_pressed() -> void:
	if multiplayer.is_server():
		pass
		#multiplayer.multiplayer_peer.close()
	else:
		multiplayer.multiplayer_peer.close()
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
