//
//  HABuddyTableViewCell.m
//  hikerapp
//
//  Created by Ravindra Shetty on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import "HABuddyTableViewCell.h"

@implementation HABuddyTableViewCell

- (void)awakeFromNib {
    self.avatarImageView.layer.cornerRadius = 25.0f;
    self.notifIndicatorView = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-20, 0, 20, 75)];
    [self.notifIndicatorView setBackgroundColor:[UIColor orangeColor]];
    [self.contentView addSubview:self.notifIndicatorView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
