//
//  MyAppDelegate.h
//  CCGLTouchBasic example
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//

#import <UIKit/UIKit.h>

#import "CCGLTouchAppDelegate.h"

#import "MyViewController.h"
#import "MyCinderGLView.h"


@interface MyAppDelegate : CCGLTouchAppDelegate {
    MyCinderGLView *glView;
    IBOutlet MyViewController *viewController;
}

@end
