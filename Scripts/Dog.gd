extends "res://Scripts/Pathfinder.gd"

export var followDuration: float
export var guideDistance: int = 2500
export var followDistance: int = 100
export var followToGuideDelay: float = 1.0
export var guideToFollowDelay: float = 3.0
export var scaredToFollowDelay: float = 4.0
export var calledByMimicToFollowDelay: float = 10.0
export var offScreenLoseDuration: float = 25000000.0

onready var Main = get_parent()

var followTimer : float
var callTimer = callCooldown
var offScreenTimer : float = 0.0

var mimicToFollow : Node2D
var startState = true
var barkTimer : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_state("guidePlayer")

func set_state(s):
	state = s
	changeStateTimer = 0
	
	if s == "scared":
		print("BARK")
		var pos = maze.get_random_nearby_pos(position, runAwayDistance)
		set_target_location(pos)
		level.soundManager.play_effect("bark", 0, find_volume(position, 1, -10))
		moveSpeed = 20000.0
		return
	if s == "guidePlayer":
		moveSpeed = 5000.0
	elif s == "followPlayer":
		moveSpeed = 10000.0
	elif s == "called":
		rng.randomize()
		var randI = rng.randi_range(0, 2)
		level.soundManager.play_effect("call", randI, 0)
		moveSpeed = 25000.0
	elif s == "calledByMimic":
		level.soundManager.play_effect("call", 0, 0)
		moveSpeed = 25000.0
	elif s == "idle":
		moveSpeed = 0.0
	
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
	
	if abs(velocity.x) > 0 or abs(velocity.y) > 0:
		set_animation("walk")
	else:
		set_animation("idle")
	
	if animation == "walk":
		if sprite.frame % 2 == 1:
			level.soundManager.play_footsteps2("footsteps", sceneManager.sceneNum, find_volume(position, 15, 0))
	
	if position.distance_squared_to(player.position) > offScreenDistance*offScreenDistance:
		offScreenTimer += delta
		if offScreenTimer > offScreenLoseDuration:
			level.off_screen_restart()
	else:
		offScreenTimer = 0
