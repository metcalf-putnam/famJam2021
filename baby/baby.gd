extends Node2D
var rng = RandomNumberGenerator.new()
var chosen_food
var accepted_change := 4.0
var declined_change := -4.0


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
	think_about_food()


func think_about_food():
	$Thought.texture = load(chosen_food["sprite_path"])
	

func _on_food_clicked(food_name):
	if food_name == chosen_food["name"]:
		EventHub.emit_signal("food_accepted", accepted_change)
		pick_food()
	else:
		EventHub.emit_signal("food_declined", declined_change)
