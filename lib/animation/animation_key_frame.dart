// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class AnimationKeyFrame extends BuckshotObject
{
  FrameworkProperty timeProperty;
  FrameworkProperty statesProperty;
  num _percentage; //represents a conversion of time to a percentage along a time span
 // int _ordinal; //represents the ordinal order of the keyframe in an animation sequence
  
  //TODO add support for easing with 'animation-timing-function'
  
  AnimationKeyFrame(){
    _initAnimationKeyFrameProperties();
    
    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = statesProperty;
  }
  
  _initAnimationKeyFrameProperties(){
    timeProperty = new FrameworkProperty(this, 'time', (_){}, converter:const StringToNumericConverter());
    
    statesProperty = new FrameworkProperty(this, 'states', (_){}, new List<AnimationState>());
  }
  
  num get time => getValue(timeProperty);
  set time(num v) => setValue(timeProperty, v);
  
  List<AnimationState> get states => getValue(statesProperty);
  set states(List<AnimationState> v) => setValue(statesProperty, v);
  
  
  /// Overridden [BuckshotObject] method.
  BuckshotObject makeMe() => new AnimationKeyFrame();
  
  String get type => 'AnimationKeyFrame';
}
