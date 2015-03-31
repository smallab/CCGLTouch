//
//  CCGLTouchAppDelegate.h
//  Core application delegate of the CocoaCinderGLTouch wrapper.
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//
//
//  Latest update for Cinder v0.8.5: 06/02/2013
//  Latest update for XCode 6 & llvm 6.0: 31/03/2015
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

#import <UIKit/UIKit.h>

#include "cinder/Cinder.h"
#include "cinder/Camera.h"
#include "cinder/ImageIo.h"
#include "cinder/app/Event.h"
#import "cinder/app/App.h"
#include "cinder/app/AppCocoaTouch.h"
#include "cinder/app/Renderer.h"
#include "cinder/app/TouchEvent.h"
#include "cinder/cocoa/CinderCocoaTouch.h"
#include "cinder/DataSource.h"
#include "cinder/Exception.h"
#include "cinder/Utilities.h"
#include "cinder/gl/gl.h"
#include "cinder/gl/Texture.h"
#include "cinder/Area.h"
#include "cinder/Surface.h"
#include "cinder/ip/Flip.h"

#include <stdio.h>
#include <map>

using namespace ci;
using namespace ci::app;
using namespace std;

@interface CCGLTouchAppDelegate : NSObject <UIApplicationDelegate, UIAccelerometerDelegate> {
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

/**
 *  Launch app
 */

- (void)launch;

/**
 *  App Utils
 */

- (std::string)getAppPath;

@end
