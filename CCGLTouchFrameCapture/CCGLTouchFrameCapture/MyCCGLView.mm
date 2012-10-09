//
//  MyCCGLView.mm
//  CCGLTouchFrameCapture example
//
//  Created by Matthieu Savary on 06/06/12.
//  Copyright (c) 2012 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//
//  Latest revision on 10/06/12.
//

#import "MyCCGLView.h"

@implementation MyCCGLView

/**
 *	The superclass setup method
 */

- (void)setup
{
    [super setup];
    
    // setup the camera
	mCam.lookAt( Vec3f(-100.0f, 20.0f, 10.0f), Vec3f::zero() );
	mCam.setPerspective( 60.0f, [self getWindowAspectRatio], 1.0f, 1000.0f );
}



/**
 *  The superclass draw method
 */

- (void)draw
{
	// this pair of lines is the standard way to clear the screen in OpenGL
	gl::clear( Color( 1.0f, frameCount/100.0f, 0.75f ), true );
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    // use the camera
    gl::setMatrices( mCam );
    
    // draw a rotating cube
	glPushMatrix();
    glRotatef(5 * frameCount, 0.0f, 1.0f, 0.0f);
	gl::drawColorCube( Vec3f::zero(), Vec3f(20.0f, 20.0f, 20.0f) );
	glPopMatrix();
}



/**
 *  incoming from controller
 */

- (void)captureFrame
{
    // What follows is ready-made in the CCGLTouchView super,
    // saves GL scene to photo album as soon as possible
    [self captureNextFrame];
}

@end
