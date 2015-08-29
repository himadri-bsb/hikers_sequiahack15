//
//  HAUser.m
//  hikerapp
//
//  Created by Himadri Jyoti on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import "HAUser.h"

NSString * const kKeyUserName = @"userName";
NSString * const kKeyPhoneNumber = @"phoneNumber";
NSString * const kKeyGender = @"gender";
NSString * const kKeyImage = @"image";

@implementation HAUser

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.userName = [aDecoder decodeObjectForKey:kKeyUserName];
        self.phoneNumber = [aDecoder decodeObjectForKey:kKeyPhoneNumber];
        self.gender = [aDecoder decodeObjectForKey:kKeyGender];
        NSData *imageData = [aDecoder decodeObjectForKey:kKeyImage];
        self.image = [UIImage imageWithData:imageData];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userName forKey:kKeyUserName];
    [aCoder encodeObject:self.phoneNumber forKey:kKeyPhoneNumber];
    [aCoder encodeObject:self.gender forKey:kKeyGender];

    NSData *imageData = UIImagePNGRepresentation(self.image);
    [aCoder encodeObject:imageData forKey:kKeyImage];
}




@end
