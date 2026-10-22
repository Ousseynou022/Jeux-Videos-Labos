extends State

const RELEASE_CUT := 0.45


func enter(_previous_state: String) -> void:
	player.velocity.y = Player.JUMP_VELOCITY
	player.animated_sprite.play("jump")


func physics_update(_delta: float) -> void:
	player.move_horizontally(player.get_move_direction())

	if Input.is_action_just_released("jump") and player.velocity.y < 0.0:
		player.velocity.y *= RELEASE_CUT

	if player.wants_attack():
		change_to("attack")
	elif player.velocity.y >= 0.0:
		change_to("fall")
