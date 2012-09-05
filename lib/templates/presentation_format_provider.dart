// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Interface contract for classes registering as presentation format providers.
*
* ## See Also ##
* * [XmlTemplateProvider]
* * [JSONTemplateProvider]
* * [YAMLTemplateProvider]
*/
class IPresentationFormatProvider
{
  /**
  * Takes an object tree starting at [elementRoot] and attempts to convert it to a serialized string
  * in the format of the implementing class. */
  abstract String serialize(FrameworkElement elementRoot);

  /**
  * Returns true if the given template is detected to be of a compatible format.
  */
  abstract bool isFormat(String template);
  
  /**
   * Returns a normalized Xml Tree from the given template.
   */
  abstract XmlElement toXmlTree(String template);
}