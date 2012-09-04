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
#source('lib/core/BuckshotSystem.dart');
#source('lib/core/FrameworkObject.dart');
#source('lib/core/FrameworkProperty.dart');
#source('lib/core/ObservableList.dart');
#source('lib/core/FrameworkElement.dart');
#source('lib/core/Dom.dart');
#source('lib/core/BuckshotObject.dart');
#source('lib/core/FrameworkPropertyBase.dart');
#source('lib/core/AttachedFrameworkProperty.dart');
#source('lib/core/DataTemplate.dart');
#source('lib/core/IFrameworkContainer.dart');

#source('lib/core/polly/Polly.dart');
#source('lib/core/polly/FlexModel.dart');
#source('lib/core/polly/_Brutus.dart');

#source('lib/events/BuckshotEvent.dart');
#source('lib/events/MeasurementChangedEventArgs.dart');
#source('lib/events/DragEventArgs.dart');

#source('lib/MVVM/ViewModelBase.dart');
#source('lib/MVVM/IView.dart');

#source('lib/binding/Binding.dart');
#source('lib/binding/BindingMode.dart');
#source('lib/binding/BindingData.dart');

#source('lib/elements/Panel.dart');
#source('lib/elements/StackPanel.dart');
#source('lib/elements/TextBlock.dart');
#source('lib/elements/Border.dart');
#source('lib/elements/LayoutCanvas.dart');
#source('lib/elements/Image.dart');
#source('lib/elements/RawHtml.dart');
#source('lib/elements/grid/Grid.dart');
#source('lib/elements/grid/RowDefinition.dart');
#source('lib/elements/grid/ColumnDefinition.dart');
#source('lib/elements/grid/_GridCell.dart');
#source('lib/elements/grid/GridLayoutDefinition.dart');
#source('lib/elements/grid/GridLength.dart');
#source('lib/elements/CollectionPresenter.dart');
#source('lib/elements/ContentPresenter.dart');
//#source('elements/DockPanel.dart');

#source('lib/elements/actions/ActionBase.dart');
#source('lib/elements/actions/AnimationAction.dart');
#source('lib/elements/actions/SetPropertyAction.dart');
#source('lib/elements/actions/TogglePropertyAction.dart');

#source('lib/controls/TextBox.dart');
#source('lib/controls/control/Control.dart');
#source('lib/controls/control/ControlTemplate.dart');
#source('lib/controls/RadioButton.dart');
#source('lib/controls/RadioButtonGroup.dart');
#source('lib/controls/Button.dart');
#source('lib/controls/CheckBox.dart');
#source('lib/controls/TextArea.dart');
#source('lib/controls/Slider.dart');
#source('lib/controls/Hyperlink.dart');
#source('lib/controls/DropDownList.dart');
//#source('controls/ListBox.dart');
//#source('controls/TreeView/TreeView.dart');
//#source('controls/TreeView/TreeNode.dart');

#source('lib/converters/StringToNumericConverter.dart');
#source('lib/converters/StringToThicknessConverter.dart');
#source('lib/converters/StringToBooleanConverter.dart');
#source('lib/converters/StringToGridLengthConverter.dart');
#source('lib/converters/StringToGridUnitTypeConverter.dart');
#source('lib/converters/StringToHorizontalAlignmentConverter.dart');
#source('lib/converters/StringToOrientationConverter.dart');
#source('lib/converters/StringToVerticalAlignmentConverter.dart');
#source('lib/converters/StringToColorConverter.dart');
#source('lib/converters/StringToSolidColorBrushConverter.dart');
#source('lib/converters/StringToRadialGradientDrawModeConverter.dart');
#source('lib/converters/StringToFrameworkElementConverter.dart');
#source('lib/converters/StringToVisibilityConverter.dart');
#source('lib/converters/StringToInputTypesConverter.dart');
#source('lib/converters/StringToLocationConverter.dart');

#source('lib/resources/FrameworkResource.dart');
#source('lib/resources/ResourceCollection.dart');
#source('lib/resources/VarResource.dart');
#source('lib/resources/Color.dart');
#source('lib/resources/Brush.dart');
#source('lib/resources/SolidColorBrush.dart');
#source('lib/resources/LinearGradientBrush.dart');
#source('lib/resources/RadialGradientBrush.dart');
#source('lib/resources/StyleSetter.dart');
#source('lib/resources/StyleTemplate.dart');
#source('lib/resources/GradientStop.dart');

#source('lib/animation/FrameworkAnimation.dart');
#source('lib/animation/AnimationResource.dart');
#source('lib/animation/AnimationKeyFrame.dart');
#source('lib/animation/AnimationState.dart');
#source('lib/animation/_CssCompiler.dart');

#source('lib/elements/shape/Shape.dart');
#source('lib/elements/shape/Ellipse.dart');
#source('lib/elements/shape/Rectangle.dart');
#source('lib/elements/shape/Line.dart');
#source('lib/elements/shape/PolyLine.dart');
#source('lib/elements/shape/Polygon.dart');

#source('lib/templates/IPresentationFormatProvider.dart');
#source('lib/templates/XmlTemplateProvider.dart');
#source('lib/templates/JSONTemplateProvider.dart');
#source('lib/templates/YAMLTemplateProvider.dart');
#source('lib/templates/Template.dart');

//Use this to generate clean dart docs of just the buckshot library
//main(){}
