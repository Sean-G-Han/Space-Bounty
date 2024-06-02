extends Panel

@onready var coin = $Label

func _ready():
	Events.connect("updateCoin", update)
	update(Events.coin)

func update(value):
	coin.text = "$" + str(value)
