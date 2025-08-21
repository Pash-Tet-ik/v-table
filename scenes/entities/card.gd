extends PanelContainer

@export var data : Dictionary


func set_up(card_data : Dictionary) -> void:
	data = card_data

	$body/header/name.text = data.get("name","nameless")
	set_up_optional("description", $body/main/description)
	set_up_optional("actions", $body/header/actions)
	set_up_optional("count", $body/header/counter, "counter")
	if "attack" in data:
		$body/main/attack/dmg.text = data["attack"].get("dmg","XкXX + X")
		$body/main/attack/mod.text = data["attack"].get("mod","+X")
		$body/main/attack.show()


func set_up_optional(data_key : String, node : Node, type := "text"):
	if data_key in data:
		if type == "text":
			node.text = data[data_key]
		elif type == "counter":
			node.max_value = data[data_key]
			node.value = data.get_or_add("count_value", node.max_value)
		node.show()


func _on_counter_value_changed(value: float) -> void:
	data["count_value"] = value
