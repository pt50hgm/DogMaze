extends "res://Scripts/Pathfinder.gd"

export var followDuration: float
export var guideDistance: int = 25000 * 25000
export var dogTimer: float = 3.0

onready var Main = get_parent()
onready var Graphics = get_node("/root/ViewportContainer/Viewport/Main/Player/Graphics")
onready var light = get_node("/root/ViewportContainer/Viewport/Main/Player/Graphics/Light2D")
onready var Player = get_node("/root/ViewportContainer/Viewport/Main/Player")

var followTimer : float
var followPlayer = false
var velocity : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	state = "guidePlayer"

func followPlayer(delta):
	set_target_location(Player.position)
	changeStateTimer += delta
	if not is_illuminated():
		changeStateTimer = 0
	if changeStateTimer > dogTimer:
		set_state("guidePlayer")

func guidePlayer(delta):
	var exitPos = Vector2(1000, 0) # Replace this with actual exit later
	set_target_location(exitPos)
	changeStateTimer += delta
	if is_illuminated() and position.distance_squared_to(Player.position) < guideDistance:
		changeStateTimer = 0
	if changeStateTimer > dogTimer:
		set_state("followPlayer")

func do_state_action(delta):
	if state == "followPlayer":
		followPlayer(delta)
	elif state == "guidePlayer":
		guidePlayer(delta)
	elif state == "call":
		set_target_location(Player.position)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	do_state_action(delta)
	if Input.is_action_pressed("call_dog"):
		set_state("call")
	move(delta)
	

func is_illuminated() -> bool:
	var dogPosition = self.position

	var lightPosition = light.global_position
	var graphicsRotation = Graphics.rotation
	
	if graphicsRotation > 2*PI: graphicsRotation -= 2*PI
	elif graphicsRotation < 0: graphicsRotation += 2*PI
	
	var angleToDog = lightPosition.angle_to_point(dogPosition)
	if angleToDog > 0:
		angleToDog -= PI
	else: angleToDog += PI
#	print("angle to dog: ", rad2deg(angleToDog))
#	print("graphics angle: ", rad2deg(graphicsRotation))
	
	return (abs(angleToDog - graphicsRotation) < PI/4/2) or \
	(abs(angleToDog + 2*PI - graphicsRotation) < PI/4/2) or \
	(abs(angleToDog - graphicsRotation + 2*PI) < PI/4/2)
