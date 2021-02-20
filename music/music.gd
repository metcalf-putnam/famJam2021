extends Node

var low_db = -50
var high_db = -15
var transition_time := 2.0

var title = true
var current_player
var old_player


func _ready():
	EventHub.connect("playback_speed_updated", self, "_on_playback_speed_updated")


func _on_playback_speed_updated(_speed):
	update_song()


func play_title():
	title = true
	transition_song($Players/Title)


func update_song():
	var new_player
	if title:
		new_player = $Players/Title
	else:
		match Global.mood:
			Global.Mood.ANGRY:
				new_player = $Players/Angry
			Global.Mood.HAPPY:
				new_player = $Players/Happy
			Global.Mood.SAD:
				new_player = $Players/Sad
			Global.Mood.UPSET:
				new_player = $Players/Upset
	transition_song(new_player)


func transition_song(player):
	if current_player == player:
		return
	if current_player != null:
		setup_tween_out(current_player)
	setup_tween_in(player)
	old_player = current_player
	current_player = player
	$Tween.start()
	player.play()


func setup_tween_in(new_player):
	$Tween.interpolate_property(new_player, "volume_db", low_db, high_db, transition_time)


func setup_tween_out(current):
	$Tween.interpolate_property(current, "volume_db", high_db, low_db, transition_time)


func _on_Tween_tween_all_completed():
	if old_player:
		old_player.stop()
