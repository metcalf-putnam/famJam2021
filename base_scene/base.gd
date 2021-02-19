extends Node2D

enum Difficulty {EASY, NORMAL, HARD, HELLISH}
var selected_difficulty = Difficulty.NORMAL
const win_text = "Success!"
const lose_text = "So close!"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Food.texture = null
	add_difficulties()
	initialize_kitchen()
	EventHub.connect("game_over", self, "_on_game_over")
	EventHub.connect("food_clicked", self, "_on_food_clicked")
	EventHub.connect("food_accepted", self, "_on_food_accepted")
	EventHub.connect("food_declined", self, "_on_food_declined")


func add_difficulties():
	# TODO: make a baby mode? Like, for literal babies like Zoey?
	$Title/Buttons/OptionButton.add_item("easy")
	$Title/Buttons/OptionButton.add_item("normal")
	$Title/Buttons/OptionButton.add_item("hard")
	$Title/Buttons/OptionButton.add_item("hellish")
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


func _on_OptionButton_item_selected(index):
	selected_difficulty = index
	initialize_meter()


func initialize_meter():
	match selected_difficulty:
		Difficulty.EASY:
			$ProgressBar.set_value(80)
		Difficulty.NORMAL:
			$ProgressBar.set_value(55)
		Difficulty.HARD:
			$ProgressBar.set_value(30)
			# TODO: make some clues audio only?
		Difficulty.HELLISH:
			$ProgressBar.set_value(10)
			# TODO: make audio only clues?

func _on_game_over(boolean):
	if boolean:
		$GameOver/Label.text = win_text
		$GameOver/Success.play()
	else: 
		$GameOver/Label.text = lose_text
		$GameOver/Failure.play()
		pass # TODO: failure noises?
	$AnimationPlayer.play("game_over")


func _on_MenuButton_pressed():
	$AnimationPlayer.play("title")
