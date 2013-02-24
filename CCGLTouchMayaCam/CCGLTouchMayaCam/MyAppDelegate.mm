//
//  MyAppDelegate.mm
//  CCGLTouchMayaCam example
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
	// our CCGLTouchView being added as a subview
	ccglView = [[MyCCGLView alloc] initWithFrame:CGRectMake(0.0, 0.0, (float)[UIScreen mainScreen].bounds.size.width, (float)[UIScreen mainScreen].bounds.size.height-70.0)];
	[[viewController view] addSubview:ccglView];
    [ccglView release];
	
    // set our view controller's prop that will hold a pointer to our newly created CCGLTouchView
    [viewController setCCGLView:ccglView];

    
    // viewController as the root view for our window
    super.window.rootViewController = viewController;
}

- (void)dealloc
{
    [viewController release];
    [ccglView release];
    [super dealloc];
}

@end
