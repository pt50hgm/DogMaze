extends KinematicBody2D

export var speed : float
var velocity : Vector2 = Vector2.ZERO
onready var camera : Camera2D = $Camera2D
#onready var viewport : Viewport = get_node("/root/ViewportContainer/Viewport")

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

func _input(event):
	if event is InputEventMouseMotion:
		var container : ViewportContainer = get_node("/root/ViewportContainer")
		if container != null:
			event = container.make_input_local(event)
		event = make_input_local(event)
		$Graphics.look_at(event.position + position)


func get_position() -> Vector2:
	return position
