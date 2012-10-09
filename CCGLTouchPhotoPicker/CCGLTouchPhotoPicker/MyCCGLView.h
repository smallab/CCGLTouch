//
//  MyCCGLView.h
//  CCGLTouchPhotoPicker example
//
//  Created by Matthieu Savary on 04/02/12.
//  Copyright (c) 2012 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//
//  Latest revision on 10/06/12.
//

#import "CCGLTouchView.h"

@interface MyCCGLView : CCGLTouchView {
	CameraPersp     mCam;
    float           mCubeSize;
    gl::Texture     mTex;
}

/**
 *  incoming from controller
 */

- (void)setImage:(UIImage*)img;

@end
