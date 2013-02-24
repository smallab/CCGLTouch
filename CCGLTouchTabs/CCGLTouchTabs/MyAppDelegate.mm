//
//  MyAppDelegate.mm
//  CCGLTouchTabs example
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//
//  Latest revision on 10/06/12.
//

#import "MyAppDelegate.h"


@implementation MyAppDelegate

- (void)launch
{    
    // First View Controller
    
	// OpenGL View
	ccglView = [[MyCinderGLView alloc] initWithFrame:CGRectMake(0.0, 0.0, (float)[UIScreen mainScreen].bounds.size.width, (float)[UIScreen mainScreen].bounds.size.height-120.0)];//[UIScreen mainScreen].bounds];
	[[viewController view] addSubview:ccglView];
    [ccglView release];
	
    // set First View Controller's prop
    [viewController setGLView:ccglView];

    
    // Second View Controller
    
	// OpenGL View
	secondCcglView = [[MySecondCinderGLView alloc] initWithFrame:CGRectMake(0.0, 0.0, (float)[UIScreen mainScreen].bounds.size.width, (float)[UIScreen mainScreen].bounds.size.height-120.0)];//[UIScreen mainScreen].bounds];
	[[secondViewController view] addSubview:secondCcglView];
    [secondCcglView release];
	
    // set Second View Controller's prop
    [secondViewController setGLView:secondCcglView];
    
    
    // use tabBarController as the root view controller
    super.window.rootViewController = tabBarController;
}

- (void)dealloc
{
    [viewController release];
    [secondViewController release];
    [ccglView release];
    [secondCcglView release];
    [tabBarController release];
    [super dealloc];
}

@end
