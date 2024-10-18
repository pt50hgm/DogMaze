extends "res://Scripts/Pathfinder.gd"

export var moveSpeed : float = 5000.0

var velocity : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	set_target_location(get_global_mouse_position())
	var moveDirection = get_dir_to_target()
	if arrived_at_target():
		#Set animation to idle
		pass
	else:
		velocity = moveDirection * moveSpeed * delta
		navigationAgent.set_velocity(velocity)
	move_and_slide(velocity)
