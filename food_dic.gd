extends Node


var foods = [
	{
	"name" : "banana",
	"sprite_path" : "res://food/banana.png",
	"food_holder" : "pantry",
	"liquid" : false,
	"dish" : "plate",
	"color" : "yellow"
	},
	
	{
	"name" : "blueberries",
	"sprite_path" : "res://food/blueberries.png",
	"served_path" : "res://food/served_images/blueberriesinbowl.png",
	"food_holder" : "fridge",
	"liquid" : false,
	"dish" : "bowl",
	"color" : "blue"
	},

	{
	"name" : "water",
	"sprite_path" : "res://food/water.png",
	"served_path" : "res://food/served_images/watersippy.png",
	"food_holder" : "fridge",
	"liquid" : true,
	"dish" : "sippy",
	"color" : "blue"
	},

	{
	"name" : "oatmeal",
	"sprite_path" : "res://food/oats.png",
	"food_holder" : "pantry",
	"liquid" : false,
	"dish" : "bowl",
	"color" : "brown"
	},
	
	{
	"name" : "juice",
	"sprite_path" : "res://food/juice.png",
	"served_path" : "res://food/served_images/juicesippy.png",
	"food_holder" : "fridge",
	"liquid" : true,
	"dish" : "sippy",
	"color" : "orange"
	},
	
	{
	"name" : "milk",
	"sprite_path" : "res://food/milk.png",
	"served_path" : "res://food/served_images/milksippy.png",
	"food_holder" : "fridge",
	"liquid" : true,
	"dish" : "sippy",
	"color" : "white"
	},
	
	{
	"name" : "yogurt",
	"sprite_path" : "res://food/yogurt.png",
	"served_path" : "res://food/served_images/yogurtinbowl.png",
	"food_holder" : "fridge",
	"liquid" : false,
	"dish" : "bowl",
	"color" : "blue"
	},
]


var dishes = {
	"bowl" : "res://dishes/bowl.png",
	"sippy" : "res://dishes/sippycup.png",
	"plate" : "res://dishes/bowlback.png"
}


var colors = {
	"base_sprite_path" : "res://thought_bubble/color_splash.png",
	"brown" : Color(0.54, 0.46, 0.29),
	"pink" : Color(0.83, 0.49, 0.78),
	"orange" : Color(0.95, 0.63, 0.12),
	"blue" : Color(0.16, 0.49, 0.91),
	"yellow" : Color(0.93, 0.92, 0.08),
	"white" : Color(1,1,1)
}

var food_holders = {
	"pantry" : "res://food/mini_pantry.png",
	"fridge" : "res://food/mini_fridge.png"
}
