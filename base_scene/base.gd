extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_kitchen()
	refresh_objects()
	EventHub.connect("food_clicked", self, "_on_food_clicked")


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


func _on_food_clicked(_food_name):
	$FoodClicked.play()
