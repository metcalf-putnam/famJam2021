extends Node2D
var sound : int
var music : int

enum Difficulty {BABY, NORMAL, HARD, PARENT}
var selected_difficulty = Difficulty.NORMAL
const win_text = "Success!"
const lose_text = "So close!"
var beats := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	sound = AudioServer.get_bus_index("sfx")
	music = AudioServer.get_bus_index("Music")
	$Food.texture = null
	add_difficulties()
	initialize_kitchen()
	EventHub.connect("game_over", self, "_on_game_over")
	EventHub.connect("food_clicked", self, "_on_food_clicked")
	EventHub.connect("food_accepted", self, "_on_food_accepted")
	EventHub.connect("food_declined", self, "_on_food_declined")
	EventHub.connect("heart_beat", self, "_on_heart_beat")
	_on_OptionButton_item_selected(selected_difficulty)
	set_process(true)


func _process(_delta):
	if Input.is_action_pressed("ui_cancel") and !$Title.visible:
		$ProgressBar.stop()
		$AnimationPlayer.play("title")


func add_difficulties():
	# TODO: make a baby mode? Like, for literal babies like Zoey?
	$Title/Buttons/OptionButton.add_item("baby")
	$Title/Buttons/OptionButton.add_item("normal")
	$Title/Buttons/OptionButton.add_item("hard")
	$Title/Buttons/OptionButton.add_item("parent")
	$Title/Buttons/OptionButton.select(selected_difficulty)


func initialize_kitchen():
	for food in FoodDic.foods:
		if food["food_holder"] == "fridge":
			$fridge.add_food_type(food["name"], load(food["sprite_path"]))
		elif food["food_holder"] == "pantry":
			$pantry.add_food_type(food["name"], load(food["sprite_path"]))
		else:
			print("error: no food holder assigned for: ", food["name"])


func refresh_objects():
	$Baby.pick_food()
	$fridge.reload()
	$pantry.reload()
	$ProgressBar.start()
	Global.active = true


func _on_food_clicked(food_name):
	$FoodClicked.play()
	for food in FoodDic.foods:
		if food["name"] == food_name:
			populate_food(food)
			return


func populate_food(food):
	if food.has("served_path"):
		$Food.texture = load(food["served_path"])
	else:
		$Food.texture = load(food["sprite_path"])
	$AnimationPlayer.play("idle")


func _on_food_accepted():
	$AnimationPlayer.play("eaten")


func _on_food_declined():
	$AnimationPlayer.play("thrown")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "thrown" or anim_name == "eaten":
		$Food.texture = null


func _on_StartButton_pressed():
	initialize_meter()
	$AnimationPlayer.play("start_game")
	refresh_objects()
	$Food.texture = null
	$Music.title = false
	$Music.update_song()
	beats = 0


func _on_OptionButton_item_selected(index):
	selected_difficulty = index
	initialize_meter()
	var score = Global.get_high_score(selected_difficulty)
	if score:
		$Title/Buttons/HighScore/Value.text = str(score)
		$Title/Buttons/HighScore.visible = true
	else:
		$Title/Buttons/HighScore.visible = false
	show_description(index)


func initialize_meter():
	match selected_difficulty:
		Difficulty.BABY:
			$ProgressBar.set_value(60)
			Global.visuals_on = true
			Global.lose_condition = false
		Difficulty.NORMAL:
			$ProgressBar.set_value(55)
			Global.visuals_on = true
			Global.lose_condition = true
		Difficulty.HARD:
			$ProgressBar.set_value(30)
			Global.visuals_on = true
			Global.lose_condition = true
		Difficulty.PARENT:
			$ProgressBar.set_value(15)
			Global.visuals_on = false
			Global.lose_condition = true


func _on_game_over(boolean):

	if boolean:
		$GameOver/Label.text = win_text
		$GameOver/HBoxContainer/Beats.text = str(beats)
		$GameOver/HBoxContainer/Beats.visible = true
		$GameOver/HBoxContainer/Beats/label2.text = "Difficulty: " + $Title/Buttons/OptionButton.text
		$GameOver/Success.play()
		log_score(beats)
	else: 
		$GameOver/HBoxContainer/Beats.visible = false
		$GameOver/Label.text = lose_text
		$GameOver/Failure.play()
	$AnimationPlayer.play("game_over")


func log_score(heartbeats):
	var score = Global.get_high_score(selected_difficulty)
	if score and score > heartbeats or !score:
		Global.save(selected_difficulty, heartbeats)


func _on_MenuButton_pressed():
	$AnimationPlayer.play("title")
	$Music.play_title()


func _on_SoundButton_toggled(button_pressed):
	AudioServer.set_bus_mute(sound, button_pressed)
	$Title/Buttons/Settings/SoundButton/Noise.play()


func _on_title_end():
	$Music.play_title()
	_on_OptionButton_item_selected($Title/Buttons/OptionButton.selected)


func _on_MusicButton_toggled(button_pressed):
	AudioServer.set_bus_mute(music, button_pressed)
	$Title/Buttons/Settings/MusicButton/Music.play()


func _on_heart_beat():
	beats += 1


func show_description(index):
	var description = $Title/DifficultyDescription
	match index:
		Difficulty.BABY:
			description.text = "For actual, real-life babies. No lose condition!"
		Difficulty.NORMAL:
			description.text = "Recommended for most players. Visual + verbal clues."
		Difficulty.HARD:
			description.text = "Like normal, but with a feistier toddler."
		Difficulty.PARENT:
			description.text = "Only verbal clues (reminder: voice actor is a toddler)"
	description.visible = true
