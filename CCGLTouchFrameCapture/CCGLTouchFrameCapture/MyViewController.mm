//
//  MyViewController.mm
//  CCGLTouchFrameCapture example
//
//  Created by Matthieu Savary on 06/06/12.
//  Copyright (c) 2012 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//
//  Latest revision on 10/06/12.
//

#import "MyViewController.h"

@implementation MyViewController

/**
 *	setting ccglView(s) from the Delegate
 */

- (void)setCCGLView:(MyCCGLView *)view
{
    ccglView = view;
}


/**
 *  Cocoa UI methods
 */

-(IBAction)listenToCaptureFrameButton:(id)sender
{
    [ccglView captureFrame];
}

@end