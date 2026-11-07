extends Node

const SAVE_PATH := "user://settings.cfg"

# Volumes entre 0.0 (muet) et 1.0 (maximum)
var volumes := {"Master": 1.0, "Music": 0.8, "SFX": 0.8}


func _ready() -> void:
	load_settings()
	for bus_name in volumes:
		_apply_volume(bus_name)


func get_volume(bus_name: String) -> float:
	return volumes[bus_name]


func set_volume(bus_name: String, value: float) -> void:
	volumes[bus_name] = value
	_apply_volume(bus_name)


func _apply_volume(bus_name: String) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_warning("Bus audio introuvable : " + bus_name)
		return
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volumes[bus_name]))
	AudioServer.set_bus_mute(bus_index, volumes[bus_name] <= 0.0)


func save_settings() -> void:
	var config := ConfigFile.new()
	for bus_name in volumes:
		config.set_value("audio", bus_name, volumes[bus_name])
	config.save(SAVE_PATH)


func load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return  # premier lancement : on garde les valeurs par défaut
	for bus_name in volumes:
		volumes[bus_name] = config.get_value("audio", bus_name, volumes[bus_name])
