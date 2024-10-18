extends "res://Scripts/Pathfinder.gd"

export var moveSpeed : float = 5000.0

var velocity : Vector2 = Vector2.ZERO
onready var Main = get_parent()
onready var Player = get_node("/root/ViewportContainer/Viewport/Main/Player")
var follow_player = false
export var follow_duration: float
var follow_timer
onready var player_light = get_node("/root/ViewportContainer/Viewport/Main/Player/Graphics/Light2D")

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
		pass
	else:
		velocity = moveDirection * moveSpeed * delta
		navigationAgent.set_velocity(velocity)
	move_and_slide(velocity)
	
#	if is_illuminated(player_light):
#		print("i'm illuminated!")
#	else:
#		print("sadge")
#
#
#func is_illuminated(light: Light2D) -> bool:
#	# Get the global position of the dog
#	var dog_position = global_position
#
#	# Check if the light has a valid texture
#	if light.texture == null:
#		return false
#
#	# Get the global position and rotation of the light
#	var light_position = light.global_position
#	var light_rotation = Player.rotation
#
#	# Calculate the light's effective radius (length of the cone)
#	var light_radius = light.texture.get_size().x * light.scale.x
#
#	# Define the width of the cone (adjust based on your requirements)
#	var cone_width = light.texture.get_size().y * light.scale.y
#
#	# Create a rectangle representing the cone's area
#	var half_width = cone_width / 2
#	var rect_center = light_position + Vector2(light_radius / 2, 0).rotated(light_rotation)
#	var light_rect = Rect2(rect_center - Vector2(light_radius / 2, half_width), Vector2(light_radius, cone_width))
#
#	# Rotate the rectangle based on the light's rotation
#	var rotated_position = dog_position - light_position
#	rotated_position = rotated_position.rotated(-light_rotation)
#	var rotated_rect = Rect2(light_rect.position - light_position, light_rect.size)
#
#	# Check if the dog's position (rotated into light's local space) is within the rotated rectangle
#	return rotated_rect.has_point(rotated_position)

