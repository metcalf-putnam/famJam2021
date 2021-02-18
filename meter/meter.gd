extends ProgressBar
var happy_heart = preload("res://meter/hearthappy.png")
var upset_heart = preload("res://meter/heartupset.png")
var mad_heart = preload("res://meter/heartangry.png")

var upset_limit := 75.0
var mad_limit := 40.0

var happy_speed := 1.0
var upset_speed := 1.5
var mad_speed := 2.25


func _ready():
	EventHub.connect("patience_changed", self, "_on_patience_changed")
	$Heart.position.x = rect_size.x * value / 100
	_update_heart_sprite()


func beat():
	EventHub.emit_signal("heart_beat")


func _on_patience_changed(amount):
	# TODO: add animation effect and sound here
	change_value(amount)
	_update_heart_sprite()


func _update_heart_sprite():
	if value <= mad_limit:
		$Heart.texture = mad_heart
		update_playback_speed(mad_speed)
	elif value <= upset_limit:
		$Heart.texture = upset_heart
		update_playback_speed(upset_speed)
	else:
		$Heart.texture = happy_heart
		update_playback_speed(happy_speed)


func update_playback_speed(new_value):
	if $AnimationPlayer.playback_speed == new_value:
		return
	
	EventHub.emit_signal("playback_speed_updated", new_value)
	$AnimationPlayer.playback_speed = new_value
	

func change_value(amount : float):
	value += amount
	$Heart.position.x = rect_size.x * value / 100 # TODO: make this tween?
