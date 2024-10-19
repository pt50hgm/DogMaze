extends "res://Scripts/Pathfinder.gd"

export var followDuration: float
export var guideDistance: int = 2500
export var followDistance: int = 100
export var followToGuideDelay: float = 1.0
export var guideToFollowDelay: float = 3.0

onready var Main = get_parent()

var followTimer : float
var followPlayer = false
var velocity : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	state = "guidePlayer"

func set_state(s):
	state = s
	changeStateTimer = 0
	if s == "guidePlayer":
		moveSpeed = 5000.0
	elif s == "followPlayer":
		moveSpeed = 10000.0
	elif s == "called":
		moveSpeed = 10000.0

func stateFollowPlayer(delta):
	set_target_location(player.position)
	
	if not is_illuminated():
		changeStateTimer -= delta
	else:
		changeStateTimer += delta
	changeStateTimer = max(changeStateTimer, 0)
	if changeStateTimer > followToGuideDelay:
		set_state("guidePlayer")

func stateGuidePlayer(delta):
	var exitPos = Vector2(1000, 0) # Replace this with actual exit later
	set_target_location(exitPos)
	
	if is_illuminated() and position.distance_squared_to(player.position) < guideDistance*guideDistance:
		changeStateTimer -= delta
	else:
		changeStateTimer += delta
	changeStateTimer = max(changeStateTimer, 0)
	if changeStateTimer > guideToFollowDelay:
		set_state("followPlayer")

func stateCalled(delta):
	set_target_location(player.position)
	
	if position.distance_squared_to(player.position) < followDistance*followDistance:
		set_state("guidePlayer")

func do_state_action(delta):
	if state == "followPlayer":
		stateFollowPlayer(delta)
	elif state == "guidePlayer":
		stateGuidePlayer(delta)
	elif state == "called":
		stateCalled(delta)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	do_state_action(delta)
	if Input.is_action_pressed("call_dog"):
		set_state("called")
	move(delta)

