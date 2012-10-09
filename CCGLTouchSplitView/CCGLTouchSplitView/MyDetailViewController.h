//
//  MyDetailViewController.h
//  CCGLTouchSplitView example
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//
//  Latest revision on 10/06/12.
//

#import "CCGLTouchViewController.h"
#import "MyCCGLView.h"

@interface MyDetailViewController : CCGLTouchViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
    MyCCGLView *ccglView;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) id detailItem;

/**
 *  incoming from root view (choice of a table cell)
 */

- (void)switchShape:(int)num;

@end
