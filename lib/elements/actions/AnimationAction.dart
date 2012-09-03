// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class AnimationAction extends ActionBase {

  FrameworkProperty animationProperty;
  FrameworkProperty actionProperty;
  
  BuckshotObject makeMe() => new AnimationAction();
  
  AnimationAction(){
    _initAnimationActionProperties();
  }
  
  void _initAnimationActionProperties(){
    animationProperty = new FrameworkProperty(this, 'animation', (_){});
    actionProperty = new FrameworkProperty(this, 'action', (_){});
  }
  
  String get animation => getValue(animationProperty);
  set animation(String value) => setValue(animationProperty, value);
  
  String get action => getValue(actionProperty);
  set action(String value) => setValue(actionProperty, value);
  
  void onEventTrigger(){
    if (animation == null || action == null) return;
    
    FrameworkAnimation.playAnimation(animation);
  }
  
  String get type => "AnimationAction";
}