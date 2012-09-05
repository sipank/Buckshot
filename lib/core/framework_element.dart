// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents a base class for all visual elements in the framework.
* Generally speaking all elements that render DOM output should derive
* from this class.
*/
class FrameworkElement extends FrameworkObject {
  StyleTemplate _style;

  final HashMap<FrameworkProperty, String> _templateBindings;

  final HashMap<String, String> _transitionProperties;

  _Brutus _manualAlignmentHandler;

  /// Represents the margin [Thickness] area outside the FrameworkElement boundary.
  FrameworkProperty marginProperty;
  /// Represents the width of the FrameworkElement.
  FrameworkProperty widthProperty;
  /// Represents the height of the FrameworkElement.
  FrameworkProperty heightProperty;
  /// Represents the HTML 'ID' property of the FrameworkElement.
  FrameworkProperty htmlIDProperty;
  /// Represents the maximum width property of the FrameworkElement.
  FrameworkProperty maxWidthProperty;
  /// Represents the minimum height property of the FrameworkElement.
  FrameworkProperty minWidthProperty;
  /// Represents the maximum height property of the FrameworkElement.
  FrameworkProperty maxHeightProperty;
  /// Represents the minimum height proeprty of the FrameworkElement.
  FrameworkProperty minHeightProperty;
  /// Represents the shape the cursor will take when passing over the FrameworkElement.
  FrameworkProperty cursorProperty;
  /// Represents a general use [Object] property of the FrameworkElement.
  FrameworkProperty tagProperty;
  /// Represents the horizontal alignment of this FrameworkElement inside another element.
  FrameworkProperty hAlignProperty;
  /// Represents the [VerticalAlignment] of this FrameworkElement inside another element.
  FrameworkProperty vAlignProperty;
  /// Represents the html z order of this FrameworkElement in relation to other elements.
  FrameworkProperty zOrderProperty;
  /// Represents the actual adjusted width of the FrameworkElement.
  FrameworkProperty actualWidthProperty;
  /// Represents the actual adjusted height of the FrameworkElement.
  FrameworkProperty actualHeightProperty;
  /// Represents the opacity value [Double] of the FrameworkElement.
  AnimatingFrameworkProperty opacityProperty;
  /// Represents the [Visibility] property of the FrameworkElement.
  AnimatingFrameworkProperty visibilityProperty;
  /// Represents the [StyleTemplate] value that is currently applied to the FrameworkElement.
  FrameworkProperty styleProperty;
  /// Represents whether an element is draggable
  FrameworkProperty draggableProperty;

  AnimatingFrameworkProperty translateXProperty;
  AnimatingFrameworkProperty translateYProperty;
  AnimatingFrameworkProperty translateZProperty;
  AnimatingFrameworkProperty scaleXProperty;
  AnimatingFrameworkProperty scaleYProperty;
  AnimatingFrameworkProperty scaleZProperty;
  AnimatingFrameworkProperty rotateXProperty;
  AnimatingFrameworkProperty rotateYProperty;
  AnimatingFrameworkProperty rotateZProperty;
  FrameworkProperty transformOriginXProperty;
  FrameworkProperty transformOriginYProperty;
  FrameworkProperty transformOriginZProperty;
  FrameworkProperty perspectiveProperty;

  FrameworkProperty actionsProperty;

  //events
  /// Fires when the DOM gives the FrameworkElement focus.
  FrameworkEvent<EventArgs> gotFocus;
  /// Fires when the DOM removes focus from the FrameworkElement.
  FrameworkEvent<EventArgs> lostFocus;
  /// Fires when the mouse enters the boundary of the FrameworkElement.
  FrameworkEvent<EventArgs> mouseEnter;
  /// Fires when the mouse leaves the boundary of the FrameworkElement.
  FrameworkEvent<EventArgs> mouseLeave;
  /// Fires when a mouse click occurs on the FrameworkElement.
  FrameworkEvent<MouseEventArgs> click;
  /// Fires when the mouse position changes over the FrameworkElement.
  FrameworkEvent<MouseEventArgs> mouseMove;
  /// Fires when the mouse button changes to a down position while over the FrameworkElement.
  FrameworkEvent<MouseEventArgs> mouseDown;
  /// Fires when the mouse button changes to an up position while over the FrameworkElement.
  FrameworkEvent<MouseEventArgs> mouseUp;
//  FrameworkEvent<KeyEventArgs> keyUp;
//  FrameworkEvent<KeyEventArgs> keyDown;

