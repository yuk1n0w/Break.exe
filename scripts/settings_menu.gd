extends Control

var option_boxes: Array = []
var current_index := 0
@onready var arrow = $Arrow
@onready var options_vbox = $OptionsVBox
@onready var tween = create_tween()
@onready var fullscreen_option_value = 	  $OptionsVBox/FullscreenHBox/FullscreenOptionValue
@onready var master_vol_option_value = $OptionsVBox/MasterVolumeHBox/MasterVolumeOptionValue

func _ready():
	# Get all the option HBoxContainers
	option_boxes = options_vbox.get_children()
	update_arrow_pos(true) # instant = true
	
	# Load settings
	fullscreen_option_value.text = "[ON]" if Settings.fullscreen else "[OFF]"
	master_vol_option_value.text = "[" + str(Settings.master_vol) + "%]"

func _unhandled_input(event):
	if event.is_action_pressed("ui_down"):
		current_index = (current_index + 1) % option_boxes.size()	
		update_arrow_pos()
	elif event.is_action_pressed("ui_up"):
		current_index = (current_index - 1 + option_boxes.size()) % option_boxes.size()
		update_arrow_pos()
	elif event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	elif event.is_action_pressed("ui_right"):
		if current_index == 0:
			Settings.fullscreen = true
			fullscreen_option_value.text = "[ON]"
			Settings.save_settings()
			Settings.apply_settings()
		elif current_index == 1:
			Settings.master_vol = clamp(Settings.master_vol + 5, 0, 100)
			master_vol_option_value.text = "[" + str(Settings.master_vol) + "%]"
			Settings.save_settings()
			Settings.apply_settings()
	elif event.is_action_pressed("ui_left"):
		if current_index == 0:
			Settings.fullscreen = false
			fullscreen_option_value.text = "[OFF]"
			Settings.save_settings()
			Settings.apply_settings()
		elif current_index == 1:
			Settings.master_vol = clamp(Settings.master_vol - 5, 0, 100)
			master_vol_option_value.text = "[" + str(Settings.master_vol) + "%]"
			Settings.save_settings()
			Settings.apply_settings()

func update_arrow_pos(immediate=false):
	var target_rect = option_boxes[current_index].get_global_rect()
	var target_y = target_rect.position.y

	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()

	if immediate:
		arrow.global_position.y = target_y
	else:
		tween.tween_property(arrow, "global_position:y", target_y, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
