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

var current_value_target

const clue_level_multipliers = {
	0: 6, 
	1: 3, 
	2: 2,
	3: 1,
	4: 1,
	5: 1,
	6: 1,
	7: 1
}

const happiness_level_multipliers = {
	Global.Mood.ANGRY: 1,
	Global.Mood.UPSET: 1,
	Global.Mood.SAD: 1.25,
	Global.Mood.HAPPY: 1.5
}

var change_text_offset := Vector2(0, 30)
var positive_color = Color(0.04,0.81,0.2)  
var negative_color = Color(0.82,0.15,0.14)


func start():
	$AnimationPlayer.play("beat")	


func stop():
	$AnimationPlayer.stop()


func set_value(value_in):
	value = value_in
	current_value_target = value
	$Heart.position.x = rect_size.x * value / 100 # TODO: make this tween?
	_update_heart_sprite()


func _ready():
	EventHub.connect("patience_changed", self, "_on_patience_changed")
	$Heart.position.x = rect_size.x * value / 100
	current_value_target = value
	_update_heart_sprite()


func beat():
	EventHub.emit_signal("heart_beat")


func _on_patience_changed(amount, clue_level, consecutive_correct_choices):
	# TODO: add animation effect and sound here
	change_value(amount, clue_level, consecutive_correct_choices)
	_update_heart_sprite()


func _update_heart_sprite():
	if current_value_target <= mad_limit:
		$Heart.texture = mad_heart
		Global.mood = Global.Mood.ANGRY
		update_playback_speed(mad_speed)
	elif current_value_target <= upset_limit:
		$Heart.texture = upset_heart
		Global.mood = Global.Mood.UPSET
		update_playback_speed(upset_speed)
	elif current_value_target <= sad_limit:
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


func change_value(amount : float, clue_level : int, consecutive_correct_choices : int):
	var adjustedAmount = get_adjusted_value(amount, clue_level, consecutive_correct_choices)
	
	$Change.rect_position = $Heart.position + change_text_offset
	var prefix = ""
	if amount > 0:
		prefix = "+"
		$Change.self_modulate = positive_color
	else:
		$Change.self_modulate = negative_color
		
	$Change.text = prefix + str(adjustedAmount)
	
	if clue_level_multipliers[clue_level] > 1 and amount > 0 and consecutive_correct_choices > 0:
		$Heart/ValueAnim.play("bonus_anim")
		print("playing bonus!")
	else:
		$Heart/ValueAnim.play("value_change")
	
	current_value_target = min(100, value + adjustedAmount)
	var desired_heart_position = rect_size.x * current_value_target / 100 # TODO: make this tween?
	var desired_heart_vector = Vector2(desired_heart_position, $Heart.position.y)
	
	print("meter value: ", current_value_target)
	
	$Tween.interpolate_property($Heart, "position", $Heart.position, desired_heart_vector, .6, $Tween.TRANS_SINE, $Tween.EASE_OUT)
	$Tween.interpolate_property(self, "value", value, current_value_target, .6, $Tween.TRANS_SINE, $Tween.EASE_OUT)
	$Tween.start()
	if current_value_target >= 100 or current_value_target <= 0:
		var win_bool = current_value_target >= 100
		EventHub.emit_signal("game_over", win_bool)
		$AnimationPlayer.stop()


func get_adjusted_value(amount, clue_level, consecutive_correct_choices):
	if amount >= 0:
		if consecutive_correct_choices > 0: #if it's 0 that means it was set to -1 by giving wrong food
			var combo_multiplier = min((consecutive_correct_choices - 1) * .25, 1) + 1
			amount *= combo_multiplier
			amount *= clue_level_multipliers[clue_level]
			set_times_bonus_text(consecutive_correct_choices)
			print("applying bonus!")
		amount *= happiness_level_multipliers[Global.mood]
	
	return amount


func set_times_bonus_text(times):
	if times > 1:
		$TimesCorrectBonus.text = str(times) + "X streak bonus!"
		$TimesCorrectBonus/AnimationPlayer.play("bonus")



