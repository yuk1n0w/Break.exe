extends Control

# Explicitly get HBoxContainers for options
@onready var fullscreen_hbox: HBoxContainer = $OptionsVBox/FullscreenHBox
@onready var master_volume_hbox: HBoxContainer = $OptionsVBox/MasterVolumeHBox

var option_boxes: Array[HBoxContainer] # Will store the HBoxContainers
var current_index := 0

# Assuming Arrow is a Label node, direct child of this script's node,
# AND its Layout Mode is set to "Position" in the Inspector.
@onready var arrow: Label = $Arrow
@onready var options_vbox: VBoxContainer = $OptionsVBox # Used if Arrow X is relative to it

var current_tween: Tween

@onready var fullscreen_option_value: Label = $OptionsVBox/FullscreenHBox/FullscreenOptionValue
@onready var master_vol_option_value: Label = $OptionsVBox/MasterVolumeHBox/MasterVolumeOptionValue

@onready var sfx_move: AudioStreamPlayer = $Move
@onready var sfx_confirm: AudioStreamPlayer = $Confirm


const ARROW_ANIMATION_DURATION = 0.15

func _ready():
	self.focus_mode = Control.FOCUS_ALL # Allow this control to get focus

	option_boxes = [
		fullscreen_hbox,
		master_volume_hbox
	]

	if not is_instance_valid(arrow):
		printerr("Settings Arrow node not found or invalid! Path: $Arrow. Ensure it's a child of the node with this script.")
		return # Stop if arrow is not found

	# IMPORTANT: For this script to work, you MUST ensure that in the Godot Editor,
	# the 'Arrow' node (referenced by $Arrow) has its 'Layout -> Layout Mode' 
	# property set to 'Position'. We are not checking this in script.

	await get_tree().process_frame
	update_arrow_pos(true) # instant = true
	
	if Settings:
		fullscreen_option_value.text = "[ON]" if Settings.fullscreen else "[OFF]"
		master_vol_option_value.text = "[" + str(Settings.master_vol) + "%]"
		Settings.apply_settings()
	else:
		printerr("Settings autoload not found!")

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
		if Settings: Settings.save_settings()
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
		if is_instance_valid(arrow): # Good to keep this check before animating
			update_arrow_pos()
		else:
			printerr("Settings Arrow became invalid, cannot update position.")

func handle_value_change(direction: int):
	if not Settings: return

	if current_index == 0: # Fullscreen
		Settings.fullscreen = not Settings.fullscreen
		fullscreen_option_value.text = "[ON]" if Settings.fullscreen else "[OFF]"
	elif current_index == 1: # Master Volume
		var change_amount = 5 * direction
		Settings.master_vol = clamp(Settings.master_vol + change_amount, 0, 100)
		master_vol_option_value.text = "[" + str(Settings.master_vol) + "%]"
	
	Settings.save_settings()
	Settings.apply_settings()

func update_arrow_pos(immediate: bool = false):
	if option_boxes.is_empty() or not is_instance_valid(arrow):
		return
	if current_index >= option_boxes.size() or current_index < 0:
		printerr("current_index out of bounds for option_boxes in settings.")
		return

	var target_hbox = option_boxes[current_index]
	if not is_instance_valid(target_hbox):
		printerr("Target HBox for arrow in settings is invalid.")
		return

	var target_y_centered = target_hbox.global_position.y + (target_hbox.size.y / 2.0) - (arrow.size.y / 2.0)
	var arrow_x_global = arrow.global_position.x # Use X set in editor

	if is_instance_valid(current_tween) and current_tween.is_running():
		current_tween.kill()
	
	if immediate:
		arrow.global_position = Vector2(arrow_x_global, target_y_centered)
	else:
		current_tween = create_tween()
		current_tween.tween_property(arrow, "global_position", Vector2(arrow_x_global, target_y_centered), ARROW_ANIMATION_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
