extends HBoxContainer


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$main.show()
	else:
		$main.hide()


func set_pressed():
	$side_btns/open_close_btn.button_pressed = true


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Rect2(Vector2(), size).has_point(get_local_mouse_position()):
			G.user.input_access = false
		else:
			G.user.input_access = true
