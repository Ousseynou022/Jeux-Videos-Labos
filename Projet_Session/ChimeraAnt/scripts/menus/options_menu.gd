class_name OptionsMenu
extends Control

signal closed

@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SfxSlider
@onready var back_button: Button = %BackButton


func _ready() -> void:
	# On place les curseurs AVANT de connecter les signaux
	master_slider.value = Settings.get_volume("Master")
	music_slider.value = Settings.get_volume("Music")
	sfx_slider.value = Settings.get_volume("SFX")

	master_slider.value_changed.connect(_on_master_changed)
	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	back_button.pressed.connect(close)


func open() -> void:
	visible = true
	master_slider.grab_focus()


func close() -> void:
	Settings.save_settings()
	visible = false
	closed.emit()


func _on_master_changed(value: float) -> void:
	Settings.set_volume("Master", value)


func _on_music_changed(value: float) -> void:
	Settings.set_volume("Music", value)


func _on_sfx_changed(value: float) -> void:
	Settings.set_volume("SFX", value)
