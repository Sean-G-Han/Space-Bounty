extends CharacterBody2D

class_name Entity

@export var stats: Resource = null

enum {
	INACTIVE,
	MOVE,
	DIE
}

var damageTaken = 0.0
var blood = preload("res://Particles/DeathAnimation.tscn")

func spewBlood(SCALE: Vector2, COLOR: Color):
	var instance = blood.instantiate()
	instance.global_position = global_position
	instance.scale = SCALE
	instance.modulate = COLOR
	get_node("/root/Effects").add_child(instance)


