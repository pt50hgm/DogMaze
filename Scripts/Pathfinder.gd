extends KinematicBody2D


onready var navigationAgent : NavigationAgent2D = $NavigationAgent2D

var targetLocation : Vector2 = Vector2.ZERO

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
	
