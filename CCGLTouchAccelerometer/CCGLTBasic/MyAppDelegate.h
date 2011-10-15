//
//  MyAppDelegate.h
//  CCGLTouchAccelerometer
//
//  Created by Matthieu Savary on 08/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
