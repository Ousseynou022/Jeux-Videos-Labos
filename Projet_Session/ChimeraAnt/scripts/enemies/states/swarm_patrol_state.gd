extends State
## PATROUILLE EN ESSAIM 

var wander_target := Vector2.ZERO
var timer := 0.0


func enter() -> void:
	enemy.anim.play("fly")
	_pick_new_target()


func physics_update(delta: float) -> void:
	timer -= delta
	if timer <= 0.0:
		_pick_new_target()

	var direction: Vector2 = enemy.flock_direction(wander_target)
	enemy.steer_towards(direction, enemy.fly_speed * 0.6, delta)

	#  POURSUITE
	if enemy.distance_to_player() < enemy.detect_range:
		enemy.alert_swarm()


func _pick_new_target() -> void:
	timer = randf_range(2.0, 4.0)
	wander_target = enemy.spawn_position + Vector2(randf_range(-300, 300), randf_range(-150, 150))
