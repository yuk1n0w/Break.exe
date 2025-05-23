extends Control
@onready var fps_counter: Label = $FPSCounter
@onready var physics_fps_counter: Label = $PhysicsFPSCounter


func _process(delta):
	fps_counter.text = "FPS: " + str(int(round(1/delta)))

func _physics_process(delta):
	physics_fps_counter.text = "Physics FPS: " + str(int(round(1/delta)))
