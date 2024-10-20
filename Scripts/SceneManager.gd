extends Node2D

export var sceneNum = 0

onready var soundManager = get_node("/root/ViewportContainer/SoundManager")

var scenes = [
	preload("res://Scenes/Game Scenes/Level1.tscn"),
	preload("res://Scenes/Game Scenes/Level2.tscn"),
	preload("res://Scenes/Game Scenes/Level3.tscn"),
	preload("res://Scenes/Game Scenes/End_Level.tscn"),
]

var isTransitioning = false


# Called when the node enters the scene tree for the first time.
func _ready():
	start_scene(scenes[sceneNum])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# End the current level and start a new one. It may be the same level in the
# case of a reset, or the next one if the player finishes the current one.
func start_scene(nextScene):
	self.remove_child(get_child(0))
	self.add_child(nextScene.instance())
	if sceneNum < 3:
		soundManager.set_track(sceneNum)
	isTransitioning = false

func transition_to_next_scene(nextScene):
	SceneTransition.transition_black(nextScene)
	isTransitioning = true

func restart_level():
	transition_to_next_scene(scenes[sceneNum])

func next_level():
	sceneNum += 1
	transition_to_next_scene(scenes[sceneNum])
