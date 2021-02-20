extends Node


var foods = [
	{
	"name" : "banana",
	"sprite_path" : "res://food/banana.png",
	"served_path" : "res://food/served_images/bananasonplate.png",
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
	"served_path" : "res://food/served_images/oarmealinbowl.png",
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
	{
	"name" : "carrot",
	"sprite_path" : "res://food/carrot.png",
	"served_path" : "res://food/served_images/carrotsonplate.png",
	"food_holder" : "fridge",
	"liquid" : false,
	"dish" : "plate",
	"color" : "orange"
	},
	{
	"name" : "muffin",
	"sprite_path" : "res://food/blueberrymuffin packaged.png",
	"served_path" : "res://food/served_images/muffinonplate.png",
	"food_holder" : "pantry",
	"liquid" : false,
	"dish" : "plate",
	"color" : "brown"
	},
	{
	"name" : "cookie",
	"sprite_path" : "res://food/packagedcookie.png",
	"served_path" : "res://food/served_images/cookieonplate.png",
	"food_holder" : "pantry",
	"liquid" : false,
	"dish" : "plate",
	"color" : "brown"
	},

]


var dishes = {
	"bowl" : "res://dishes/bowl.png",
	"sippy" : "res://dishes/sippycup.png",
	"plate" : "res://dishes/bowlback.png"
}


var colors = {
	"brown" : "res://colors/brownclue.png",
	"red" : "res://colors/redclue.png",
	"orange" : "res://colors/orangeclue.png",
	"blue" : "res://colors/blueclue.png",
	"yellow" : "res://colors/yellowclue.png",
	"white" : "res://colors/whiteclue.png"
}

var food_holders = {
	"pantry" : "res://food/mini_pantry.png",
	"fridge" : "res://food/mini_fridge.png"
}

var audio_clips = {
	"milk" : "res://baby/vocals/Milk.wav",
	"fridge" : "res://baby/vocals/Cold.wav",
	"banana" : "res://baby/vocals/Banana.wav",
	"pink" : "res://baby/vocals/Pink.wav",
	"orange" : "res://baby/vocals/Orange.wav",
	"white" : "res://baby/vocals/White.wav",
	"yellow" : "res://baby/vocals/yell(ow).wav",
	"blueberries" : "res://baby/vocals/berries_2.wav",
	"muffin" : "res://baby/vocals/muffin_2.wav",
	"water" : "res://baby/vocals/water.wav",
	"yogurt" : "res://baby/vocals/yogurt.wav",
	"carrot" : "res://baby/vocals/carrot.wav",
	"red" : "res://baby/vocals/Red.wav",
	"juice" : "res://baby/vocals/juice.wav",
	"blue" : "res://baby/vocals/blue_maybe.wav",
	"fruit snack" : "res://baby/vocals/treat_3.wav"
}
