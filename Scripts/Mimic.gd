extends "res://Scripts/Pathfinder.gd"

export var jumpscareDistance : float
export var wanderToChaseDistance : int = 2500
export var chaseToWanderDelay : float = 10.0
export var wanderToWanderDelay : float = 10.0

var startPos : Vector2

func _ready():
	state = "wander"
	startPos = position


func set_state(s):
	state = s
	changeStateTimer = 0
	if s == "wander":
		set_target_location(player.position)
		moveSpeed = 5000.0
	elif s == "chase":
		moveSpeed = 10000.0


func stateWander(delta):
	changeStateTimer += delta
	if changeStateTimer > wanderToWanderDelay:
		set_state("wander")
	if is_illuminated() \
	or position.distance_squared_to(player.position) < wanderToChaseDistance*wanderToChaseDistance:
		set_state("chase")
		
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
	if Input.is_action_pressed("call_dog"):
		set_state("call")
		moveSpeed = 10000.0
	
	move(delta)
	if self.position.distance_squared_to(player.position) < jumpscareDistance*jumpscareDistance:
		# queue jumpscare
		pass
