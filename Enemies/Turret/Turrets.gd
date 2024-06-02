extends Enemy

@onready var cannon = $Cannon
@onready var base = $Base
@onready var rayCast = $RayCast
@onready var aimLine = $AimLine
@onready var fireRateTimer = $FireRateTimer
@export var bullet: Resource = null

var playerPath
var alone = true
var baseAngle

func _ready():
	aimLine.add_point(Vector2.ZERO, 0)
	aimLine.add_point(Vector2.ZERO, 1)
	baseAngle = base.rotation_degrees
	if get_tree().has_group("Player"):
		playerPath = get_tree().get_nodes_in_group("Player")[0]

func _process(_delta):
	match state:
		MOVE:
			move()
		DIE:
			die()

func move():
	var player = playerPath.global_position
	aimLine.set_point_position(1, player - global_position)
	if aim(player) and not $Cannon/GunPlayer.is_playing():
		if fireRateTimer.is_stopped():
			fireRateTimer.start(1.0 / stats.FireRate)
		aimLine.visible = true
		aimLine.set_point_position(1, player - global_position)
	else:
		fireRateTimer.stop()

func aim(player_position):
	var angle = rad_to_deg(get_angle_to(player_position))
	rayCast.target_position = player_position - global_position
	var canHit = (angle <= baseAngle and angle >= baseAngle-180) or angle <= baseAngle + 50 or angle >= baseAngle + 130
	if !rayCast.is_colliding() and canHit:
		#print(angle, baseAngle)
		cannon.look_at(player_position)
		return true
	else:
		aimLine.visible = false
		return false

func die():
	changeHurtbox(false)
	fireRateTimer.stop()
	aimLine.visible = false
	Events.emit_signal("enemyKilled")
	hurtPlayer.play("Die")
	state = INACTIVE

func takeDamage(damage):
	if alone:
		if state == MOVE:
			damageTaken += damage
			spawnDamageNumbers(damage)
			if damageTaken < stats.Health:
				soundPlayer.playSound(hurtSound, -5)
				hurtPlayer.play("Hurt")
			else:
				soundPlayer.playSound(deathSound, -5)
				Events.coin += bounty
				state = DIE
	else:
		get_parent().get_parent().takeDamage(damage)

func activate():
	if get_parent().get_parent() is Enemy:
		alone = false
	state = MOVE

func fire():
	if state == MOVE:
		if alone == false:
			if get_parent().get_parent().state != DIE:
				shoot()
		else:
			shoot()

func shoot():
	var direction = Vector2(cos(cannon.rotation), sin(cannon.rotation))
	var instance = bullet.instantiate()
	instance.rotation = cannon.rotation
	instance.global_position = global_position
	instance.linear_velocity = direction * stats.Speed
	get_node("/root/World").call_deferred("add_child", instance)
	instance.call_deferred("update", stats.Attack)


func _on_fire_rate_timer_timeout():
	$Cannon/GunPlayer.play("Fire")
