extends CanvasLayer
## HUD 

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
	GameState.xp_changed.connect(update_xp)
	GameState.leveled_up.connect(_on_leveled_up)
	_connect_player.call_deferred()


func _connect_player() -> void:
	var player := get_tree().get_first_node_in_group("player") as Player
	if player:
		player.health_changed.connect(_on_health_changed)


func _on_health_changed(current: int, maximum: int) -> void:
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
	create_tween().tween_property(xp_bar, "value", float(GameState.xp), 0.3)  # remplissage fluide


func _on_leveled_up(new_level: int) -> void:
	_on_health_changed(GameState.player_health, GameState.player_max_health)
	Audio.play_sfx("level_up", 0.0)
	var popup := Label.new()
	popup.text = "NIVEAU %d !\n+%d PV max" % [new_level, GameState.HEALTH_PER_LEVEL]
	popup.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	popup.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	popup.offset_top = 260
	popup.add_theme_font_size_override("font_size", 64)
	popup.add_theme_color_override("font_color", Color(1.0, 0.85, 0.4))
	popup.add_theme_color_override("font_outline_color", Color.BLACK)
	popup.add_theme_constant_override("outline_size", 14)
	add_child(popup)
	popup.pivot_offset = Vector2(960, 60)
	popup.scale = Vector2(0.3, 0.3)
	var tween := create_tween()
	tween.tween_property(popup, "scale", Vector2.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_interval(1.4)
	tween.tween_property(popup, "modulate:a", 0.0, 0.6)
	tween.tween_callback(popup.queue_free)
