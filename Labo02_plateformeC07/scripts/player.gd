class_name Player
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_hitbox: Area2D = $AttackHitbox
@onready var attack_shape: CollisionShape2D = $AttackHitbox/CollisionShape2D
@onready var state_machine: StateMachine = $StateMachine

var facing: int = 1


func _ready() -> void:
	attack_hitbox.body_entered.connect(_on_attack_hitbox_body_entered)
	animated_sprite.frame_changed.connect(_on_animated_sprite_frame_changed)
	state_machine.init(self)


func _physics_process(delta: float) -> void:
	# La gravité est commune à tous les états.
	if not is_on_floor():
		velocity += get_gravity() * delta

	state_machine.physics_update(delta)
	move_and_slide()



func get_move_direction() -> float:
	return Input.get_axis("move_left", "move_right")


func wants_jump() -> bool:
	return Input.is_action_just_pressed("jump")


func wants_attack() -> bool:
	return Input.is_action_just_pressed("attack")



func move_horizontally(direction: float) -> void:
	if direction != 0.0:
		velocity.x = direction * SPEED
		set_facing(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func set_facing(direction: float) -> void:
	if direction == 0.0:
		return
	facing = 1 if direction > 0.0 else -1
	animated_sprite.flip_h = facing < 0
	attack_hitbox.scale.x = facing


func set_attack_hitbox_enabled(enabled: bool) -> void:
	attack_shape.set_deferred("disabled", not enabled)


func _on_animated_sprite_frame_changed() -> void:
	if animated_sprite.animation == &"attack":
		set_attack_hitbox_enabled(animated_sprite.frame in [2, 3])


func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_hit"):
		body.take_hit(1, global_position)
