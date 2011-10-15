//
//  MyViewController.h
//  CCGLTouchBasic
//
//  Created by Matthieu Savary on 08/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCGLTouchViewController.h"
#import "MyCinderGLView.h"

@interface MyViewController : CCGLTouchViewController {
    MyCinderGLView *glView;
}

- (void)setGLView:(CCGLTouchView *)view;

/**
 *  Cocoa UI methods
 */

-(IBAction)listenToCubeSizeSlider:(id)sender;

@end
