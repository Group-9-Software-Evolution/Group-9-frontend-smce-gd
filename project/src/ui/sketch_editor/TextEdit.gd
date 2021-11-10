extends Node2D

var sketch_path = [] # Array containing paths to all open files in the editor

	# Tries to open the currently open sketch in the editor
func _ready():
	if(sketch_path):
		_on_OpenFileDialog_file_selected(sketch_path[0])
	sketch_path.append(" ")

	# Closes the editor, does not save upon exit
func _on_Close_pressed():
	Global.editor_node = null
	self.queue_free()

	# Opens dialog popup
func _on_OpenFile_pressed():
	$OpenFileDialog.popup()

	# Sets the text in TextView to the same as in the file chosen in the dialog popup, 
	# also changes the name of the tab to the name of the file opened
func _on_OpenFileDialog_file_selected(path):
	var file = File.new()
	sketch_path[$TabContainer.current_tab] = path
	file.open(path, 1)
	var textField = $TabContainer.get_children()
	textField[$TabContainer.current_tab].set_text(file.get_as_text())
	update_tab_name()

	# Saves the text in TextView to a file chosen in the dialog popup
func _on_SaveFileDialog_file_selected(path):
	var file = File.new()
	sketch_path[$TabContainer.current_tab] = path
	file.open(path, 2)
	var textField = $TabContainer.get_children()
	file.store_string(textField[$TabContainer.current_tab].get_text())
	update_tab_name()
	$SavedNotification.popup()

	# Saves the text in the current tab to whatever path of the current tab is 
	# (needs error handling/handle an empty path)
func _on_SaveFile_pressed():
	var file = File.new()
	file.open(sketch_path[$TabContainer.current_tab], 2)
	var textField = $TabContainer.get_children()
	file.store_string(textField[$TabContainer.current_tab].get_text())
	$SavedNotification.popup()

	# Opens dialog popup
func _on_SaveAs_pressed():
	$SaveFileDialog.popup()

	# Opens dialog popup
func _on_Button_pressed():
	$SavedNotification.hide()

	# Creates a new tab containing a text editor and names it "New Sketch"
func _on_NewSketch_pressed():
	sketch_path.append("")
	var newSketch = $TabContainer.get_child(0).duplicate()
	newSketch.text = " "
	newSketch.name = "New Sketch"
	$TabContainer.add_child(newSketch)

	# Updates the current tab to whatever is currently recognized as the open files name
func update_tab_name():
	$TabContainer.get_child($TabContainer.current_tab).name = get_file_name(sketch_path[$TabContainer.current_tab])

	# Returns filename (removes parent folders and file extensions from a filepath)
func get_file_name(path):
	var file_name = path.get_file()
	file_name = file_name.substr(0, (path.get_file().length() - path.get_extension().length()))
	return(file_name)

	# Hides the editors node
func _on_Minimize_pressed():
	self.hide()
