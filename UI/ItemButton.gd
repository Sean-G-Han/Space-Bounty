extends Button

var ItemStats : set = update
@onready var Sprite = $Sprite
@onready var Description = $Description
@onready var Name = $HBoxContainer/Name
@onready var Cost = $HBoxContainer/Cost
@onready var SoldOut = $SoldOut
var playerPath
var cost

enum {
	
}

func _ready():
	if get_tree().has_group("Player"):
		playerPath = get_tree().get_nodes_in_group("Player")[0]

func update(resource):
	ItemStats = resource
	Sprite.texture = ItemStats.Sprite
	Name.text = ItemStats.Name
	Description.text = ItemStats.Description
	var costValue = ItemStats.Cost
	cost = Events.random_array([floori(costValue * 0.8), floori(costValue * 0.9),costValue, floori(costValue * 1.1), floori(costValue * 1.2)], false)
	Cost.text = " - $" + str(cost)


func _on_button_down():
	if Events.coin >= cost:
		Events.coin -= cost
		buffStats()
		Events.emit_signal("updateStats")
		get_parent().update()
		$SoundPlayer.playSound("res://Assets/Sound/SFX/Purchase.wav", -5)
	else:
		$SoundPlayer.playSound("res://Assets/Sound/SFX/NoMoney.wav", -5)

func buffStats():
	var stats = playerPath.stats
	var base = Events.playerBaseStats
	stats.Health = clamp(stats.Health + ItemStats.Health, 1, 100000)
	playerPath.damageTaken = clamp(playerPath.damageTaken - ItemStats.DamageHealed,0, stats.Health - 1)
	stats.Speed += base.Speed * ItemStats.Speed/10.0
	stats.Attack += base.Attack * ItemStats.Attack/10.0
	stats.FireRate += base.FireRate * ItemStats.FireRate/10.0
	stats.FallSpeed += base.FallSpeed * ItemStats.FallSpeed/10.0
	stats.Acceleration += base.Acceleration * ItemStats.Acceleration/10.0
	stats.JumpVelocity += base.JumpVelocity * ItemStats.JumpVelocity/10.0
	stats.ProjectileSpeed += base.ProjectileSpeed * ItemStats.ProjectileSpeed/10.0
	Events.emit_signal("healthUpdate", playerPath.stats.Health - playerPath.damageTaken, playerPath.stats.Health)
