extends Node2D

var global_counter = 0

func _ready() -> void:
	G.table = self
	admin_init() if multiplayer.is_server() else client_init()

	for i in range(-13,13):
		for j in range(-13,13):
			$TileMapLayer.set_cell(Vector2i(i,j),0,Vector2i((abs(i+j)%2+1),0))


func admin_init() -> void:
	add_child(load("res://scenes/users_and_moduls/admin.tscn").instantiate())


func client_init() -> void:
	add_child(load("res://scenes/users_and_moduls/player.tscn").instantiate())


func add_token(img_path : String, global_pos : Vector2, size_mod : int):
	var img = Image.new()
	img.load(img_path)
	var new_token = load("res://scenes/token.tscn").instantiate()
	new_token.name = "token_" + str(global_counter)
	new_token.global_position = global_pos
	new_token.size_mod = size_mod
	new_token.img_bytes = img.save_png_to_buffer()
	add_child(new_token)

	global_counter_rise.rpc()

func add_map(img_path : String, global_pos : Vector2):
	var img = Image.new()
	img.load(img_path)
	var new_map = load("res://scenes/map.tscn").instantiate()
	new_map.name = "map_" + str(global_counter)
	new_map.global_position = global_pos
	new_map.img_bytes = img.save_png_to_buffer()
	add_child(new_map)

	global_counter_rise.rpc()


@rpc("any_peer", "call_local")
func set_musik(path : String):
	$AudioStreamPlayer.stream = load(path)
	$AudioStreamPlayer.play()

func add_roulettes(selected_dises : Array, pos : Vector2, user_name : String, user_color : String):
	rpc("server_add_roulettes", selected_dises, pos, user_name, user_color)

@rpc("any_peer", "call_local")
func server_add_roulettes(selected_dises : Array, pos : Vector2, user_name : String, user_color : String):
	if multiplayer.is_server():
		var roulette_set = load("res://scenes/rualette_set.tscn").instantiate()
		roulette_set.name = "roulette_set_" + str(global_counter)
		roulette_set.position = pos
		global_counter_rise.rpc()
		add_child(roulette_set)

		var ids = range(len(selected_dises))
		roulette_set.set_up(selected_dises, ids, user_name, user_color)
		for d in selected_dises:
			global_counter_rise.rpc()


@rpc("any_peer", "call_local")
func global_counter_rise():
	global_counter += 1


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()
