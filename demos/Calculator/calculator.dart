#import('dart:html');
#import('dart:math');
#import('../../buckshot.dart');
#import('package:DartNet-Event-Model/events.dart');

#source('common/i_calculator.dart');
#source('common/output_changed_event_args.dart');
#source('views/main.dart');
#source('views/standard_calc.dart');
#source('views/extended_calc.dart');
#source('viewmodels/view_model.dart');
#source('models/naive_calc_model.dart');


/**
* ## Buckshot Calculator ##
* A calculator widget to demonstrate the Buckshot UI framework.
*
* This demo only supports mouse input.
*
* Video Walkthrough: http://www.youtube.com/watch?v=lbUO0E3kgdk
* 
* ### Benefits of Buckshot and the MVVM Pattern ###
* * A template & data focused application (minimal infrastructure noise).
* * Clean separation of concerns between design and implementation.
* * Easy visual content switching (between calculator keypad layouts).
* * Unit testable (unit tests drive the view model and inspect results).
* * Extensible by implementing [ICalculator].
*/
void main() {
  
  // Always load resources first.
  buckshot.rootView = 
      new IView.from(Template.deserialize(Template.getTemplate('#resources')));
    
  // Load the main view, to start the app.
  buckshot.rootView = new Main();
}

