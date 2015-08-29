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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
