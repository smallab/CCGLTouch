//
//  MyViewController.h
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

#import "CCGLTouchViewController.h"
#import "MyCCGLView.h"

@interface MyViewController : CCGLTouchViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    MyCCGLView *ccglView;
    
    IBOutlet UIButton *usePictureButton;
    IBOutlet UIButton *takePhotoButton;
    IBOutlet UIImageView *image;
	UIImagePickerController *imgPicker;
}

- (void)setCCGLView:(CCGLTouchView *)view;

@property (nonatomic, retain) UIImagePickerController *imgPicker;

/**
 *  Cocoa UI methods
 */

- (IBAction)grabImage;
- (IBAction)takePicture;

@end
