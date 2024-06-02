extends GridContainer

var itemArray = []
var playerPath

@onready var AudioPlayer = $HBoxContainer/SoundPlayer

func _ready():
	if get_tree().has_group("Player"):
		playerPath = get_tree().get_nodes_in_group("Player")[0]
	itemArray = Events.load_files_in_directory("res://Items/Items/")
	update()

func update():
	var tempArray = itemArray.duplicate()
	tempArray.shuffle()
	$Button.ItemStats = tempArray.pop_front()
	$Button2.ItemStats = tempArray.pop_front()
	$Button3.ItemStats = tempArray.pop_front()
	$Button4.ItemStats = tempArray.pop_front()
	$Button5.ItemStats = tempArray.pop_front()

func _on_restock_button_down():
	if Events.coin >= 10:
		Events.coin -= 10
		update()
		AudioPlayer.playSound("res://Assets/Sound/SFX/Purchase.wav", -5)
	else:
		AudioPlayer.playSound("res://Assets/Sound/SFX/NoMoney.wav", -5)

func _on_heal_button_down():
	if Events.coin >= 50:
		Events.coin -= 50
		playerPath.damageTaken = 0
		Events.emit_signal("healthUpdate", playerPath.stats.Health - playerPath.damageTaken, playerPath.stats.Health)
		AudioPlayer.playSound("res://Assets/Sound/SFX/Purchase.wav", -5)
	else:
		AudioPlayer.playSound("res://Assets/Sound/SFX/NoMoney.wav", -5)
