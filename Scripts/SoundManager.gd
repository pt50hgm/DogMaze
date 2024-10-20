extends Node

var soundTracks = [
	preload("res://Sounds/Koto.wav"),
	preload("res://Sounds/Smoky Bells.wav"),
	preload("res://Sounds/Clockwork.wav"),
]
var footsteps = [
	preload("res://Sounds/footsteps_wooden.wav"),
	preload("res://Sounds/footsteps_carpet.wav"),
	preload("res://Sounds/footsteps_concrete.mp3"),
]
var bark = preload("res://Sounds/bark.mp3")
var calls = [
	preload("res://Sounds/call1.wav"),
	preload("res://Sounds/call2.wav"),
	preload("res://Sounds/call3.wav"),
]
var mimicSounds = [
	preload("res://Sounds/ghostly humming.mp3"),
	preload("res://Sounds/mimic_call.wav"),
]
var jumpScare = preload("res://Sounds/jumpscare.wav")

onready var soundTrackPlayer = $SoundTrackPlayer
onready var soundEffectsPlayer = $SoundEffectsPlayer
onready var footstepsPlayer = $FootstepsPlayer
onready var footstepsPlayer2 = $FootstepsPlayer2

var muted = false
var trackI = -1

func set_track(i):
	trackI = i
	soundTrackPlayer.stream = soundTracks[i]

func play_footsteps(effect, i, volume):
	footstepsPlayer.set_volume_db(volume)
	footstepsPlayer.stream = footsteps[i]
	footstepsPlayer.play()
func play_footsteps2(effect, i, volume):
	footstepsPlayer2.set_volume_db(volume)
	footstepsPlayer2.stream = footsteps[i]
	footstepsPlayer2.play()
	
func play_effect(effect, i, volume):
	soundEffectsPlayer.set_volume_db(volume)
	if effect == "bark":
		soundEffectsPlayer.stream = bark
	elif effect == "call":
		soundEffectsPlayer.stream = calls[i]
	elif effect == "mimicSound":
		soundEffectsPlayer.stream = mimicSounds[i]
	elif effect == "jumpScare":
		soundEffectsPlayer.stream = jumpScare
	soundEffectsPlayer.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	soundTrackPlayer.set_volume_db(-25)

func _process(delta):
	if trackI != -1:
		if not soundTrackPlayer.is_playing():
			soundTrackPlayer.play()
