extends Node

var active = true
enum Mood {UPSET, SAD, ANGRY, HAPPY}
var mood = Mood.HAPPY
var savegame = File.new() 
var save_path = "user://savegame.save" 
var example_score
var save_data = {"difficulty": example_score} 


func _ready() -> void:
	if not savegame.file_exists(save_path):
		create_save()


func create_save() -> void:
   savegame.open(save_path, File.WRITE)
   savegame.store_var(save_data)
   savegame.close()


func save(difficulty : int, high_score : int) -> void:    
   save_data[difficulty] = high_score 
   savegame.open(save_path, File.WRITE) 
   savegame.store_var(save_data) 
   savegame.close() 


func get_high_score(difficulty : int) -> int:
   savegame.open(save_path, File.READ) 
   save_data = savegame.get_var() 
   savegame.close()
   return save_data.get(difficulty)
