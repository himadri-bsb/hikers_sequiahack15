//
//  HAUser.h
//  hikerapp
//
//  Created by Himadri Jyoti on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface HAUser : NSObject

- (instancetype)initWithPFUser:(PFUser*)parseUser;

@property (nonatomic, strong)PFUser *parseUser;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, strong) UIImage *image;

@end
