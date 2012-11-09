//
//  MyCCGLView.mm
//  CCGLTouchPhotoPicker example
//
//  Created by Matthieu Savary on 04/02/12.
//  Copyright (c) 2012 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//
//  Latest revision on 10/06/12.
//

#import "MyCCGLView.h"

#include "cinder/ImageSourceFileUiImage.h"
#include "cinder/cocoa/CinderCocoa.h"
#include <UIKit/UIImage.h>


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
	
    // init value
    mCubeSize = 50;
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
    glRotatef(5 * frameCount, 0.0f, 1.0f, 0.0f);
    if (mTex)
        mTex.enableAndBind();
	gl::drawColorCube( Vec3f::zero(), Vec3f(mCubeSize, mCubeSize, mCubeSize) );
	glPopMatrix();
}



/**
 *  incoming from controller
 */

- (void)setImage:(UIImage *)img
{
    // turn UIImage into CGImageRef
	CGImageRef imageRef = 0;
	if ( img ) {
		imageRef = ((UIImage*)img).CGImage;
		if ( ! imageRef )
			throw ImageIoExceptionFailedLoad();
	} else
		throw ImageIoExceptionFailedLoad();		
    
    // turn CGImageRef into texture
    mTex = gl::Texture( cinder::cocoa::createImageSource( imageRef ) );
}

@end
