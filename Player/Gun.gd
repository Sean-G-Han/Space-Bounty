extends Node2D

@onready var sprite = $GunPivot
@onready var gun = $GunPivot/GunSprite
@onready var fireRateTimer = $FireRateTimer
@onready var animationPlayer = $AnimationPlayer
@onready var gunFire = $GunFire

var bullet = preload("res://Bullet/Bullet.tscn")

func _process(_delta):
	if get_parent().state == Entity.MOVE:
		var mouse = get_global_mouse_position()
		look_at(mouse)
		if mouse.x - global_position.x < 0:
			sprite.scale.y = -1
		else:
			sprite.scale.y = 1

		if Input.is_action_pressed("LeftClick") and fireRateTimer.is_stopped():
			animationPlayer.play("Fire")
			gunFire.play()
			fireRateTimer.start(1.0 / get_parent().stats.FireRate)
			var direction = Vector2(cos(rotation), sin(rotation))
			var instance = bullet.instantiate()
			instance.rotation = rotation
			instance.global_position = gun.global_position + direction * 16
			instance.linear_velocity = direction * get_parent().stats.ProjectileSpeed
			#get_parent().velocity -= direction * 100
			get_parent().get_parent().call_deferred("add_child", instance)
			instance.call_deferred("update", get_parent().stats.Attack)
		
