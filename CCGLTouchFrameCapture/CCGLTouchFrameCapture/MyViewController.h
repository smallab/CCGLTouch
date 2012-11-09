//
//  MyViewController.h
//  CCGLTouchFrameCapture example
//
//  Created by Matthieu Savary on 06/06/12.
//  Copyright (c) 2012 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//
//  Latest revision on 10/06/12.
//

#import "CCGLTouchViewController.h"
#import "MyCCGLView.h"

@interface MyViewController : CCGLTouchViewController {
    MyCCGLView *ccglView;
}

- (void)setCCGLView:(CCGLTouchView *)view;

/**
 *  Cocoa UI methods
 */

-(IBAction)listenToCaptureFrameButton:(id)sender;

@end
