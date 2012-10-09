//
//  MyCCGLView.mm
//  CCGLTouchBasic example
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//  
//  Latest revision on 10/06/12.
//

#import "MyCCGLView.h"

@implementation MyCCGLView

/**
 *	The superclass prepareSettings & setup method
 */

- (void)prepareSettings
{
    [self enableAntiAliasing];
    frameRate = 30;
}

- (void)setup
{
    // Comment the following line to simply override, if you want to not animate
    // automatically, to change the default viewport, to not use CCGL's OpenGL
    // default params... Check this method in the super class implementation for
    //  more details on what happens.
    [super setup];
    
    // setup the camera
	mCam.lookAt( Vec3f(-100.0f, 20.0f, 10.0f), Vec3f::zero() );
	mCam.setPerspective( 60.0f, [self getWindowAspectRatio], 1.0f, 1000.0f );
	
    // init value
    mCubeSize = 10;
}

/**
 *  The superclass draw method
 */

- (void)draw
{
	// this pair of lines is the standard way to clear the screen in OpenGL
	gl::clear( Color( 0.9f, 0.9f, 0.9f ), true );
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    // use the camera
    gl::setMatrices( mCam );
    
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
    
    console() << "mCubeSize: " << mCubeSize << endl;
}

@end
