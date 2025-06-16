extends Button

@onready var file_dialog = $FileDialog

func _ready() -> void:
	pass

func _on_pressed() -> void:
	file_dialog.show()

func _on_file_dialog_mouse_entered() -> void:
	G.user.input_access = false

func _on_file_dialog_mouse_exited() -> void:
	G.user.input_access = true


func _on_file_dialog_file_selected(path: String) -> void:
	G.table.add_map(path, Vector2(30,20))
