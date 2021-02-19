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
	var texture = load(chosen_food["sprite_path"])
 
	# TODO: make this a bit random which clue goes in which slot
	# and, like, if you have fridge + sippy, that's a bit annoying, since all 
	# things that go into sippy cup are in the fridge
	var chosen_dish = chosen_food["dish"]
	if FoodDic.dishes.has(chosen_dish):
		populate_clue(1, load(FoodDic.dishes[chosen_dish]), get_audio(chosen_dish))
	
	var food_holder = chosen_food["food_holder"]
	if FoodDic.food_holders.has(food_holder):
		populate_clue(1, load(FoodDic.food_holders[food_holder]), get_audio(food_holder))
		
	var chosen_color = chosen_food["color"]
	if FoodDic.colors.has(chosen_color):
		populate_clue(2, chosen_color, get_audio(chosen_color))
		
	populate_clue(3, texture, get_audio(chosen_food["name"]))

func get_audio(word):
	var audio 
	
	if FoodDic.audio_clips.has(word):
		audio = load(FoodDic.audio_clips[word])
	
	if audio:
		return audio
	else:
		return default_clue_audio

func populate_clue(clue_number, texture, sound):
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
	if food_accepted:
		EventHub.emit_signal("food_accepted") # may not keep these accepted/declined signals
		EventHub.emit_signal("patience_changed", accepted_change)
		eat_food()
	else:
		EventHub.emit_signal("food_declined") 
		EventHub.emit_signal("patience_changed", declined_change)
		state = State.THROW
		animationState.travel("throw_food")
	update_head()


func get_angry():
	state = State.TANTRUM
	Global.active = false
	update_head()
	EventHub.emit_signal("tantrum")
	EventHub.emit_signal("patience_changed", tantrum_change)
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
