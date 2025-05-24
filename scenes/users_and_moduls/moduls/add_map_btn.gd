extends Button

@onready var file_dialog = $FileDialog
var table
var user

func _ready() -> void:
	pass

func _on_pressed() -> void:
	file_dialog.show()

func _on_file_dialog_mouse_entered() -> void:
	user.input_access = false

func _on_file_dialog_mouse_exited() -> void:
	user.input_access = true


func _on_file_dialog_file_selected(path: String) -> void:
	print(file_dialog.current_path)
	table.add_map(path, Vector2(30,20))
