extends "res://Scripts/Pathfinder.gd"

export var callDuration: float = 10.0
export var guideDistance: int = 1.5 * 128*3
export var offScreenDistance: int = 2.5 * 128*3
export var callCooldown: float = 20.0
export var runAwayDistance: int = 3 * 128 * 3
export var guideToFollowDelay: float = 3.0
export var scaredToFollowDelay: float = 4.0
export var calledByMimicToFollowDelay: float = 10.0
export var offScreenLoseDuration: float = 25.0

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
	
	if position.distance_squared_to(player.position) + 32*32 < guideDistance*guideDistance:
		set_state("guidePlayer")

func stateGuidePlayer(delta):
	set_target_location(level.exitPos)
	
	if position.distance_squared_to(player.position) > guideDistance*guideDistance:
		set_state("idle")

func stateIdle(delta):
	var margin = 128.0
	if position.distance_squared_to(player.position) - margin*margin > guideDistance*guideDistance:
		set_state("followPlayer")
	if position.distance_squared_to(player.position) + margin*margin < guideDistance*guideDistance:
		set_state("guidePlayer")

func stateCalled(delta):
	set_target_location(player.position)
	
	changeStateTimer += delta
	if changeStateTimer > callDuration:
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
	elif state == "idle":
		stateIdle(delta)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if startState:
		set_state("guidePlayer")
		startState = false
	if Input.is_action_just_pressed("call_dog") and callTimer >= callCooldown:
		set_state("called")
		callTimer = 0
	callTimer += delta
	
	do_state_action(delta)
	move(delta)
	
	if abs(velocity.x) > 0 or abs(velocity.y) > 0:
		set_animation("walk")
	else:
		set_animation("idle")
	
	if animation == "walk":
		if sprite.frame % 2 == 1:
			soundManager.play_footsteps2("footsteps", sceneManager.sceneNum, find_volume(position, 15, 0))
	
	if position.distance_squared_to(player.position) > offScreenDistance*offScreenDistance:
		offScreenTimer += delta
		if offScreenTimer > offScreenLoseDuration:
			level.off_screen_restart()
	else:
		offScreenTimer = 0
