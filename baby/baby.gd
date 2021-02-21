extends Node2D
var rng = RandomNumberGenerator.new()
var chosen_food
var accepted_change := 4.0
var declined_change := -2.0
var tantrum_change := -5
enum State {EATING, IDLE, HUNGRY, TANTRUM, THINKING, THROW}
var state = State.IDLE
var clue_current := 1
var bubble_current := 1
var animationState : AnimationNodeStateMachinePlayback
var food_accepted
var game_over = false

var angry_head = preload("res://baby/baby_parts/angryhead.png")
var frowning_head = preload("res://baby/baby_parts/frowninghead.png")
var happy_face = preload("res://baby/baby_parts/happyface.png")
var sad_head = preload("res://baby/baby_parts/sadhead.png")
var tantrum_head = preload("res://baby/baby_parts/tantrumhead.png")

var default_clue_audio = preload("res://baby/vocals/Want whimper.wav")


func _ready():
	update_head()
	EventHub.connect("game_over", self, "_on_game_over")
	EventHub.connect("playback_speed_updated", self, "_on_playback_speed_updated")
	animationState = $AnimationTree["parameters/playback"]
	rng.randomize()
	EventHub.connect("food_clicked", self, "_on_food_clicked")
	EventHub.connect("heart_beat", self, "_on_heart_beat")
	$AnimationTree.active = true


func pick_food():
	game_over = false
	animationState.travel("idle")
	state = State.HUNGRY
	update_head()
	var num = FoodDic.foods.size()
	if num == 0:
		print("error: no foods for baby to pick from")
		return
	
	var rand_num = rng.randi_range(0, num -1)
	chosen_food = FoodDic.foods[rand_num]
	reset_clues()
	think_about_food()


func update_head():
	var head_tex
	if state == State.TANTRUM:
		head_tex = angry_head
	elif state == State.THROW:
		head_tex = tantrum_head
	elif state == State.THINKING:
		head_tex = frowning_head
	elif state == State.EATING:
		head_tex = happy_face
	else:
		match Global.mood:
			Global.Mood.HAPPY:
				head_tex = happy_face
			Global.Mood.ANGRY:
				head_tex = angry_head
			Global.Mood.UPSET:
				head_tex = sad_head
			Global.Mood.SAD:
				head_tex = frowning_head

	$skeleton/body/head.texture = head_tex


func reset_clues():
	$Thought1.reset()
	$Thought2.reset()
	$Thought3.reset()
	clue_current = 1
	bubble_current = 1


func think_about_food(): 
	# TODO: make this a bit random which clue goes in which slot
	# and, like, if you have fridge + sippy, that's a bit annoying, since all 
	# things that go into sippy cup are in the fridge
	print(chosen_food)
	var clues = [chosen_food["dish"], chosen_food["food_holder"], chosen_food["color"]]
	
	clues = remove_duplicate_clues(clues)
	
	var array_loc = rng.randi_range(0, len(clues) - 1)
	
	var clue_name = clues[array_loc]
	populate_clue(1, clue_name)
	clues.erase(clue_name)
	
	array_loc = rng.randi_range(0, len(clues) - 1)
	
	clue_name = clues[array_loc]
	populate_clue(2, clue_name)
	
	var texture = load(chosen_food["sprite_path"])
	$Thought3.set_clue(texture, get_audio(chosen_food["name"]))

func remove_duplicate_clues(clues):
	if clues.has("sippy") and clues.has("fridge"):
		if rng.randi() % 2 == 0:
			clues.erase("sippy")
		else:
			clues.erase("fridge")
		
	return clues
	
	
func get_audio(word):
	var audio 
	
	if FoodDic.audio_clips.has(word):
		audio = load(FoodDic.audio_clips[word])
	
	if audio:
		return audio
	else:
		return default_clue_audio

func get_clue_texture_to_load(clue_name):
	
	if FoodDic.dishes.has(clue_name):
		return FoodDic.dishes.get(clue_name)
		
	if FoodDic.food_holders.has(clue_name):
		return FoodDic.food_holders.get(clue_name)
		
	if FoodDic.colors.has(clue_name):
		return FoodDic.colors.get(clue_name)
		
	assert (false, "Clue not found in any dictionary")

func populate_clue(clue_number, clue_name):
	var texture_to_load = get_clue_texture_to_load(clue_name)
	var sound = get_audio(clue_name)	
	var texture = load(texture_to_load)
	get_node("Thought" + str(clue_number)).set_clue(texture, sound)


func _on_food_clicked(food_name):
	# TODO: food will be presented to baby then baby will respond
	state = State.THINKING
	animationState.travel("thinking")
	update_head()
	Global.active = false
	if food_name == chosen_food["name"]:
		food_accepted = true
	else:
		food_accepted = false


func eat_food():
	state = State.EATING
	update_head()
	reset_clues()
	animationState.travel("eating")


func _on_done_thinking():
	var corrected_clue_num = clue_current - 1 + (1 if bubble_current >= 4 else 0)
	
	print("Guessed with number of clues: " + str(corrected_clue_num))
	
	if food_accepted:
		EventHub.emit_signal("food_accepted") # may not keep these accepted/declined signals
		EventHub.emit_signal("patience_changed", accepted_change, corrected_clue_num)
		eat_food()
	else:
		EventHub.emit_signal("food_declined") 
		EventHub.emit_signal("patience_changed", declined_change, corrected_clue_num)
		state = State.THROW
		animationState.travel("throw_food")
	update_head()


func get_angry():
	state = State.TANTRUM
	Global.active = false
	update_head()
	EventHub.emit_signal("tantrum")
	EventHub.emit_signal("patience_changed", tantrum_change, clue_current)
	reset_clues()
	animationState.travel("tantrum")


func _on_heart_beat():
	if state != State.HUNGRY:
		return
	if bubble_current >= 4:
		bubble_current = 1
		clue_current += 1

	if clue_current == 6:
			get_angry()
			return

	if clue_current >= 4:
		clue_current += 1
		return
	
	get_node("Thought" + str(clue_current)).show_bubble(bubble_current)
	
	bubble_current += 1
	


func _on_tantrum_end():
	if game_over:
		return
	Global.active = true
	pick_food()


func _on_done_eating():
	if game_over:
		return
	Global.active = true
	pick_food()


func _on_done_throwing_food():
	if game_over:
		return
	Global.active = true
	state = State.HUNGRY
	update_head()
	animationState.travel("idle")


func _on_playback_speed_updated(_value):
	if state == State.TANTRUM:
		return
	update_head()


func _on_game_over(_bool):
	game_over = true
