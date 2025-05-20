extends Node

var fullscreen = false
var master_vol = 100
var bgm_vol = 100
var sfx_vol = 100

func _ready():
	load_settings()
	apply_settings()
	
func save_settings():
	var config = ConfigFile.new()
	
	config.set_value("display", "fullscreen", fullscreen)
	config.set_value("audio", "master", master_vol)
	config.set_value("audio", "bgm", bgm_vol)
	config.set_value("audio", "sfx", sfx_vol)
	
	config.save("user://settings.cfg")

func load_settings():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err != OK:
		return

	fullscreen = config.get_value("display", "fullscreen", false)
	master_vol = config.get_value("audio", "master", 100)
	bgm_vol = config.get_value("audio", "bgm", 100)
	sfx_vol = config.get_value("audio", "sfx", 100)
	
	
	apply_settings()
	
func apply_settings():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), master_vol / 100.0)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), bgm_vol / 100.0)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), sfx_vol / 100.0)
