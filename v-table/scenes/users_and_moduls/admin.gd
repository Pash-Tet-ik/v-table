extends "res://scenes/users_and_moduls/user.gd"

var characters = []

func _ready() -> void:
	super._ready()
	$ui/add_roulette.table = table
	$ui/add_roulette.user = self
	$ui/left_bot_box/add_token_btn.table = table
	$ui/left_bot_box/add_token_btn.user = self
	$ui/left_bot_box/add_map_btn.table = table
	$ui/left_bot_box/add_map_btn.user = self
	$ui/left_bot_box/add_musik_btn.table = table
	$ui/left_bot_box/add_musik_btn.user = self
	
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)

func _on_player_connected(id: int):
	print("connected" + str(id))
	Server.add_player(id)


func _on_player_disconnected(id: int):
	print("disconnected" + str(id))
	Server.del_player(id)
