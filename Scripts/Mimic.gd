extends KinematicBody2D

onready var Player = get_node("/root/ViewportContainer/Viewport/Main/Player")
export var jumpscareDistance : float

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.position.distance_squared_to(Player.position) < jumpscareDistance:
		# queue jumpscare
		pass
