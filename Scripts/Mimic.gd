extends "res://Scripts/Pathfinder.gd"

export var jumpscareDistance : int = 1 * 128
export var wanderDistance : int = 3 * 128*3
export var wanderToChaseDistance : int = 2 * 128*3
export var callDogDistance : int = 3 * 128*3
export var wanderToWanderDelay : float = 10.0
export var callChance : float = 0.1
export var callDelay : float = 20.0

onready var dog = get_node(Util.levelPath + "/Navigation2D/Dog")

var startPos : Vector2
var callTimer = 0
var stunned = false
var mimicType : String

func _ready():
	set_state("wander")
	startPos = position
	rng.randomize()
	var randI = rng.randi_range(0, maze.mimicTypes.size()-1)
	mimicType = maze.mimicTypes[randI]
	if mimicType.substr(0, 6) == "person":
		sprite.rotation = PI/2

func set_state(s):
	state = s
	changeStateTimer = 0
	if s == "wander":
		set_target_location(maze.get_random_nearby_pos(startPos, wanderDistance))
		moveSpeed = 10000.0
	if s == "chase":
		set_target_location(maze.get_random_nearby_pos(startPos, wanderDistance))
		moveSpeed = 15000.0

func stateWander(delta):
	changeStateTimer += delta
	if position.distance_squared_to(player.position) < wanderToChaseDistance*wanderToChaseDistance:
		set_state("chase")
	elif arrived_at_target() or changeStateTimer > wanderToWanderDelay:
		set_state("wander")
		
func stateChase(delta):
	set_target_location(player.position)
	
	changeStateTimer += delta
	if position.distance_squared_to(player.position) > wanderDistance*wanderDistance:
		set_state("wander")

func do_state_action(delta):
	if state == "wander":
		stateWander(delta)
	elif state == "chase":
		stateChase(delta)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not stunned:
		do_state_action(delta)
		move(delta)
		
		if abs(velocity.x) > 0 or abs(velocity.y) > 0:
			set_animation(mimicType + "_walk")
		else:
			set_animation(mimicType + "_idle")
		
	if player.turbo:
		if is_illuminated():
			stunned = true
			set_animation(mimicType + "_idle")
	else:
		stunned = false
	
	if not stunned:
		if position.distance_squared_to(dog.position) < callDogDistance*callDogDistance:
			if callTimer > callDelay:
				if dog.state != "scared" and dog.state != "called":
					dog.set_state("calledByMimic")
					dog.mimicToFollow = self
					callTimer = 0
		callTimer += delta
		if position.distance_squared_to(dog.position) < jumpscareDistance*jumpscareDistance * 4:
			if dog.state != "scared":
				dog.set_state("scared")
	if position.distance_squared_to(player.position) < jumpscareDistance*jumpscareDistance:
		level.start_jump_scare(Node2D.new())
	
	
			
