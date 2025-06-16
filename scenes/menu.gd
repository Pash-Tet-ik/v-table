extends Node

@onready var port_input = $MarginContainer/main_cont/port_name
@onready var ip_input = $MarginContainer/main_cont/ip
@onready var status_label = $MarginContainer/main_cont/panel_cont/status


const DEFAULT_PORT = 8910


func _ready() -> void:
	var file = FileAccess.open("res://db/greeting_messages.json", FileAccess.READ)
	status_label.text = JSON.parse_string(file.get_as_text())["normal"].pick_random()
	file.close()


func _on_host_btn_pressed() -> void:
	var port = int(port_input.text) if int(port_input.text) else DEFAULT_PORT
	var peer = ENetMultiplayerPeer.new()
	var max_players = 10
	
	var error = peer.create_server(port, max_players)
	if error != OK:
		status_label.text = "Ошибка хоста: " + error_string(error)
		return

	multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file("res://scenes/table.tscn")


func _on_connect_btn_pressed() -> void:
	var port = int(port_input.text) if int(port_input.text) else DEFAULT_PORT
	var peer = ENetMultiplayerPeer.new()
	var ip = ip_input.text

	var error = peer.create_client(ip, port) 
	if error != OK:
		status_label.text = "Ошибка подключения: " + error_string(error)
		return

	multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file("res://scenes/table.tscn")


func _on_characters_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/characters_preview.tscn")
