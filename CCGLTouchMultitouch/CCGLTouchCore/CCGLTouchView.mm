//
//  CCGLTouchView.mm
//  Core class of the CocoaCinderGLTouch wrapper.
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
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

#import "CCGLTouchView.h"

#define USE_DEPTH_BUFFER 0

// A class extension to declare private methods & props
@interface CCGLTouchView ()
@property (nonatomic, retain) EAGLContext *context;
- (void)allocateGraphics;
- (void)makeCurrentContext;
- (void)flushBuffer;
@end


@implementation CCGLTouchView

@synthesize context;

// You must implement this method (for Apple's EAGL implementation)
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

/**
 *	initWithFrame
 */

//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithFrame:(CGRect)frame
{
	if ( (self = [super initWithFrame:frame]) ) {
        // Animation
        animating = NO;
        frameRate = 30;
        frameCount = 0;
		displayLink = nil;
        startTime = ::CFAbsoluteTimeGetCurrent();
        
        // Bounds of the current screen
		[self setCurrentBounds:frame];

        // setup flag
		appSetupCalled = NO;
        
        // other inits
        self.multipleTouchEnabled = NO;
        
		if( [[UIScreen mainScreen] respondsToSelector:@selector(scale:)] &&
           [self respondsToSelector:@selector(setContentScaleFactor:)] )
			[self setContentScaleFactor:[[UIScreen mainScreen] scale]];
        
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        // Create EAGL context
        [self allocateGraphics];
        
        // Launch only if there is an actual size to the thing
        if (backingWidth > 0 && backingHeight > 0) {
            [self prepareSettings];
            [self setup];
        }
	}
    
	return self;	
}

- (void)setCurrentBounds:(CGRect)frame
{
    // Bounds of the current screen
    bounds = frame;
    backingWidth = bounds.size.width;
    backingHeight = bounds.size.height;
}

- (void) allocateGraphics
{
    // Create EAGL context
	context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	if (!context || ![EAGLContext setCurrentContext:context]) {
		[self release];
		return;
	}
}

- (void) layoutSubviews
{
    // make sure setting the context is done
    [EAGLContext setCurrentContext:context];
	
    // First destroy any existing frame buffer
    glDeleteFramebuffersOES(1, &defaultFramebuffer);
    defaultFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &colorRenderbuffer);
    colorRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
    
	// Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
	glGenFramebuffersOES( 1, &defaultFramebuffer );
	glGenRenderbuffersOES( 1, &colorRenderbuffer );
	glBindFramebufferOES( GL_FRAMEBUFFER_OES, defaultFramebuffer );
	glBindRenderbufferOES( GL_RENDERBUFFER_OES, colorRenderbuffer );
	glFramebufferRenderbufferOES( GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer );
    
	glGenRenderbuffersOES( 1, &depthRenderbuffer );
	glBindRenderbufferOES( GL_RENDERBUFFER_OES, depthRenderbuffer );
	glRenderbufferStorageOES( GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight );
	glFramebufferRenderbufferOES( GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer );
    
	// Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
    glRenderbufferStorageOES(GL_RENDERBUFFER_OES, 
                             GL_DEPTH_COMPONENT16_OES, 
                             backingWidth, backingHeight);
	
    if( glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES ) {
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
    }
}

/**
 *	The "true" draw loop (similar to drawRect in OSX version)
 */

-(void)drawView:(id)sender
{
	if (!appSetupCalled)
		[self setup];
	
    frameCount++;
	[self makeCurrentContext];
    [self draw];
	[self flushBuffer];
}

- (void)makeCurrentContext
{
	[EAGLContext setCurrentContext:context];
    
	// This application only creates a single default framebuffer which is already bound at this point.
	// This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    
	// Define the viewport.  Changing the settings for the viewport can allow you to scale the viewport
	// as well as the dimensions etc and so I'm setting it for each frame in case we want to change it
	//glViewport(0, 0, bounds.size.width , bounds.size.height);
    glViewport(0, 0, backingWidth, backingHeight);
	
	// Clear the screen.  If we are going to draw a background image then this clear is not necessary
	// as drawing the background image will destroy the previous image
	glClear(GL_COLOR_BUFFER_BIT);
	
	// Setup how the images are to be blended when rendered.  This could be changed at different points during your
	// render process if you wanted to apply different effects
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

- (void)flushBuffer
{
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)setFrameSize:(CGSize)newSize
{
	[self layoutSubviews];
}

- (void)defaultResize
{
	cinder::gl::setMatricesWindow( backingWidth, backingHeight );
}

- (void)dealloc {
    
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
    [context release];  
    [super dealloc];
}



/**
 *	Handling "timer" and animation flag
 */

- (void)startAnimation
{
	if (!appSetupCalled)
		[self setup];
	    
	if( ! animating ) {
    displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView:)];
    [displayLink setFrameInterval:animationFrameInterval];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
		animating = YES;
     }
}