  //TODO mouseWheel, onScroll;

  //---------------------------------------------------------------------
  // Drag events
  //---------------------------------------------------------------------

  /// Fires when an object is dragged into the drop target's boundary
  FrameworkEvent<DragEventArgs> dragEnter;
  /// Fires when an object is dragged out of the drop target's boundary.
  FrameworkEvent<DragEventArgs> dragLeave;
  /// Fires repeatedly when an object is over a target's boundary.
  FrameworkEvent<DragEventArgs> dragOver;
  /// Fires when an object is dropped within a target's boundary.
  FrameworkEvent<DragEventArgs> drop;
  /// Fires when an object starts being dragged.
  FrameworkEvent<DragEventArgs> dragStart;
  /// Fires when an object stops being dragged.
  FrameworkEvent<DragEventArgs> dragEnd;

  BuckshotObject makeMe() => new FrameworkElement();

  FrameworkElement() :
    _templateBindings = new HashMap<FrameworkProperty, String>(),
    _transitionProperties = new HashMap<String, String>()
  {
    Browser.appendClass(rawElement, "FrameworkElement");

    _manualAlignmentHandler = new _Brutus.with(this);

    _style = new StyleTemplate(); //give a blank style so merging works immediately

    _initFrameworkProperties();

    rawElement.attributes["data-buckshot-element"] = this.type;
    rawElement.attributes['data-buckshot-id'] = '${this.hashCode()}';

    _initFrameworkEvents();
  }


