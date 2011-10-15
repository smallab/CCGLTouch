//
//  MyTableViewCell.h
//  CCGLTouchSplitView
//
//  Created by Matthieu Savary on 24/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell {
    UILabel *primaryLabel;
    UILabel *secondaryLabel;
    UIImageView *myImageView;
}

@property(nonatomic,retain)UILabel *primaryLabel;
@property(nonatomic,retain)UILabel *secondaryLabel;
@property(nonatomic,retain)UIImageView *myImageView;

@end