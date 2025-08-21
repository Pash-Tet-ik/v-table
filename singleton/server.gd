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
		request_player_character(player["id"])


@rpc
func send_characters_to_player(characters) -> void:
	G.characters = characters
	G.user.find_child("CharacterSelection").add_chars()


@rpc("any_peer")
func request_player_character(player_id: int) -> void:
	rpc_id(player_id, "send_character_to_server")


@rpc
func send_character_to_server():
	if G.user.character:
		rpc_id(1, "get_character_from_player", multiplayer.get_unique_id(), G.user.character)


@rpc("any_peer")
func get_character_from_player(player_id, user_character):
	for player in players:
		if player["id"] == player_id:
			player["character"] = user_character
			return
