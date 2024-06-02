extends Node2D

@onready var camera = $Camera2D
@onready var enemies = $Enemies
@onready var gates = $Gates

var activated = false
var numEnemies: int

func _ready():
	Events.connect("enemyKilled", enemyKilled)
	deactivate()

func deactivate():
	activated = false
	visible = false
	camera.enabled = false

func activate():
	activated = true
	visible = true
	camera.enabled = true
	numEnemies = enemies.get_child_count()
	if numEnemies > 0:
		for gate in gates.get_children():
			gate.lock()
		for enemy in enemies.get_children():
			enemy.activate()

func _on_player_detector_body_entered(body):
	if body is Player:
		activate()

func _on_player_detector_body_exited(body):
	if body is Player:
		deactivate()

func enemyKilled():
	if activated:
		numEnemies -= 1
		print(numEnemies)
		if numEnemies == 0:
			for gate in gates.get_children():
				gate.unlock()


