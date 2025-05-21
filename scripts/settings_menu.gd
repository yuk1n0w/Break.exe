extends Control

# ------------------------------------------------------------------------------------------

# CONSTANTS

const ARROW_ANIMATION_DURATION = 0.15

# CONSTANTS

# ------------------------------------------------------------------------------------------

var option_boxes: Array
var current_index := 0
var current_tween: Tween

@onready var arrow: Label = $Arrow
@onready var options_vbox: VBoxContainer = $OptionsVBox


# Option values

@onready var fullscreen_option_value: Label = $OptionsVBox/FullscreenHBox/OptionValue
@onready var master_vol_option_value: Label = $OptionsVBox/MasterVolumeHBox/OptionValue
@onready var bgm_vol_option_value: Label = $OptionsVBox/BgmVolumeHBox/OptionValue
@onready var sfx_vol_option_value: Label = $OptionsVBox/SfxVolumeHBox/OptionValue

# Option values

# ------------------------------------------------------------------------------------------

# Sound effects

@onready var sfx_move: AudioStreamPlayer = Global.get_node("Move")
@onready var sfx_confirm: AudioStreamPlayer = Global.get_node("Confirm")

# Sound effects

# ------------------------------------------------------------------------------------------

func _ready():
	self.focus_mode = Control.FOCUS_ALL

	option_boxes = options_vbox.get_children()
	
	await get_tree().process_frame
	update_arrow_pos(true)

	fullscreen_option_value.text = "[ON]" if Settings.fullscreen else "[OFF]"
	master_vol_option_value.text = "[" + str(Settings.master_vol) + "%]"
	bgm_vol_option_value.text = "[" + str(Settings.bgm_vol) + "%]"
	sfx_vol_option_value.text = "[" + str(Settings.sfx_vol) + "%]"

	grab_focus()

func _unhandled_input(event: InputEvent):
	var selection_changed = false
	if event.is_action_pressed("ui_down"):
		sfx_move.play()
		current_index = (current_index + 1) % option_boxes.size()
		selection_changed = true
		accept_event()
	elif event.is_action_pressed("ui_up"):
		sfx_move.play()
		current_index = (current_index - 1 + option_boxes.size()) % option_boxes.size()
		selection_changed = true
		accept_event()
	elif event.is_action_pressed("ui_cancel"):
		sfx_confirm.play()
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		accept_event()
	elif event.is_action_pressed("ui_right"):
		sfx_move.play()
		handle_value_change(1)
		accept_event()
	elif event.is_action_pressed("ui_left"):
		sfx_move.play()
		handle_value_change(-1)
		accept_event()

	if selection_changed:
		update_arrow_pos()

func handle_value_change(direction: int):
	if current_index == 0: # Fullscreen
		Settings.fullscreen = not Settings.fullscreen
		fullscreen_option_value.text = "[ON]" if Settings.fullscreen else "[OFF]"
	elif current_index == 1: # Master Volume
		var change_amount = 5 * direction
		Settings.master_vol = clamp(Settings.master_vol + change_amount, 0, 100)
		master_vol_option_value.text = "[" + str(Settings.master_vol) + "%]"
	elif current_index == 2: # Bgm Volume
		var change_amount = 5 * direction
		Settings.bgm_vol = clamp(Settings.bgm_vol + change_amount, 0, 100)
		bgm_vol_option_value.text = "[" + str(Settings.bgm_vol) + "%]"
	elif current_index == 3: # Sfx Volume
		var change_amount = 5 * direction
		Settings.sfx_vol = clamp(Settings.sfx_vol + change_amount, 0, 100)
		sfx_vol_option_value.text = "[" + str(Settings.sfx_vol) + "%]"
	
	Settings.save_settings()
	Settings.apply_settings()

func update_arrow_pos(immediate: bool = false):
	var target_hbox = option_boxes[current_index]

	var target_y_centered = target_hbox.global_position.y + (target_hbox.size.y / 2.0) - (arrow.size.y / 2.0)
	var arrow_x_global = arrow.global_position.x

	if is_instance_valid(current_tween) and current_tween.is_running():
		current_tween.kill()
	
	if immediate:
		arrow.global_position = Vector2(arrow_x_global, target_y_centered)
	else:
		current_tween = create_tween()
		current_tween.tween_property(arrow, "global_position", Vector2(arrow_x_global, target_y_centered), ARROW_ANIMATION_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