  void _initFrameworkProperties(){

    void doTransform(FrameworkElement e){
      Polly.setCSS(e.rawElement, 'transform',
        '''translateX(${getValue(translateXProperty)}px) translateY(${getValue(translateYProperty)}px) translateZ(${getValue(translateZProperty)}px)
           scaleX(${getValue(scaleXProperty)}) scaleY(${getValue(scaleYProperty)}) scaleZ(${getValue(scaleZProperty)}) 
           rotateX(${getValue(rotateXProperty)}deg) rotateY(${getValue(rotateYProperty)}deg) rotateZ(${getValue(rotateZProperty)}deg)
        ''');
    }

    actionsProperty = new FrameworkProperty(this, 'actions', (ObservableList<ActionBase> aList){
      if (actionsProperty != null){
        throw const BuckshotException('FrameworkElement.actionsProperty collection can only be assigned once.');
      }

      aList.listChanged + (_, ListChangedEventArgs args){
        if (args.oldItems.length > 0) throw const BuckshotException('Actions cannot be removed once added to the collection.');

        //assign this element as the source to any new actions
        args.newItems.forEach((ActionBase action){
          setValue(action._sourceProperty, this);
        });
      };
    }, new ObservableList<ActionBase>());


    //TODO: propogate this property in elements that use virtual containers

    perspectiveProperty = new FrameworkProperty(this, "perspective", (num value){
      Polly.setCSS(rawElement, 'perspective', '$value');
    },converter:const StringToNumericConverter());

    translateXProperty = new AnimatingFrameworkProperty(this, "translateX", (num value){
      doTransform(this);
    }, 'transform', converter:const StringToNumericConverter());

    translateYProperty = new AnimatingFrameworkProperty(this, "translateY", (num value){
      doTransform(this);
    }, 'transform', converter:const StringToNumericConverter());

    translateZProperty = new AnimatingFrameworkProperty(this, "translateZ", (num value){
      doTransform(this);
    }, 'transform', converter:const StringToNumericConverter());

    scaleXProperty = new AnimatingFrameworkProperty(this, "scaleX", (num value){
      doTransform(this);
    }, 'transform', converter:const StringToNumericConverter());

    scaleYProperty = new AnimatingFrameworkProperty(this, "scaleY", (num value){
      doTransform(this);
    }, 'transform', converter:const StringToNumericConverter());

    scaleZProperty = new AnimatingFrameworkProperty(this, "scaleZ", (num value){
      doTransform(this);
    }, 'transform', converter:const StringToNumericConverter());

    rotateXProperty = new AnimatingFrameworkProperty(this, "rotateX", (num value){
      doTransform(this);
    }, 'transform', converter:const StringToNumericConverter());

    rotateYProperty = new AnimatingFrameworkProperty(this, "rotateY", (num value){
      doTransform(this);
    }, 'transform', converter:const StringToNumericConverter());

    rotateZProperty = new AnimatingFrameworkProperty(this, "rotateZ", (num value){
      doTransform(this);
    }, 'transform', converter:const StringToNumericConverter());

    transformOriginXProperty = new FrameworkProperty(this, "transformOriginX", (num value){
      Polly.setCSS(rawElement, 'transform-origin', '${getValue(transformOriginXProperty)}% ${getValue(transformOriginYProperty)}% ${getValue(transformOriginZProperty)}px');
    }, converter:const StringToNumericConverter());

    transformOriginYProperty = new FrameworkProperty(this, "transformOriginY", (num value){
      Polly.setCSS(rawElement, 'transform-origin', '${getValue(transformOriginXProperty)}% ${getValue(transformOriginYProperty)}% ${getValue(transformOriginZProperty)}px');
    }, converter:const StringToNumericConverter());

    transformOriginZProperty = new FrameworkProperty(this, "transformOriginZ", (num value){
      Polly.setCSS(rawElement, 'transform-origin', '${getValue(transformOriginXProperty)}% ${getValue(transformOriginYProperty)}% ${getValue(transformOriginZProperty)}px');
    }, converter:const StringToNumericConverter());

    opacityProperty = new AnimatingFrameworkProperty(
      this,
      "opacity",
      (value){
        if (value < 0.0) value = 0.0;
        if (value > 1.0) value = 1.0;
        rawElement.style.opacity = value.toStringAsPrecision(2);
        //rawElement.style.filter = "alpha(opacity=${value * 100})";
      }, 'opacity', converter:const StringToNumericConverter());

    visibilityProperty = new AnimatingFrameworkProperty(
      this,
      "visibility",
      (Visibility value){
        if (value == Visibility.visible){
          rawElement.style.visibility = '$value';

          rawElement.style.display =  _stateBag["display"] == null ? "inherit" : _stateBag["display"];
          _stateBag.remove("display");
        }else{
          //preserve in case some element is using "inline" or some other fancy display value
          _stateBag["display"] = rawElement.style.display;
          rawElement.style.visibility = '$value';

          rawElement.style.display = "none";
        }
      }, 'visibility', converter:const StringToVisibilityConverter());

    zOrderProperty = new FrameworkProperty(
      this,
      "zOrder",
      (num value){
        rawElement.style.zIndex = value.toInt().toString(); //, null);
      }, converter:const StringToNumericConverter());

    marginProperty = new FrameworkProperty(
      this,
      "margin",
      (Thickness value){
        rawElement.style.margin = '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px'; //, null);
        if (parent != null) parent.updateLayout();
      }, new Thickness(0), converter:const StringToThicknessConverter());

    actualWidthProperty = new FrameworkProperty(
      this,
      "actualWidth",
      (num _){});

    actualHeightProperty = new FrameworkProperty(
      this,
      "actualHeight",
      (num _){});

    widthProperty = new FrameworkProperty(
      this,
      "width",
      (Dynamic value) => calculateWidth(value), "auto", converter:const StringToNumericConverter());

    heightProperty = new FrameworkProperty(
      this,
      "height",
      (Dynamic value) => calculateHeight(value), "auto", converter:const StringToNumericConverter());

    minHeightProperty = new FrameworkProperty(
      this,
      "minHeight",
      (value){

        rawElement.style.minHeight = '${value}px';
      }, converter:const StringToNumericConverter());

    maxHeightProperty = new FrameworkProperty(
      this,
      "maxHeight",
      (value){

        rawElement.style.maxHeight = '${value}px';
      }, converter:const StringToNumericConverter());

    minWidthProperty = new FrameworkProperty(
      this,
      "minWidth",
      (value){

        rawElement.style.minWidth = '${value}px';
      }, converter:const StringToNumericConverter());

    maxWidthProperty = new FrameworkProperty(
      this,
      "maxWidth",
      (value){

        rawElement.style.maxWidth = '${value}px';

      }, converter:const StringToNumericConverter());

    cursorProperty = new FrameworkProperty(
      this,
      "cursor",
      (Cursors value){
        rawElement.style.cursor = '$value';
      }, converter:const StringToCursorConverter());

    tagProperty = new FrameworkProperty(
      this,
      "tag",
      (value){});

    hAlignProperty = new FrameworkProperty(
      this,
      "hAlign",
      (HorizontalAlignment value){
        updateMeasurementAsync.then((_){
          if (parent != null) parent.updateLayout();
        });
      },
      HorizontalAlignment.left, converter:const StringToHorizontalAlignmentConverter());

    vAlignProperty = new FrameworkProperty(
      this,
      "vAlign",
      (VerticalAlignment value){
        updateMeasurementAsync.then((_){
          if (parent != null) parent.updateLayout();

        });
      },
      VerticalAlignment.top, converter:const StringToVerticalAlignmentConverter());

    styleProperty = new FrameworkProperty(
      this,
      "style",
      (StyleTemplate value){
        if (value == null){
          //setting non-null style to null
          _style._unregisterElement(this);
          styleProperty._previousValue = _style;
          _style = new StyleTemplate();
          styleProperty.value = _style;
        }else{
          //replacing style with style
          if (_style != null) _style._unregisterElement(this);
          value._registerElement(this);
          _style = value;
        }
      }, new StyleTemplate());

    draggableProperty = new FrameworkProperty(
      this,
      "draggable",
      (bool value) {
        rawElement.draggable = value;
      },
      false,
      converter:const StringToBooleanConverter());
  }

