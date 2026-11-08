extends State
## BLESSÉ : recul + clignotement rouge pendant un court instant.

const DURATION := 0.3
const KNOCKBACK := 350.0

var timer := 0.0


func enter() -> void:
	timer = DURATION
	enemy.anim.play("idle")
	enemy.anim.modulate = Color(1.0, 0.35, 0.35)
	enemy.velocity.x = enemy.knock_direction * KNOCKBACK


func exit() -> void:
	enemy.anim.modulate = Color.WHITE


func physics_update(delta: float) -> void:
	timer -= delta
	enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, 1500.0 * delta)
	# Transition : fin du recul -> POURSUITE
	if timer <= 0.0:
		enemy.state_machine.change_state("Chase")
