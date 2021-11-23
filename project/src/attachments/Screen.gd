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

extends Spatial
func extern_class_name():
	return "Screen"

onready var viewport: Viewport = Viewport.new()
onready var timer: Timer = Timer.new()
onready var effect = ColorRect.new()
onready var viewport_root = Spatial.new()
onready var Camera = Camera.new()

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
	
	viewport.size = Vector2(640, 480)
	viewport.handle_input_locally = false
	viewport.hdr = false
	viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
	viewport.shadow_atlas_quad_0 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_1
	viewport.shadow_atlas_quad_3 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_16
	
	screen.fov = fov
	screen.far = far
	screen.current = true
	screen.transform.origin = Vector3(0, 1.198, -0.912)
	viewport_root.add_child(screen)
	
	var backbuffer = BackBufferCopy.new()
	backbuffer.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
	viewport_root.add_child(backbuffer)
	

	viewport.add_child(viewport_root)
	
	add_child(viewport)

#If the viewport is the child of a ViewportContainer it will become active and display anything it has inside.
func _on_frame() -> void:
	if ! view || ! view.is_valid():
		return
    var img = view.framebuffers(pin).read_rgb888()

	var texture: Texture = viewport.get_texture()
	
	if texture.get_height() * texture.get_width() > 0:
		var img = texture.get_data()
		


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
	
	vflip = buffer.needs_vertical_flip()
	hflip = buffer.needs_horizontal_flip()
	
	if ! DebugCanvas.disabled:
		DebugCanvas.add_draw(screen.global_transform.origin, screen.global_transform.origin + screen.global_transform.basis.xform(Vector3.FORWARD), Color.yellow)


func visualize() -> Control:
	var visualizer = NodeVisualizer.new()
	visualizer.display_node(self, "visualize_content")
	return visualizer


func visualize_content() -> String:
	return "   Resolution: %dx%d\n   FPS: %d\n   V Flip: %s\n   H Flip: %s" % [resolution.x, resolution.y, fps, vflip, hflip]
