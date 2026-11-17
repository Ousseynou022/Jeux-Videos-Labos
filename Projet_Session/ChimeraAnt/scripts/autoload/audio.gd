extends Node
## Gestionnaire audio : musique (avec fondus), effets sonores et Mute (Ctrl+M).
## Utilisation, de n'importe où :
##   Audio.play_sfx("sword_hit")
##   Audio.play_music(ma_musique)

const SFX := {
	"sword_swing": preload("res://assets/audio/sfx/sword_swing.wav"),
	"sword_hit": preload("res://assets/audio/sfx/sword_hit.wav"),
	"jump": preload("res://assets/audio/sfx/jump.wav"),
	"player_hurt": preload("res://assets/audio/sfx/player_hurt.wav"),
	"player_death": preload("res://assets/audio/sfx/player_death.wav"),
	"enemy_hurt": preload("res://assets/audio/sfx/enemy_hurt.wav"),
	"enemy_death": preload("res://assets/audio/sfx/enemy_death.wav"),
	"enemy_attack": preload("res://assets/audio/sfx/enemy_attack.wav"),
	"swarm_dive": preload("res://assets/audio/sfx/swarm_dive.wav"),
	"portal": preload("res://assets/audio/sfx/portal.wav"),
	"ui_move": preload("res://assets/audio/sfx/ui_move.wav"),
	"ui_select": preload("res://assets/audio/sfx/ui_select.wav"),
	"victory": preload("res://assets/audio/sfx/victory.wav"),
	"heal": preload("res://assets/audio/sfx/heal.wav"),
}

# Réglage du volume de chaque son (en décibels, 0 = normal, -6 = moitié moins fort)
const SFX_VOLUME_DB := {
	"ui_move": -10.0,
	"ui_select": -6.0,
	"jump": -8.0,
	"enemy_hurt": -6.0,
	"enemy_attack": -4.0,
	"swarm_dive": -9.0,
}

const SFX_PLAYERS := 12     # nombre de sons pouvant jouer en même temps
const FADE_TIME := 1.0      # durée des fondus entre deux musiques
const SILENT_DB := -40.0

var muted := false

var _music_a: AudioStreamPlayer
var _music_b: AudioStreamPlayer
var _current_music: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []
var _next_sfx := 0


func _ready() -> void:
	# Toujours actif : les sons de menu marchent aussi pendant la pause
	process_mode = Node.PROCESS_MODE_ALWAYS
	_music_a = _create_player("Music")
	_music_b = _create_player("Music")
	_current_music = _music_a
	for i in SFX_PLAYERS:
		_sfx_players.append(_create_player("SFX"))
	# Sons d'interface automatiques pour TOUS les boutons du jeu
	get_tree().node_added.connect(_on_node_added)
	get_viewport().gui_focus_changed.connect(_on_focus_changed)


func _create_player(bus_name: String) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.bus = bus_name
	add_child(player)
	return player


# ------------------------------------------------------------- EFFETS SONORES

## Joue un effet sonore. pitch_variation change un peu la hauteur à chaque fois
## pour qu'un son répété (coups d'épée…) ne paraisse pas robotique.
func play_sfx(sound_name: String, pitch_variation: float = 0.1) -> void:
	if not SFX.has(sound_name):
		push_warning("Son inconnu : " + sound_name)
		return
	# On prend le lecteur suivant dans la liste (le plus ancien est réutilisé)
	var player := _sfx_players[_next_sfx]
	_next_sfx = (_next_sfx + 1) % _sfx_players.size()
	player.stream = SFX[sound_name]
	player.volume_db = SFX_VOLUME_DB.get(sound_name, 0.0)
	player.pitch_scale = randf_range(1.0 - pitch_variation, 1.0 + pitch_variation)
	player.play()


# ------------------------------------------------------------------- MUSIQUE

## Lance une musique en fondu enchaîné. Si c'est déjà celle qui joue, on ne fait rien.
func play_music(stream: AudioStream) -> void:
	if stream == null:
		stop_music()
		return
	if _current_music.stream == stream and _current_music.playing:
		return
	_set_loop(stream)

	var old_music := _current_music
	_current_music = _music_b if _current_music == _music_a else _music_a
	_current_music.stream = stream
	_current_music.volume_db = SILENT_DB
	_current_music.play()

	var tween := create_tween().set_parallel(true)
	tween.tween_property(_current_music, "volume_db", 0.0, FADE_TIME)
	if old_music.playing:
		tween.tween_property(old_music, "volume_db", SILENT_DB, FADE_TIME)
		tween.chain().tween_callback(old_music.stop)


func stop_music() -> void:
	if not _current_music.playing:
		return
	var music := _current_music
	var tween := create_tween()
	tween.tween_property(music, "volume_db", SILENT_DB, FADE_TIME)
	tween.tween_callback(music.stop)


## Fait boucler la musique, quel que soit son format
func _set_loop(stream: AudioStream) -> void:
	if stream is AudioStreamOggVorbis or stream is AudioStreamMP3:
		stream.loop = true
	elif stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		stream.loop_end = int(stream.get_length() * stream.mix_rate)


# --------------------------------------------------------------------- MUTE

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mute"):
		toggle_mute()
		get_viewport().set_input_as_handled()


func toggle_mute() -> void:
	muted = not muted
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), muted)


# ------------------------------------------------------- SONS D'INTERFACE

func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		node.pressed.connect(play_sfx.bind("ui_select", 0.0))


func _on_focus_changed(_control: Control) -> void:
	play_sfx("ui_move", 0.05)
