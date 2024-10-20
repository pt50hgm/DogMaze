extends Node2D

export var exitXCoord : int
export var exitYCoords : Array
export var floorTile : int

onready var tileMap = $TileMap
var rng = RandomNumberGenerator.new()

func get_random_nearby_pos(pos, dist):
	if tileMap == null: return pos
	var tile = -1
	var randPos : Vector2
	while tile == -1:
		rng.randomize()
		randPos = Vector2(
			pos.x + rng.randf_range(-dist, dist),
			pos.y + rng.randf_range(-dist, dist))
		var cell = tileMap.world_to_map(randPos)
		tile = tileMap.get_cellv(cell)
	return randPos

func get_random_rightward_pos(pos, xDist, yDist):
	if tileMap == null: return pos
	var tile = -1
	var randPos : Vector2
	while tile == -1:
		rng.randomize()
		randPos = Vector2(
			pos.x + rng.randf_range(0, xDist),
			pos.y + rng.randf_range(-yDist, yDist))
		var cell = tileMap.world_to_map(randPos)
		tile = tileMap.get_cellv(cell)
	return randPos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
