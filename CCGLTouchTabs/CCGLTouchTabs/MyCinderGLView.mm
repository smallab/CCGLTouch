//
//  MyCinderGLView.mm
//  CCGLTouchTabs example
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//
//  Latest revision on 10/06/12.
//

#import "MyCinderGLView.h"

#include "Resources.h"


@implementation MyCinderGLView

/**
 *	The superclass setup method
 */

- (void)prepareSettings
{
    frameRate = 30;
}

- (void)setup
{
    [super setup];
    
    // setup the camera
	mCam.lookAt( Vec3f(-100.0f, 10.0f, 10.0f), Vec3f::zero() );
	mCam.setPerspective( 60.0f, [self getWindowAspectRatio], 1.0f, 1000.0f );
	
    // init value
    mCubeSize = 10;
    
    // Load texture
	mTexture = gl::Texture( loadImage( [self loadResource:RES_IMAGE_CINDER] ) );
    mTexture.enableAndBind();
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
    gl::color(  ColorA(1, 1, 1, 0.5f)  );
	glPushMatrix();
    glRotatef(10.0f * frameCount, 0.0f, 1.0f, 0.0f);
	gl::drawCube( Vec3f::zero(), Vec3f(mCubeSize, mCubeSize, mCubeSize) );
	glPopMatrix();
}



/**
 *  incoming from controller
 */

- (void)setCubeSize:(float)size
{
    mCubeSize = size * 30 + 10;
    
    cout << "First CubeSize : " << mCubeSize << endl;
}

@end
