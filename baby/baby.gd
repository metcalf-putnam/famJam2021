extends Node2D
var rng = RandomNumberGenerator.new()
var chosen_food
var accepted_change := 4.0
var declined_change := -2.0
var tantrum_change := -5
enum State {EATING, IDLE, HUNGRY, TANTRUM}
var state = State.IDLE
var clue_current := 1
var bubble_current := 1


func _ready():
	rng.randomize()
	EventHub.connect("food_clicked", self, "_on_food_clicked")
	EventHub.connect("heart_beat", self, "_on_heart_beat")


func pick_food():
	state = State.HUNGRY
	var num = FoodDic.foods.size()
	if num == 0:
		print("error: no foods for baby to pick from")
		return
	
	var rand_num = rng.randi_range(0, num -1)
	chosen_food = FoodDic.foods[rand_num]
	reset_clues()
	think_about_food()


func reset_clues():
	$Thought1.reset()
	$Thought2.reset()
	$Thought3.reset()
	clue_current = 1
	bubble_current = 1


func think_about_food():
	var texture = load(chosen_food["sprite_path"])
 
	# TODO: make this a bit random which clue goes in which slot
	# and, like, if you have fridge + sippy, that's a bit annoying, since all 
	# things that go into sippy cup are in the fridge
	if chosen_food.has("dish") and FoodDic.dishes.has(chosen_food["dish"]):
		populate_clue(1, load(FoodDic.dishes[chosen_food["dish"]]))
	if chosen_food.has("food_holder") and FoodDic.food_holders.has(chosen_food["food_holder"]):
		populate_clue(1, load(FoodDic.food_holders[chosen_food["food_holder"]]))
	if chosen_food.has("color") and FoodDic.colors.has(chosen_food["color"]):
		populate_clue(2, chosen_food["color"])
		
	populate_clue(3, texture)


func populate_clue(clue_number, texture):
	get_node("Thought" + str(clue_number)).set_clue(texture)


func _on_food_clicked(food_name):
	# TODO: food will be presented to baby then baby will respond
	if food_name == chosen_food["name"]:
		EventHub.emit_signal("food_accepted") # may not keep these accepted/declined signals
		EventHub.emit_signal("patience_changed", accepted_change)
		pick_food()
	else:
		EventHub.emit_signal("food_declined") 
		EventHub.emit_signal("patience_changed", declined_change)


func get_angry():
	state = State.TANTRUM
	EventHub.emit_signal("tantrum")
	EventHub.emit_signal("patience_changed", tantrum_change)
	reset_clues()
	# TODO: add animation before 
	pick_food()
	


func _on_heart_beat():
	if state != State.HUNGRY:
		return

	if bubble_current >= 4:
		bubble_current = 1
		clue_current += 1


	if clue_current == 4:
			get_angry()
			return
	
	get_node("Thought" + str(clue_current)).show_bubble(bubble_current)
	
	bubble_current += 1
	
	
	
