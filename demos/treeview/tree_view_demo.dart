#import('../../buckshot.dart');
#import('../../extensions/controls/treeview/tree_view.dart');


void main() {
  
  buckshot.registerElement(new TreeView());
  buckshot.registerElement(new TreeNode());

  final view = new IView.from(Template.deserialize(Template.getTemplate('#main')));
  
  buckshot.rootView = view;
  
  final tv = buckshot.namedElements['tvDemo'] as TreeView;
    
  tv.treeNodeSelected + (_, TreeNodeSelectedEventArgs args){
    print('Node Selected: ${args.node.header}');
  };
}
