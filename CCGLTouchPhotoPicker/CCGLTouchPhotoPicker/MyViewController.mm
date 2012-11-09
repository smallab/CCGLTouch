//
//  MyViewController.mm
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

#import "MyViewController.h"

@implementation MyViewController

@synthesize imgPicker;

/**
 *	setting glView(s) from the Delegate
 */

- (void)setCCGLView:(MyCCGLView *)view
{
    ccglView = view;
}



/**
 *	dealing with the image picking
 */

- (void)viewDidLoad
{
	self.imgPicker = [[UIImagePickerController alloc] init];
	self.imgPicker.allowsEditing = YES;
	self.imgPicker.delegate = self;		
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo
{
	image.image = img;
    [ccglView setImage:img];
	[self dismissModalViewControllerAnimated:YES];
}



/**
 *  Cocoa UI methods
 */

- (IBAction)grabImage
{
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:self.imgPicker animated:YES];
}

- (IBAction)takePicture
{
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:self.imgPicker animated:YES];
}

@end