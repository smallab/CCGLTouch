//
//  MyCCGLView.mm
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

#import "MyCCGLView.h"

@implementation MyCCGLView

/**
 *	The superclass setup method
 */

- (void)prepareSettings
{
    [self enableAntiAliasing];
    frameRate = 30;
}

- (void)setup
{
    [super setup];
    
	// setup our camera
	CameraPersp cam;
	cam.setEyePoint( Vec3f(-100.0f, 10.0f, 10.0f) );
	cam.setCenterOfInterestPoint( Vec3f(0.0f, 0.0f, 0.0f) );
	cam.setPerspective( 60.0f, [self getWindowAspectRatio], 1.0f, 1000.0f );
	mMayaCam.setCurrentCam( cam );
	
    // init value
    mCubeSize = 10;
}



/**
 *  The superclass draw method
 */

- (void)draw
{
    // use the camera
    gl::setMatrices( mMayaCam.getCamera() );
    
	// this pair of lines is the standard way to clear the screen in OpenGL
	gl::clear( Color( 0.9f, 0.9f, 0.9f ), true );
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    // draw a rotating cube
	glPushMatrix();
    glRotatef(5 * frameCount, 0.0f, 1.0f, 0.0f);
	gl::drawColorCube( Vec3f::zero(), Vec3f(mCubeSize, mCubeSize, mCubeSize) );
	glPopMatrix();
}



/**
 *  incoming from controller
 */

- (void)setCubeSize:(float)size
{
    mCubeSize = size * 30 + 10;
    
    cout << "mCubeSize : " << mCubeSize << endl;
}



/**
 *  Superclass events
 */

- (void)mouseDown:(ci::app::MouseEvent)event
{
    mMayaCam.mouseDown( event.getPos() );
}

- (void)mouseDrag:(ci::app::MouseEvent)event
{
    mMayaCam.mouseDrag( event.getPos(), event.isLeftDown(), event.isMiddleDown(), event.isRightDown() );
}

@end
