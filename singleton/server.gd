extends Node

var players = []


func add_player(id: int) -> void :
	players.append({"id" : id})
	rpc_id(id, "send_characters_to_player", G.characters)


func del_player(id: int) -> void :
	for i in range(len(players)):
		if players[i]["id"] == id:
			players.remove_at(i)
			return
	print("no player " + str(id))


func update():
	for player in players:
		request_player_data(player["id"])


@rpc
func send_characters_to_player(characters) -> void:
	G.characters = characters
	G.user.find_child("CharacterSelection")._ready()


@rpc("any_peer")
func request_player_data(player_id: int) -> void:
	rpc_id(player_id, "send_data_to_server")


@rpc
func send_data_to_server():
	var user_data = G.data.duplicate()
	if "name" in G.user.character.keys():
		user_data["name"] = G.user.character["name"]
	
	rpc_id(1, "get_data_from_player", multiplayer.get_unique_id(), user_data)


@rpc("any_peer")
func get_data_from_player(player_id, user_data):
	for player in players:
		if player["id"] == player_id:
			for key in user_data.keys():
				player[key] = user_data[key]
			return
