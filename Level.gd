extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var dogStartOffset = Vector2(100, 100)

onready var sceneManager = get_node("/root/ViewportContainer/Viewport/SceneManager")
onready var startPoints = $Navigation2D/Maze/StartPoints.get_children()
onready var player = $Player
onready var dog = $Navigation2D/Dog
onready var maze = $Navigation2D/Maze
onready var tileMap = $Navigation2D/Maze/TileMap
onready var soundManager = get_node("/root/ViewportContainer/SoundManager")

var rng = RandomNumberGenerator.new()
var mimicSoundTimer = 0.0

func set_player_to_start():
	rng.randomize()
	var randI = rng.randi_range(0, startPoints.size()-1)
	var pos = startPoints[randI].position
	player.position = pos
	dog.position = player.position + dogStartOffset

func set_maze_exit():
	rng.randomize()
	var randI = rng.randi_range(0, maze.exitYCoords.size()-1)
	var exitYCoord = maze.exitYCoords[randI]
	
	var v1 = Vector2(maze.exitXCoord, exitYCoord)
	var v2 = Vector2(maze.exitXCoord, exitYCoord+1)
	tileMap.set_cellv(v1, maze.floorTile)
	tileMap.set_cellv(v2, maze.floorTile)
	tileMap.update_bitmask_area(v1)
	tileMap.update_bitmask_area(v2)


func start_jump_scare(animation):
	soundManager.play_effect("jumpScare", 0, -15)
	if not sceneManager.isTransitioning:
		sceneManager.restart_level()

	
# Called when the node enters the scene tree for the first time.
func _ready():
	set_player_to_start()
	set_maze_exit()
	mimicSoundTimer = rng.randf_range(60*2, 60*5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var exitX = 128 * (maze.exitXCoord + 1)
	if player.position.x > exitX:
		if not sceneManager.isTransitioning:
			sceneManager.next_level()
	
	mimicSoundTimer -= delta
	if mimicSoundTimer <= 0:
		rng.randomize()
		mimicSoundTimer = rng.randf_range(60*2, 60*5)
		var randI = rng.randi_range(0, 1)
		soundManager.play_effect("mimicSound", randI, -15)
		
