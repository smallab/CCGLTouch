//
//  MyCCGLView.mm
//  CCGLTouchAccelerometer example
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

- (void)setup
{
    [super setup];
    
    // setup the camera
	mCam.setPerspective( 60, [self getWindowAspectRatio], 1, 1000 );
	mCam.lookAt( Vec3f( 0, 0, 3 ), Vec3f::zero() );	

    // init value
    mCubeSize = 0.1f;
}



/**
 *  The superclass draw method
 */

- (void)draw
{
	gl::clear( Color( 0.2f, 0.2f, 0.3f ) );
	gl::enableDepthRead();
    
	gl::setMatrices( mCam );
	gl::multModelView( mModelView );
	gl::drawColorCube( Vec3f::zero(), Vec3f( mCubeSize, mCubeSize, mCubeSize ) );
}



/**
 *  incoming from controller
 */

- (void)setCubeSize:(float)size
{
    mCubeSize = size + 0.1f;
}



/**
 *  incoming from delegate
 */

- (void)accel:(AccelEvent)event
{
	mModelView = event.getMatrix();
	if( event.isShake() )
		console() << "Shake!" << std::endl;
}

@end
