extends Node

var smth_is_pick = false
var characters = []
var real_version = "0.5"
var settings = {
	"version" : real_version,
	"volume" : {"master" : 0.5, "music" : 0.5, "sfx" : 0.5
}}

var user : Node
var data : Dictionary

func _ready() -> void:
	load_chars()

	if FileAccess.file_exists("user://settings.json"): 
		load_settings()
		if settings["version"] != real_version:
			settings["version"] = real_version
	save_settings()

	AudioServer.set_bus_volume_db(0,linear_to_db(settings["volume"]["master"]))

func load_settings():
	var file = FileAccess.open("user://settings.json", FileAccess.READ)
	settings = JSON.parse_string(file.get_as_text())


func save_settings():
	var file = FileAccess.open("user://settings.json", FileAccess.WRITE)
	file.store_line(JSON.stringify(settings))


func load_chars():
	var file_names = DirAccess.get_files_at("res://db/characters")
	for file_name in file_names:
		var load_file = FileAccess.open("res://db/characters/" + file_name, FileAccess.READ)
		characters.append(JSON.parse_string(load_file.get_as_text()))
		load_file.close()
