extends Control

# References to the HBoxContainers for each option
@onready var play_option_hbox: HBoxContainer = $OptionsVBox/PlayOption
@onready var settings_option_hbox: HBoxContainer = $OptionsVBox/SettingsOption
@onready var credits_option_hbox: HBoxContainer = $OptionsVBox/CreditsOption
@onready var exit_option_hbox: HBoxContainer = $OptionsVBox/ExitOption

# References to the HBoxContainers for each option
@onready var play_option_hbox: HBoxContainer = $OptionsVBox/PlayOption
@onready var settings_option_hbox: HBoxContainer = $OptionsVBox/SettingsOption
@onready var credits_option_hbox: HBoxContainer = $OptionsVBox/CreditsOption
@onready var exit_option_hbox: HBoxContainer = $OptionsVBox/ExitOption

# Reference to the single moving ArrowLabel
@onready var arrow_label: Label = $ArrowLabel # Assumes ArrowLabel is direct child of MainMenu

# Reference to OptionsVBox
@onready var options_vbox: VBoxContainer = $OptionsVBox

var menu_option_nodes: Array[HBoxContainer]
var current_selection_index: int = 0
var current_tween: Tween

const ARROW_ANIMATION_DURATION = 0.12
const ARROW_TEXT = "▶ " # Or "▶ "

func _ready():
	menu_option_nodes = [
		play_option_hbox,
		settings_option_hbox,
		credits_option_hbox,
		exit_option_hbox
	]

	if not is_instance_valid(arrow_label):
		printerr("ArrowLabel node not found or invalid! Path: $ArrowLabel. Ensure it exists and is a child of MainMenu.")
		return # Stop if arrow_label is not found

	# IMPORTANT: For this script to work, you MUST ensure that in the Godot Editor,
	# the 'ArrowLabel' node has its 'Layout -> Layout Mode' property set to 'Position'.

	await get_tree().process_frame # Wait for layout to settle
	set_arrow_initial_position()

	grab_focus()

func set_arrow_initial_position():
	if menu_option_nodes.is_empty() or not is_instance_valid(arrow_label) or not is_instance_valid(options_vbox):
		printerr("Cannot set arrow initial position: critical nodes invalid.")
		return

	var target_node = menu_option_nodes[current_selection_index]
	if not is_instance_valid(target_node):
		printerr("Initial target node for arrow is invalid.")
		return

	var desired_arrow_x_global = arrow_label.global_position.x # Use X set in editor
	# Optional: Calculate X programmatically if needed
	# var text_left_margin_guess = 5 # Example: if text inside OptionsVBox has some left margin
	# desired_arrow_x_global = options_vbox.global_position.x + text_left_margin_guess - arrow_label.size.x - 5 # 5px gap

	var target_y_global_centered = target_node.global_position.y + (target_node.size.y / 2.0) - (arrow_label.size.y / 2.0)

	arrow_label.global_position = Vector2(desired_arrow_x_global, target_y_global_centered)
	arrow_label.text = ARROW_TEXT

func _input(event: InputEvent):
	if not is_visible_in_tree():
		return

	var previous_selection = current_selection_index

	if event.is_action_pressed("ui_down"):
		current_selection_index = (current_selection_index + 1) % menu_option_nodes.size()
		accept_event()
	elif event.is_action_pressed("ui_up"):
		current_selection_index = (current_selection_index - 1 + menu_option_nodes.size()) % menu_option_nodes.size()
		accept_event()
	elif event.is_action_pressed("ui_accept"):
		_on_option_selected()
		accept_event()

	if previous_selection != current_selection_index:
		if is_instance_valid(arrow_label): # Check before animating
			animate_arrow_to_selection()
		else:
			printerr("ArrowLabel became invalid, cannot animate.")


func animate_arrow_to_selection():
	# is_instance_valid(arrow_label) already checked in _input before calling this
	if menu_option_nodes.is_empty():
		printerr("Cannot animate arrow: menu_option_nodes is empty.")
		return

	var target_node = menu_option_nodes[current_selection_index]
	if not is_instance_valid(target_node):
		printerr("Target node for arrow animation is invalid.")
		return

	var final_y_global_centered = target_node.global_position.y + (target_node.size.y / 2.0) - (arrow_label.size.y / 2.0)
	var final_x_global = arrow_label.global_position.x # Keep current X

	if is_instance_valid(current_tween) and current_tween.is_running():
		current_tween.kill()

	current_tween = create_tween()
	current_tween.set_trans(Tween.TRANS_QUAD)
	current_tween.set_ease(Tween.EASE_OUT)
	current_tween.tween_property(arrow_label, "global_position:y", final_y_global_centered, ARROW_ANIMATION_DURATION)

func _on_option_selected():
	match current_selection_index:
		0: # Play
			print("Play selected")
		1: # Settings
			print("Settings selected")
			get_tree().change_scene_to_file("res://scenes/settings.tscn")
		2: # Credits
			print("Credits selected")
			print("Credits selected")
			# Example: Transition to a credits scene
			# get_tree().change_scene_to_file("res://credits_scene.tscn")
		3: # Exit
			print("Exit selected")
			get_tree().quit() # Quits the game
