extends Node2D

var sketch_path = ""

func _ready():
	if(sketch_path):
		_on_OpenFileDialog_file_selected(sketch_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

	# Closes the editor, does not save upon exit
func _on_Close_pressed():
	#get_tree().change_scene("res://src/ui/master_control/Master.tscn")
	self.queue_free()

func _on_OpenFile_pressed():
	$OpenFileDialog.popup()

func _on_OpenFileDialog_file_selected(path):
	var file = File.new()
	file.open(path, 1)
	$TextEdit.text = file.get_as_text()

func _on_SaveFileDialog_file_selected(path):
	var file = File.new()
	file.open(path, 2)
	file.store_string($TextEdit.text)

func _on_SaveFile_pressed():
	$SaveFileDialog.popup()
