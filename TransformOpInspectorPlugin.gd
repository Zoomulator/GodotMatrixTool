# MyInspectorPlugin.gd
extends EditorInspectorPlugin

var TransformOpEditor = preload("TransformOpEditor.gd")


func can_handle(object):
	# We support all objects in this example.
	return true


func parse_property(object, type, path, hint, hint_text, usage):
	# We handle properties of type integer.
	if type == TYPE_TRANSFORM:
		# Create an instance of the custom property editor and register
		# it to a specific property path.
		add_property_editor(path, TransformOpEditor.new())
		# Inform the editor to remove the default property editor for
		# this property type.
		return false
	else:
		return false
