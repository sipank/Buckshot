// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/// A primitive [Shape] representing rectangle.
class Rectangle extends Shape{
  
  BuckshotObject makeMe() => new Rectangle();
        
  Rectangle(){
    Browser.appendClass(rawElement, "rectangle");
  }
  
  //override shape properties since we are just using a div here instead of SVG element
  _initShapeProperties(){
    
    strokeWidthProperty = new AnimatingFrameworkProperty(this, 'strokeWidth', (value){
      String color = getValue(strokeProperty) != null ? getValue(strokeProperty) : Colors.White.toString();
      
      //TODO support border hatch styles
      
      rawElement.style.borderTop = 'solid ${value.top}px $color';
      rawElement.style.borderRight = 'solid ${value.right}px $color';
      rawElement.style.borderLeft = 'solid ${value.left}px $color';
      rawElement.style.borderBottom = 'solid ${value.bottom}px $color';
      
    }, 'border-thickness', converter:const StringToNumericConverter());
    
    strokeProperty = new AnimatingFrameworkProperty(this, 'stroke', (value){
      
      shapeElement.style.borderColor = value.color.toString();
      
    }, 'border-color', converter:const StringToSolidColorBrushConverter());
    
    
    fillProperty = new AnimatingFrameworkProperty(this, 'fill', (Brush value){
      
      //TODO Animation hooks won't work because shapeElement is not root
      //need to implement some sort of proxy element solution
      
      value.renderBrush(rawElement);

    }, 'background', converter:const StringToSolidColorBrushConverter());
    
  }
  
  String get shapeTag => 'rect';
  
  String get type => 'Rectangle';
  
  void createElement(){
    rawElement = new DivElement();
  }
}
