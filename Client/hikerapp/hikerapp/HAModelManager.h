//
//  HAModelManager.h
//  hikerapp
//
//  Created by Himadri Jyoti on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HAUser;

@interface HAModelManager : NSObject

+ (HAModelManager *)sharedManager;
- (void)initializeBeaconStac;

@property (nonatomic, strong, readonly) HAUser *currentUser;

@end
