extends State


func enter(_previous_state: String) -> void:
	player.animated_sprite.play("idle")


func physics_update(_delta: float) -> void:
	player.move_horizontally(0.0)

	if not player.is_on_floor():
		change_to("fall")
	elif player.wants_attack():
		change_to("attack")
	elif player.wants_jump():
		change_to("jump")
	elif player.get_move_direction() != 0.0:
		change_to("run")
