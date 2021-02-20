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

const clue_level_multipliers = {
	1: 3, #delayed by one step, since there will only be one beat after clue 1 is shown before clue level 2 begins
	2: 3,
	3: 2,
	4: 1,
	5: 1,
	6: 1
}

const happiness_level_multipliers = {
	Global.Mood.ANGRY: 1,
	Global.Mood.UPSET: 1,
	Global.Mood.SAD: 1.2,
	Global.Mood.HAPPY: 1.5
}

var change_text_offset := Vector2(0, 30)
var positive_color = Color(0.04,0.81,0.2)  
var negative_color = Color(0.82,0.15,0.14)


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


func _on_patience_changed(amount, clue_level):
	# TODO: add animation effect and sound here
	change_value(amount, clue_level)
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


func change_value(amount : float, clue_level : int):
	value += get_adjusted_value(amount, clue_level)
	print("meter value: ", value)
	$Change.rect_position = $Heart.position + change_text_offset
	var prefix = ""
	if amount > 0:
		prefix = "+"
		$Change.self_modulate = positive_color
	else:
		$Change.self_modulate = negative_color
		
	$Change.text = prefix + str(amount)
	$Heart/ValueAnim.play("value_change")
	$Heart.position.x = rect_size.x * value / 100 # TODO: make this tween?
	if value >= 100 or value <= 0:
		var win_bool = value >= 100
		EventHub.emit_signal("game_over", win_bool)
		$AnimationPlayer.stop()


func get_adjusted_value(amount, clue_level):
	if amount >= 0:
		return get_adjusted_positive_value(amount, clue_level)
	
	return get_adjusted_negative_value(amount, clue_level)


func get_adjusted_positive_value(amount, clue_level : int):
	var adjusted_value = amount
	
	adjusted_value *= clue_level_multipliers[clue_level]
	adjusted_value *= happiness_level_multipliers[Global.mood]
	
	return adjusted_value


# warning-ignore:unused_argument
func get_adjusted_negative_value(amount, clue_level):	
	var adjusted_value = amount
	
	return adjusted_value

