//
//  MyViewController.mm
//  CCGLTouchBasic example
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//

#import "MyViewController.h"

@implementation MyViewController

/**
 *	setting glView(s) from the Delegate
 */

- (void)setCCGLView:(MyCCGLView *)view
{
    ccglView = view;
}


/**
 *  Cocoa UI methods
 */

-(IBAction)listenToCubeSizeSlider:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [ccglView setCubeSize:(float)[slider value]];
}

@end