extends State

const COYOTE_TIME := 0.1

var _coyote_timer: float = 0.0


func enter(previous_state: String) -> void:
	player.animated_sprite.play("fall")
	_coyote_timer = COYOTE_TIME if previous_state in ["idle", "run"] else 0.0


func physics_update(delta: float) -> void:
	_coyote_timer -= delta
	var direction := player.get_move_direction()
	player.move_horizontally(direction)

	if player.is_on_floor():
		change_to("run" if direction != 0.0 else "idle")
	elif player.wants_attack():
		change_to("attack")
	elif _coyote_timer > 0.0 and player.wants_jump():
		change_to("jump")
