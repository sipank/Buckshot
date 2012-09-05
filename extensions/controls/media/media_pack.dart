// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('media.controls.buckshotui.org');

#import('../../../buckshot.dart');

#import('youtube.dart');
#import('hulu.dart');
#import('vimeo.dart');
#import('funny_or_die.dart');

/* Video and Audio Extensions for Buckshot Framework */ 

void initializeMediaPackExtensions(){
  buckshot.registerElement(new YouTube());
  buckshot.registerElement(new Hulu());
  buckshot.registerElement(new Vimeo());
  buckshot.registerElement(new FunnyOrDie());
}