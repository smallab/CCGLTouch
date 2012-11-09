//
//  CCGLTouchAppDelegate.mm
//  Core application delegate of the CocoaCinderGLTouch wrapper.
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//
//  
//  The Cinder source code is used under the following terms:
//
//
//  Copyright (c) 2010, The Barbarian Group
//  All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that
//  the following conditions are met:
//  
//  * Redistributions of source code must retain the above copyright notice, this list of conditions and
//  the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and
//  the following disclaimer in the documentation and/or other materials provided with the distribution.
//  
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
//  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
//   ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
//  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//  

#import "CCGLTouchAppDelegate.h"


@implementation CCGLTouchAppDelegate

@synthesize window = _window;



/**
 *  Launch app
 */

- (void)launch {}



/**
 *  The superclass methods
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    application.applicationSupportsShakeToEdit = YES;
    mLastAccel = mLastRawAccel = Vec3f::zero();
    
    // Override point for customization after application launch
    [self launch];
        
    // generic calls
    [self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}



/**
 *  App Utils
 */

- (std::string)getAppPath
{ 
	return [[[NSBundle mainBundle] bundlePath] UTF8String];
}



/**
 *  Accelerometer
 */

//! Enables the device's accelerometer and modifies its filtering. \a updateFrequency represents the frequency with which accelerated() is called, measured in Hz. \a filterFactor represents the amount to weight the current value relative to the previous.
- (void)enableAccelerometer:(float)updateFrequency //, float filterFactor )
{
	//mAccelFilterFactor = filterFactor;
	
	if( updateFrequency <= 0 )
		updateFrequency = 30.0f;
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / updateFrequency];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
}
//! Turns off the accelerometer
- (void)disableAccelerometer
{
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)thisAcceleration
{
	// Massage the UIAcceleration class into a Vec3f
	Vec3f direction( thisAcceleration.x, thisAcceleration.y, thisAcceleration.z );
	[self privateAccelerated:direction];
}

- (void)privateAccelerated:(Vec3f)direction
{
    float mAccelFilterFactor = 0.1f;
	Vec3f filtered = mLastAccel * (1.0f - mAccelFilterFactor) + direction * mAccelFilterFactor;
	AccelEvent event( filtered, direction, mLastAccel, mLastRawAccel );
    [self accelerated:event];
    
	mLastAccel = filtered;
	mLastRawAccel = direction;
}

- (void)accelerated:(AccelEvent)event {}

@end
