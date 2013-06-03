//
//  CCGLTouchView.h
//  Core class of the CocoaCinderGLTouch wrapper.
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//
//
//  Latest update for Cinder v0.8.5: 06/02/2013
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

#define CINDER_COCOA_TOUCH

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#include "cinder/Cinder.h"
#include "cinder/Camera.h"
#include "cinder/ImageIo.h"
#import "cinder/app/App.h"
#include "cinder/app/Event.h"
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

@protocol CCGLTouchViewDelegate
- (EAGLSharegroup *)getThreadsSharegroup;
@end

/*
 This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
 The view content is basically an EAGL surface you render your OpenGL scene into.
 Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
 */
@interface CCGLTouchView : UIView {
    
@private
	// The pixel dimensions of the CAEAGLLayer
	GLint backingWidth;
	GLint backingHeight;
    
@protected
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint defaultFramebuffer, colorRenderbuffer, depthRenderbuffer;
    //Buffer definitions for the MSAA (anti-aliasing)
    GLuint ccglMsaaFramebuffer, ccglMsaaRenderBuffer, ccglMsaaDepthBuffer;
    // OpenGL sharegroup
    EAGLSharegroup *sharegroup;
    
    // Animation
    BOOL animating;
	float frameRate;
    NSInteger animationFrameInterval;
    id displayLink;
	long frameCount;
	::CFAbsoluteTime startTime;
    
	// Events
    std::map<UITouch*,uint32_t>	mTouchIdMap;
	std::vector<ci::app::TouchEvent::Touch> mActiveTouches;
	ci::Vec3d					mAcceleration;
    
    // Retina display scaling
    size_t retinaScaling;
    
	// Bounds of the current screen
	CGRect bounds;
    
    // App setup flag
	BOOL appSetupCalled;
    
    // Anti-aliasing flag
    BOOL antiAliasingEnabled;
    
    // Multi-touch flag
    BOOL multipleTouchEnabled;
    
    // Capture sketch
    UIImage *ccglCapture;
    BOOL ccglCaptureFlag;
    
    // Delegate
    __unsafe_unretained id<CCGLTouchViewDelegate> _delegate;
}
@property (nonatomic, assign) id<CCGLTouchViewDelegate> delegate;



/**
 *	initWithFrame, Bounds, Context, Sharegroup, layoutSubviews, Anti-aliasing
 */

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame andSharegroup:(EAGLSharegroup *)_sharegroup;
- (void)setCurrentBounds:(CGRect)frame;
- (EAGLSharegroup *)getThisSharegroup;
- (EAGLContext *)getThisContext;
- (void)layoutSubviews;
- (void)layoutSubviewsWithoutMSAA;
- (void)layoutSubviewsWithMSAA;
- (void)drawView:(id)sender;
- (void)makeCurrentContext;
- (void)flushBuffer;
- (void)presentCurrentContext;
- (void)enableAntiAliasing;
- (void)enableAntiAliasing:(BOOL)flag;
- (BOOL)isAntiAliasingEnabled;

/**
 *  OpenGL capture methods
 */

- (void)captureNextFrame;
-(void)sendCaptureToPhotoAlbum;
- (UIImage *)glToUIImage;

/**
 *	Handling "timer" loop and animation flag
 */

- (void)startAnimation;
- (void)stopAnimation;
- (NSInteger)animationFrameInterval;
- (void)setAnimationFrameInterval:(NSInteger)frameInterval;

/**
 *	Preparing to draw
 */

- (void)prepareSettings;
- (void)setup;
- (void)glView;
- (void)glParams;

/**
 *  Actual drawing
 */

- (void)draw;

/**
 *  Cocoa'd general utils extracted from Cinder
 */

- (double)getElapsedSeconds;
- (int)getWindowWidth;
- (int)getWindowHeight;
- (Area)getWindowBounds;
- (Surface)copyWindowSurface;
- (Surface)copyWindowSurface:(Area) area;
- (float)getWindowAspectRatio;
- (bool)withinDrawingBoundsX:(int)x Y:(int)y;

/**
 *  Touch & Mouse Events
 */

- (void)enableMultiTouch;
- (void)enableMultiTouch:(BOOL)flag;
- (BOOL)isMultiTouchEnabled;
- (uint32_t)addTouchToMap:(UITouch*)touch;
- (void)removeTouchFromMap:(UITouch*)touch;
- (uint32_t)findTouchInMap:(UITouch*)touch;
- (void)updateActiveTouches;
- (void)setActiveTouches:(std::vector<ci::app::TouchEvent::Touch>&)touches;
- (std::vector<ci::app::TouchEvent::Touch>&)getActiveTouches;
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)touchesBegan:(std::vector<ci::app::TouchEvent::Touch>&)touchList;
- (void)touchesMoved:(std::vector<ci::app::TouchEvent::Touch>&)touchList;
- (void)touchesEnded:(std::vector<ci::app::TouchEvent::Touch>&)touchList;
- (void)mouseDown:(ci::app::MouseEvent)event;
- (void)mouseDrag:(ci::app::MouseEvent)event;
- (void)mouseUp:(ci::app::MouseEvent)event;

/**
 *  Cinder's resource handling gone slightly or very Cocoa
 */

//! Cinder's Exception for failed resource loading
/*class ResourceLoadExc : public Exception
 {
 public:
 ResourceLoadExc( const string &macPath );
 virtual const char * what() const throw() { return mMessage; }
 char mMessage[4096];
 };*/
//! Cinder's
//! Returns a DataSourceRef to an application resource. \a macPath is a path relative to the bundle's resources folder. Throws ResourceLoadExc on failure. \sa \ref CinderResources
- (DataSourcePathRef)	loadResource:(string) macPath;
//! Returns the absolute file path to a resource located at \a rsrcRelativePath inside the bundle's resources folder. Throws ResourceLoadExc on failure. \sa \ref CinderResources
- (string)			getResourcePath:(string) rsrcRelativePath;
/*//! Returns the absolute file path to the bundle's resources folder. \sa \ref CinderResources
 static std::string			getResourcePath();*/
//! Presents the user with a file-open dialog and returns the selected file path.
/** The dialog optionally begins at the path \a initialPath and can be limited to allow selection of files ending in the extensions enumerated in \a extensions.
 If the active app is in full-screen mode it will temporarily switch to windowed-mode to present the dialog.
 \return the selected file path or an empty string if the user cancelled. **/
string		getOpenFilePath( const std::string &initialPath = "", std::vector<std::string> extensions = std::vector<std::string>() );
//! Presents the user with a folder-open dialog and returns the selected folder.
string		getFolderPath(const std::string &initialPath="");
//! Presents the user with a file-save dialog and returns the selected file path.
/** The dialog optionally begins at the path \a initialPath and can be limited to allow selection of files ending in the extensions enumerated in \a extensions.
 If the active app is in full-screen mode it will temporarily switch to windowed-mode to present the dialog.
 \return the selected file path or an empty string if the user cancelled. **/
string		getSaveFilePath( const std::string &initialPath = "", std::vector<std::string> extensions = std::vector<std::string>() );

@end
