extends "res://Scripts/Pathfinder.gd"

export var jumpscareDistance : int = 100
export var wanderDistance : int = 5 * 128*3
export var wanderToChaseDistance : int = 1.5 * 128*3
export var chaseToWanderDelay : float = 10.0
export var wanderToWanderDelay : float = 10.0

var startPos : Vector2

func _ready():
	set_state("wander")
	startPos = position


func set_state(s):
	print(s)
	state = s
	changeStateTimer = 0
	if s == "wander":
		rng.randomize()
		var randPos = startPos + Vector2(
			rng.randf_range(-wanderDistance, wanderDistance),
			rng.randf_range(-wanderDistance, wanderDistance))
		print(Vector2(
			rng.randf_range(-wanderDistance, wanderDistance),
			rng.randf_range(-wanderDistance, wanderDistance)))
		set_target_location(randPos)

func stateWander(delta):
	changeStateTimer += delta
	if is_illuminated() \
	or position.distance_squared_to(player.position) < wanderToChaseDistance*wanderToChaseDistance:
		set_state("chase")
	elif changeStateTimer > wanderToWanderDelay:
		set_state("wander")
		
func stateChase(delta):
	set_target_location(player.position)
	
	changeStateTimer += delta
	if changeStateTimer > chaseToWanderDelay:
		set_state("wander")

func do_state_action(delta):
	if state == "wander":
		stateWander(delta)
	elif state == "chase":
		stateChase(delta)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	do_state_action(delta)
	move(delta)
	if self.position.distance_squared_to(player.position) < jumpscareDistance*jumpscareDistance:
		level.start_jump_scare(Node2D.new())
