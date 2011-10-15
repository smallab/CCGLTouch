//
//  MyViewController.mm
//  CCGLTouchBasic
//
//  Created by Matthieu Savary on 08/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyViewController.h"

@implementation MyViewController

/**
 *	setting glView(s) from the Delegate
 */

- (void)setGLView:(MyCinderGLView *)view
{
    glView = view;
}


/**
 *  Cocoa UI methods
 */

-(IBAction)listenToCubeSizeSlider:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [glView setCubeSize:(float)[slider value]];
}

@end