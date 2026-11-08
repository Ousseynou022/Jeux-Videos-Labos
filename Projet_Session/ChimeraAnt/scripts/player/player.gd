class_name Player
extends CharacterBody2D

const SPEED := 400.0
const JUMP_VELOCITY := -700.0
const SWORD_DAMAGE := 1
const SWORD_HIT_FRAME := 3  # image de l'attaque où l'épée frappe

@export var level_width := 5760.0  # largeur du niveau (hub 5760, arène 1920)

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking := false
var has_hit := false
var health := 100

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D
@onready var sword_area: Area2D = $SwordArea


func _ready() -> void:
	add_to_group("player")
	camera.limit_right = int(level_width)
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
		has_hit = false
		anim.play("attack")

	# L'épée touche au bon moment de l'animation
	if is_attacking and not has_hit and anim.frame >= SWORD_HIT_FRAME:
		has_hit = true
		_hit_enemies()

	# Déplacement (bloqué pendant une attaque au sol)
	var direction := Input.get_axis("move_left", "move_right")
	if is_attacking and is_on_floor():
		direction = 0.0
	velocity.x = direction * SPEED
	if direction != 0:
		anim.flip_h = direction < 0
		sword_area.scale.x = -1.0 if direction < 0 else 1.0  # l'épée change de côté

	move_and_slide()
	position.x = clamp(position.x, 40.0, level_width - 40.0)

	_update_animation(direction)


func _hit_enemies() -> void:
	for body in sword_area.get_overlapping_bodies():
		if body is Enemy:
			body.take_damage(SWORD_DAMAGE, global_position.x)


func take_damage(amount: int) -> void:
	health -= amount
	# Clignotement rouge (le vrai système de vie viendra avec la carte « Combat »)
	anim.modulate = Color(1.0, 0.35, 0.35)
	create_tween().tween_property(anim, "modulate", Color.WHITE, 0.3)
	print("Joueur touché ! PV : ", health)


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
