//
//  HAUser.h
//  hikerapp
//
//  Created by Himadri Jyoti on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HAUser : NSObject <NSCoding>

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) UIImage *image;

@end
