extends "res://Scripts/Pathfinder.gd"

export var followDuration: float = 10.0
export var guideDistance: int = 2 * 128*3
export var callCooldownTimer: float = 5.0
onready var callCooldown = callCooldownTimer
export var followDistance: int = 100
export var runAwayDistance: int = 3 * 128 * 3
export var guideToFollowDelay: float = 3.0
export var scaredToFollowDelay: float = 4.0
export var calledByMimicToFollowDelay: float = 10.0
var startTimer: bool = false

onready var Main = get_parent()

var followTimer : float
var followPlayer = false
var velocity : Vector2 = Vector2.ZERO

var mimicToFollow : Node2D
var startState = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_state(s):
	print(state, " ", s)
	if s == "scared":
		var pos = maze.get_random_nearby_pos(position, runAwayDistance)
		set_target_location(pos)
		moveSpeed = 20000.0
		state = s
		return
	state = s
	changeStateTimer = 0
	if s == "guidePlayer":
		print(level.exitPos)
		set_target_location(level.exitPos)
		moveSpeed = 15000.0
	elif s == "followPlayer":
		moveSpeed = 0
	elif s == "called":
		moveSpeed = 25000.0
	elif s == "calledByMimic":
		moveSpeed = 25000.0

func stateFollowPlayer(delta):
	if position.distance_squared_to(player.position) < guideDistance*guideDistance:
		set_state("guidePlayer")

func stateGuidePlayer(delta):
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

func stateScared(delta):
	changeStateTimer += delta
	if changeStateTimer > scaredToFollowDelay:
		set_state("followPlayer")

func stateCalledByMimic(delta):
	set_target_location(mimicToFollow.position)
	
	changeStateTimer += delta
	if changeStateTimer > calledByMimicToFollowDelay:
		set_state("followPlayer")

func do_state_action(delta):
	if state == "followPlayer":
		stateFollowPlayer(delta)
	elif state == "guidePlayer":
		stateGuidePlayer(delta)
	elif state == "called":
		stateCalled(delta)
	elif state == "scared":
		stateScared(delta)
	elif state == "calledByMimic":
		stateCalledByMimic(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if startState:
		set_state("guidePlayer")
		startState = false
	if Input.is_action_just_pressed("call_dog") and callCooldown == callCooldownTimer
		set_state("called")
		startTimer = true
	print(callCooldown)
	if startTimer:
		callCooldown -= delta
		if callCooldown <= 0:
			startTimer = false
			callCooldown = callCooldownTimer
	
	do_state_action(delta)
	move(delta)
