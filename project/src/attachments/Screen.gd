#
#  Screen.gd
#  Copyright 2021 ItJustWorksTM
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
class_name Screen
extends Spatial
func extern_class_name():
	return "Screen"

onready var viewport: Viewport = Viewport.new()
onready var timer: Timer = Timer.new()
onready var effect = ColorRect.new()
onready var viewport_root = Spatial.new()
onready var image = Image.new()
onready var image_texture = ImageTexture.new()
onready var screen_texture_rect = TextureRect.new()

export var pin = 0
export(float, 0, 1) var distort = 0.75
export(float) var fov = 90
export(float) var far = 300

var view = null

var resolution = Vector2.ZERO
var fps = 0

func set_view(_view: Node) -> void:
	if ! _view:
		return
	view = _view


func _ready():
	timer.connect("timeout", self, "_on_frame")
	
	timer.autostart = true
	add_child(timer)
	viewport.add_child(viewport_root)
	add_child(viewport)
	add_child(screen_texture_rect)

#If the viewport is the child of a ViewportContainer it will become active and display anything it has inside.
func _on_frame() -> void:
	if ! view || ! view.is_valid():
		return
	var image_from_buffer = view.framebuffers(pin).read_rgb888()
	image.create_from_data(600,400, false, Image.FORMAT_RGB8, image_from_buffer)
	image_texture.create_from_image(image)
	screen_texture_rect.texture = image_texture
	print("hej")

func _physics_process(delta):
	viewport.get_screen().global_transform.origin = global_transform.origin
	viewport.get_screen().global_transform.basis = global_transform.basis
	effect.get_material().set_shader_param("factor", distort)
	
	if ! view || ! view.is_valid():
		return
	var buffer = view.framebuffers(pin)
	var new_res = Vector2(buffer.get_width(), buffer.get_height())
	var new_freq = buffer.get_freq()
	if new_res != resolution:
		viewport.size = new_res
		effect.get_material().set_shader_param("resolution", viewport.size)
		effect.rect_size = new_res
		resolution = new_res
		
	if new_freq != fps && new_freq != 0:
		timer.wait_time = 1.0/new_freq
		fps = new_freq

#func visualize_content() -> String:
#	return "   Resolution: %dx%d\n   FPS: %d\n   V Flip: %s\n   H Flip: %s" % [resolution.x, resolution.y, fps, hflip]


func visualize() -> Control:
	var visualizer = NodeVisualizer.new()
	visualizer.display_node(self, "visualize_content")
	return visualizer