- (void)stopAnimation
{
	if( animating ) {
		[displayLink invalidate];
		displayLink = nil;
		
		animating = NO;
	}
}

- (NSInteger) animationFrameInterval
{
	return animationFrameInterval;
}

- (void) setAnimationFrameInterval:(NSInteger)frameInterval
{
	if ( frameInterval >= 1 ) {
		animationFrameInterval = frameInterval;
		
		if( animating ) {
			[self stopAnimation];
			[self startAnimation];
		}
	}
}



/**
 *	Preparing to draw
 */

- (void)prepareSettings {}

- (void)setup
{
	[self glView];
	[self glParams];
    
    // calculate the animation's frame interval here so that the user can set it in setup
    animationFrameInterval = 60/frameRate;
    
    // confirm that setup has been executed
	appSetupCalled = YES;
    
    // it's all good, let's start
    [self startAnimation];
}

/**
 *	Convenience camera method to be used in setup (or when resized, etc.)
 */

- (void)glView {
	glViewport(0, 0, backingWidth, backingHeight);
	CameraPersp cam( backingWidth, backingHeight, 60.0f );
	
	glMatrixMode( GL_PROJECTION );
	glLoadMatrixf( cam.getProjectionMatrix().m );
	
	glMatrixMode( GL_MODELVIEW );
	glLoadMatrixf( cam.getModelViewMatrix().m );
	glScalef( 1.0f, -1.0f, 1.0f );           // invert Y axis so increasing Y goes down.
	glTranslatef( 0.0f, (float)-[self frame].size.height, 0.0f );       // shift origin up to upper-left corner.
}

/**
 *	Some default GL parameters to be used in setup
 */

- (void) glParams
{
	gl::enableDepthWrite();
	gl::enableDepthRead();
	gl::enableAlphaBlending();
	glDisable( GL_TEXTURE_2D );
    glShadeModel(GL_SMOOTH);
}



/**
 *  Actual drawing with a default scene clearing
 */

- (void)draw {
	// this pair of lines is the standard way to clear the screen in OpenGL
	gl::clear( Color( 0.5f, 0.5f, 0.5f ), true );
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
}



/**
 *  Cocoa'd general utils extracted from Cinder 
 */

- (double) getElapsedSeconds
{
    return ::CFAbsoluteTimeGetCurrent() - startTime;
}

- (int) getWindowWidth
{
	return bounds.size.width;
}

- (int) getWindowHeight
{
	return bounds.size.height;
}

- (Area) getWindowBounds
{
    return Area( 0, 0, [self getWindowWidth], [self getWindowHeight] );
}

- (Surface)	copyWindowSurface
{
	return [self copyWindowSurface:[self getWindowBounds]];
}

- (Surface)	copyWindowSurface:(Area) area
{
	Area clippedArea = area.getClipBy( [self getWindowBounds] );
    
	Surface s( area.getWidth(), area.getHeight(), false );
	glFlush(); // there is some disagreement about whether this is necessary, but ideally performance-conscious users will use FBOs anyway
	GLint oldPackAlignment;
	glGetIntegerv( GL_PACK_ALIGNMENT, &oldPackAlignment ); 
	glPixelStorei( GL_PACK_ALIGNMENT, 1 );
	glReadPixels( area.x1, [self getWindowHeight] - area.y2, area.getWidth(), area.getHeight(), GL_RGB, GL_UNSIGNED_BYTE, s.getData() );
	glPixelStorei( GL_PACK_ALIGNMENT, oldPackAlignment );		
	ip::flipVertical( &s );
	return s;
}

- (float) getWindowAspectRatio
{
	return [self getWindowWidth] / (float) [self getWindowHeight];
}

- (bool) withinDrawingBoundsX:(int)x Y:(int)y
{
    return (x < [self getWindowWidth] &&
            x > 0 &&
            y < [self getWindowHeight] &&
            y > 0);
}



