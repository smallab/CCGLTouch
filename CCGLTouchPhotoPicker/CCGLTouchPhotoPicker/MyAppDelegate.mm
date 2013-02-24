//
//  MyAppDelegate.mm
//  CCGLTouchPhotoPicker example
//
//  Created by Matthieu Savary on 04/02/12.
//  Copyright (c) 2012 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//
//  Latest revision on 10/06/12.
//

#import "MyAppDelegate.h"


@implementation MyAppDelegate

@synthesize window;

- (void)launch
{    
	// our CCGLTouchView being added as a subview
	ccglView = [[MyCCGLView alloc] initWithFrame:CGRectMake(0.0, 0.0, (float)[UIScreen mainScreen].bounds.size.width, (float)[UIScreen mainScreen].bounds.size.height)];
	[[viewController view] addSubview:ccglView];
    [ccglView release];
	
    // set our view controller's prop that will hold a pointer to our newly created CCGLTouchView
    [viewController setCCGLView:ccglView];

    
    // viewController as the root view for our window
    window.rootViewController = viewController;

    [window addSubview:viewController.view];
	[window makeKeyAndVisible];
}

- (void)dealloc
{
    [viewController release];
    [ccglView release];
    [window release];
    [super dealloc];
}

@end
