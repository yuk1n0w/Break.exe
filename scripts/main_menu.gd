extends Control

@onready var play_option: HBoxContainer = $OptionsVBox/PlayOption
@onready var settings_option: HBoxContainer = $OptionsVBox/SettingsOption
@onready var credits_option: HBoxContainer = $OptionsVBox/CreditsOption
@onready var exit_option: HBoxContainer = $OptionsVBox/ExitOption

var menu_options: Array[HBoxContainer]
var current_selection_index: int = 0

const ARROW_TEXT = "▶ " 
const EMPTY_ARROW_TEXT = "  "

func _ready():
	menu_options = [
		play_option,
		settings_option,
		credits_option,
		exit_option
	]

	update_visual_selection()

	grab_focus()


func _input(event: InputEvent):
	if not is_visible_in_tree():
		return

	var previous_selection = current_selection_index

	if event.is_action_pressed("ui_down"):
		current_selection_index = (current_selection_index + 1) % menu_options.size()
		accept_event()
	elif event.is_action_pressed("ui_up"):
		current_selection_index = (current_selection_index - 1 + menu_options.size()) % menu_options.size()
		accept_event()
	elif event.is_action_pressed("ui_accept"):
		_on_option_selected()
		accept_event()

	if previous_selection != current_selection_index:
		update_visual_selection()


func update_visual_selection():
	for i in range(menu_options.size()):
		var option_hbox: HBoxContainer = menu_options[i]
		var arrow_label: Label = option_hbox.get_child(0) as Label
		if arrow_label: 
			if i == current_selection_index:
				arrow_label.text = ARROW_TEXT
			else:
				arrow_label.text = EMPTY_ARROW_TEXT
		else:
			printerr("ArrowLabel not found for option at index: ", i, " (Node: ", option_hbox.name, ")")
			printerr("Check node paths and ensure Arrow labels are the first child of their HBoxContainers.")


func _on_option_selected():
	match current_selection_index:
		0:
			print("Play selected")
		1: 
			get_tree().change_scene_to_file("res://scenes/settings.tscn")
		2:
			print("Credits selected")
		3:
			print("Exit selected")
			get_tree().quit()
