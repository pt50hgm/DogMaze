extends CanvasLayer

onready var sceneManager = get_node("/root/ViewportContainer/Viewport/SceneManager")

func transition_black(nextScene):
	$AnimationPlayer.play("DissolveBlack")
	yield($AnimationPlayer, "animation_finished")
	sceneManager.start_scene(nextScene)
	$AnimationPlayer.play_backwards("DissolveBlack")

func transition_white(nextScene):
	$AnimationPlayer.play("DissolveWhite")
	yield($AnimationPlayer, "animation_finished")
	sceneManager.start_scene(nextScene)
	$AnimationPlayer.play_backwards("DissolveWhite")