/**
 *  Touch & Mouse Events
 */

- (void)enableMultiTouch
{
    self.multipleTouchEnabled = YES;
}

- (void)enableMultiTouch:(BOOL)flag
{
    self.multipleTouchEnabled = flag;
}

- (BOOL)isMultiTouchEnabled
{
    return self.multipleTouchEnabled;
}

- (uint32_t)addTouchToMap:(UITouch*)touch
{
	uint32_t candidateId = 0;
	bool found = true;
	while( found ) {
		candidateId++;
		found = false;
		for( std::map<UITouch*,uint32_t>::const_iterator mapIt = mTouchIdMap.begin(); mapIt != mTouchIdMap.end(); ++mapIt ) {
			if( mapIt->second == candidateId ) {
				found = true;
				break;
			}
		}
	}
	
	mTouchIdMap.insert( std::make_pair( touch, candidateId ) );
	
	return candidateId;
}

- (void)removeTouchFromMap:(UITouch*)touch
{
	std::map<UITouch*,uint32_t>::iterator found( mTouchIdMap.find( touch ) );
	if( found == mTouchIdMap.end() )
		;//std::cout << "Couldn' find touch in map?" << std::endl;
	else
		mTouchIdMap.erase( found );
}

- (uint32_t)findTouchInMap:(UITouch*)touch
{
	std::map<UITouch*,uint32_t>::const_iterator found( mTouchIdMap.find( touch ) );
	if( found == mTouchIdMap.end() ) {
		;//std::cout << "Couldn' find touch in map?" << std::endl;
		return 0;
	}
	else
		return found->second;
}

- (void)updateActiveTouches
{
	static float contentScale = [self respondsToSelector:NSSelectorFromString(@"contentScaleFactor")] ? self.contentScaleFactor : 1;
    
	std::vector<ci::app::TouchEvent::Touch> activeTouches;
	for( std::map<UITouch*,uint32_t>::const_iterator touchIt = mTouchIdMap.begin(); touchIt != mTouchIdMap.end(); ++touchIt ) {
		CGPoint pt = [touchIt->first locationInView:self];
		CGPoint prevPt = [touchIt->first previousLocationInView:self];
		activeTouches.push_back( ci::app::TouchEvent::Touch( ci::Vec2f( pt.x, pt.y ) * contentScale, ci::Vec2f( prevPt.x, prevPt.y ) * contentScale, touchIt->second, [touchIt->first timestamp], touchIt->first ) );
	}
	[self setActiveTouches:activeTouches];
}

- (void)setActiveTouches:(std::vector<ci::app::TouchEvent::Touch>&)touches
{
    mActiveTouches = touches;
}

//! Returns a std::vector of all active touches
- (std::vector<ci::app::TouchEvent::Touch>&)getActiveTouches
{
    return mActiveTouches;
}


