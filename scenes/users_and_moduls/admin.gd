extends "res://scenes/users_and_moduls/user.gd"


func _ready() -> void:
	super._ready()

	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)


func _on_player_connected(id: int):
	print("connected " + str(id))
	Server.add_player(id)


func _on_player_disconnected(id: int):
	print("disconnected " + str(id))
	Server.del_player(id)
