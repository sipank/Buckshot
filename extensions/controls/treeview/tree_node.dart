// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * Represents a node in a [TreeView] structure.
 */
class TreeNode extends Control implements IFrameworkContainer
{    
  bool _mouseStylesSet = false;
  TreeView _parentTreeView;
  
  FrameworkProperty headerProperty;
  FrameworkProperty iconProperty;
  FrameworkProperty folderIconProperty;
  FrameworkProperty fileIconProperty;
  FrameworkProperty childNodesProperty;
  FrameworkProperty indicatorProperty;
  FrameworkProperty childVisibilityProperty;
  
  FrameworkProperty _mouseEventStylesProperty;
  
  TreeNode()
  {
    Browser.appendClass(rawElement, "TreeNode");
    
    _initializeTreeNodeProperties();
    
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = childNodes;
        
    _initControl();
    
    _setMouseStyles();
  }
  
  void _initControl(){
    var lastWasEmpty = false;
    void adjustIndicator(){
      if (childNodes.isEmpty()){               
        if (lastWasEmpty) return;
        
        indicator = '';
        
        setValue(iconProperty, fileIcon);
        
        lastWasEmpty = true;
      }else{
        indicator = childVisibility == Visibility.visible 
            ? TreeView.INDICATOR_EXPANDED
            : TreeView.INDICATOR_COLLAPSED;
        
        setValue(iconProperty, folderIcon);
        
        lastWasEmpty = false;
      }
    }
    
    
    // Adjust indicator if children present or not.
    childNodes.listChanged + (__, _) => adjustIndicator();
    
    // Toggle visibility of child nodes when clicked.
    Template
      .findByName('__tree_node_indicator__', template)
      .click + (_, __){
        childVisibility = childVisibility == Visibility.visible 
            ? Visibility.collapsed 
            : Visibility.visible;
  
        adjustIndicator(); 
      };
    
    loaded + (_, __){
      _parentTreeView = Template.findParentByType(this, 'TreeView');          
      adjustIndicator();
    };
  }
  
  
  void _setMouseStyles(){
    if (_mouseStylesSet) return;
    _mouseStylesSet = true;
    
    final rowElement = Template.findByName('__tree_node_header__', template);
    if (rowElement is! Border) {
      throw const BuckshotException('Expected TreeNode row element to be of type Border.');
    }
    
    rowElement.mouseEnter + (_, __){
      setValue(_mouseEventStylesProperty, _parentTreeView.mouseEnterBorderStyle);
    };
    
    rowElement.mouseLeave + (_, __){
      setValue(_mouseEventStylesProperty, _parentTreeView.mouseLeaveBorderStyle);
    };
    
    rowElement.mouseDown + (_, __){
      setValue(_mouseEventStylesProperty, _parentTreeView.mouseDownBorderStyle);
    };
        
    rowElement.mouseUp + (_, __){
      setValue(_mouseEventStylesProperty, _parentTreeView.mouseUpBorderStyle);
      _parentTreeView._onTreeNodeSelected(this);
    };
    
  }
  
  
  void _initializeTreeNodeProperties(){
    
    childNodesProperty = new FrameworkProperty(this, 'childNodes', (_){}, 
      new ObservableList<TreeNode>());
    
    iconProperty = new FrameworkProperty(this, 'icon', (_){});
    
    folderIconProperty = new FrameworkProperty(this, 'folderIcon', (_){},
        Template.deserialize(TreeView.FOLDER_DEFAULT_TEMPLATE));
    
    fileIconProperty = new FrameworkProperty(this, 'fileIcon', (_){},
      Template.deserialize(TreeView.FILE_DEFAULT_TEMPLATE));

    indicatorProperty = new FrameworkProperty(this, 'indicator', (_){}, 
      TreeView.INDICATOR_COLLAPSED);
    
    headerProperty = new FrameworkProperty(this, 'header', (_){}, '');
    
    childVisibilityProperty = new FrameworkProperty(
      this, 
      'childVisibility', 
      (_){}, 
      Visibility.collapsed, 
      converter:const StringToVisibilityConverter());
    
    _mouseEventStylesProperty = new FrameworkProperty(this, '_mouseEventStyles', (_){});
  }
  
  
  // IFrameworkContainer interface
  get content => template;
  
  get header => getValue(headerProperty);
  set header(value) => setValue(headerProperty, value);
  
  get indicator => getValue(indicatorProperty);
  set indicator(value) => setValue(indicatorProperty, value);
  
  FrameworkElement get folderIcon => getValue(folderIconProperty);
  set folderIcon(FrameworkElement value) => setValue(folderIconProperty, value);
  
  FrameworkElement get fileIcon => getValue(fileIconProperty);
  set fileIcon(FrameworkElement value) => setValue(fileIconProperty, value);
  
  Visibility get childVisibility => getValue(childVisibilityProperty);
  set childVisibility(Visibility value) => setValue(childVisibilityProperty, value);
  
  ObservableList<TreeNode> get childNodes => getValue(childNodesProperty);
  
  /// Overridden [BuckshotObject] method.
  FrameworkObject makeMe() => new TreeNode();
    
  String get defaultControlTemplate {
    return
    '''<controltemplate controlType="${this.templateName}">
          <template>
            <stackpanel>
              <stackpanel orientation='horizontal'>
                <contentpresenter name='__tree_node_indicator__' margin='2' minwidth='15' content='{template indicator}' />
                <border padding='0,5,0,0' borderThickness='1' cornerRadius='4' style='{template _mouseEventStyles}' name='__tree_node_header__'>
                  <stackpanel orientation='horizontal'>
                    <contentpresenter valign='center' margin='2' minwidth='20' content='{template icon}' />
                    <contentpresenter valign='center' content='{template header}' />
                  </stackpanel>
                </border>
              </stackpanel>
              <collectionpresenter visibility='{template childVisibility}' datacontext='{template childNodes}'>
                <itemstemplate>
                  <contentpresenter margin='0,0,0,20' content='{data}' />
                </itemstemplate>
              </collectionpresenter>
            </stackpanel>
          </template>
        </controltemplate>
    ''';
  }
  
  String get type => "TreeNode";
}