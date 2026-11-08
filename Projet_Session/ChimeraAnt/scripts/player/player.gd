class_name Player
extends CharacterBody2D

signal health_changed(current: int, maximum: int)  # pour le HUD
signal died

const SPEED := 400.0
const JUMP_VELOCITY := -700.0
const SWORD_DAMAGE := 1
const SWORD_HIT_FRAME := 3          
const INVINCIBILITY_TIME := 1.0   
const HURT_TIME := 0.3              # secondes où on ne contrôle plus le joueur
const KNOCKBACK := Vector2(450, -250)

@export var level_width := 5760.0  

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking := false
var has_hit := false
var is_dead := false
var hurt_left := 0.0
var invincible_left := 0.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D
@onready var sword_area: Area2D = $SwordArea


func _ready() -> void:
	add_to_group("player")
	camera.limit_right = int(level_width)
	anim.animation_finished.connect(_on_animation_finished)
	anim.play("idle")
	health_changed.emit.call_deferred(GameState.player_health, GameState.player_max_health)


func _physics_process(delta: float) -> void:
	# Gravité
	if not is_on_floor():
		velocity.y += gravity * delta

	# Mort 
	if is_dead:
		velocity.x = move_toward(velocity.x, 0.0, 1500.0 * delta)
		move_and_slide()
		return

	_update_invincibility(delta)

	# Blessé
	if hurt_left > 0.0:
		hurt_left -= delta
		velocity.x = move_toward(velocity.x, 0.0, 1200.0 * delta)
		move_and_slide()
		return

	# Saut
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_attacking:
		velocity.y = JUMP_VELOCITY

	# Attaque
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		has_hit = false
		anim.play("attack")

	# épée 
	if is_attacking and not has_hit and anim.frame >= SWORD_HIT_FRAME:
		has_hit = true
		_hit_enemies()

	# Déplacement 
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


func take_damage(amount: int, from_x: float = global_position.x) -> void:
	if is_dead or invincible_left > 0.0:
		return  

	GameState.player_health = maxi(GameState.player_health - amount, 0)
	health_changed.emit(GameState.player_health, GameState.player_max_health)

	if GameState.player_health <= 0:
		_die()
		return

	# Recul 
	var push := signf(global_position.x - from_x)
	if push == 0.0:
		push = 1.0 if anim.flip_h else -1.0
	velocity = Vector2(push * KNOCKBACK.x, KNOCKBACK.y)

	is_attacking = false
	hurt_left = HURT_TIME
	invincible_left = INVINCIBILITY_TIME
	anim.play("hurt")


func _update_invincibility(delta: float) -> void:
	if invincible_left <= 0.0:
		return
	invincible_left -= delta
	# Clignotement 
	anim.modulate.a = 0.35 if int(invincible_left * 10.0) % 2 == 0 else 1.0
	if invincible_left <= 0.0:
		anim.modulate.a = 1.0


func _die() -> void:
	is_dead = true
	is_attacking = false
	anim.modulate.a = 1.0
	anim.play("death")
	died.emit()
	await anim.animation_finished
	await get_tree().create_timer(1.0).timeout
	GameState.player_defeated()


func _update_animation(direction: float) -> void:
	if is_attacking:
		return
	if not is_on_floor():
		_play("jump")
	elif direction != 0:
		_play("run")
	else:
		_play("idle")


func _play(anim_name: String) -> void:
	if anim.animation != anim_name:
		anim.play(anim_name)


func _on_animation_finished() -> void:
	if anim.animation == "attack":
		is_attacking = false
