//
//  MyAppDelegate.h
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

#import <UIKit/UIKit.h>

#import "CCGLTouchAppDelegate.h"

#import "MyViewController.h"
#import "MyCCGLView.h"


@interface MyAppDelegate : CCGLTouchAppDelegate {
	IBOutlet UIWindow *window;
    MyCCGLView *ccglView;
    IBOutlet MyViewController *viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
