extends State
## ATTAQUE EN PIQUÉ

const HIT_FRAME := 4     
const HIT_DISTANCE := 150.0 

var has_hit := false
var dive_direction := Vector2.ZERO


func enter() -> void:
	has_hit = false
	dive_direction = (enemy.player_target() - enemy.global_position).normalized()
	enemy.anim.play("attack")


func physics_update(delta: float) -> void:
	enemy.velocity = enemy.velocity.lerp(dive_direction * enemy.dive_speed, clampf(6.0 * delta, 0.0, 1.0))

	if not has_hit and enemy.anim.frame >= HIT_FRAME:
		has_hit = true
		if enemy.distance_to_player() <= HIT_DISTANCE:
			enemy.player.take_damage(enemy.damage)

	if not enemy.anim.is_playing():
		# les fourmis n'attaquent pas en même temps
		enemy.cooldown_left = enemy.attack_cooldown * randf_range(0.8, 1.6)
		enemy.velocity = -dive_direction * enemy.fly_speed
		enemy.state_machine.change_state("Chase")
