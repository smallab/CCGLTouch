//
//  MySecondViewController.h
//  CCGLTouchTabs example
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//

#import "CCGLTouchViewController.h"
#import "MySecondCinderGLView.h"

@interface MySecondViewController : CCGLTouchViewController {
    MySecondCinderGLView *glView;
}

- (void)setGLView:(MySecondCinderGLView *)view;

/**
 *  Cocoa UI methods
 */

-(IBAction)listenToCubeSizeSlider:(id)sender;

@end
