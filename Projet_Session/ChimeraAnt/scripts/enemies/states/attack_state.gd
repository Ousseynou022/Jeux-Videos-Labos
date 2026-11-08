extends State
## ATTAQUE : joue l'animation et blesse le joueur au moment du coup.

const HIT_FRAME := 4  # image de l'animation où les griffes frappent

var has_hit := false


func enter() -> void:
	has_hit = false
	enemy.velocity.x = 0.0
	enemy.anim.play("attack")


func physics_update(_delta: float) -> void:
	enemy.velocity.x = 0.0

	if not has_hit and enemy.anim.frame >= HIT_FRAME:
		has_hit = true
		if enemy.distance_to_player() <= enemy.attack_range * 1.2:
			enemy.player.take_damage(enemy.damage, enemy.global_position.x)

	# Transition : animation terminée -> POURSUITE
	if not enemy.anim.is_playing():
		enemy.cooldown_left = enemy.attack_cooldown
		enemy.state_machine.change_state("Chase")
