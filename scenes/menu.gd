extends Node

@onready var port_input = $MarginContainer/main_cont/port_name
@onready var ip_input = $MarginContainer/main_cont/ip
@onready var status_label = $MarginContainer/main_cont/panel_cont/status


const DEFAULT_PORT = 8910

func _ready() -> void:
	var msg = [
		"я хранитель этой лампы",
		"у меня зрение -15",
		"рос-ро-рост у тебя -15",
		"нахуй ты сливу склеил",
		"ЫЫЕ",
		"преверка жопы",
		"а он меня больше любит",
		"славный малый",
		"гиги за шаги",
		"гитлер ни в чём не виноват",
		"садик под подошвой",
		"здесь был Гена Цидормян",
		"do you know a way?",
		"трубоеб виталя )",
		"светлана 500 метров от вас",
		"я съел деда",
		"меня съел внук",
		"тепло деда",
		"даблъю даблъю",
		"блять, отравленый",
		"заходит как-то улитка в бар",
		"колдун ебучий",
		"мать чекни",
		"кчау, твоя мать в канаве",
		"ничего не произошло на площади Тяньаньмэнь в 1989",
		"чтобы увеличить челен нужно ...",
		"цой жив",
		"жой цив",
		"кто гавкает?",
		"гав-гав-гва гав-гав гав-гав",
		"сосал?",
		"детка, ты выполнила задание на 5+",
		"8-9-16-17-21-13-12-15-1",
		"Ты гнида этой двери!",
		"+2 или -2?",
		"У вас хуй видно, в курсе?",
		"а хули ты хотел? 15 тонн",
		"и засмеялся ещё так неприятно",
		"выйди и зайди нормально",
		"Нихуя, годен",
		"НЕТ? ПОШЁЛ ТЫ ТОГДА НАХУЙ!",
		"горячие мамочки 3 км от вас",
		"ебутся как-то 2 клоуна",
		"дилижабаль ага",
		"амням ебался",
		"амням не ебался",
		"он умер в конце драйва",
		"он не умер в конце драйва"
	]
	status_label.text = msg.pick_random()

func _on_host_btn_pressed() -> void:
	var port = int(port_input.text) if int(port_input.text) else DEFAULT_PORT
	var peer = ENetMultiplayerPeer.new()
	
	var error = peer.create_server(port, 10)
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
