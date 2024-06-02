extends RigidBody2D

var origin = Vector2.ZERO
var magnitude = 1
var impact = preload("res://Particles/HurtAnimation.tscn")

func _on_hitbox_body_entered(body):
	if body is Wall:
		$AnimationPlayer.play("Delete")
		linear_velocity = Vector2.ZERO

func update(Damage):
	$Hitbox.monitorable = true
	$Hitbox.Damage = Damage
	magnitude = sqrt(Damage)
	$Trail.add_point(Vector2.ZERO, 0)
	$Trail.add_point(Vector2.ZERO, 1)
	var sizeBoost = sqrt(Damage)
	$Sprite2D.scale = Vector2(sizeBoost, sizeBoost)
	$Hitbox/CollisionShape2D.scale = Vector2(sizeBoost, sizeBoost)
	$Trail.width = sizeBoost * 1.5
	origin = global_position

func _process(_delta):
	var length = (global_position - origin).length()
	length = clamp(length, 0, 60)
	$Trail.set_point_position(1, Vector2.LEFT * length)

func _on_hitbox_area_entered(area):
	if area is Hurtbox and area.is_player == $Hitbox.target_player:
		$AnimationPlayer.play("Delete")
		if linear_velocity != Vector2.ZERO:
			spewImpact(Vector2(magnitude,magnitude), Color.WHITE)
		linear_velocity = Vector2.ZERO

func spewImpact(SCALE: Vector2, COLOR: Color):
	var instance = impact.instantiate()
	instance.global_position = global_position
	instance.scale = SCALE
	instance.modulate = COLOR
	instance.process_material.direction.x = linear_velocity.normalized().x
	instance.process_material.direction.y = linear_velocity.normalized().y
	get_node("/root/Effects").add_child(instance)
