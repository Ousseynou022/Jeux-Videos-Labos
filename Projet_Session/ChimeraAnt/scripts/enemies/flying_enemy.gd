class_name FlyingEnemy
extends Enemy
## Fourmi ailée 

@export var fly_speed := 260.0
@export var dive_speed := 420.0
@export var steer_strength := 3.0        
@export var neighbor_radius := 220.0     
@export var separation_radius := 160.0   
@export var separation_weight := 4.0
@export var alignment_weight := 0.7
@export var cohesion_weight := 0.4
@export var target_weight := 1.2
@export var flight_zone := Rect2(100, 120, 1720, 680)  
@export var orbit_speed := 0.8           

var spawn_position := Vector2.ZERO
var orbit_radius := 0.0   # distance place autour du joueur
var orbit_phase := 0.0    # décalage 
var orbit_time := 0.0


func _ready() -> void:
	super()
	spawn_position = position
	orbit_radius = randf_range(140.0, 230.0)
	orbit_phase = randf_range(0.0, TAU)
	add_to_group("swarm")
	died.connect(_on_died)


func _physics_process(delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player") as Player
	cooldown_left = maxf(cooldown_left - delta, 0.0)
	orbit_time += delta
	if is_dead():
		velocity.y += gravity * delta  #tomber

	state_machine.physics_update(delta)
	move_and_slide()

	if absf(velocity.x) > 10.0 and not is_dead():
		face(velocity.x)


func _on_died() -> void:
	remove_from_group("swarm")  


## ALERTE DE L'ESSAIM
func alert_swarm() -> void:
	for other in get_tree().get_nodes_in_group("swarm"):
		if other.state_machine.current_state.name == "Patrol":
			other.state_machine.change_state("Chase")



func player_target() -> Vector2:
	return player.global_position + Vector2(0, -110)


## ENCERCLEMENT 
func encircle_target() -> Vector2:
	var angle := -PI / 2.0 + sin(orbit_time * orbit_speed + orbit_phase) * 1.3
	return player_target() + Vector2.from_angle(angle) * orbit_radius


func distance_to_player() -> float:
	if player == null:
		return INF
	return global_position.distance_to(player_target())


## ALGORITHME D'ESSAIM 
func flock_direction(target: Vector2) -> Vector2:
	var separation := Vector2.ZERO
	var alignment := Vector2.ZERO
	var center := Vector2.ZERO
	var neighbors := 0

	for other in get_tree().get_nodes_in_group("swarm"):
		if other == self:
			continue
		var offset: Vector2 = global_position - other.global_position
		var distance := offset.length()
		if distance == 0.0 or distance > neighbor_radius:
			continue
		neighbors += 1
		alignment += other.velocity          # 2) ALIGNEMENT : même direction que les voisines
		center += other.global_position      # 3) COHÉSION : vers le centre du groupe
		if distance < separation_radius:     # 1) SÉPARATION : s'écarter si trop proche
			separation += offset.normalized() * (1.0 - distance / separation_radius)

	var direction := (target - global_position).normalized() * target_weight

	if neighbors > 0:
		center /= neighbors
		direction += separation * separation_weight
		direction += alignment.normalized() * alignment_weight
		direction += (center - global_position).normalized() * cohesion_weight

	direction += _stay_in_zone()
	return direction.normalized()


func _stay_in_zone() -> Vector2:
	var force := Vector2.ZERO
	if global_position.x < flight_zone.position.x:
		force.x += 1.0
	elif global_position.x > flight_zone.end.x:
		force.x -= 1.0
	if global_position.y < flight_zone.position.y:
		force.y += 1.0
	elif global_position.y > flight_zone.end.y:
		force.y -= 1.0
	return force * 2.0


func steer_towards(direction: Vector2, speed: float, delta: float) -> void:
	velocity = velocity.lerp(direction * speed, clampf(steer_strength * delta, 0.0, 1.0))
