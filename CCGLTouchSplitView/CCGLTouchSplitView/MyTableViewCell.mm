//
//  MyTableViewCell.mm
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

#import "MyTableViewCell.h"

@implementation MyTableViewCell

@synthesize primaryLabel,secondaryLabel,myImageView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        primaryLabel = [[UILabel alloc]init];
        primaryLabel.textAlignment = UITextAlignmentLeft;
        primaryLabel.font = [UIFont systemFontOfSize:14];
        secondaryLabel = [[UILabel alloc]init];
        secondaryLabel.textAlignment = UITextAlignmentLeft;
        secondaryLabel.font = [UIFont systemFontOfSize:8];
        myImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:primaryLabel];
        [self.contentView addSubview:secondaryLabel];
        [self.contentView addSubview:myImageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    frame= CGRectMake(boundsX+10 ,0, 50, 50);
    myImageView.frame = frame;
    
    frame= CGRectMake(boundsX+70 ,5, 200, 25);
    primaryLabel.frame = frame;
    
    frame= CGRectMake(boundsX+70 ,30, 100, 15);
    secondaryLabel.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}





- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
