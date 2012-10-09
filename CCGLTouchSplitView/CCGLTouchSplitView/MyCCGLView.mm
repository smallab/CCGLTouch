//
//  MyCCGLView.mm
//  CCGLTouchSplitView example
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
 *	The superclass setup method
 */

- (void)setup
{
    [super setup];
    
    [self setCam];
    
    // init value
    mShapeNum = 0;
}

- (void)setCam
{
    // we need to reset the bounds size values in superclass after there has been some size adjustments due to user rotating the interface, presumably by turning the device...
    [self setCurrentBounds:self.frame];
    
    // setup the camera
	mCam.lookAt( Vec3f(-100.0f, 20.0f, 10.0f), Vec3f::zero() );
	mCam.setPerspective( 60.0f, [self getWindowAspectRatio], 1.0f, 1000.0f );
}


/**
 *  The superclass draw method
 */

- (void)draw {
	// this pair of lines is the standard way to clear the screen in OpenGL
	gl::clear( Color( 0.9f, 0.9f, 0.9f ), true );
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    // use the camera
    gl::setMatrices( mCam );
    
    // draw a rotating cube
	glPushMatrix();
    glRotatef(frameCount, 0.0f, 1.0f, 0.0f);
    switch (mShapeNum) {
        case 0:
            gl::drawColorCube( Vec3f::zero(), Vec3f(20, 20, 20) );
            break;
        case 1:
            gl::drawColorCube( Vec3f::zero(), Vec3f(20, 20, 70) );
            break;
        case 2:
            gl::drawColorCube( Vec3f::zero(), Vec3f(20, 70, 20) );
            break;
        case 3:
            gl::drawColorCube( Vec3f::zero(), Vec3f(50, 50, 5) );
            break;
        case 4:
            gl::drawColorCube( Vec3f::zero(), Vec3f(70, 70, 70) );
            break;
        default:
            break;
    }
	glPopMatrix();
}


/**
 *  setting the shape
 */

- (void)setShapeNum:(int)num
{
    mShapeNum = num;
}

@end
