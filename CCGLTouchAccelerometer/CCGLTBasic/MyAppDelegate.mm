//
//  MyAppDelegate.mm
//  CCGLTouchAccelerometer
//
//  Created by Matthieu Savary on 08/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
    
    
    // start accelerometer
    [self enableAccelerometer:50];
    
    // viewController as the root view for our window
    super.window.rootViewController = viewController;
}

- (void)accelerated:(AccelEvent)event
{
    [glView accel:event];
}

- (void)dealloc
{
    [viewController release];
    [glView release];
    [super dealloc];
}

@end
