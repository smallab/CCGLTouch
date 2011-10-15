//
//  MyAppDelegate.mm
//  CCGLTouchTabs example
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
    // First View Controller
    
	// OpenGL View
	MyCinderGLView *aView = [[MyCinderGLView alloc] init];
	glView = aView;
	[aView release];
	glView = [[MyCinderGLView alloc] initWithFrame:CGRectMake(0.0, 0.0, (float)[UIScreen mainScreen].bounds.size.width, (float)[UIScreen mainScreen].bounds.size.height-120.0)];//[UIScreen mainScreen].bounds];
	[[viewController view] addSubview:glView];
	
    // set First View Controller's prop
    [viewController setGLView:glView];

    
    // Second View Controller
    
	// OpenGL View
	MySecondCinderGLView *aSecondView = [[MySecondCinderGLView alloc] init];
	secondGlView = aSecondView;
	[aSecondView release];
	secondGlView = [[MySecondCinderGLView alloc] initWithFrame:CGRectMake(0.0, 0.0, (float)[UIScreen mainScreen].bounds.size.width, (float)[UIScreen mainScreen].bounds.size.height-120.0)];//[UIScreen mainScreen].bounds];
	[[secondViewController view] addSubview:secondGlView];
	
    // set Second View Controller's prop
    [secondViewController setGLView:secondGlView];
    
    
    // use tabBarController as the root view controller
    super.window.rootViewController = tabBarController;
}

- (void)dealloc
{
    [viewController release];
    [secondViewController release];
    [glView release];
    [secondGlView release];
    [tabBarController release];
    [super dealloc];
}

@end