  /**
  Properties
  */

  /// Gets the [styleProperty] value.
  StyleTemplate get style => getValue(styleProperty);
  /// Sets the [styleProperty] value.
  set style(StyleTemplate value) => setValue(styleProperty, value);

  /// Gets the inner width of the element less any bordering offsets (margin, padding, borderThickness)
  num get actualWidth => getValue(actualWidthProperty);

  /// Gets the inner height of the element less any bordering offsets (margin, padding, borderThickness)
  num get actualHeight => getValue(actualHeightProperty);

  /// Sets the [htmlIDProperty] value.
  set htmlID(String value) => setValue(htmlIDProperty, value);
  /// Gets the [htmlIDProperty] value.
  String get htmlID => getValue(htmlIDProperty);

  /// Sets the [opacityProperty] value.
  set opacity(double value) => setValue(opacityProperty, value);
  /// Gets the [opacityProperty] value.
  double get opacity => getValue(opacityProperty);

  /// Sets the [visibilityProperty] value.
  set visibility(Visibility value) => setValue(visibilityProperty, value);
  /// Gets the [visibilityProperty] value.
  Visibility get visibility => getValue(visibilityProperty);

  /// Sets the [zOrderProperty] value.
  set zOrder(num value) => setValue(zOrderProperty, value);
  /// Gets the [zOrderProperty] value.
  num get zOrder => getValue(zOrderProperty);

  /// Sets the [tagProperty] value.
  set tag(Dynamic value) => setValue(tagProperty, value);
  /// Gets the [tagProperty] value.
  Dynamic get tag => getValue(tagProperty);

  /// Sets the [marginProperty] value.
  set margin(Thickness value) => setValue(marginProperty, value);
  /// Gets the [marginProperty] value.
  Thickness get margin => getValue(marginProperty);

