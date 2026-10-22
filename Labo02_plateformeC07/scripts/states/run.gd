extends State


func enter(_previous_state: String) -> void:
	player.animated_sprite.play("run")


func physics_update(_delta: float) -> void:
	var direction := player.get_move_direction()
	player.move_horizontally(direction)

	if not player.is_on_floor():
		change_to("fall")
	elif player.wants_attack():
		change_to("attack")
	elif player.wants_jump():
		change_to("jump")
	elif direction == 0.0:
		change_to("idle")
