extends "res://Scripts/Pathfinder.gd"

export var moveSpeed : float = 5000.0
export var followDuration: float

onready var Main = get_parent()
onready var Graphics = get_node("/root/ViewportContainer/Viewport/Main/Player/Graphics")
onready var light = get_node("/root/ViewportContainer/Viewport/Main/Player/Graphics/Light2D")

var followTimer : float
var followPlayer = false
var velocity : Vector2 = Vector2.ZERO

export var followDuration: float
export var guideDistance: int = 25000
export var dogTimer: float = 3
var illumCounter : float = 0
var notIllumCounter : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func do_state_action(delta):
	if state == "followPlayer":
		set_target_location(Player.position)
	elif state == "guidePlayer":
		pass
	elif state == "call":
		set_target_location(Player.position)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	do_state_action(delta)
	
	if Input.is_action_pressed("call_dog"):
		set_state("call")
	
	if self.is_illuminated() or self.position.distance_squared_to(Player.position) < guideDistance:
		notIllumCounter = 0
		illumCounter += delta
		print("illuminated")
		if illumCounter > dogTimer:
			print("guiding")
			set_state("guidePlayer")
	elif not self.is_illuminated():
		illumCounter = 0
		print("not illuminated")
		notIllumCounter += delta
		if notIllumCounter > dogTimer:
			print("following")
			set_pathfind(Player.position, moveSpeed, followDuration)
			set_state("followPlayer")
	print(illumCounter)
	print(notIllumCounter)
	

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
