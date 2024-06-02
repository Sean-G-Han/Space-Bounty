extends CanvasLayer

@onready var fadePlayer = $AnimationPlayer

@onready var EmptyHearts = $HealthBar/EmptyHearts
@onready var FullHearts = $HealthBar/FullHearts
@onready var Rect = $ColorRect
@onready var Menu = $TabContainer

var playerPath
var emptyHearts = preload("res://UI/EmptyHearts.tscn")
var Hearts = preload("res://UI/Hearts.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().has_group("Player"):
		playerPath = get_tree().get_nodes_in_group("Player")[0]
		updateStats()
	Events.connect("healthUpdate", healthUpdate)
	Events.connect("fadeIn", fadeIn)
	Events.connect("fadeOut", fadeOut)
	Events.connect("updateStats", updateStats)
	Events.connect("playerDied", restart)

func fadeIn():
	get_tree().paused = true
	fadePlayer.play("Fade In")

func fadeOut():
	get_tree().paused = false
	fadePlayer.play("Fade Out")

func curtainsUp():
	if Events.gameOver:
		get_tree().reload_current_scene()
		get_tree().change_scene_to_file("res://MainMenu.tscn")
	else:
		Events.emit_signal("curtainsUp")

func healthUpdate(health: int, maxHealth: int):
	var maxHealthDifference = maxHealth - EmptyHearts.get_child_count()
	if maxHealthDifference > 0:
		for x in range(maxHealthDifference):
			var instance = emptyHearts.instantiate()
			EmptyHearts.add_child(instance)
	else:
		for x in range(-maxHealthDifference):
			EmptyHearts.get_child(EmptyHearts.get_child_count() - 1).queue_free()
	
	var HealthDifference = health - FullHearts.get_child_count()
	if HealthDifference > 0:
		for x in range(HealthDifference):
			var instance = Hearts.instantiate()
			FullHearts.add_child(instance)
	else:
		for x in range(-HealthDifference):
			FullHearts.get_child(FullHearts.get_child_count() - 1).queue_free()
	
func _input(event):
	if event.is_action_pressed("Menu") and Events.gameOver == false:
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			Menu.current_tab = 0
			var tween = create_tween()
			tween.tween_property(Rect, "color", Color(Color(0,0,0), 0.8), 0.1)
			tween.tween_property(Menu, "position", Vector2(32, 32), 0.5)
		else:
			var tween = create_tween()
			tween.tween_property(Rect, "color", Color(Color(0,0,0), 0), 0.1)
			tween.tween_property(Menu, "position", Vector2(-1120, 32), 0.5)

func updateStats():
	$HealthBar/Stats/Attack.update(playerPath.stats.Attack * 10)
	$HealthBar/Stats/ProjectileSpeed.update(playerPath.stats.ProjectileSpeed)
	$HealthBar/Stats/ProjectileRate.update(playerPath.stats.FireRate * 10)
	$HealthBar/Stats/Speed.update(playerPath.stats.Speed)

func restart():
	fadePlayer.play("Fade In")
	
	


