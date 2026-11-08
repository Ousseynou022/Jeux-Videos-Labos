extends CanvasLayer
## HUD : vie, vies, niveau et XP. Se met à jour grâce au signal du joueur.

const HEART_FULL := preload("res://assets/ui/heart_full.png")
const HEART_EMPTY := preload("res://assets/ui/heart_empty.png")

@onready var health_bar: ProgressBar = %HealthBar
@onready var health_text: Label = %HealthText
@onready var lives_box: HBoxContainer = %LivesBox
@onready var level_label: Label = %LevelLabel
@onready var xp_bar: ProgressBar = %XpBar


func _ready() -> void:
	health_bar.max_value = GameState.player_max_health
	health_bar.value = GameState.player_health
	_update_health_text(GameState.player_health, GameState.player_max_health)
	update_lives()
	update_xp()
	# Le joueur n'est peut-être pas encore prêt : on se branche à l'image suivante
	_connect_player.call_deferred()


func _connect_player() -> void:
	var player := get_tree().get_first_node_in_group("player") as Player
	if player:
		player.health_changed.connect(_on_health_changed)


func _on_health_changed(current: int, maximum: int) -> void:
	# Flash rouge seulement si on PERD de la vie
	if current < health_bar.value:
		health_bar.modulate = Color(1.8, 0.5, 0.5)
		create_tween().tween_property(health_bar, "modulate", Color.WHITE, 0.35)
	health_bar.max_value = maximum
	create_tween().tween_property(health_bar, "value", float(current), 0.25)  # descente fluide
	_update_health_text(current, maximum)


func _update_health_text(current: int, maximum: int) -> void:
	health_text.text = "%d / %d" % [current, maximum]


## Un cœur plein par vie restante, un cœur vide par vie perdue
func update_lives() -> void:
	for child in lives_box.get_children():
		child.queue_free()
	for i in GameState.MAX_LIVES:
		var heart := TextureRect.new()
		heart.texture = HEART_FULL if i < GameState.lives else HEART_EMPTY
		heart.custom_minimum_size = Vector2(40, 40)
		heart.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		lives_box.add_child(heart)


func update_xp() -> void:
	level_label.text = "Niv. %d" % GameState.level
	xp_bar.max_value = GameState.xp_needed()
	xp_bar.value = GameState.xp
