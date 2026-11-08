extends State
## POURSUITE EN ESSAIM 


func enter() -> void:
	enemy.anim.play("fly")


func physics_update(delta: float) -> void:
	var distance := enemy.distance_to_player()


	if distance > enemy.detect_range * 2.5:
		enemy.state_machine.change_state("Patrol")
		return

	# Attaque a la poitrine 
	if distance <= enemy.attack_range and enemy.cooldown_left <= 0.0:
		enemy.state_machine.change_state("Attack")
		return

	var direction: Vector2 = enemy.flock_direction(enemy.encircle_target())
	enemy.steer_towards(direction, enemy.fly_speed, delta)