  /// Sets the [widthProperty] value.
  set width(Dynamic value) => setValue(widthProperty, value);
  /// Gets the [widthProperty] value.
  Dynamic get width => getValue(widthProperty);

  /// Sets the [heightProperty] value.
  set height(Dynamic value) => setValue(heightProperty, value);
  /// Gets the [heightProperty] value.
  Dynamic get height => getValue(heightProperty);

  /// Sets the [minWidthProperty] value.
  set minWidth(num value) => setValue(minWidthProperty, value);
  /// Gets the [minWidthProperty] value.
  num get minWidth => getValue(minWidthProperty);

  /// Sets the [maxWidthProperty] value.
  set maxWidth(num value) => setValue(maxWidthProperty, value);
  /// Gets the [maxWidthProperty] value.
  num get maxWidth => getValue(maxWidthProperty);

  /// Sets the [minHeightProperty] value.
  set minHeight(num value) => setValue(minHeightProperty, value);
  /// Gets the [minHeightProperty] value.
  num get minHeight => getValue(minHeightProperty);

  /// Sets the [maxHeightProperty] value.
  set maxHeight(num value) => setValue(maxHeightProperty, value);
  /// Gets the [maxHeightProperty] value.
  num get maxHeight => getValue(maxHeightProperty);

  /// Sets the [cursorProperty] value.
  set cursor(Cursors value) => setValue(cursorProperty, value);
  /// Gets the [cursorProperty] value.
  Cursors get cursor => getValue(cursorProperty);

  /// Sets the [verticalAlignmentProperty] value.
  set vAlign(VerticalAlignment value) => setValue(vAlignProperty, value);
  /// Gets the [verticalAlignmentProperty] value.
  VerticalAlignment get vAlign => getValue(vAlignProperty);

  /// Sets the [horizontalAlignmentProperty] value.
  set hAlign(HorizontalAlignment value) => setValue(hAlignProperty, value);
  /// Gets the [horizontalAlignmentProperty] value.
  HorizontalAlignment get hAlign => getValue(hAlignProperty);

  /// Sets the [draggableProperty] value.
  set draggable(bool value) => setValue(draggableProperty, value);
  /// Gets the [draggableProperty] value.
  bool get draggable => getValue(draggableProperty);

  /// ** Internal Use Only **
  void calculateWidth(value){
    if (value == "auto"){
      rawElement.style.width = "auto"; //, null);
      this.updateMeasurementAsync.then((_){
        if (this is IFrameworkContainer){
          updateLayout();
        }else{
          if (parent != null) parent.updateLayout();
        }
      });
      return;
    }

    if (minWidth != null && value < minWidth){
      width = minWidth;
    }

    if (maxWidth != null && value > maxWidth){
      width = maxWidth;
    }

    rawElement.style.width = '${value}px';

    this.updateMeasurementAsync.then((_){
      if (this is IFrameworkContainer){
        updateLayout();
      }else{
        if (parent != null) parent.updateLayout();
      }
    });

  }

  /// ** Internal Use Only **
  void calculateHeight(value){
    if (value == "auto"){
      rawElement.style.height = "auto";//, null);
      this.updateMeasurementAsync.then((_){
        if (this is IFrameworkContainer){
          updateLayout();
        }else{
          if (parent != null) parent.updateLayout();
        }
      });
      return;
    }

    if (minHeight != null && value < minHeight){
      height = minHeight;
    }

    if (maxHeight != null && value > maxHeight){
      height =  maxHeight;
    }

   rawElement.style.height = '${value}px'; //, null);

   this.updateMeasurementAsync.then((_){
     if (this is IFrameworkContainer){
       updateLayout();
     }else{
       if (parent != null) parent.updateLayout();
     }
   });

  }

  //TODO: throw exception (maybe) if element is not loaded in DOM
  Future<ElementRect> get updateMeasurementAsync{
   Completer c = new Completer();

   rawElement.rect.then((ElementRect r){
    setValue(actualWidthProperty, r.bounding.width);
    setValue(actualHeightProperty, r.bounding.height);
    this.mostRecentMeasurement = r;
    c.complete(r);
   });

   return c.future;
  }



