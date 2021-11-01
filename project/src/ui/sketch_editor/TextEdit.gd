extends Node2D

var sketch_path = []

func _ready():
	if(sketch_path):
		_on_OpenFileDialog_file_selected(sketch_path[0])
		sketch_path.append(" ")


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
	sketch_path[$TabContainer.current_tab] = path
	file.open(path, 1)
	var textField = $TabContainer.get_children()
	textField[$TabContainer.current_tab].set_text(file.get_as_text())
	textField[$TabContainer.current_tab].name = sketch_path[$TabContainer.current_tab].get_file()

func _on_SaveFileDialog_file_selected(path):
	var file = File.new()
	sketch_path[$TabContainer.current_tab] = path
	file.open(path, 2)
	file.store_string($TextEdit.text)
	$TabContainer.get_child($TabContainer.current_tab).name = sketch_path[$TabContainer.current_tab].get_file()
	$SavedNotification.popup()

func _on_SaveFile_pressed():
	var file = File.new()
	file.open(sketch_path, 2)
	file.store_string($TextEdit.text)
	$SavedNotification.popup()

func _on_SaveAs_pressed():
	$SaveFileDialog.popup()

func _on_Button_pressed():
	$SavedNotification.hide()

func _on_NewSketch_pressed():
	sketch_path.append("")
	var newSketch = $TabContainer.get_child(0).duplicate()
	newSketch.text = " "
	newSketch.name = "New Sketch"
	$TabContainer.add_child(newSketch)
