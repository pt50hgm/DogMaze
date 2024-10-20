extends KinematicBody2D

export var speed : float
export var max_stamina : float = 3
onready var stamina = max_stamina
export var sprint_speed : float = 2
export var turboCoolDown = 30.0
export var turboFlashDuration = 3.0
export var default_light_energy : float
export var turbo_light_energy : float

onready var camera : Camera2D = $Camera2D
onready var viewportContainer = get_node("/root/ViewportContainer")
onready var graphics = $Graphics
onready var light : Light2D = $Graphics/Light2D
onready var sprite : AnimatedSprite = $Graphics/Sprite
onready var sceneManager = get_node("/root/ViewportContainer/Viewport/SceneManager")
onready var level = get_node(Util.levelPath)

var sprint_multiplier : float = 1
var allowed_to_sprint : bool = true
var velocity : Vector2 = Vector2.ZERO
var animation = ""
var turbo = false
var turboTimer = turboCoolDown
var turboFlashTimer = 0.0

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
	
	velocity = velocity.normalized() * speed
	
	if graphics.rotation < -PI:
		graphics.rotation += 2*PI
	elif graphics.rotation > PI:
		graphics.rotation -= 2*PI 

func _physics_process(delta):
	get_input()
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
	
	if sprite.frame % 2 == 1:
		level.soundManager.play_footsteps("footsteps", sceneManager.sceneNum, 0)