  void _initFrameworkEvents(){
//
//    void keyHandler(e){
//      if (!keyUp.hasHandlers) return;
//
//      e.stopPropagation();
//
//      var ev = new KeyEventArgs(e.keyCode, e.charCode);
//      ev.altKey = e.altKey;
//      ev.shiftKey = e.shiftKey;
//      ev.ctrlKey = e.ctrlKey;
//
//      keyUp.invoke(this, ev);
//    }
//
//    keyUp = new FrameworkEvent<EventArgs>
//    ._watchFirstAndLast(
//      () => rawElement.on.keyUp.add(keyHandler),
//      () => rawElement.on.keyUp.add(keyHandler)
//      );
//
//    keyDown = new FrameworkEvent<EventArgs>
//    ._watchFirstAndLast(
//      () => rawElement.on.keyDown.add(keyHandler),
//      () => rawElement.on.keyDown.add(keyHandler)
//      );

    void mouseUpHandler(e){
      if (!mouseUp.hasHandlers) return;

      e.stopPropagation();

      var p = document.window.webkitConvertPointFromPageToNode(rawElement,
        new Point(e.pageX, e.pageY));
      mouseUp.invoke(this, new MouseEventArgs(p.x, p.y, e.pageX, e.pageY));

    }

    mouseUp = new BuckshotEvent<MouseEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.mouseUp.add(mouseUpHandler),
      () => rawElement.on.mouseUp.remove(mouseUpHandler)
    );

    void mouseDownHandler(e){
      rawElement.focus();

      if (!mouseDown.hasHandlers) return;

      e.stopPropagation();

      var p = document.window.webkitConvertPointFromPageToNode(rawElement,
        new Point(e.pageX, e.pageY));
      mouseDown.invoke(this, new MouseEventArgs(p.x, p.y, e.pageX, e.pageY));
    }

