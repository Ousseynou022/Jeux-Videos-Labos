class_name Enemy
extends CharacterBody2D
## Ennemi de base. Le COMPORTEMENT est entièrement géré par la StateMachine.

signal died

@export var max_health := 3
@export var patrol_speed := 120.0
@export var chase_speed := 260.0
@export var patrol_distance := 250.0  # demi-largeur de la zone de patrouille
@export var detect_range := 550.0     # distance où il repère le joueur
@export var attack_range := 130.0     # distance où il attaque
@export var attack_cooldown := 1.2    # secondes entre deux attaques
@export var damage := 10

var health := 0
var player: Player = null
var spawn_x := 0.0
var cooldown_left := 0.0
var knock_direction := 0.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine


func _ready() -> void:
	add_to_group("enemies")
	health = max_health
	spawn_x = position.x


func _physics_process(delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player") as Player
	if not is_on_floor():
		velocity.y += gravity * delta
	cooldown_left = maxf(cooldown_left - delta, 0.0)

	state_machine.physics_update(delta)  # l'état actif décide de la vitesse
	move_and_slide()


func face(direction: float) -> void:
	if direction != 0.0:
		anim.flip_h = direction < 0.0


func distance_to_player() -> float:
	if player == null:
		return INF
	return absf(player.global_position.x - global_position.x)


func direction_to_player() -> float:
	if player == null:
		return 0.0
	return signf(player.global_position.x - global_position.x)


func is_dead() -> bool:
	return state_machine.current_state.name == "Dead"


func take_damage(amount: int, from_x: float) -> void:
	if is_dead():
		return
	health -= amount
	knock_direction = signf(global_position.x - from_x)
	if health <= 0:
		state_machine.change_state("Dead")
	else:
		state_machine.change_state("Hurt")
