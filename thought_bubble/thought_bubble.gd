extends Node2D
var color_base
var normal_modulate = Color(1, 1, 1)


func _ready():
	$Bub3.rotation = $Bub3.rotation - rotation
	EventHub.connect("playback_speed_updated", self, "_on_playback_speed_updated")
	

func reset():
	$AnimationPlayer.play("reset")
	$Bub3/Clue.texture = null
	$Bub3/Clue.modulate = normal_modulate


func set_clue(texture, sound):
	$Bub3/Clue.texture = texture
	$AudioStreamPlayer.stream = sound


func show_bubble(num):
	if num < 1 or num > 3:
		print("error: bubble does not have a bubble number ", num)
		return
	if should_show_bubble(num):
		$AnimationPlayer.play("bub" + str(num))
	if num == 3:
		$AudioStreamPlayer.play()


func should_show_bubble(_num):
	#maybe I'm missing something obvious, but returning false here seems to be the only thing we
	#need to do to activate voice-only mode?  Doing voice only for only some clues will/would be trickier
	return Global.visuals_on


func _on_playback_speed_updated(new_speed):
	$AnimationPlayer.playback_speed = new_speed
