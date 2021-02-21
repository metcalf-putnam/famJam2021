extends Node2D
export (Resource) var image
export (PackedScene) var food_object

const reload_text = "reload"

var food = []
var reload_time := 1.5
var i = 0
var rng = RandomNumberGenerator.new()
var prob_food = 1 # probability that any food location will populate food
const minimum_food_items = 2
var food_count := 0


func _ready():
	EventHub.connect("food_clicked", self, "_on_food_clicked")
	$ProgressBar.visible = false
	rng.randomize()
	if image:
		$sprite.texture = load(image.resource_path)
	else:
		print("error: no image assigned for this food holder")


func add_food_type(name, preloaded_image):
	food.append({"name": name, "image": preloaded_image})


func _on_Button_pressed():
	reload()
	$Restock.play()
	
	if Global.lose_condition:
		$Button.disabled = true
		$ProgressBar.value = 0
		$ProgressBar.visible = true
		$Timer.start(reload_time)
		$Tween.interpolate_property($ProgressBar, "value", 0, 100, reload_time)
		$Tween.start()


func reload():
	if food.size() == 0:
		return
	
	$AnimationPlayer.play("idle")
	food_count = 0
	for n in range($food_locations.get_child_count()):
		clear_slot($food_locations.get_child(n))
		var num = rng.randf()
		if num < prob_food:
			populate_slot($food_locations.get_child(n))
			food_count += 1
	
	if (food_count < minimum_food_items):
		reload()


func clear_slot(location : Position2D):
	for child in location.get_children():
		child.queue_free()


func populate_slot(location : Position2D):
	var new_food = food_object.instance()
	var food_num = rng.randi_range(0, food.size() - 1)
	new_food.init_food(food[food_num]["name"], food[food_num]["image"])
	location.add_child(new_food)


func _on_Timer_timeout():
	$Button.disabled = false
	$ProgressBar.visible = false


func _on_food_clicked(name):
	for item in food:
		if item["name"] == name:
			food_count -= 1
			continue
	if food_count == 0:
		$AnimationPlayer.play("blinking")
