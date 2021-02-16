extends Node2D
export (Resource) var image
export (PackedScene) var food_object
var food = []
var i = 0
var rng = RandomNumberGenerator.new()
var prob_food = 0.5
const minimum_food_items = 2


func _ready():
	rng.randomize()
	if image:
		$sprite.texture = load(image.resource_path)
	else:
		print("error: no image assigned for this food holder")


func add_food_type(name, preloaded_image):
	food.append({"name": name, "image": preloaded_image})


func _on_Button_pressed():
	reload()


func reload():
	if food.size() == 0:
		return
	
	var food_items = 0
	for n in range($food_locations.get_child_count()):
		clear_slot($food_locations.get_child(n))
		var num = rng.randf()
		if num > prob_food:
			populate_slot($food_locations.get_child(n))
			food_items += 1
	
	if (food_items < minimum_food_items):
		reload()


func clear_slot(location : Position2D):
	for child in location.get_children():
		child.queue_free()


func populate_slot(location : Position2D):
	var new_food = food_object.instance()
	var food_num = rng.randi_range(0, food.size() - 1)
	new_food.init_food(food[food_num]["name"], food[food_num]["image"])
	location.add_child(new_food)
#
#	$test_food.texture = food[i]["image"]
#	i += 1
#	if i >= food.size():
#		i = 0
