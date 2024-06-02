extends Node

func _ready():
	randomize()
	connect("playerDied", playerDie)

func reset():
	gameOver = false
	playerMapPosition = Vector2.ZERO
	coin = 0

func random_array(ar, ignoreFirst: bool):
	if ignoreFirst:
		return ar[(randi() % (ar.size() - 1)) + 1]
	else:
		return ar[randi() % ar.size()]

func load_files_in_directory(path):
	var files = []
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and (file.ends_with(".tscn") or file.ends_with(".tres")):
			files.append(load(path + file))
	dir.list_dir_end()
	return files

func updateCoins(value):
	coin = value
	emit_signal("updateCoin", coin)

func playerDie():
	gameOver = true

#Pause
signal fadeIn
signal fadeOut
signal curtainsUp
#Player to UI
signal healthUpdate(currenthealth, maxHealth)
#Enemy to Rooms > Enemies
signal enemyKilled
#World to Map
signal createMap(steps)
signal updateMap(steps)
#UI
signal updateCoin(value)
signal updateStats()
signal playerDied

var gameOver = false
var playerMapPosition = Vector2.ZERO
var coin : int = 100 : set = updateCoins
var playerBaseStats : Resource
