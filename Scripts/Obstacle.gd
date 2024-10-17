tool # Makes this entire script run in the editor
extends Node2D

""" 
When editing the obstacle's width and height, script will automatically
update sprite and collision shape's widths and heights too
"""
export var width : float = 200.0 setget set_width
func set_width(value):
	width = value
	resize_sprite_collision()
export var height : float = 200.0 setget set_height
func set_height(value):
	height = value
	resize_sprite_collision()
func resize_sprite_collision():
	if has_node("Sprite") and has_node("StaticBody2D/CollisionShape2D"):
		$Sprite.scale = Vector2(width, height) / 100.0
		$StaticBody2D/CollisionShape2D.scale = Vector2(width, height) / 100.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	resize_sprite_collision()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
