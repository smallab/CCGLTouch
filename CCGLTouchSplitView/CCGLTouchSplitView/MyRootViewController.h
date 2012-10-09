//
//  MyRootViewController.h
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

#import <UIKit/UIKit.h>

#import "MyTableViewCell.h"

@class MyDetailViewController;

@interface MyRootViewController : UITableViewController

@property (nonatomic, retain) IBOutlet MyDetailViewController *detailViewController;

@end
