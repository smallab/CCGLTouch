//
//  MyCinderGLView.h
//

#import "CCGLTouchView.h"

@interface MyCinderGLView : CCGLTouchView {
	CameraPersp     mCam;
    float           mCubeSize;
	Matrix44f		mModelView;
}

/**
 *  incoming from controller
 */

- (void)setCubeSize:(float)size;

/**
 *  incoming from delegate
 */

- (void)accel:(AccelEvent)event;
@end
