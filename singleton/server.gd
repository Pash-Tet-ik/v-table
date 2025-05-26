extends Node

var players = []

func add_player(id: int) -> void :
	players.append({"id" : id})


func del_player(id: int) -> void :
	for i in range(len(players)):
		if players[i]["id"] == id:
			players.remove_at(i)
			return
	print("no player " + str(id))


func update():
	for player in players:
		request_player_data(player["id"])

@rpc("any_peer")
func request_player_data(player_id: int) -> void:
	rpc_id(player_id, "send_data_to_server")

@rpc
func send_data_to_server():
	var data = G.data.duplicate()
	if "name" in G.user.character.keys():
		data["name"] = G.user.character["name"]
	
	rpc_id(1, "get_data_from_player", multiplayer.get_unique_id(), data)

@rpc("any_peer")
func get_data_from_player(player_id, data):
	for player in players:
		if player["id"] == player_id:
			for key in data.keys():
				player[key] = data[key]
