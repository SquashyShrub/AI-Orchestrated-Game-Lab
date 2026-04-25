extends Node
class_name AudioManager

@export_category("Players")
@export var music_player_path: NodePath = NodePath("MusicPlayer")
@export var voice_player_path: NodePath = NodePath("VoicePlayer")

@onready var _music: AudioStreamPlayer = get_node(music_player_path) as AudioStreamPlayer
@onready var _voice: AudioStreamPlayer = get_node(voice_player_path) as AudioStreamPlayer


func _ready() -> void:
	play_background_music_looped()


func _unhandled_input(event: InputEvent) -> void:
	# Why: This listens for E even if you haven't set up an Input Map action yet.
	# It also avoids repeats by ignoring echo events.
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		play_voice_line()


func play_background_music_looped() -> void:
	# Why: Some stream types don't expose seamless looping; restarting on `finished`
	# is a reliable fallback that works for MP3/OGG/WAV.
	if _music == null:
		return

	if not _music.finished.is_connected(_on_music_finished):
		_music.finished.connect(_on_music_finished)

	if not _music.playing:
		_music.play()


func _on_music_finished() -> void:
	if _music != null:
		_music.play()


func play_voice_line() -> void:
	if _voice == null:
		return

	_voice.stop()
	_voice.play()
