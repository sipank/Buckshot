// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A [FrameworkResource] which represents the initial visual representation of
* a [Control].
*/
class ControlTemplate extends FrameworkResource implements IFrameworkContainer
{
  FrameworkProperty controlTypeProperty;
  FrameworkProperty templateProperty;
  
  BuckshotObject makeMe() => new ControlTemplate();
  
  ControlTemplate(){
    _initializeControlTemplateProperties();
    
    //redirect the resource finder to the template property
    //otherwise the ControlTemplate itself would be retrieved as the resource
    //this._stateBag[FrameworkResource.RESOURCE_PROPERTY] = templateProperty;
    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = templateProperty;
  }
  
  get content => getValue(templateProperty);
  
  void _initializeControlTemplateProperties(){
    controlTypeProperty = new FrameworkProperty(this, "controlType", (_){}, "");
    
    templateProperty = new FrameworkProperty(this, "template", (_){});
    
    //key is not needed, so just shadow copy whatever the controlType is.
    new Binding(this.controlTypeProperty, this.keyProperty);
  }
  
  String get controlType => getValue(controlTypeProperty);
  set controlType(String value) => setValue(controlTypeProperty, value);
  
  FrameworkElement get template => getValue(templateProperty);
  set template(FrameworkElement value) => setValue(templateProperty, value);
  
  String get type => "ControlTemplate";
}
