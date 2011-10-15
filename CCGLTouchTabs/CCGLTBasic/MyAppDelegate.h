//
//  MyAppDelegate.h
//  CCGLTouchTabs example
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//

#import "CCGLTouchAppDelegate.h"

#import "MyViewController.h"
#import "MySecondViewController.h"
#import "MyCinderGLView.h"
#import "MySecondCinderGLView.h"


@interface MyAppDelegate : CCGLTouchAppDelegate <UITabBarControllerDelegate> {
    
    MyCinderGLView *glView;
    MySecondCinderGLView *secondGlView;
    
    IBOutlet MyViewController *viewController;
    IBOutlet MySecondViewController *secondViewController;
    IBOutlet UITabBarController *tabBarController;
}

@end
