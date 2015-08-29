//
//  HABuddyTableViewCell.m
//  hikerapp
//
//  Created by Ravindra Shetty on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import "HABuddyTableViewCell.h"
#import "HACommonDefs.h"


@implementation HABuddyTableViewCell

- (void)awakeFromNib {
    self.avatarImageView.layer.cornerRadius = 25.0f;
    self.notifIndicatorView = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-20, 0, 20, 75)];
    [self.notifIndicatorView setBackgroundColor:[UIColor orangeColor]];
    [self.notifIndicatorView setHidden:YES];
    [self.contentView addSubview:self.notifIndicatorView];
    [self addLongPressGestureRecogniser];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.notifIndicatorView.hidden = YES;
}

- (void)addLongPressGestureRecogniser
{
    UILongPressGestureRecognizer *lpg = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTap:)];
    [self addGestureRecognizer:lpg];
}


- (void)handleLongTap:(UILongPressGestureRecognizer *)logTapGesture {
    if (logTapGesture.state == UIGestureRecognizerStateBegan) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_LongPressTableCell object:self];
    }
}

@end