    mouseDown = new BuckshotEvent<MouseEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.mouseDown.add(mouseDownHandler),
      () => rawElement.on.mouseDown.remove(mouseDownHandler)
    );


    void mouseMoveHandler(e){
      if (!mouseMove.hasHandlers) return;

      e.stopPropagation();

      var p = document.window.webkitConvertPointFromPageToNode(rawElement,
        new Point(e.pageX, e.pageY));
      mouseMove.invoke(this, new MouseEventArgs(p.x, p.y, e.pageX, e.pageY));
    }

    mouseMove = new BuckshotEvent<MouseEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.mouseMove.add(mouseMoveHandler),
      () => rawElement.on.mouseMove.remove(mouseMoveHandler)
    );

    void clickHandler(e){
      rawElement.focus();

      if (!click.hasHandlers) return;

      e.stopPropagation();

      var p = document.window.webkitConvertPointFromPageToNode(rawElement,
        new Point(e.pageX, e.pageY));

      click.invoke(this, new MouseEventArgs(p.x, p.y, e.pageX, e.pageY));
    }

    click = new BuckshotEvent<MouseEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.click.add(clickHandler),
      () => rawElement.on.click.remove(clickHandler)
    );


    void gotFocusHandler(e){
      if (!gotFocus.hasHandlers) return;

      e.stopPropagation();

      gotFocus.invoke(this, new EventArgs());
    }

    gotFocus = new BuckshotEvent<EventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.focus.add(gotFocusHandler),
      () => rawElement.on.focus.remove(gotFocusHandler)
    );

    void lostFocusHandler(e){
      if (!lostFocus.hasHandlers) return;

      e.stopPropagation();

      lostFocus.invoke(this, new EventArgs());
    }

    lostFocus = new BuckshotEvent<EventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.blur.add(lostFocusHandler),
      () => rawElement.on.blur.remove(lostFocusHandler)
    );

    bool isMouseReallyOut = true;

    void mouseEnterHandler(e){
      if (!mouseEnter.hasHandlers) return;

      e.stopPropagation();

     if (isMouseReallyOut && mouseLeave.hasHandlers){
       isMouseReallyOut = false;
       mouseEnter.invoke(this, new EventArgs());
     }else if(!mouseLeave.hasHandlers){
       //TODO add a temp handler for mouse out so the
       //logic works correctly when only the mouseenter
       //event is subscribed to (corner case).
       mouseEnter.invoke(this, new EventArgs());
     }
    }

    mouseEnter = new BuckshotEvent<EventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.mouseOver.add(mouseEnterHandler),
      () => rawElement.on.mouseOver.remove(mouseEnterHandler)
    );

    void mouseLeaveHandler(e){
      if (!mouseLeave.hasHandlers) return;

      e.stopPropagation();

      rawElement.rect.then((ElementRect r){

        var p = document.window.webkitConvertPointFromPageToNode(rawElement,
          new Point(e.pageX, e.pageY));

        if (p.x > -1 && p.y > -1 && p.x < r.bounding.width
            && p.y < r.bounding.height){
          isMouseReallyOut = false;
          return;
        }

        isMouseReallyOut = true;
        mouseLeave.invoke(this, new EventArgs());
      });
    }


    mouseLeave = new BuckshotEvent<EventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.mouseOut.add(mouseLeaveHandler),
      () => rawElement.on.mouseOut.remove(mouseLeaveHandler)
    );

    _initFrameworkDragEvents();
  }

  void _initFrameworkDragEvents() {

    // Handle enter events where an element is entering
    // another element's area
    void dragEnterHandler(e) {
      if (!dragEnter.hasHandlers) return;

      dragEnter.invoke(this, new DragEventArgs(e.dataTransfer));
    }

    dragEnter = new BuckshotEvent<DragEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.dragEnter.add(dragEnterHandler),
      () => rawElement.on.dragEnter.remove(dragEnterHandler)
    );

    // Handle dragleave events
    void dragLeaveHandler(e) {
      if (!dragLeave.hasHandlers) return;

      dragLeave.invoke(this, new DragEventArgs(e.dataTransfer));
    }

    dragLeave = new BuckshotEvent<DragEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.dragLeave.add(dragLeaveHandler),
      () => rawElement.on.dragLeave.remove(dragLeaveHandler)
    );

    // Handle dragover events
    void dragOverHandler(e) {
      if (!dragOver.hasHandlers) return;

      e.stopPropagation();

      dragOver.invoke(this, new DragEventArgs(e.dataTransfer));
    }

    dragOver = new BuckshotEvent<DragEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.dragOver.add(dragOverHandler),
      () => rawElement.on.dragOver.remove(dragOverHandler)
    );

    // Handle drop events
    void dropHandler(e) {
      if (!drop.hasHandlers) return;

      e.preventDefault();
      e.stopPropagation();

      drop.invoke(this, new DragEventArgs(e.dataTransfer));
    }

    drop = new BuckshotEvent<DragEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.drop.add(dropHandler),
      () => rawElement.on.drop.remove(dropHandler)
    );

    // Handle dragstart events
    void dragStartHandler(e) {
      if (!dragStart.hasHandlers) return;

      dragStart.invoke(this, new DragEventArgs(e.dataTransfer));
    }

    dragStart = new BuckshotEvent<DragEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.dragStart.add(dragStartHandler),
      () => rawElement.on.dragStart.remove(dragStartHandler)
    );

    // Handle dragend events
    void dragEndHandler(e) {
      if (!dragEnd.hasHandlers) return;

      dragEnd.invoke(this, new DragEventArgs(e.dataTransfer));
    }

    dragEnd = new BuckshotEvent<DragEventArgs>
    ._watchFirstAndLast(
      () => rawElement.on.dragEnd.add(dragEndHandler),
      () => rawElement.on.dragEnd.remove(dragEndHandler)
    );
  }


  /// Overridden [FrameworkObject] method.
  void createElement(){
    rawElement = new DivElement();
  }

  /// Overridden [FrameworkObject] method.
  updateLayout(){}

  String get type => "FrameworkElement";
}
