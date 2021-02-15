extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for food in FoodDic.foods:
		if food["food_holder"] == "fridge":
			$fridge.add_food_type(food["name"], load(food["sprite_path"]))
		elif food["food_holder"] == "pantry":
			$pantry.add_food_type(food["name"], load(food["sprite_path"]))
		else:
			print("error: no food holder assigned for: ", food["name"])
	refresh()


func refresh():
	$Baby.pick_food()
	$fridge.reload()
	$pantry.reload()
