tool
extends NavigationPolygonInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_nav_poly():
	var margin = -1.0
	var polygon = NavigationPolygon.new()
	var size = 1000.0
	var vertices = [
		Vector2(-size, -size), Vector2(size, -size),
		Vector2(size, size), Vector2(-size, size)]
	polygon.add_outline(PoolVector2Array(vertices))
	var obstacleList = $"Obstacle Manager".get_children()
	for obstacle in obstacleList:
		vertices = []
		for pos in obstacle.get_corner_pos(margin):
			vertices.push_back(pos)
		polygon.add_outline(PoolVector2Array(vertices))
	polygon.make_polygons_from_outlines()
	navpoly = polygon
	


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
