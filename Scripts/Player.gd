extends KinematicBody2D

var speed : float = 300.0
var velocity : Vector2 = Vector2.ZERO
export var default_light_energy : float
export var turbo_light_energy : float

func get_input() -> void:
	# Detect up/down/left/right keystate and only move when pressed
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	move_and_slide(velocity)
	
	look_at(get_global_mouse_position())

func _process(delta):
	if Input.is_action_pressed("turbo_charge"):
		$Light2D.energy = turbo_light_energy
	else:
		$Light2D.energy = default_light_energy

func get_position() -> Vector2:
	return position
