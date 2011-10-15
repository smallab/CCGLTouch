//
//  MyAppDelegate.h
//  CCGLTouchSplitView example
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//

#import "CCGLTouchAppDelegate.h"

#import "MyDetailViewController.h"
#import "MyRootViewController.h"
#import "MyCinderGLView.h"


@interface MyAppDelegate : CCGLTouchAppDelegate {
    
    MyCinderGLView *glView;
    
    IBOutlet MyDetailViewController *detailViewController;
    IBOutlet MyRootViewController *rootViewController;
    IBOutlet UISplitViewController *splitViewController;
}

@end
