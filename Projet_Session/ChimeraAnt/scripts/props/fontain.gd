extends Area2D
## Fontaine de soins

@onready var glow: Sprite2D = $Glow
@onready var prompt_label: Label = $PromptLabel

var player_inside := false
var time := 0.0
var sparkles: CPUParticles2D
var heal_burst: CPUParticles2D


func _ready() -> void:
	prompt_label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	sparkles = _create_particles(false)
	heal_burst = _create_particles(true)


func _process(delta: float) -> void:
	# Le halo « respire » doucement
	time += delta
	glow.modulate.a = 0.45 + 0.15 * sin(time * 2.0)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		_update_prompt()
		prompt_label.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false
		prompt_label.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if player_inside and event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		_heal_player()


func _heal_player() -> void:
	if GameState.player_health >= GameState.player_max_health:
		return  # déjà en pleine forme
	var player := get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	player.heal(GameState.player_max_health)
	Audio.play_sfx("heal", 0.0)
	heal_burst.restart()
	glow.scale = Vector2(3.0, 3.0)
	create_tween().tween_property(glow, "scale", Vector2(2.2, 2.2), 0.6)
	_update_prompt()


func _update_prompt() -> void:
	if GameState.player_health >= GameState.player_max_health:
		prompt_label.text = "Vie au maximum"
	else:
		prompt_label.text = "[E] Se soigner"


func _create_particles(burst: bool) -> CPUParticles2D:
	var p := CPUParticles2D.new()
	p.position = Vector2(0, -190)
	p.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	p.emission_sphere_radius = 170.0
	p.direction = Vector2(0, -1)
	p.spread = 30.0
	p.gravity = Vector2(0, -40)
	p.scale_amount_min = 2.0
	p.scale_amount_max = 5.0
	p.color = Color(0.85, 0.65, 1.0, 0.9)
	var fade := Gradient.new()
	fade.set_color(0, Color(1, 1, 1, 1))
	fade.set_color(1, Color(1, 1, 1, 0))
	p.color_ramp = fade
	if burst:
		p.one_shot = true
		p.emitting = false
		p.amount = 60
		p.lifetime = 1.0
		p.explosiveness = 1.0
		p.initial_velocity_min = 120.0
		p.initial_velocity_max = 260.0
		p.spread = 180.0
		p.color = Color(0.75, 1.0, 0.85, 1.0)  # éclat vert-blanc du soin
	else:
		p.amount = 24
		p.lifetime = 2.5
		p.initial_velocity_min = 15.0
		p.initial_velocity_max = 40.0
	add_child(p)
	return p
