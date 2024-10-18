extends "res://Scripts/Pathfinder.gd"

export var moveSpeed : float = 5000.0

var velocity : Vector2 = Vector2.ZERO
onready var Main = get_parent()
onready var Player = get_node("/root/ViewportContainer/Viewport/Main/Player")
var follow_player = false
export var follow_duration: float
var follow_timer
onready var player_light = get_node("/root/ViewportContainer/Viewport/Main/Player/Graphics/Light2D")

export var follow_duration : float
var follow_timer : float
var follow_player = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("call_dog"):
		follow_player = true
		follow_timer = follow_duration
	
	if follow_player:
		follow_timer -= delta
		if follow_timer <= 0:
			follow_player = false
			
		set_target_location(Player.get_position()) # get player position
	
	var moveDirection = get_dir_to_target()
	if arrived_at_target():
		#Set animation to idle
		velocity = Vector2.ZERO
	else:
		velocity = moveDirection * moveSpeed * delta
		navigationAgent.set_velocity(velocity)
	move_and_slide(velocity)
	
	if Input.is_action_pressed("turbo_charge"):
		if is_illuminated(player_light):
			print("i'm illuminated!")
			pass
		else:
			print("sadge")

func is_illuminated(light: Light2D) -> bool:
	var dog_position = self.position

	var light_position = light.global_position
	var player_rotation = Player.rotation
	
	var angle_to_dog = light_position.angle_to_point(dog_position)
	if angle_to_dog > 0:
		angle_to_dog -= PI
	else: angle_to_dog += PI
	
	print("player rotation: ", rad2deg(player_rotation))
	print("angle_to_dog:", rad2deg(angle_to_dog))
	
	return (abs(angle_to_dog - player_rotation) < PI/4/2) or \
	(abs(angle_to_dog + 2*PI - player_rotation) < PI/4/2) or \
	(abs(angle_to_dog - player_rotation + 2*PI) < PI/4/2)
	
	print("\n\ndog: ", dog_position)
	print("light_position: ", light_position)
	return true

	# Calculate the light's effective radius (length of the cone)
#	var light_radius = light.texture.get_size().x * light.scale.x
#
#	# Define the spread angle of the cone (in radians)
#	var spread_angle = deg2rad(45) # Example spread of 45 degrees (adjust as needed)
#
#	# Calculate the two base points of the triangle
#	var direction = Vector2(1, 0).rotated(light_rotation).normalized() * light_radius
#	var left_point = light_position + direction.rotated(-spread_angle / 2)
#	var right_point = light_position + direction.rotated(spread_angle / 2)
#
#	# Check if the dog's position is inside the triangle
#	return point_in_triangle(dog_position, light_position, left_point, right_point) and detect_collision():

	# Function to check if a point is inside a triangle
#func point_in_triangle(p: Vector2, a: Vector2, b: Vector2, c: Vector2) -> bool:
#	var d1 = (p.x - b.x) * (a.y - b.y) - (a.x - b.x) * (p.y - b.y)
#	var d2 = (p.x - c.x) * (b.y - c.y) - (b.x - c.x) * (p.y - c.y)
#	var d3 = (p.x - a.x) * (c.y - a.y) - (c.x - a.x) * (p.y - a.y)
#	var has_neg = (d1 < 0) or (d2 < 0) or (d3 < 0)
#	var has_pos = (d1 > 0) or (d2 > 0) or (d3 > 0)
#	return not (has_neg and has_pos)
