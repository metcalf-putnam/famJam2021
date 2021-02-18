extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Food.texture = null
	initialize_kitchen()
	refresh_objects()
	EventHub.connect("food_clicked", self, "_on_food_clicked")
	EventHub.connect("food_accepted", self, "_on_food_accepted")
	EventHub.connect("food_declined", self, "_on_food_declined")


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
