// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents the globally available instance of Buckshot.
*
* It is normally not be necessary to create your own instance
* of the [Buckshot] class.
*/
Buckshot get buckshot => new Buckshot._cached();

/**
* A general utility service for the Buckshot framework.
*
* Use the globally available 'buckshot' object to access the
* framework system.  It is normally not necessary to create your own instance
* of the [Buckshot] class.
*/
class Buckshot extends FrameworkObject
{
  static final String _defaultRootID = "#BuckshotHost";
  static final String _version = '0.55 Alpha';

  Element _rootElt;
  StyleElement _buckshotCSS;

  /// Central registry of named [FrameworkObject] elements.
  final HashMap<String, FrameworkObject> namedElements;

  /// Bindable window width/height properties.  Readonly, so can only
  /// bind from, not to.
  FrameworkProperty windowWidthProperty;
  /// Bindable window width/height properties.  Readonly, so can only
  /// bind from, not to.
  FrameworkProperty windowHeightProperty;

  /// Bindable root width property. Readonly, so can only bind from, not to.
  FrameworkProperty rootWidthProperty;
  /// Bindable root height property. Readonly, so can only bind from, not to.
  FrameworkProperty rootHeightProperty;

  /// Bindable property representing the current version of Buckshot
  FrameworkProperty versionProperty;

  static Buckshot _ref;

  /// Pass the ID of the element in the DOM where buckshot will render content.
  Buckshot(String buckshotRootID)
  :
    namedElements = new HashMap<String, FrameworkObject>()
  {
    _initBuckshotSystem(buckshotRootID);
  }

  factory Buckshot._cached()
  {
    if (_ref != null) return _ref;

    //initialize Polly's statics
    Polly.init();

    new Buckshot._init();
    return _ref;
  }

  Buckshot._init([String rootID = Buckshot._defaultRootID])
  :
    namedElements = new HashMap<String, FrameworkObject>()
  {
    _ref = this;
    _initBuckshotSystem(rootID);
  }

  void _initBuckshotSystem(String rootID)
  {
    if (!Polly.browserOK){
      print('Buckshot Warning: Browser may not be compatible with Buckshot'
          ' framework.');
    }

    _initCSS();

    _initializeBuckshotProperties(rootID);
  }

  void _initCSS(){
    document.head.elements.add(
      new Element.html('<style id="__BuckshotCSS__"></style>'));

    _buckshotCSS = document.head.query('#__BuckshotCSS__');

    if (_buckshotCSS == null)
      throw const BuckshotException('Unable to initialize'
        ' Buckshot StyleSheet.');
  }

  void _setRootSize()
  {
    if (_rootElt == null) return;
    _rootElt.rect.then((r) {
      if (r.client.width != rootWidth) {
        setValue(rootWidthProperty, r.client.width);
      }
      if (r.client.height != rootHeight) {
        setValue(rootHeightProperty, r.client.height);
      }
    });
  }

  void _initializeBuckshotProperties(String rootID){
    versionProperty = new FrameworkProperty(Buckshot._ref,
      "version", (_){}, _version);

    //TODO unit test
    versionProperty.readOnly = true;

    rootWidthProperty = new FrameworkProperty(
        Buckshot._ref, "rootWidth", (_){}, 0);

    rootHeightProperty = new FrameworkProperty(
        Buckshot._ref, "rootHeight", (_){}, 0);

    _rootElt = query(rootID);
    _setRootSize();

    windowWidthProperty = new FrameworkProperty(
      Buckshot._ref, "windowWidth", (_){}, window.innerWidth);

    windowHeightProperty = new FrameworkProperty(
      Buckshot._ref, "windowHeight", (_){}, window.innerHeight);

    window.on.resize.add((e){
      if (_ref == null) return;

      //any elements bound to these properties will also get updated...
      if (window.innerWidth != windowWidth){
        setValue(windowWidthProperty, window.innerWidth);
      }

      if (window.innerHeight != windowHeight){
        setValue(windowHeightProperty, window.innerHeight);
      }

      _setRootSize();
    });
  }

  /// Gets the innerWidth of the window
  int get windowWidth => getValue(windowWidthProperty);

  /// Gets the innerHeight of the window
  int get windowHeight => getValue(windowHeightProperty);

  int get rootWidth  => getValue(rootWidthProperty);
  int get rootHeight => getValue(rootHeightProperty);

  /// Gets the Buckshot version.
  String get version => getValue(versionProperty);
}