// Event handlers
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	static float contentScale = [self respondsToSelector:NSSelectorFromString(@"contentScaleFactor")] ? self.contentScaleFactor : 1;
	
	if( [self isMultiTouchEnabled] == YES ) {
		std::vector<ci::app::TouchEvent::Touch> touchList;
		for( UITouch *touch in touches ) {
			CGPoint pt = [touch locationInView:self];
			CGPoint prevPt = [touch previousLocationInView:self];
			touchList.push_back( ci::app::TouchEvent::Touch( ci::Vec2f( pt.x, pt.y ) * contentScale, ci::Vec2f( prevPt.x, prevPt.y ) * contentScale, [self addTouchToMap:touch], [touch timestamp], touch ) );
		}
		[self updateActiveTouches];
		if( ! touchList.empty() )
			[self touchesBegan:(ci::app::TouchEvent)touchList];
	}
	else {
		for( UITouch *touch in touches ) {
			CGPoint pt = [touch locationInView:self];		
			int mods = 0;
			mods |= cinder::app::MouseEvent::LEFT_DOWN;
			[self mouseDown:cinder::app::MouseEvent( cinder::app::MouseEvent::LEFT_DOWN, pt.x * contentScale, pt.y * contentScale, mods, 0.0f, 0 )];
		}
	}
}
- (void)touchesBegan:(ci::app::TouchEvent)event {}
- (void)mouseDown:(ci::app::MouseEvent)event {}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	static float contentScale = [self respondsToSelector:NSSelectorFromString(@"contentScaleFactor")] ? self.contentScaleFactor : 1;
    
	if( [self isMultiTouchEnabled] == YES ) {
		std::vector<ci::app::TouchEvent::Touch> touchList;
		for( UITouch *touch in touches ) {
			CGPoint pt = [touch locationInView:self];
			CGPoint prevPt = [touch previousLocationInView:self];			
			touchList.push_back( ci::app::TouchEvent::Touch( ci::Vec2f( pt.x, pt.y ) * contentScale, ci::Vec2f( prevPt.x, prevPt.y ) * contentScale, [self findTouchInMap:touch], [touch timestamp], touch ) );
		}
		[self updateActiveTouches];
		if( ! touchList.empty() )
			[self touchesMoved:(ci::app::TouchEvent)touchList];
	}
	else {
		for( UITouch *touch in touches ) {
			CGPoint pt = [touch locationInView:self];		
			int mods = 0;
			mods |= cinder::app::MouseEvent::LEFT_DOWN;
			[self mouseDrag:cinder::app::MouseEvent( cinder::app::MouseEvent::LEFT_DOWN, pt.x * contentScale, pt.y * contentScale, mods, 0.0f, 0 )];
		}
	}
}
- (void)touchesMoved:(ci::app::TouchEvent)event {}
- (void)mouseDrag:(ci::app::MouseEvent)event {}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	static float contentScale = [self respondsToSelector:NSSelectorFromString(@"contentScaleFactor")] ? self.contentScaleFactor : 1;
    
	if( [self isMultiTouchEnabled] == YES ) {
		std::vector<ci::app::TouchEvent::Touch> touchList;
		for( UITouch *touch in touches ) {
			CGPoint pt = [touch locationInView:self];
			CGPoint prevPt = [touch previousLocationInView:self];
			touchList.push_back( ci::app::TouchEvent::Touch( ci::Vec2f( pt.x, pt.y ) * contentScale, ci::Vec2f( prevPt.x, prevPt.y ) * contentScale, [self findTouchInMap:touch], [touch timestamp], touch ) );
			[self removeTouchFromMap:touch];
		}
		[self updateActiveTouches];
		if( ! touchList.empty() )
			[self touchesEnded:(ci::app::TouchEvent)touchList];
	}
	else {
		for( UITouch *touch in touches ) {
			CGPoint pt = [touch locationInView:self];		
			int mods = 0;
			mods |= cinder::app::MouseEvent::LEFT_DOWN;
			[self mouseUp:cinder::app::MouseEvent( cinder::app::MouseEvent::LEFT_DOWN, pt.x * contentScale, pt.y * contentScale, mods, 0.0f, 0 )];
		}
	}
}
- (void)touchesEnded:(ci::app::TouchEvent)event {}
- (void)mouseUp:(ci::app::MouseEvent)event {}

- (void) touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self touchesEnded:touches withEvent:event];
}



/**
 *  Cinder's resource handling gone slightly or very Cocoa
 */

/*ResourceLoadExc::ResourceLoadExc( const string &macPath )
{
	sprintf( mMessage, "Failed to load resource: %s", macPath.c_str() );
}*/

- (DataSourcePathRef) loadResource:(string) macPath
{
	string resourcePath = [self getResourcePath:macPath];
	if( resourcePath.empty() )
		;//throw ResourceLoadExc( macPath );
	else
		return DataSourcePath::createRef( resourcePath );
}

- (string) getResourcePath:(string) rsrcRelativePath
{
	string path = getPathDirectory( rsrcRelativePath );
	string fileName = getPathFileName( rsrcRelativePath );
	
	if( fileName.empty() )
		return string();
	
	NSString *pathNS = 0;
	if( ( ! path.empty() ) && ( path != rsrcRelativePath ) )
		pathNS = [NSString stringWithUTF8String:path.c_str()];
	
	NSString *resultPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:fileName.c_str()] ofType:nil inDirectory:pathNS];
	if( ! resultPath )
		return string();
	
	return string([resultPath cStringUsingEncoding:NSUTF8StringEncoding]);
}

string getOpenFilePath( const string &initialPath, vector<string> extensions )
{
    return string();
}

string getFolderPath( const string &initialPath )
{
    return string();
}

string	getSaveFilePath( const string &initialPath, vector<string> extensions )
{
    return string();
}

@end
