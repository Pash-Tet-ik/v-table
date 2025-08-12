extends Node

var smth_is_pick = false
var characters = []
var settings = {
	"volume" : {"master" : 0.5, "music" : 0.5, "sfx" : 0.5}
}

var user : Node
var table : Node
var data : Dictionary

func _ready() -> void:
	if FileAccess.file_exists("user://settings.json"): 
		load_settings()
	else:
		save_settings()

	AudioServer.set_bus_volume_db(0,linear_to_db(settings["volume"]["master"]))

	if DirAccess.dir_exists_absolute("user://db/characters"):
		load_preset_chars() 
		#load_chars()
	else:
		DirAccess.make_dir_recursive_absolute("user://db/characters")
		load_preset_chars()


func load_settings():
	var file = FileAccess.open("user://settings.json", FileAccess.READ)
	settings = JSON.parse_string(file.get_as_text())
	file.close()


func save_settings():
	var file = FileAccess.open("user://settings.json", FileAccess.WRITE)
	file.store_line(JSON.stringify(settings))
	file.close()


func load_chars():
	var file_names = DirAccess.get_files_at("user://db/characters")
	for file_name in file_names:
		var load_file = FileAccess.open("user://db/characters/" + file_name, FileAccess.READ)
		characters.append(JSON.parse_string(load_file.get_as_text()))
		load_file.close()

func load_preset_chars():
	var file_names = DirAccess.get_files_at("res://db/characters")
	for file_name in file_names:
		var file = FileAccess.open("user://db/characters/" + file_name, FileAccess.WRITE)
		file.close()
		DirAccess.copy_absolute("res://db/characters/"+ file_name, "user://db/characters/" + file_name)
	load_chars()
	
	
