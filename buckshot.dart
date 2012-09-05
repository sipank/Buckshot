// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/// ## Try Buckshot Online ##
/// <http://www.buckshotui.org/sandbox>

#library('core.buckshotui.org');

#import('dart:html');
#import('dart:json');
#import('dart:isolate');
#import('dart:math');

#import('package:dart-xml/xml.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('package:dart_utils/web.dart');
#import('package:dart_utils/shared.dart');
#import('lib/external/yaml/yaml.dart');

#source('lib/core/globals.dart');
#source('lib/core/buckshot_system.dart');
#source('lib/core/framework_object.dart');
#source('lib/core/framework_property.dart');
#source('lib/core/observable_list.dart');
#source('lib/core/framework_element.dart');
#source('lib/core/buckshot_object.dart');
#source('lib/core/framework_property_base.dart');
#source('lib/core/attached_framework_property.dart');
#source('lib/core/data_template.dart');
#source('lib/core/i_framework_container.dart');

#source('lib/core/polly/polly.dart');
#source('lib/core/polly/flex_model.dart');
#source('lib/core/polly/_brutus.dart');

#source('lib/events/buckshot_event.dart');
#source('lib/events/measurement_changed_event_args.dart');
#source('lib/events/drag_event_args.dart');

#source('lib/mvvm/view_model_base.dart');
#source('lib/mvvm/view.dart');

#source('lib/binding/binding.dart');
#source('lib/binding/binding_mode.dart');
#source('lib/binding/binding_data.dart');

#source('lib/elements/panel.dart');
#source('lib/elements/stack_panel.dart');
#source('lib/elements/text_block.dart');
#source('lib/elements/border.dart');
#source('lib/elements/layout_canvas.dart');
#source('lib/elements/image.dart');
#source('lib/elements/raw_html.dart');
#source('lib/elements/grid/grid.dart');
#source('lib/elements/grid/row_definition.dart');
#source('lib/elements/grid/column_definition.dart');
#source('lib/elements/grid/_grid_cell.dart');
#source('lib/elements/grid/grid_layout_definition.dart');
#source('lib/elements/grid/grid_length.dart');
#source('lib/elements/collection_presenter.dart');
#source('lib/elements/content_presenter.dart');
//#source('elements/DockPanel.dart');

#source('lib/elements/actions/action_base.dart');
#source('lib/elements/actions/animation.dart');
#source('lib/elements/actions/set_property.dart');
#source('lib/elements/actions/toggle_property.dart');

#source('lib/controls/text_box.dart');
#source('lib/controls/control/control.dart');
#source('lib/controls/control/control_template.dart');
#source('lib/controls/radio_button.dart');
#source('lib/controls/radio_button_group.dart');
#source('lib/controls/ button.dart');
#source('lib/controls/check_box.dart');
#source('lib/controls/text_area.dart');
#source('lib/controls/slider.dart');
#source('lib/controls/hyperlink.dart');
#source('lib/controls/drop_down_list.dart');
//#source('controls/ListBox.dart');
//#source('controls/TreeView/TreeView.dart');
//#source('controls/TreeView/TreeNode.dart');

#source('lib/converters/string_to_numeric.dart');
#source('lib/converters/string_to_thickness.dart');
#source('lib/converters/string_to_boolean.dart');
#source('lib/converters/string_to_grid_length.dart');
#source('lib/converters/string_to_grid_unit_type.dart');
#source('lib/converters/string_to_horizontal_alignment.dart');
#source('lib/converters/string_to_orientation.dart');
#source('lib/converters/string_to_vertical_alignment.dart');
#source('lib/converters/string_to_color.dart');
#source('lib/converters/string_to_solid_color_brush.dart');
#source('lib/converters/string_to_radial_gradient_brush.dart');
#source('lib/converters/string_to_framework_element.dart');
#source('lib/converters/string_to_visibility.dart');
#source('lib/converters/string_to_input_types.dart');
#source('lib/converters/string_to_location.dart');

#source('lib/resources/framework_resource.dart');
#source('lib/resources/resource_collection.dart');
#source('lib/resources/var_resource.dart');
#source('lib/resources/color.dart');
#source('lib/resources/brush.dart');
#source('lib/resources/solid_color_brush.dart');
#source('lib/resources/linear_gradient_brush.dart');
#source('lib/resources/radial_gradient_brush.dart');
#source('lib/resources/style_setter.dart');
#source('lib/resources/style_template.dart');
#source('lib/resources/gradient_stop.dart');

#source('lib/animation/framework_animation.dart');
#source('lib/animation/animation_resource.dart');
#source('lib/animation/animation_key_frame.dart');
#source('lib/animation/animation_state.dart');
#source('lib/animation/_css_compiler.dart');

#source('lib/elements/shape/shape.dart');
#source('lib/elements/shape/ellipse.dart');
#source('lib/elements/shape/rectangle.dart');
#source('lib/elements/shape/line.dart');
#source('lib/elements/shape/polyline.dart');
#source('lib/elements/shape/polygon.dart');

#source('lib/templates/i_presentation_format_provider.dart');
#source('lib/templates/xml_template_provider.dart');
#source('lib/templates/json_template_provider.dart');
#source('lib/templates/yaml_template_provider.dart');
#source('lib/templates/template.dart');

//Use this to generate clean dart docs of just the buckshot library
//main(){}
