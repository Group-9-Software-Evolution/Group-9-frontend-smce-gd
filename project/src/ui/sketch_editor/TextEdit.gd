extends Node2D

var sketch_path = [] # Array containing paths to all open files in the editor

	# Tries to open the currently open sketch in the editor
func _ready():
	set_syntax()
	if(sketch_path):
		_on_OpenFileDialog_file_selected(sketch_path[0])
	sketch_path.append(" ")
	
	
func set_syntax(): # much code here is from group 10
	#Arduino syntax highlighting
	$TabContainer/TextEdit.add_color_region('//','',Color(0.638306, 0.65625, 0.65625)) # comments
	$TabContainer/TextEdit.add_color_region('/*','*/',Color(0.834412, 0.847656, 0.847656)) # info boxes
	$TabContainer/TextEdit.add_color_region('"','"',Color(0.085144, 0.605469, 0.56721)) # Strings

	#variables
	var varTypes = ['PROGMEM','sizeof','HIGH','LOW','OUTPUT','uint8_t','private','public','class','static','const','float','int','String','uint16_t','boolean','bool','void','byte','unsigned','long','char','uint32_t','word','struct']
	for v in varTypes:
		$TabContainer/TextEdit.add_keyword_color(v,Color(0.228943, 0.945313, 0.844573))
	
	#operators/keywords	
	var operators = ['ifndef','endif','define','ifdef','include','setup','loop','if','for','while','switch','else','case','break','and','or','final','return']
	for o in operators:
		$TabContainer/TextEdit.add_keyword_color(o,Color(0.605167, 0.875, 0.071777))
	
	#stream, serial, other operations
	var other = ['interrupts','noInterrupts','CAN','setCursor','display','bit','read','peek','onReceive','onRequest','flush', 'requestFrom','endTransmission','beginTransmission','setClock', 'status','write','size_t','Stream','Serial','begin','end','stop','print','printf','println','delay','attach','readMsgBuf','sendMsgBuf']
	for t in other:
		$TabContainer/TextEdit.add_keyword_color(t,Color(0.976563, 0.599444, 0.324249))

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
