//
//  MyViewController.mm
//  CCGLTouchFrames2Video example
//
//  Created by Matthieu Savary on 06/06/12.
//  Copyright (c) 2012 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//
//  Latest revision on 10/06/12.
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

-(IBAction)listenToCaptureFramesButton:(id)sender
{
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    if (!recordingFlag) {
        recordingFlag = YES;
        button.title = @"Stop";
        button.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.75];
        [ccglView captureFrames:YES];
    } else {
        recordingFlag = NO;
        button.title = @"Save";
        button.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
        [ccglView captureFrames:NO];
    }
}

@end