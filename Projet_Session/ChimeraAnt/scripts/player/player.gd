class_name Player
extends CharacterBody2D

const SPEED := 400.0
const JUMP_VELOCITY := -700.0
const HUB_WIDTH := 5760.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking := false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	add_to_group("player")
	anim.animation_finished.connect(_on_animation_finished)
	anim.play("idle")


func _physics_process(delta: float) -> void:
	# Gravité
	if not is_on_floor():
		velocity.y += gravity * delta

	# Saut
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_attacking:
		velocity.y = JUMP_VELOCITY

	# Attaque
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		anim.play("attack")

	# Déplacement (bloqué pendant une attaque au sol)
	var direction := Input.get_axis("move_left", "move_right")
	if is_attacking and is_on_floor():
		direction = 0.0
	velocity.x = direction * SPEED
	if direction != 0:
		anim.flip_h = direction < 0

	move_and_slide()
	position.x = clamp(position.x, 40.0, HUB_WIDTH - 40.0)

	_update_animation(direction)


func _update_animation(direction: float) -> void:
	if is_attacking:
		return
	if not is_on_floor():
		_play("jump")
	elif direction != 0:
		_play("run")
	else:
		_play("idle")


# Change d'animation seulement si ce n'est pas déjà celle-là
func _play(anim_name: String) -> void:
	if anim.animation != anim_name:
		anim.play(anim_name)


func _on_animation_finished() -> void:
	if anim.animation == "attack":
		is_attacking = false
