extends Control

var option_boxes := [HBoxContainer]
var current_index := 0
@onready var arrow = $Arrow
@onready var options_vbox = $OptionsVBox
@onready var tween = create_tween()

func _ready():
	# Get all the option HBoxContainers
	option_boxes = options_vbox.get_children()
	update_arrow_pos(true)

func _unhandled_input(event):
	if event.is_action_pressed("ui_down"):
		current_index = (current_index + 1) % option_boxes.size()
		update_arrow_pos()
	elif event.is_action_pressed("ui_up"):
		current_index = (current_index - 1 + option_boxes.size()) % option_boxes.size()
		update_arrow_pos()

func update_arrow_pos(immediate=false):
	var target_rect = option_boxes[current_index].get_global_rect()
	var target_y = target_rect.position.y

	if immediate:
		arrow.global_position.y = target_y
	else:
		var tween = create_tween()
		tween.tween_property(arrow, "global_position:y", target_y, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
