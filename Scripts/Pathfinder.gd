extends KinematicBody2D

onready var navigationAgent : NavigationAgent2D = $NavigationAgent2D

export var state : String
export var moveSpeed : float

onready var player = get_node(Util.levelPath + "/Player")
onready var graphics = get_node(Util.levelPath + "/Player/Graphics")
onready var light = get_node(Util.levelPath + "/Player/Graphics/Light2D")
onready var sprite = $Sprite

var targetLocation : Vector2 = Vector2.ZERO
var followPosition : Vector2
var changeStateTimer : float = 0

func set_animation(newAnimation):
	if animation != newAnimation:
		animation = newAnimation
		sprite.play(animation)

func set_target_location(target : Vector2) -> void:
	navigationAgent.set_target_location(target)
	# look_at_direction(target)
	
func get_dir_to_target():
	var moveDirection = position.direction_to(navigationAgent.get_next_location())
	return moveDirection

func arrived_at_target() -> bool:
	return navigationAgent.is_navigation_finished()

func on_velocity_computed(velocity) -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	navigationAgent.connect("velocity_computed", self, "_on_velocity_computed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass	

func move(delta):
	var velocity
	var moveDirection = get_dir_to_target()
	
	if arrived_at_target():
		#Set animation to idle
		velocity = Vector2.ZERO
	else:
		velocity = moveDirection * moveSpeed * delta
		navigationAgent.set_velocity(velocity)
	move_and_slide(velocity)
	look_at(velocity + position)
	

func is_illuminated() -> bool:
	var dogPosition = self.position

	var lightPosition = light.global_position
	var graphicsRotation = graphics.rotation
	
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
