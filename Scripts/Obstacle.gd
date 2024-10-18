tool # Makes this entire script run in the editor
extends Node2D

""" 
When editing the obstacle's width and height, script will automatically
update sprite and collision shape's widths and heights too
"""
export var width : float = 200.0 setget set_width
func set_width(value : float) -> void:
	width = value
	resize_sprite_collision()
export var height : float = 200.0 setget set_height
func set_height(value : float) -> void:
	height = value
	resize_sprite_collision()
func resize_sprite_collision() -> void:
	if has_node("Sprite") and has_node("StaticBody2D/CollisionShape2D") and has_node("LightOccluder2D"):
		$Sprite.scale = Vector2(width, height) / 100.0
		$StaticBody2D/CollisionShape2D.scale = Vector2(width, height) / 100.0
		var occluder : OccluderPolygon2D = OccluderPolygon2D.new()
		occluder.polygon = PoolVector2Array(get_corner_relative_pos(-10))
		$LightOccluder2D.occluder = occluder
		if get_parent() != null:
			var navPoly = get_parent().get_parent()
			if navPoly != null:
				navPoly.set_nav_poly()
		
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func get_corner_relative_pos(margin : float):
	var corners = get_corner_pos(margin)
	for i in range(corners.size()):
		corners[i] -= position
	return corners

func get_corner_pos(margin : float):
	var corners = []
	for m in [[-1, -1], [1, -1], [1, 1], [-1, 1]]:
		var mx = m[0]
		var my = m[1]
		corners.push_back(Vector2(
			position.x + (width*0.5 + margin) * mx,
			position.y + (height*0.5 + margin) * my))
	return corners

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
