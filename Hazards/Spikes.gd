extends Sprite2D

@onready var hitBox = $Hitbox
@export var damage = 1

func _ready():
	hitBox.Damage = damage


func _on_hitbox_area_entered(area):
	var x = sin(rotation)
	var y = -cos(rotation)
	if area is Hurtbox:
		if area.is_player:
			area.get_parent().velocity = Vector2(x, y) * 200
