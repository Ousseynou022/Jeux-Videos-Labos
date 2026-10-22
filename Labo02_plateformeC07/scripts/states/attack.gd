extends State

const ENTRY_SPEED_FACTOR := 0.3

var _finished: bool = false


func enter(_previous_state: String) -> void:
	_finished = false
	player.velocity.x *= ENTRY_SPEED_FACTOR
	player.animated_sprite.play("attack")
	if not player.animated_sprite.animation_finished.is_connected(_on_animation_finished):
		player.animated_sprite.animation_finished.connect(_on_animation_finished)


func exit() -> void:
	player.set_attack_hitbox_enabled(false)
	if player.animated_sprite.animation_finished.is_connected(_on_animation_finished):
		player.animated_sprite.animation_finished.disconnect(_on_animation_finished)


func physics_update(_delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, Player.SPEED)

	if not _finished:
		return

	if not player.is_on_floor():
		change_to("fall")
	elif player.get_move_direction() != 0.0:
		change_to("run")
	else:
		change_to("idle")


func _on_animation_finished() -> void:
	if player.animated_sprite.animation == &"attack":
		_finished = true
