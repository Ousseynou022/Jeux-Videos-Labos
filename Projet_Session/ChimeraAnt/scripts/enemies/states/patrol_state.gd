extends State
## PATROUILLE : marche de gauche à droite autour du point d'apparition.

var direction := 1.0


func enter() -> void:
	enemy.anim.play("walk")


func physics_update(_delta: float) -> void:
	# Demi-tour aux bords de la zone de patrouille
	if enemy.position.x > enemy.spawn_x + enemy.patrol_distance:
		direction = -1.0
	elif enemy.position.x < enemy.spawn_x - enemy.patrol_distance:
		direction = 1.0
	enemy.velocity.x = direction * enemy.patrol_speed
	enemy.face(direction)

	# Transition : le joueur est assez proche -> POURSUITE
	if enemy.distance_to_player() < enemy.detect_range:
		enemy.state_machine.change_state("Chase")
