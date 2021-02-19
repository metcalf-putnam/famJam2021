extends ProgressBar
var happy_heart = preload("res://meter/hearthappy.png")
var upset_heart = preload("res://meter/heartupset.png")
var mad_heart = preload("res://meter/heartangry.png")
var sad_heart = preload("res://meter/heartsad.png")

var sad_limit := 75.0
var upset_limit := 50.0
var mad_limit := 25.0

var happy_speed := 1.0
var sad_speed := 1.25
var upset_speed := 1.75
var mad_speed := 2.25


func start():
	$AnimationPlayer.play("beat")	


func set_value(value_in):
	value = value_in
	$Heart.position.x = rect_size.x * value / 100 # TODO: make this tween?
	_update_heart_sprite()


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
		Global.mood = Global.Mood.ANGRY
		update_playback_speed(mad_speed)
	elif value <= upset_limit:
		$Heart.texture = upset_heart
		Global.mood = Global.Mood.UPSET
		update_playback_speed(upset_speed)
	elif value <= sad_limit:
		$Heart.texture = sad_heart
		Global.mood = Global.Mood.SAD
		update_playback_speed(sad_speed)
	else:
		$Heart.texture = happy_heart
		Global.mood = Global.Mood.HAPPY
		update_playback_speed(happy_speed)


func update_playback_speed(new_value):
	if $AnimationPlayer.playback_speed == new_value:
		return
	
	EventHub.emit_signal("playback_speed_updated", new_value)
	$AnimationPlayer.playback_speed = new_value
	

func change_value(amount : float):
	value += amount
	$Heart.position.x = rect_size.x * value / 100 # TODO: make this tween?
	if value >= 100 or value <= 0:
		var win_bool = value >= 100
		EventHub.emit_signal("game_over", win_bool)
		$AnimationPlayer.stop()
