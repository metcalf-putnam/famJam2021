extends Node2D
var color_base
var normal_modulate = Color(1, 1, 1)


func _ready():
	$Bub3.rotation = $Bub3.rotation - rotation
	color_base = load(FoodDic.colors["base_sprite_path"])
	EventHub.connect("playback_speed_updated", self, "_on_playback_speed_updated")
	

func reset():
	$AnimationPlayer.play("reset")
	$Bub3/Clue.texture = null
	$Bub3/Clue.modulate = normal_modulate


func set_clue(texture, sound):
	if texture in FoodDic.colors:
		set_color_clue(texture)
	else:
		$Bub3/Clue.texture = texture
	$AudioStreamPlayer.stream = sound


func set_color_clue(color):
	$Bub3/Clue.texture = color_base
	$Bub3/Clue.modulate = FoodDic.colors[color]


func show_bubble(num):
	if num < 1 or num > 3:
		print("error: bubble does not have a bubble number ", num)
		return
	$AnimationPlayer.play("bub" + str(num))
	if num == 3:
		$AudioStreamPlayer.play()


func _on_playback_speed_updated(new_speed):
	$AnimationPlayer.playback_speed = new_speed
