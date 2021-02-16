extends Node2D
var rng = RandomNumberGenerator.new()
var chosen_food
var accepted_change := 4.0
var declined_change := -4.0
var clue_time_seconds = 2
var check_int


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
	$Clue1.texture = null
	$Clue2.texture = null
	$Clue3.texture = null
	think_about_food()


func think_about_food():
	check_int = rng.randi()
	var texture = load(chosen_food["sprite_path"])
	
	$Tween.interpolate_callback(self, 0, "populate_clue", check_int, 1, texture)
	$Tween.interpolate_callback(self, 1, "populate_clue", check_int, 2, texture)
	$Tween.interpolate_callback(self, 2, "populate_clue", check_int, 3, texture)
	$Tween.start()

func populate_clue(event_check_int, clue_number, texture):
	if (check_int != event_check_int):
		return
	
	get_node("Clue" + str(clue_number)).texture = texture

func _on_food_clicked(food_name):
	if food_name == chosen_food["name"]:
		EventHub.emit_signal("food_accepted", accepted_change)
		pick_food()
	else:
		EventHub.emit_signal("food_declined", declined_change)
