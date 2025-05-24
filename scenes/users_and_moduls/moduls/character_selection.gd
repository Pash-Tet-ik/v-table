extends Control


func _ready() -> void:
	for i in len(G.characters):
		var el = Button.new()
		el.text = G.characters[i]["name"]
		$ScrollContainer/VBoxContainer.add_child(el)
		el.connect("pressed", Callable(self, "select").bind(i))


func select(i : int) -> void:
	hide()
	G.user.set_up_charachter(G.characters[i])
