extends Entity

class_name Enemy

@onready var hurtPlayer = $HurtPlayer
@onready var animationPlayer = $AnimationPlayer
@onready var soundPlayer = $SoundPlayer
@onready var hurtBox = $Hurtbox
@export var bounty : int = 3
@export var hurtSound = "res://Assets/Sound/SFX/EnemyHurtSound.wav"
@export var deathSound = "res://Assets/Sound/SFX/EnemyDeathSound.wav"

var damageNumbers = preload("res://UI/World/damage_numbers.tscn")

var state = INACTIVE

func die():
	changeHurtbox(false)
	animationPlayer.play("RESET")
	hurtPlayer.play("Die")

func takeDamage(damage):
	if state == MOVE:
		damageTaken += damage
		#spewImpact(Vector2(1,1), Color.WHITE, Vector2.LEFT)
		velocity = Vector2.ZERO
		spawnDamageNumbers(damage)
		if damageTaken < stats.Health:
			soundPlayer.playSound(hurtSound, -5)
			hurtPlayer.play("Hurt")
		else:
			state = DIE
			soundPlayer.playSound(deathSound, -5)
			Events.coin += bounty
			Events.emit_signal("enemyKilled")

func spawnDamageNumbers(damage):
	var instance = damageNumbers.instantiate()
	instance.update(damage)
	instance.global_position = global_position
	get_node("/root/Effects").add_child(instance)

func changeHurtbox(status: bool):
	hurtBox.monitoring = status
	hurtBox.monitorable = status
