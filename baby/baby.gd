extends Node2D
var rng = RandomNumberGenerator.new()
var chosen_food
var accepted_change := 4.0
var declined_change := -4.0
var clue_time_seconds = 2

func _ready():
	rng.randomize()
	EventHub.connect("food_clicked", self, "_on_food_clicked")


func pick_food():
	var num = FoodDic.foods.size()
	if num == 0:
		print("error: no foods for baby to pick from")
		return
	
	var rand_num = rng.randi_range(0, num -1)
	chosen_food = FoodDic.foods[rand_num]
	reset_clues()
	think_about_food()

func reset_clues():
	$Clue1.texture = null
	$Clue2.texture = null
	$Clue3.texture = null
	$Tween.remove_all()

func think_about_food():
	var texture = load(chosen_food["sprite_path"])
	
	$Tween.interpolate_callback(self, 0, "populate_clue", 1, texture)
	$Tween.interpolate_callback(self, clue_time_seconds, "populate_clue", 2, texture)
	$Tween.interpolate_callback(self, 2 * clue_time_seconds, "populate_clue", 3, texture)
	$Tween.start()

func populate_clue(clue_number, texture):
	get_node("Clue" + str(clue_number)).texture = texture

func _on_food_clicked(food_name):
	if food_name == chosen_food["name"]:
		EventHub.emit_signal("food_accepted", accepted_change)
		pick_food()
	else:
		EventHub.emit_signal("food_declined", declined_change)
