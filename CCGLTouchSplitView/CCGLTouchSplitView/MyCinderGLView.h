//
//  MyCinderGLView.h
//  CCGLTouchSplitView example
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//

#import "CCGLTouchView.h"

@interface MyCinderGLView : CCGLTouchView {
	CameraPersp     mCam;
    int             mShapeNum;
}

- (void)setCam;
- (void)setShapeNum:(int)num;

@end
