extends Control

var user : Node2D
var charachter : Dictionary

func _ready() -> void:
	for i in len(G.characters):
		var el = Button.new()
		el.text = G.characters[i]["name"]
		$ScrollContainer/VBoxContainer.add_child(el)
		el.connect("pressed", Callable(self, "select").bind(i))

func select(i : int) -> void:
	charachter = G.characters[i]
	hide()
	user.set_up_charachter(charachter)
	
