// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* Provides serialization/deserialization for JSON format templates.
*/
class JSONTemplateProvider implements IPresentationFormatProvider 
{
  //TODO MIME as identifier type instead?
  /**
  * Returns the file extension supported by the implementing class. */
  String get fileExtension => 'json';
  
  /**
  * Takes a string representation of elements in [template] and 
  * attempts to convert it to an object tree
  * using parsing rules from the implementing class. */
  FrameworkElement deserialize(String template){
    if (!isFormat(template)){
      _err('Template format not recognized.');
    }
    
    //convert the json into an XmlElement tree and let the 
    //XmlTemplateProvider do the rest...
    
    final p = new XmlTemplateProvider();
    
    return p._getNextElement(_toXmlTree(template));
  }
  
  XmlElement _toXmlTree(String template){
    var json = JSON.parse(template);
    
    assert(json is List);
    
    if (json.length > 2){
      _err('Expected only 1 or 2 elements in json top level array.');
    }
    
    if (json[0] is! String){
      _err('Expected first element to be a String literal');
    }
    
    return _nextElement(json);
  }
  
  XmlElement _nextElement(List json){
    final e = new XmlElement(json[0]);
    
    if(json.length == 1) return e; //no body
    
    final List body = json[1];
    
    assert(body is List);
    
    if (body.length > 2){
      _err('Expected between 0 and 2 elements in ${e.name} body.');
    }
   
    for(final b in body){
      if (b is Map){
        b.forEach((property, value){
          e.attributes[property] = value;
        });
      }else if (b is List){
        //iterate
        if (b.length % 2 != 0){
          _err('Expected even number of element/body pairs.');
        }
        
        for(int i = 0; i < b.length; i+=2){
          e.addChild(_nextElement([b[i], b[i + 1]]));
        }
        
      }else{
        _err('Type in element body is not recognized.  Should be Map or List.');
      }
    }
    
    
    return e;
  }
  
  /**
  * Takes an object tree starting at [elementRoot] and attempts to 
  * convert it to a serialized string
  * in the format of the implementing class. */
  String serialize(FrameworkElement elementRoot){
    throw const NotImplementedException();
  }
  
  /**
  * Returns true if the given template is detected to be of a compatible format.
  */
  bool isFormat(String template) => template.startsWith('[');
  
  void _err(String str){
    throw new PresentationProviderException('$str');
  }
}
