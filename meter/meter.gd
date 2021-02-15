extends ProgressBar


func _ready():
	EventHub.connect("food_accepted", self, "_on_food_accepted")
	EventHub.connect("food_declined", self, "_on_food_declined")


func _on_food_accepted(amount):
	# TODO: add animation effect and sound here
	change_value(amount)


func _on_food_declined(amount):
	# TODO: add animation effect and sound here
	change_value(amount)


func change_value(amount : float):
	value += amount
