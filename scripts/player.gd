extends CharacterBody2D
@onready var dialogue: Control = $CanvasLayer/Dialogue

const SPEED = 75.0
var speed_multiplier = 1.0
@export var in_dialogue = false

func _physics_process(delta: float) -> void:
	if not in_dialogue:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		# TODO: Replace UI actions with custom gameplay actions.
		var x_direction := Input.get_axis("ui_left", "ui_right")
		var y_direction := Input.get_axis("ui_up", "ui_down")
		
		velocity.x = x_direction * SPEED * speed_multiplier
		velocity.y = y_direction * SPEED * speed_multiplier

		move_and_slide()

func do_dialogue(text, picture=null, sfx=null, speed=null, sfx_vol=null, sfx_bus=null, pitch=null, pitch_randomization=null):
	if not in_dialogue:
		in_dialogue = true
		dialogue.visible = true
		await dialogue.do_dialogue(text, picture, sfx, speed, sfx_vol, sfx_bus, pitch, pitch_randomization)
		dialogue.visible = false
		in_dialogue = false

func run_list(dialogue_list):
	if not in_dialogue:
		in_dialogue = true
		dialogue.visible = true
		await dialogue.run_list(dialogue_list)
		dialogue.visible = false
		in_dialogue = false
