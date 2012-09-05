// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#import('dart:html');
#import('../../buckshot.dart');
#import('package:dart_utils/shared.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('../../lib/extensions/controls/media/youtube.dart');
#import('../../lib/extensions/controls/media/hulu.dart');
#import('../../lib/extensions/controls/media/vimeo.dart');
#import('../../lib/extensions/controls/media/funny_or_die.dart');
#import('../../lib/extensions/controls/list_box.dart');
#import('../../lib/extensions/controls/modal_dialog.dart');
#import('../../lib/extensions/controls/social/plus_one.dart');
#import('../../lib/extensions/controls/treeview/tree_view.dart');
#import('../../lib/extensions/controls/dock_panel.dart');

#import('apps/calculator/calculator.dart', prefix:'calc');
#import('apps/todo/todo.dart', prefix:'todo');

#source('viewmodels/demo_view_model.dart');
#source('models/demo_model.dart');
#source('views/main.dart');
#source('views/error.dart');

void main() {
  setView(new Main());
}