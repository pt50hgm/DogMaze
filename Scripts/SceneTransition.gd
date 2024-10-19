extends CanvasLayer

onready var sceneManager = get_node("/root/ViewportContainer/Viewport/SceneManager")

func TransitionBlack(nextScene):
	$AnimationPlayer.play("DissolveBlack")
	yield($AnimationPlayer, "animation_finished")
	sceneManager.StartLevel(nextScene)
	$AnimationPlayer.play_backwards("DissolveBlack")

func TransitionWhite(nextScene):
	$AnimationPlayer.play("DissolveWhite")
	yield($AnimationPlayer, "animation_finished")
	sceneManager.StartLevel(nextScene)
	$AnimationPlayer.play_backwards("DissolveWhite")
