extends KinematicBody2D

export var speed : float
export var max_stamina : float = 3
onready var stamina = max_stamina
var sprint_multiplier : float = 1
var allowed_to_sprint : bool = true
export var sprint_speed : float = 2
export var turboCoolDown = 30.0
export var turboFlashDuration = 3.0

var velocity : Vector2 = Vector2.ZERO
var animation = ""
var turbo = false
var turboTimer = turboCoolDown
var turboFlashTimer = 0.0

export var default_light_energy : float
export var turbo_light_energy : float

onready var camera : Camera2D = $Camera2D
onready var viewportContainer = get_node("/root/ViewportContainer")
onready var graphics = $Graphics
onready var light : Light2D = $Graphics/Light2D
onready var sprite : AnimatedSprite = $Graphics/Sprite

func _ready():
	pass

func set_animation(newAnimation):
	if animation != newAnimation:
		animation = newAnimation
		sprite.play(animation)

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
	
	if graphics.rotation < -PI:
		graphics.rotation += 2*PI
	elif graphics.rotation > PI:
		graphics.rotation -= 2*PI 

func check_sprint(delta) -> void:
	if Input.is_action_just_pressed('sprint'):
		allowed_to_sprint = true

	if allowed_to_sprint and Input.is_action_pressed('sprint'):
		if stamina <= 0:
			allowed_to_sprint = false
		else:
			stamina -= delta
			sprint_multiplier = sprint_speed
	else:
		if stamina < max_stamina:
			stamina += delta * 0.5
		sprint_multiplier = 1
	
func _physics_process(delta):
	get_input()
	check_sprint(delta)
	velocity = velocity.normalized() * speed * sprint_multiplier	
	move_and_slide(velocity)

func _input(event):
	if event is InputEventMouseMotion:
		event = viewportContainer.make_input_local(event)
		event = make_input_local(event)
		$Graphics.look_at(event.position + position)

func _process(delta):
	turboTimer += delta
	if Input.is_action_pressed("turbo_charge") and turboTimer > turboCoolDown:
		light.energy = turbo_light_energy
		turbo = true
		turboTimer = 0
		turboFlashTimer = 0
		
	if turbo:
		turboFlashTimer += delta
		if turboFlashTimer > turboFlashDuration:
			turbo = false
			light.energy = default_light_energy
	
	if abs(velocity.x) > 0 or abs(velocity.y) > 0:
		set_animation("walk")
	else:
		set_animation("idle")
