//
//  MyAppDelegate.h
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

#import <UIKit/UIKit.h>

#import "CCGLTouchAppDelegate.h"

#import "MyViewController.h"
#import "MyCCGLView.h"


@interface MyAppDelegate : CCGLTouchAppDelegate {
    MyCCGLView *ccglView;
    IBOutlet MyViewController *viewController;
}

@end
