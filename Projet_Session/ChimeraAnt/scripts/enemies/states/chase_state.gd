extends State
## POURSUITE : court vers le joueur, puis attaque quand il est à portée.


func enter() -> void:
	enemy.anim.play("run")


func physics_update(_delta: float) -> void:
	var distance := enemy.distance_to_player()

	# Transition : joueur trop loin -> retour en PATROUILLE
	if distance > enemy.detect_range * 1.5:
		enemy.state_machine.change_state("Patrol")
		return

	var direction := enemy.direction_to_player()
	enemy.face(direction)

	if distance <= enemy.attack_range:
		enemy.velocity.x = 0.0
		# Transition : à portée et attaque rechargée -> ATTAQUE
		if enemy.cooldown_left <= 0.0:
			enemy.state_machine.change_state("Attack")
		elif enemy.anim.animation != "idle":
			enemy.anim.play("idle")  # attend la fin du temps de recharge
	else:
		enemy.velocity.x = direction * enemy.chase_speed
		if enemy.anim.animation != "run":
			enemy.anim.play("run")
