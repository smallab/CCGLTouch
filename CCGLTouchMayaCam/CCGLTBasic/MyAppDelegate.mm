//
//  MyAppDelegate.mm
//  CCGLTouchBasic example
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//

#import "MyAppDelegate.h"


@implementation MyAppDelegate

- (void)launch
{    
	// our CCGLTouchView being added as a subview
	MyCinderGLView *aView = [[MyCinderGLView alloc] init];
	glView = aView;
	[aView release];
	glView = [[MyCinderGLView alloc] initWithFrame:CGRectMake(0.0, 0.0, (float)[UIScreen mainScreen].bounds.size.width, (float)[UIScreen mainScreen].bounds.size.height-70.0)];
	[[viewController view] addSubview:glView];
	
    // set our view controller's prop that will hold a pointer to our newly created CCGLTouchView
    [viewController setGLView:glView];

    
    // viewController as the root view for our window
    super.window.rootViewController = viewController;
}

- (void)dealloc
{
    [viewController release];
    [glView release];
    [super dealloc];
}

@end
