extends Area2D

class_name Hurtbox

@export var is_player = false

func _on_area_entered(area):
	if area is Hitbox:
		if area.target_player == is_player:
			get_parent().takeDamage(area.Damage)
