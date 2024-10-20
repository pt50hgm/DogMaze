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

var exitPos : Vector2
var rng = RandomNumberGenerator.new()

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
	exitPos = Vector2(maze.exitXCoord + 0.5, exitYCoord + 0.5) * 128
	
	
	var v1 = Vector2(maze.exitXCoord, exitYCoord)
	var v2 = Vector2(maze.exitXCoord, exitYCoord+1)
	tileMap.set_cellv(v1, maze.floorTile)
	tileMap.set_cellv(v2, maze.floorTile)
	tileMap.update_bitmask_area(v1)
	tileMap.update_bitmask_area(v2)


func start_jump_scare(animation):
	# Instantiate the animation node
  #	yield() until animation is done
	if not sceneManager.isTransitioning:
		sceneManager.restart_level()

func off_screen_restart():
	# Play dog scream audio
	if not sceneManager.isTransitioning:
		sceneManager.restart_level()

	
# Called when the node enters the scene tree for the first time.
func _ready():
	set_player_to_start()
	set_maze_exit()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var exitX = 128 * (maze.exitXCoord + 1)
	if player.position.x > exitX:
		if not sceneManager.isTransitioning:
			sceneManager.next_level()
